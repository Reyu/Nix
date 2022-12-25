local ensure_packer = function()
    local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
        vim.fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup({ function(use)
    use "wbthomason/packer.nvim"

    -- Theme
    use({
        "Tsuzat/NeoSolarized.nvim",
        config = function()
            require('reyu.theme')
        end,
    })

    -- Interface
    use({
        "anuvyklack/hydra.nvim",
        cond = { "vim.fn.exists('g:started_by_firenvim') == 0" },
        config = function()
            require('reyu.plugins.hydra')
        end,
    })

    use({
        "lewis6991/gitsigns.nvim",
        cond = { "vim.fn.exists('g:started_by_firenvim') == 0" },
        config = function()
            require('gitsigns').setup()
        end,
    })

    use({
        "mrjones2014/smart-splits.nvim",
        cond = { "vim.fn.exists('g:started_by_firenvim') == 0" },
        after = "hydra.nvim",
        config = function()
            require('reyu.plugins.smart-splits')
        end,
    })

    use({
        "nvim-neo-tree/neo-tree.nvim",
        cond = { "vim.fn.exists('g:started_by_firenvim') == 0" },
        requires = {
            { "nvim-lua/plenary.nvim" },
            { "MunifTanjim/nui.nvim" },
            { "s1n7ax/nvim-window-picker" },
            { 'kyazdani42/nvim-web-devicons' },
        },
        config = function()
            require('reyu.plugins.neo-tree')
        end,
    })

    use({
        "karb94/neoscroll.nvim",
        config = function()
            require('reyu.plugins.neoscroll')
        end,
    })

    use({
        "folke/noice.nvim",
        cond = { "vim.fn.exists('g:started_by_firenvim') == 0" },
        requires = {
            { "MunifTanjim/nui.nvim" },
            {
                "rcarriga/nvim-notify",
                config = function()
                    require('reyu.plugins.notify')
                end,
            },
        },
        config = function()
            require('reyu.plugins.noice')
        end,
    })

    use({
        "nvim-lualine/lualine.nvim",
        cond = { "vim.fn.exists('g:started_by_firenvim') == 0" },
        requires = {
            { 'kyazdani42/nvim-web-devicons' },
            { "folke/noice.nvim" },
        },
        config = function()
            require('reyu.plugins.lualine')
        end,
    })

    use({
        "kevinhwang91/nvim-ufo",
        requires = {
            { "kevinhwang91/promise-async" },
        },
        config = function()
            require('reyu.plugins.ufo')
        end,
    })

    use({
        "folke/twilight.nvim",
        cond = { "vim.fn.exists('g:started_by_firenvim') == 0" },
        config = function()
            require('reyu.plugins.twilight')
        end,
    })

    use({
        "tpope/vim-fugitive",
        cond = { "vim.fn.exists('g:started_by_firenvim') == 0" },
        config = function()
            require('reyu.plugins.fugitive')
        end,
    })

    use({
        "folke/which-key.nvim",
        config = function()
            require('reyu.plugins.which-key')
        end,
    })

    use({
        "folke/zen-mode.nvim",
        cond = { "vim.fn.exists('g:started_by_firenvim') == 0" },
        config = function()
            require('reyu.plugins.zen-mode')
        end,
    })

    use({
        "echasnovski/mini.nvim",
        config = function()
            require('reyu.plugins.mini-nvim')
        end,
    })

    use({
        "kwkarlwang/bufresize.nvim",
        cond = { "vim.fn.exists('g:started_by_firenvim') == 0" },
        config = function()
            require('bufresize').setup()
        end
    })

    -- Fuzzy Finder / Picker
    use({
        "nvim-telescope/telescope.nvim",
        cond = { "vim.fn.exists('g:started_by_firenvim') == 0" },
        requires = {
            { "nvim-lua/plenary.nvim" },
            { "nvim-telescope/telescope-dap.nvim", requires = { "mfussenegger/nvim-dap" } },
            { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
            { "nvim-telescope/telescope-frecency.nvim", requires = { "kkharji/sqlite.lua" } },
            { "nvim-telescope/telescope-ui-select.nvim" },
        },
        config = function()
            require('reyu.plugins.telescope')
        end,
    })

    -- Completion and Snippets
    use({
        "hrsh7th/nvim-cmp",
        requires = {
            { "L3MON4D3/LuaSnip" },
            { "andersevenrud/cmp-tmux" },
            { "aspeddro/cmp-pandoc.nvim" },
            { "davidsierradz/cmp-conventionalcommits" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-calc" },
            { "hrsh7th/cmp-emoji" },
            { "hrsh7th/cmp-latex-symbols" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-nvim-lsp-document-symbol" },
            { "hrsh7th/cmp-nvim-lua" },
            { "lukas-reineke/cmp-under-comparator" },
            { "max397574/cmp-greek" },
            { "onsails/lspkind.nvim" },
            { "petertriho/cmp-git" },
            { "ray-x/cmp-treesitter" },
            { "uga-rosa/cmp-dictionary" },
        },
        config = function()
            require("reyu.plugins.cmp")
        end,
    })

    use({
        "nvim-treesitter/nvim-treesitter",
        requires = {
            { "nvim-treesitter/nvim-treesitter-context" },
            { "RRethy/nvim-treesitter-endwise" },
            { "nvim-treesitter/nvim-treesitter-textobjects" },
            { "JoosepAlviste/nvim-ts-context-commentstring" },
            { "nvim-treesitter/playground" },
        },
        config = function()
            require("reyu.plugins.treesitter")
        end,
    })

    -- Debug and Testing
    use({
        "mfussenegger/nvim-dap",
        cond = { "vim.fn.exists('g:started_by_firenvim') == 0" },
        requires = {
            { "mfussenegger/nvim-dap-python" },
            { "rcarriga/nvim-dap-ui" },
            { "theHamsta/nvim-dap-virtual-text", requires = { "nvim-treesitter/nvim-treesitter" } },
        },
        after = "hydra.nvim",
        config = function()
            require("reyu.plugins.dap")
        end,
    })

    use({
        "folke/trouble.nvim",
        cond = { "vim.fn.exists('g:started_by_firenvim') == 0" },
        requires = {
            { "kyazdani42/nvim-web-devicons" },
        },
        config = function()
            require('reyu.plugins.trouble')
        end,
    })

    use({
        "neovim/nvim-lspconfig",
        requires = {
            { "folke/neoconf.nvim" },
            { "folke/neodev.nvim" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "b0o/SchemaStore.nvim" },
            { "jose-elias-alvarez/null-ls.nvim" },
        },
        after = "which-key.nvim",
        config = function()
            require('reyu.lsp_config')
        end,
    })

    use({
        "williamboman/mason.nvim",
        cond = { "vim.fn.exists('g:started_by_firenvim') == 0" },
        requires = {
            {
                "williamboman/mason-lspconfig.nvim",
                requires = { "neovim/nvim-lspconfig" },
            },
            {
                "jayp0521/mason-null-ls.nvim",
                requires = { "jose-elias-alvarez/null-ls.nvim" },
            },
            {
                "jayp0521/mason-nvim-dap.nvim",
                requires = { "mfussenegger/nvim-dap" },
            },
        },
        config = function()
            require('reyu.plugins.mason')
        end,
    })

    -- EXTRA
    use({
        "pwntester/octo.nvim",
        cond = { "vim.fn.exists('g:started_by_firenvim') == 0" },
        requires = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope.nvim',
            'kyazdani42/nvim-web-devicons',
        },
        config = function()
            require('reyu.plugins.octo')
        end,
    })

    use({
        "glacambre/firenvim",
        cond = { "vim.fn.exists('g:started_by_firenvim') == 1" },
        run = function() vim.fn['firenvim#install'](0) end,
        config = function()
            require('reyu.plugins.firenvim')
        end,
    })

    if packer_bootstrap then
        require('packer').sync()
    end
end,
    config = {
        display = {
            open_fn = require('packer.util').float,
        }
    } })
