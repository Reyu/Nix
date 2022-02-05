local nvim_lsp = require('lspconfig')
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  require("which_key").register({
      g = {
        name = "Goto",
        D = { function() vim.lsp.buf.declaration() end, "Goto Declaration" },
        d = { function() vim.lsp.buf.definition() end, "Goto Definition" },
        i = { function() vim.lsp.buf.implementation() end, "Goto Implementation" },
        r = { function() vim.lsp.buf.references() end, "Goto References" },
      },
      K = { function() vim.lsp.buf.hover() end, "Show hover menu" },
      ["<C-k>"] = { function() vim.lsp.buf.signature_help() end, "Signature Help" },
      ["["] = { d = function() vim.lsp.diagnostic.goto_prev() end, "Goto previous diagnostic" },
      ["]"] = { d = function() vim.lsp.diagnostic.goto_next() end, "Goto next diagnostic" },
      ["<space>"] = {
        name = "LSP Actions",
        w = {
          name = "LSP Workspace",
          a = { function() vim.lsp.buf.add_workspace_folder() end, "Add workspase folder" },
          r = { function() vim.lsp.buf.remove_workspace_folder() end, "Remove workspace folder" },
          l = { function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, "List workspace folders" },
        },
        D = { function() vim.lsp.buf.type_definition() end, "Type Definition" },
        r = { n = { function() vim.lsp.buf.rename() end, "Rename" }, },
        e = { function() vim.lsp.diagnostic.show_line_diagnostics() end, "Show line diagnostics" },
        q = { function() vim.lsp.diagnostic.set_loclist() end, "Set loclist" },
      },
  }, {
    mode = "n",
    buffer = buffnr,
  })

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    require("which_key").register({ f = { function vim.lsp.buf.formatting() end, "Formatt Buffer" } }, { prefix = "<space>" })
  elseif client.resolved_capabilities.document_range_formatting then
    -- TODO: ??? why is this the same
    require("which_key").register({ f = { function vim.lsp.buf.formatting() end, "Formatt Buffer" } }, { prefix = "<space>" })
  end

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
      augroup lsp_document_highlight
        autocmd!
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end
end

-- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- Use a loop to conveniently both setup defined servers and
-- map buffer local keybindings when the language server attaches
local servers = { "bashls", "dockerls", "hls", "html", "jsonls", "terraformls", "vimls", "yamlls", "jedi-language-server", "pylsp", "pyright" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
        on_attach = on_attach,
        capabilities = capabilities,
        log_level = vim.lsp.protocol.MessageType.Log,
        message_level = vim.lsp.protocol.MessageType.Log
    }
end
