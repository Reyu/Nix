-- Basic Options
require('reyu.options')

-- Attempt to find and/or configure a python3 environment
local has_pyenv, pyenv_repos = pcall(vim.fn.system, 'pyenv virtualenvs --bare')
if has_pyenv then
    if string.match(pyenv_repos, '%sneovim%s') ~= nil then
        vim.api.nvim_set_var('python3_host_prog', vim.fn
                                 .trim(
                                 vim.fn
                                     .system(
                                     'env PYENV_VERSION=neovim pyenv which python')))
    else
        print('Creating PyEnv virtual environment')
        vim.fn.system('pyenv virtualenv neovim')
        vim.fn.system(
            'env PYENV_VERSION=neovim pyenv exec python -m pip install pynvim')
        vim.api.nvim_set_var('python3_host_prog', vim.fn
                                 .trim(
                                 vim.fn
                                     .system(
                                     'env PYENV_VERSION=neovim pyenv which python')))
    end
else
    vim.api.nvim_set_var('loaded_python3_provider', 0)
end

-- Install and configure Lazy.nvim to manage plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git", "--branch=stable", -- latest stable release
        lazypath
    })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({import = "plugins"}, {
    defaults = {lazy = true},
    install = {missing = true, colorscheme = {"NeoSolarized"}},
    checker = {enabled = true}
})
