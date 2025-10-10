-- 专用 Rust 插件配置
-- 此文件包含所有 Rust 专用插件及其配置

return {
	-- 主要 Rust 开发环境
	{
		"mrcjkb/rustaceanvim",
		version = "^5",
		ft = { "rust" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			vim.g.rustaceanvim = {
				-- 简化的工具配置
				tools = {
					hover_actions = {
						auto_focus = false,
						max_width = 80,
						max_height = 20,
					},

					test_executor = "background",
					test_status = {
						virtual_text = true,
						signs = true,
					},

					code_actions = {
						ui_select_fallback = true,
					},

					workspace_symbol = {
						search_kind = "all_symbols",
						search_scope = "workspace_and_dependencies",
					},
				},

				-- 服务器配置
				server = {
					cmd = { "rust-analyzer" },
					standalone = true,

					on_attach = function(client, bufnr)
						local opts = { buffer = bufnr, noremap = true, silent = true, desc = "" }

						-- 基本 LSP 映射
						vim.keymap.set("n", "gK", function()
							vim.cmd.RustLsp({ "hover", "actions" })
						end, vim.tbl_extend("force", opts, { desc = "Rust 增强悬停" }))

						-- Rust 代码动作
						vim.keymap.set({ "n", "v" }, "<leader>xra", function()
							vim.cmd.RustLsp("codeAction")
						end, vim.tbl_extend("force", opts, { desc = "Rust 代码动作" }))

						-- 保存时格式化
						if client.supports_method("textDocument/formatting") then
							vim.api.nvim_create_autocmd("BufWritePre", {
								group = vim.api.nvim_create_augroup("RustFormat." .. bufnr, {}),
								buffer = bufnr,
								callback = function()
									vim.lsp.buf.format({ bufnr = bufnr })
								end,
							})
						end

						-- 内联提示管理
						if client.server_capabilities.inlayHintProvider then
							local inlay_enabled = false
							local debounce_timer = nil

							local function toggle_inlay_hints(enable)
								if enable ~= inlay_enabled then
									vim.lsp.inlay_hint.enable(enable, { bufnr = bufnr })
									inlay_enabled = enable
								end
							end

							local function debounced_enable_inlay_hints()
								if debounce_timer then
									debounce_timer:stop()
								end
								debounce_timer = vim.defer_fn(function()
									toggle_inlay_hints(true)
								end, 300)
							end

							vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
								buffer = bufnr,
								callback = debounced_enable_inlay_hints,
							})

							vim.api.nvim_create_autocmd(
								{ "InsertEnter", "CursorMoved", "TextChanged", "TextChangedI" },
								{
									buffer = bufnr,
									callback = function()
										if debounce_timer then
											debounce_timer:stop()
										end
										toggle_inlay_hints(false)
									end,
								}
							)
						end
					end,

					-- 简化的 rust-analyzer 设置
					default_settings = {
						["rust-analyzer"] = {
							cargo = {
								allFeatures = true,
								loadOutDirsFromCheck = true,
							},

							check = {
								command = "clippy",
								features = "all",
							},

							procMacro = {
								enable = true,
							},

							inlayHints = {
								enable = true,
								typeHints = { enable = true },
								parameterHints = { enable = true },
								chainingHints = { enable = true },
								maxLength = 25,
								lifetimeElisionHints = {
									enable = "skip_trivial",
									useParameterNames = true,
								},
								closureReturnTypeHints = {
									enable = "always",
								},
							},

							completion = {
								addCallParentheses = true,
								addCallArgumentSnippets = true,
								autoimport = { enable = true },
							},

							diagnostics = {
								enable = true,
								enableRustcLint = true,
								disabled = { "unresolved-proc-macro" },
							},

							imports = {
								granularity = { group = "module" },
								prefix = "crate",
							},

							files = {
								watcher = "server",
								excludeDirs = { "target", ".git" },
							},

							lens = {
								enable = true,
								run = { enable = true },
								debug = { enable = true },
								implementations = { enable = true },
							},

							hover = {
								actions = { enable = true },
								memoryLayout = { enable = true },
								documentation = { enable = true },
							},
						},
					},
				},
			}
		end,
	},

	-- 增强的 Cargo.toml 管理
	{
		"saecki/crates.nvim",
		event = { "BufRead Cargo.toml" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("crates").setup({
				smart_insert = true,
				insert_closing_quote = true,
				avoid_prerelease = true,
				autoload = true,
				autoupdate = true,
				loading_indicator = true,
				date_format = "%Y-%m-%d",
				thousands_separator = ",",
				notification_title = "Crates",
				text = {
					loading = "  加载中...",
					version = "  %s",
					prerelease = "  %s (预发布)",
					yanked = "  %s (已撤销)",
					nomatch = "  无匹配",
					upgrade = "  %s → %s",
					error = "  获取 Crate 错误",
				},
				highlight = {
					loading = "CratesNvimLoading",
					version = "CratesNvimVersion",
					prerelease = "CratesNvimPreRelease",
					yanked = "CratesNvimYanked",
					nomatch = "CratesNvimNoMatch",
					upgrade = "CratesNvimUpgrade",
					error = "CratesNvimError",
				},
				popup = {
					autofocus = true,
					copy_version = false,
					hide_releases = false,
					hide_prereleases = false,
					hide_yanked = false,
				},
				src = {
					cmp = {
						enabled = true,
						use_custom_kind = true,
						kind_text = {
							version = "版本",
							feature = "特性",
						},
						kind_highlight = {
							version = "CmpItemKindVersion",
							feature = "CmpItemKindFeature",
						},
					},
				},
			})

			-- Cargo.toml 专用键位映射 (仅在 Cargo.toml 文件中生效)
			-- 使用新的分层前缀系统避免冲突
			vim.keymap.set("n", "<leader>xrct", function()
				require("crates").toggle()
			end, { desc = "切换 Crate 版本", buffer = true })

			vim.keymap.set("n", "<leader>xrcu", function()
				require("crates").upgrade_crate()
			end, { desc = "升级 Crate", buffer = true })

			vim.keymap.set("n", "<leader>xrcU", function()
				require("crates").upgrade_all_crates()
			end, { desc = "升级所有 Crate", buffer = true })

			vim.keymap.set("n", "<leader>xrca", function()
				require("crates").update_crate()
			end, { desc = "更新 Crate", buffer = true })

			vim.keymap.set("n", "<leader>xrcA", function()
				require("crates").update_all_crates()
			end, { desc = "更新所有 Crate", buffer = true })

			vim.keymap.set("n", "<leader>xrch", function()
				require("crates").show_homepage()
			end, { desc = "显示 Crate 主页", buffer = true })

			vim.keymap.set("n", "<leader>xrcd", function()
				require("crates").show_documentation()
			end, { desc = "显示 Crate 文档", buffer = true })

			vim.keymap.set("n", "<leader>xrcr", function()
				require("crates").reload()
			end, { desc = "重新加载 Crate", buffer = true })

			vim.keymap.set("n", "<leader>cc", function()
				require("crates").open_category()
			end, { desc = "打开 Crate 类别", buffer = true })
		end,
	},

	-- 增强的 Rust 测试集成
	{
		"nvim-neotest/neotest",
		ft = { "rust" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("rustaceanvim.neotest"),
				},
				discovery = {
					enabled = true,
				},
				running = {
					concurrent = true,
				},
				status = {
					enabled = true,
					virtual_text = true,
				},
				output = {
					enabled = true,
					open_on_run = "short",
				},
				summary = {
					enabled = true,
					follow = true,
					expand_errors = true,
				},
				strategies = {
					integrated = {
						width = 100,
						height = 30,
					},
				},
			})

			-- 注意：通用测试键位已移至 lang-keymaps.lua
			-- 这里只保留 Rust 特定的 neotest 配置，不重复定义键位

			vim.keymap.set("n", "<leader>tl", function()
				require("neotest").run.run_last()
			end, { desc = "运行上次测试" })

			vim.keymap.set("n", "<leader>td", function()
				require("neotest").run.run({ strategy = "dap" })
			end, { desc = "调试测试" })

			vim.keymap.set("n", "<leader>to", function()
				require("neotest").output.open({ enter = true })
			end, { desc = "显示测试输出" })

			vim.keymap.set("n", "<leader>tO", function()
				require("neotest").output_panel.toggle()
			end, { desc = "切换测试输出面板" })

			vim.keymap.set("n", "<leader>tS", function()
				require("neotest").summary.toggle()
			end, { desc = "切换测试摘要" })
		end,
	},
}

