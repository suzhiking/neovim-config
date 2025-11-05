if vim.g.vscode then
    vim.api.nvim_exec2("nmap j gj", {output=false})
    vim.api.nvim_exec2("nmap k gk", {output=false})
end
