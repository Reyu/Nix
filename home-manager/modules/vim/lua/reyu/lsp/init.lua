local M = {}

local function preview_location_callback(_, result)
    if result == nil or vim.tbl_isempty(result) then return nil end
    vim.lsp.util.preview_location(result[1], {border = "rounded"})
end

local function peekDefinition(bufnr)
    local params = vim.lsp.util.make_position_params(0, 'utf-16')
    return vim.lsp.buf_request(bufnr, 'textDocument/definition', params,
                               preview_location_callback)
end

local lsp_start = vim.api.nvim_create_augroup('lsp_start', {clear = true})

vim.api.nvim_create_autocmd('LspAttach', {
    group = lsp_start,
    callback = function(args)
        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local wk = require('which-key')

        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        if client.server_capabilities["document_highlight"] then
            local lsp_doc_hl = vim.api.nvim_create_augroup(
                                   'lsp_document_highlight', {clear = true})
            vim.api.nvim_create_autocmd({'CursorHold', 'CursorHoldI'}, {
                group = lsp_doc_hl,
                buffer = bufnr,
                callback = vim.lsp.buf.document_highlight
            })
            vim.api.nvim_create_autocmd('CursorMoved', {
                group = lsp_doc_hl,
                buffer = bufnr,
                callback = vim.lsp.buf.clear_references
            })
        end

        if client.server_capabilities["hover_provider"] then
            wk.register({
                K = {
                    function()
                        -- Attempt to peek into fold
                        if not require('ufo').peekFoldedLinesUnderCursor() then
                            -- default to LSP hover action
                            vim.lsp.buf.hover()
                        end
                    end,
                    desc = 'Peek'
                }
            }, {buffer = bufnr})
        end

        require('which-key').register({
            gD = {vim.lsp.buf.declaration, desc = 'Goto Declaration'},
            gd = {
                '<Cmd>Trouble lsp_type_definitions<CR>',
                desc = 'Goto Definition'
            },
            gi = {
                '<Cmd>Trouble lsp_implementations<CR>',
                desc = 'Goto Implementation'
            },
            gr = {'<Cmd>Trouble lsp_references<CR>', desc = 'Goto References'},
            ['<C-k>'] = {
                vim.lsp.buf.signature_help,
                desc = 'Show signature help'
            },
            ['<LocalLeader>'] = {
                w = {
                    name = "+workspace",
                    a = {
                        vim.lsp.buf.add_workspace_folder,
                        desc = 'Add workspace folder'
                    },
                    r = {
                        vim.lsp.buf.remove_workspace_folder,
                        desc = 'Remove workspace folder'
                    },
                    l = {
                        function()
                            print(vim.inspect(vim.lsp.buf
                                                  .list_workspace_folder()))
                        end

                    }
                },
                D = {vim.lsp.buf.type_definition, desc = 'Type definition'},
                p = {peekDefinition, desc = 'Peek definition'},
                z = {vim.lsp.buf.rename, desc = 'Rename symbol'},
                s = {vim.lsp.buf.signature_help, desc = 'Signature help'},
                f = {vim.lsp.buf.format, desc = 'Format file'},
                c = {
                    name = '+code',
                    a = {vim.lsp.buf.code_action, desc = 'Run code action'},
                    l = {vim.lsp.codelens.run, desc = 'Run code lens'}
                }
            }
        }, {buffer = bufnr})
    end
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = {'python'},
    desc = 'Start Python LSP',
    group = lsp_start,
    callback = function(args)
        vim.lsp.start({
            name = 'pyright',
            cmd = {'pyright-langserver', '--stdio'},
            root_dir = vim.fs.dirname(vim.fs.find(
                                          {'setup.py', 'pyproject.toml'},
                                          {upward = true})[1])
        })
    end
})

return M
