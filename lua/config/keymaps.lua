-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Compilar e rodar C++ com F5 (estilo Dev-C++) usando Snacks
vim.keymap.set("n", "<F5>", function()
  vim.cmd("write") -- Salva o arquivo atual

  local file = vim.fn.expand("%:t")
  local out = vim.fn.expand("%:t:r")

  -- O comando Bash agora cria a pasta 'output', compila lá dentro e executa de lá
  local cmd = "mkdir -p output && g++ "
    .. file
    .. " -o output/"
    .. out
    .. " && ./output/"
    .. out
    .. "; echo -e '\n-------------------\nProcesso finalizado.'; read -p 'Pressione Enter para sair...'"

  Snacks.terminal({ "bash", "-c", cmd }, {
    cwd = vim.fn.expand("%:p:h"),
  })
end, { desc = "Compile and Run C++" })

vim.keymap.set("n", "<A-j>", ":m .+1<CR>==")
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==")

vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv")

-- F9 para colocar o Breakpoint (Ponto Vermelho)
vim.keymap.set("n", "<F9>", function()
  require("dap").toggle_breakpoint()
end, { desc = "Alternar Breakpoint" })

-- F5 para Compilar silenciosamente e abrir o Debugger Visual
vim.keymap.set("n", "<F6>", function()
  vim.cmd("write") -- Salva o arquivo

  local file = vim.fn.expand("%:t")
  local out = "output/" .. vim.fn.expand("%:t:r")
  local full_path_out = vim.fn.getcwd() .. "/" .. out

  -- 1. Compila o arquivo com a flag -g (necessária para o debug)
  local compile_cmd = "mkdir -p output && g++ -g " .. file .. " -o " .. out
  vim.fn.system(compile_cmd) -- Roda a compilação de forma invisível

  -- 2. Inicia o DAP usando o codelldb (que você já instalou no Mason)
  local dap = require("dap")
  dap.run({
    name = "Debug " .. file,
    type = "codelldb",
    request = "launch",
    program = full_path_out,
    cwd = vim.fn.getcwd(),
    stopOnEntry = false,
  })
end, { desc = "Compilar e Debugar (DAP)" })

-- F10 e F11 para navegar linha a linha durante o debug
vim.keymap.set("n", "<F10>", function()
  require("dap").step_over()
end, { desc = "Debug: Step Over" })
vim.keymap.set("n", "<F11>", function()
  require("dap").step_into()
end, { desc = "Debug: Step Into" })
