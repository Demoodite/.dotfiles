vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Open Expelorer" })

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.keymap.set("n", "<leader>bd", function()
    local buf = vim.api.nvim_get_current_buf()
    local wins = vim.fn.win_findbuf(buf)

    if #wins > 1 then
        -- Buffer is visible in multiple windows, just close this window's view
        vim.cmd("bnext")
    else
        -- Switch to another buffer first, then delete the original
        local bufs = vim.tbl_filter(function(b)
            return vim.api.nvim_buf_is_valid(b) and vim.bo[b].buflisted and b ~= buf
        end, vim.api.nvim_list_bufs())

        if #bufs > 0 then
            vim.api.nvim_set_current_buf(bufs[#bufs])
        else
            vim.cmd("enew") -- Open empty buffer if no others exist
        end

        vim.api.nvim_buf_delete(buf, { force = false })
    end
end, { desc = "[B]uffer [D]elete" })
