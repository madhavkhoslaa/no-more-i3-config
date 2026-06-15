return {
  -- Rust
  { import = "lazyvim.plugins.extras.lang.rust" },

  -- TypeScript / JavaScript
  { import = "lazyvim.plugins.extras.lang.typescript" },

  -- C / C++
  { import = "lazyvim.plugins.extras.lang.clangd" },

  -- Ensure language-specific tools are installed
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        -- Rust
        "rust-analyzer",
        -- TypeScript
        "typescript-language-server",
        "ts-standard",
        -- C / C++
        "clangd",
        "clang-format",
        -- general
        "stylua",
        "shellcheck",
        "shfmt",
      },
    },
  },

  -- Treesitter parsers for all languages
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "rust",
        "toml",
        "c",
        "cpp",
        "typescript",
        "tsx",
        "javascript",
        "json",
        "jsonc",
      })
    end,
  },
}
