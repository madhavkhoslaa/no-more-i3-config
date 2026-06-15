local M = {}

local function picker(name)
  local ok, tel = pcall(require, "telescope.builtin")
  if ok then
    tel[name]()
  else
    vim.notify("[helix-gd] telescope not found", vim.log.levels.WARN)
  end
end

function M.goto_definition()
  picker "lsp_definitions"
end

function M.goto_references()
  picker "lsp_references"
end

function M.goto_declaration()
  picker "lsp_declarations"
end

function M.goto_implementation()
  picker "lsp_implementations"
end

function M.type_definition()
  picker "lsp_type_definitions"
end

function M.setup(opts)
  opts = opts or {}
  local map = vim.keymap.set
  local buffer = opts.buffer or 0

  if opts.gd ~= false then
    map("n", "gd", M.goto_definition, { buffer = buffer, desc = "Go to definition" })
  end
  if opts.gr ~= false then
    map("n", "gr", M.goto_references, { buffer = buffer, desc = "Go to references" })
  end
  if opts.gD ~= false then
    map("n", "gD", M.goto_declaration, { buffer = buffer, desc = "Go to declaration" })
  end
  if opts.gi ~= false then
    map("n", "gi", M.goto_implementation, { buffer = buffer, desc = "Go to implementation" })
  end
  if opts.gy ~= false then
    map("n", "gy", M.type_definition, { buffer = buffer, desc = "Go to type definition" })
  end
end

return M
