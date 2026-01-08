return {
	-- LSP 工具管理
	{
		"williamboman/mason.nvim",
		lazy = false,
		build = ":MasonUpdate",
		config = function()
			require("mason").setup()
		end,
	},

	-- LSP 配置
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		dependencies = { "williamboman/mason-lspconfig.nvim", "saghen/blink.cmp" },
		config = function()
			-- 确保在 Neovim 退出时正确清理所有 LSP 客户端
			vim.api.nvim_create_autocmd("VimLeavePre", {
				group = vim.api.nvim_create_augroup("LspCleanup", { clear = true }),
				callback = function()
					-- 停止所有 LSP 客户端以释放文件锁
					for _, client in ipairs(vim.lsp.get_clients()) do
						vim.lsp.stop_client(client.id, true) -- true = force stop
					end
				end,
			})

			local capabilities = require("blink.cmp").get_lsp_capabilities()

			-- 诊断配置
			vim.diagnostic.config({
				virtual_text = { prefix = "●" },
				float = { border = "rounded" },
				signs = true,
				underline = true,
				update_in_insert = false,
				severity_sort = true,
			})

			-- 键位映射
			local on_attach = function(client, bufnr)
				local opts = { buffer = bufnr, noremap = true, silent = true }

				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, opts)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
				vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
				-- K 键在通用 LSP 中映射，Rust 文件会被 after/ftplugin/rust.lua 覆盖
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "g[", vim.diagnostic.goto_prev, opts)
				vim.keymap.set("n", "g]", vim.diagnostic.goto_next, opts)
				vim.keymap.set("n", "<leader>de", vim.diagnostic.open_float, opts)
				vim.keymap.set({ "n", "x" }, "<leader>a", vim.lsp.buf.code_action, opts)

				if client.server_capabilities.inlayHintProvider then
					-- NeoVim 0.11+ API: enable(enable_value, { bufnr = bufnr })
					vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
				end
			end

			-- LSP 服务器配置
			local servers = {
				basedpyright = {
					cmd = { "basedpyright-langserver", "--stdio" },
					filetypes = { "python" },
					settings = {
						basedpyright = {
							analysis = {
								autoSearchPaths = true,
								useLibraryCodeForTypes = true,
							},
						},
					},
				},
				lua_ls = {
					cmd = { "lua-language-server" },
					filetypes = { "lua" },
					settings = {
						Lua = {
							runtime = { version = "LuaJIT" },
							diagnostics = { globals = { "vim" } },
							workspace = {
								library = vim.fn.stdpath("config") .. "/lua",
								checkThirdParty = false,
							},
							telemetry = { enable = false },
						},
					},
				},
					gopls = {
					cmd = { "gopls" },
					filetypes = { "go", "gomod", "gowork", "gotmpl" },
				},
				jsonls = {
					cmd = { "vscode-json-language-server", "--stdio" },
					filetypes = { "json", "jsonc", "jsonp" },
				},
				yamlls = {
					cmd = { "yaml-language-server", "--stdio" },
					filetypes = { "yaml", "yml" },
				},
				taplo = {
					cmd = { "taplo", "lsp", "stdio" },
					filetypes = { "toml" },
				},
			}

			-- 注册 LSP 服务器
			for name, config in pairs(servers) do
				config.capabilities = capabilities
				config.on_attach = on_attach
				vim.lsp.config(name, config)
			end

			-- 自动启动 LSP
			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					local lsp_map = {
						python = "basedpyright",
						lua = "lua_ls",
						go = "gopls",
						json = "jsonls",
						yaml = "yamlls",
						toml = "taplo",
					}

					local server = lsp_map[args.file]
					if server then
						vim.lsp.enable(server)
					end
				end,
			})
		end,
	},
}
