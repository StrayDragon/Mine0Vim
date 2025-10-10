-- 重构和代码动作插件配置
-- 包含代码重构、格式化、LSP 代码动作等功能

return {
	-- 代码动作插件 - 替代 vim-quickui
	{
		"rachartier/tiny-code-action.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "ibhagwan/fzf-lua" },
		},
		event = "LspAttach",
		config = function()
			require("tiny-code-action").setup()
		end,
		keys = {
			{
				"<A-Enter>",
				function()
					require("tiny-code-action").code_action()
				end,
				desc = "LSP Code Actions (Alt+Enter)",
			},
		},
	},

	-- 增强重构支持（替代 coc.nvim 的许多重构功能）
	{
		"ThePrimeagen/refactoring.nvim",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("refactoring").setup({
				prompt_func_return_type = {
					go = false,
					java = false,
					cpp = false,
					c = false,
					h = false,
					hpp = false,
					cxx = false,
				},
				prompt_func_param_type = {
					go = false,
					java = false,
					cpp = false,
					c = false,
					h = false,
					hpp = false,
					cxx = false,
				},
				printf_statements = {},
				print_var_statements = {},
			})

			-- Refactoring keymaps (similar to coc.nvim refactoring)
			vim.keymap.set("x", "<leader>re", ":Refactor extract ", { desc = "Extract function" })
			vim.keymap.set("x", "<leader>rf", ":Refactor extract_to_file ", { desc = "Extract to file" })
			vim.keymap.set("x", "<leader>rv", ":Refactor extract_var ", { desc = "Extract variable" })
			vim.keymap.set({ "n", "x" }, "<leader>ri", ":Refactor inline_var", { desc = "Inline variable" })
			vim.keymap.set("n", "<leader>rI", ":Refactor inline_func", { desc = "Inline function" })
			vim.keymap.set("n", "<leader>rb", ":Refactor extract_block", { desc = "Extract block" })
			vim.keymap.set("n", "<leader>rbf", ":Refactor extract_block_to_file", { desc = "Extract block to file" })

			-- Refactoring menu using fzf-lua
			vim.keymap.set({ "n", "x" }, "<leader>xar", function()
				local actions = {
					{ ["🔄 Extract Function"] = function() vim.cmd("Refactor extract") end },
					{ ["🔄 Extract Variable"] = function() vim.cmd("Refactor extract_var") end },
					{ ["🔄 Extract to File"] = function() vim.cmd("Refactor extract_to_file") end },
					{ ["🔄 Inline Variable"] = function() vim.cmd("Refactor inline_var") end },
					{ ["🔄 Inline Function"] = function() vim.cmd("Refactor inline_func") end },
					{ ["🔄 Extract Block"] = function() vim.cmd("Refactor extract_block") end },
					{ ["🔄 Extract Block to File"] = function() vim.cmd("Refactor extract_block_to_file") end },
				}

				local fzf_lua = require("fzf-lua")
				fzf_lua.fzf_exec(function(fzf_cb)
					local entries = {}
					for _, item in ipairs(actions) do
						for title, _ in pairs(item) do
							table.insert(entries, title)
						end
					end
					for _, entry in ipairs(entries) do
						fzf_cb(entry)
					end
					fzf_cb()
				end, {
					prompt = "Refactoring> ",
					winopts = {
						title = "Refactoring Menu",
						title_pos = "center",
					},
					actions = {
						["default"] = function(selected)
							if selected and selected[1] then
								for _, item in ipairs(actions) do
									local action = item[selected[1]]
									if action then
										action()
										break
									end
								end
							end
						end,
					},
				})
			end, { desc = "Refactoring menu" })
		end,
	},
}