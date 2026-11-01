-- Local AI (Ollama + Qwen). MacBook only: the config is shared with other
-- machines, so this whole file is a no-op unless macOS + `ollama` exist.
--   <leader>At  toggle chat (sees current buffer with #{buffer}, folder with @{files})
--   <leader>Aa  actions menu     <leader>Ai  inline edit (visual or normal)
--   <leader>Ac  toggle auto-complete (manual trigger: <A-y>, always works)
if vim.fn.has("mac") ~= 1 or vim.fn.executable("ollama") ~= 1 then
  return {}
end

local CHAT_MODEL = "qwen3-coder:30b"
local FIM_MODEL = "qwen2.5-coder:7b" -- small base model, FIM-trained

-- The Ollama service keeps models in RAM for 1h (OLLAMA_KEEP_ALIVE in its
-- launch agent); free them as soon as Neovim quits. Detached so quitting
-- doesn't wait. Closing one of several nvim windows unloads them for all.
vim.api.nvim_create_autocmd("VimLeavePre", {
  group = vim.api.nvim_create_augroup("local_ai_unload", { clear = true }),
  callback = function()
    for _, model in ipairs({ CHAT_MODEL, FIM_MODEL }) do
      vim.system({ "ollama", "stop", model }, { detach = true })
    end
  end,
})

return {
  {
    "olimorris/codecompanion.nvim",
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
    dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
    keys = {
      { "<leader>At", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "Local AI chat" },
      { "<leader>Aa", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "Local AI actions" },
      { "<leader>Ai", ":CodeCompanion ", mode = { "n", "v" }, desc = "Local AI inline" },
    },
    opts = {
      adapters = {
        http = {
          ollama = function()
            return require("codecompanion.adapters").extend("ollama", {
              schema = {
                model = { default = CHAT_MODEL },
                num_ctx = { default = 32768 },
              },
            })
          end,
        },
      },
      interactions = {
        chat = {
          adapter = "ollama",
          tools = {
            -- Read-only: every new chat can look around the folder, never edit or run.
            groups = {
              readonly = {
                description = "Read and search files in the current folder",
                tools = { "read_file", "file_search", "grep_search" },
              },
            },
            opts = { default_tools = { "readonly" } },
          },
        },
        inline = { adapter = "ollama" },
      },
    },
  },
  {
    "milanglacier/minuet-ai.nvim",
    event = "InsertEnter",
    keys = {
      { "<leader>Ac", "<cmd>Minuet cmp toggle<cr>", desc = "Local AI auto-complete" },
    },
    opts = {
      provider = "openai_fim_compatible",
      n_completions = 1,
      context_window = 2048,
      cmp = { enable_auto_complete = false }, -- off until toggled
      provider_options = {
        openai_fim_compatible = {
          api_key = "TERM", -- Ollama ignores it, but it must be a set env var
          name = "Ollama",
          end_point = "http://localhost:11434/v1/completions",
          model = FIM_MODEL,
          optional = { max_tokens = 56, top_p = 0.9 },
        },
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    optional = true,
    opts = function(_, opts)
      table.insert(opts.sources, { name = "minuet", group_index = 1, priority = 100 })
      opts.performance = vim.tbl_extend("force", opts.performance or {}, { fetching_timeout = 2000 })
      opts.mapping = vim.tbl_extend("force", opts.mapping or {}, {
        ["<A-y>"] = require("minuet").make_cmp_map(),
      })
    end,
  },
}
