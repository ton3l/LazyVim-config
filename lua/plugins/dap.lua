return {
  {
    "mfussenegger/nvim-dap",
    optional = true,
    opts = function()
      local dap = require("dap")
      -- Force define the correct executable path
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          -- Replace this string with the absolute path to your codelldb binary
          command = vim.fn.expand("$HOME/.local/share/nvim/mason/bin/codelldb"),
          args = { "--port", "${port}" },
        },
      }
    end,
  },
}
