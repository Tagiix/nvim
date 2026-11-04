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
    ["tokyo-night"]       = { cs = "tokyonight-night",  bg = "dark"  },
    ["kanagawa"]          = { cs = "kanagawa-wave",     bg = "dark"  },
}

local function resolve()
    local slug = active_palette()
    if PALETTE_MAP[slug] then return PALETTE_MAP[slug] end
    -- macOS has no theme switcher: Kanagawa (wave / lotus), light or dark
    -- from 'background', which Neovim reads from the terminal and updates
    -- when macOS switches appearance.
    if vim.fn.has("mac") == 1 then
        return {
            cs = function()
                vim.cmd.colorscheme(vim.o.background == "light" and "kanagawa-lotus" or "kanagawa-wave")
            end,
        }
    end
    return { cs = "catppuccin-mocha", bg = "dark" }
end

local entry = resolve()
-- Set background early so plugins that check it during setup see the right value.
if entry.bg then vim.o.background = entry.bg end

if vim.fn.has("mac") == 1 then
    vim.api.nvim_create_autocmd("OptionSet", {
        pattern = "background",
        -- Scheduled: changing 'background' first re-sources the current
        -- colorscheme, which for kanagawa-wave/lotus resets it.
        callback = function()
            vim.schedule(function()
                local name = vim.g.colors_name
                local want = vim.o.background == "light" and "kanagawa-lotus" or "kanagawa-wave"
                if name ~= want and (name == nil or name:find("^kanagawa")) then entry.cs() end
            end)
        end,
    })
end

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

    -- Xcode (macOS only: xcodelight / xcodedark)
    {
        "lunacookies/vim-colors-xcode",
        lazy = true,
        cond = vim.fn.has("mac") == 1,
    },

    -- Kanagawa (dark: wave, light: lotus; macOS default). Tokyo Night comes from LazyVim's bundled tokyonight.nvim.
    {
        "rebelot/kanagawa.nvim",
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
