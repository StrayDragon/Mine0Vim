-- 简化的调试适配器协议 (DAP) 配置
-- 为所有语言提供统一的调试支持

return {
	"mfussenegger/nvim-dap",
	lazy = true,
	dependencies = {
		-- DAP 所需的异步 IO 库
		{ "nvim-neotest/nvim-nio", lazy = true },
		-- 调试用户界面
		{ "rcarriga/nvim-dap-ui", lazy = true },
		-- 调试虚拟文本
		{ "theHamsta/nvim-dap-virtual-text", lazy = true },
		-- Mason 的 DAP 集成
		{ "jay-babu/mason-nvim-dap.nvim", lazy = true },
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		-- 检查可用的调试适配器
		local function get_debug_adapter()
			if vim.fn.executable("codelldb") == 1 then
				return "codelldb"
			elseif vim.fn.executable("lldb-vscode") == 1 then
				return "lldb-vscode"
			elseif vim.fn.executable("lldb-dap") == 1 then
				return "lldb-dap"
			else
				return "lldb-dap" -- 回退选项
			end
		end

		-- 配置适配器
		local adapter_type = get_debug_adapter()
		if adapter_type == "codelldb" then
			dap.adapters.codelldb = {
				type = "server",
				port = "${port}",
				executable = {
					command = "codelldb",
					args = { "--port", "${port}" },
				},
			}
		else
			dap.adapters.lldb = {
				type = "executable",
				command = adapter_type,
				name = "lldb",
			}
		end

		-- 通用调试配置
		dap.configurations.rust = {
			{
				name = "启动程序",
				type = adapter_type,
				request = "launch",
				program = function()
					return vim.fn.input("可执行文件路径: ", "target/debug/")
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
				args = {},
			},
			{
				name = "运行测试",
				type = adapter_type,
				request = "launch",
				program = function()
					return vim.fn.input("测试可执行文件路径: ", "target/debug/deps/")
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
			},
		}

		-- 设置 DAP UI
		require("dapui").setup({
			controls = {
				element = "repl",
				enabled = true,
				icons = {
					disconnect = "⏻",
					pause = "⏸",
					play = "▶",
					run_last = "⏭",
					step_back = "⏮",
					step_into = "⏭",
					step_out = "⏮",
					step_over = "⏭",
					terminate = "⏹",
				},
			},
			layouts = {
				{
					elements = {
						{ id = "scopes", size = 0.25 },
						{ id = "breakpoints", size = 0.25 },
						{ id = "stacks", size = 0.25 },
						{ id = "watches", size = 0.25 },
					},
					position = "left",
					size = 40,
				},
				{
					elements = {
						{ id = "repl", size = 0.5 },
						{ id = "console", size = 0.5 },
					},
					position = "bottom",
					size = 10,
				},
			},
		})

		-- 设置虚拟文本
		require("nvim-dap-virtual-text").setup({
			enabled = true,
			highlight_changed_variables = true,
			show_stop_reason = true,
		})

		-- 调试开始时自动打开 DAP UI
		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end

		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
		end

		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
		end

		-- 调试键位映射
		vim.keymap.set("n", "<leader>Db", function()
			require("dap").toggle_breakpoint()
		end, { desc = "切换断点" })

		vim.keymap.set("n", "<leader>DB", function()
			require("dap").set_breakpoint(vim.fn.input("断点条件: "))
		end, { desc = "条件断点" })

		vim.keymap.set("n", "<leader>Dc", function()
			require("dap").continue()
		end, { desc = "继续/开始调试" })

		vim.keymap.set("n", "<leader>Do", function()
			require("dap").step_over()
		end, { desc = "跳过" })

		vim.keymap.set("n", "<leader>Di", function()
			require("dap").step_into()
		end, { desc = "步入" })

		vim.keymap.set("n", "<leader>DO", function()
			require("dap").step_out()
		end, { desc = "步出" })

		vim.keymap.set("n", "<leader>Dq", function()
			require("dap").terminate()
		end, { desc = "终止调试" })

		vim.keymap.set("n", "<leader>Du", function()
			require("dapui").toggle()
		end, { desc = "切换调试 UI" })

		vim.keymap.set("n", "<leader>De", function()
			require("dapui").eval()
		end, { desc = "求值表达式" })

		-- 设置 Mason DAP 集成
		require("mason-nvim-dap").setup({
			automatic_setup = true,
			handlers = {},
			ensure_installed = {
				"codelldb", -- Rust 调试首选
			},
		})
	end,
}

