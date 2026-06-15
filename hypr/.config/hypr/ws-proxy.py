#!/usr/bin/env python3
import os, sys, socket, threading, time, json, re, atexit

SIGNATURE = os.environ.get("HYPRLAND_INSTANCE_SIGNATURE")
if not SIGNATURE:
    sys.exit("HYPRLAND_INSTANCE_SIGNATURE not set")

RUNTIME_DIR = os.environ.get("XDG_RUNTIME_DIR", "/run/user/1000")
HYPR_DIR = os.path.join(RUNTIME_DIR, "hypr", SIGNATURE)
ORIG_SOCK = os.path.join(HYPR_DIR, ".socket.sock")
ACTUAL_SOCK = os.path.join(HYPR_DIR, ".socket.sock.orig")

def rewrite_dispatch(data):
    text = data.decode("utf-8", errors="replace")
    if text.startswith("dispatch workspace ") and not text.startswith("/"):
        ws = text[len("dispatch workspace "):].strip()
        return f"/dispatch hl.dsp.focus({{ workspace = \"{ws}\" }})\n"
    if text.startswith("dispatch focusworkspaceoncurrentmonitor ") and not text.startswith("/"):
        ws = text[len("dispatch focusworkspaceoncurrentmonitor "):].strip()
        return f"/dispatch hl.dsp.focus({{ workspace = \"{ws}\", monitor = \"current\" }})\n"
    return None

def handle_client(client_conn):
    try:
        server_conn = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        server_conn.connect(ACTUAL_SOCK)

        def forward(src, dst, rewrite=False):
            try:
                while True:
                    data = src.recv(4096)
                    if not data:
                        break
                    if rewrite:
                        rewritten = rewrite_dispatch(data)
                        if rewritten:
                            dst.send(rewritten.encode())
                            continue
                    dst.send(data)
            except:
                pass
            finally:
                try:
                    dst.shutdown(socket.SHUT_WR)
                except:
                    pass

        t1 = threading.Thread(target=forward, args=(client_conn, server_conn, True), daemon=True)
        t2 = threading.Thread(target=forward, args=(server_conn, client_conn, False), daemon=True)
        t1.start()
        t2.start()
        t1.join()
        t2.join()
    except Exception as e:
        print(f"ws-proxy: {e}", file=sys.stderr)
    finally:
        try:
            client_conn.close()
        except:
            pass

MARKER = os.path.join(HYPR_DIR, ".socket.sock.proxy")

def cleanup():
    if os.path.exists(ACTUAL_SOCK):
        if os.path.exists(ORIG_SOCK):
            try:
                os.unlink(ORIG_SOCK)
            except:
                pass
        try:
            os.rename(ACTUAL_SOCK, ORIG_SOCK)
            print(f"ws-proxy: restored {ORIG_SOCK}", file=sys.stderr)
        except:
            pass
    try:
        os.unlink(MARKER)
    except:
        pass

atexit.register(cleanup)

def main():
    if os.path.exists(MARKER):
        with open(MARKER) as f:
            old_pid = f.read().strip()
        if old_pid and old_pid != str(os.getpid()):
            print(f"ws-proxy: previous instance (pid {old_pid}) left marker, cleaning up", file=sys.stderr)

    if os.path.exists(ACTUAL_SOCK):
        try:
            os.unlink(ACTUAL_SOCK)
        except:
            pass

    if not os.path.exists(ORIG_SOCK):
        sys.exit(f"ws-proxy: {ORIG_SOCK} not found")

    if os.path.islink(ORIG_SOCK) or not os.path.exists(ORIG_SOCK):
        sys.exit(f"ws-proxy: {ORIG_SOCK} is not valid, aborting")

    os.rename(ORIG_SOCK, ACTUAL_SOCK)

    try:
        os.unlink(ORIG_SOCK)
    except:
        pass

    server = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    server.bind(ORIG_SOCK)
    server.listen(5)
    os.chmod(ORIG_SOCK, 0o777)

    with open(MARKER, "w") as f:
        f.write(str(os.getpid()))

    print(f"ws-proxy: listening on {ORIG_SOCK}", file=sys.stderr)
    print(f"ws-proxy: forwarding to {ACTUAL_SOCK}", file=sys.stderr)

    while True:
        client, addr = server.accept()
        threading.Thread(target=handle_client, args=(client,), daemon=True).start()

if __name__ == "__main__":
    main()
