-- ── Palette-driven colorscheme ───────────────────────────────────────────────
-- theme-switch.sh (hypr-dotfiles repo) writes the active palette slug to
-- ~/.cache/nvim/colorscheme on every theme switch. This file reads that
-- cache at startup to pick the matching colorscheme. Live-running instances
-- receive a direct `nvim --server --remote-expr` call from theme-switch.sh.
--
-- This file never changes on a theme switch — only the cache file does,
-- so no inconsistency is introduced in the nvim repo by switching themes.

local function active_palette()
    local f = io.open(vim.fn.expand("~/.cache/nvim/colorscheme"), "r")
    if not f then return nil end
    local slug = f:read("*l")
    f:close()
    return slug and vim.trim(slug) ~= "" and vim.trim(slug) or nil
end

-- Keep in sync with the case statement in theme-switch.sh section 10.
local PALETTE_MAP = {
    ["catppuccin-mocha"]  = { cs = "catppuccin-mocha", bg = "dark"  },
    ["catppuccin-latte"]  = { cs = "catppuccin-latte", bg = "light" },
    ["everforest-dark"]   = { cs = "everforest",        bg = "dark"  },
    ["everforest-light"]  = { cs = "everforest",        bg = "light" },
    ["rose-pine-main"]    = { cs = "rose-pine",         bg = "dark"  },
    ["rose-pine-dawn"]    = { cs = "rose-pine-dawn",    bg = "light" },
    ["nord"]              = { cs = "nord",              bg = "dark"  },
}

local function resolve()
    local slug = active_palette()
    return PALETTE_MAP[slug] or { cs = "catppuccin-mocha", bg = "dark" }
end

local entry = resolve()
-- Set background early so plugins that check it during setup see the right value.
vim.o.background = entry.bg

return {
    -- Catppuccin (dark: mocha, light: latte)
    {
        "catppuccin/nvim",
        lazy = true,
        name = "catppuccin",
        opts = {
            flavour = "auto",
            lsp_styles = {
                virtual_text = {
                    errors      = { "italic" },
                    hints       = { "italic" },
                    warnings    = { "italic" },
                    information = { "italic" },
                    ok          = { "italic" },
                },
                underlines = {
                    errors      = { "undercurl" },
                    hints       = { "undercurl" },
                    warnings    = { "undercurl" },
                    information = { "undercurl" },
                },
            },
            integrations = {
                aerial              = true,
                alpha               = true,
                cmp                 = true,
                dashboard           = true,
                flash               = true,
                fzf                 = true,
                grug_far            = true,
                gitsigns            = true,
                headlines           = true,
                illuminate          = true,
                indent_blankline    = { enabled = true },
                leap                = true,
                lsp_trouble         = true,
                mason               = true,
                mini                = true,
                navic               = { enabled = true, custom_bg = "lualine" },
                neotest             = true,
                neotree             = true,
                noice               = true,
                notify              = true,
                snacks              = true,
                telescope           = true,
                treesitter_context  = true,
                which_key           = true,
            },
        },
        specs = {
            {
                "akinsho/bufferline.nvim",
                optional = true,
                opts = function(_, opts)
                    if (vim.g.colors_name or ""):find("catppuccin") then
                        opts.highlights = require("catppuccin.special.bufferline").get_theme()
                    end
                end,
            },
        },
    },

    -- Everforest (dark/light via vim.o.background)
    {
        "neanias/everforest-nvim",
        lazy = true,
        config = function()
            require("everforest").setup({ background = "medium" })
        end,
    },

    -- Rose Pine (dark: rose-pine, light: rose-pine-dawn)
    {
        "rose-pine/neovim",
        lazy = true,
        name = "rose-pine",
    },

    -- Nord (dark only)
    {
        "shaunsingh/nord.nvim",
        lazy = true,
    },

    -- Apply the palette-resolved colorscheme
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = entry.cs,
        },
    },
}
