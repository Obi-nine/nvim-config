local builtin = require('telescope.builtin')

-- Toggle state
local search_no_ignore = false

local function find_files()
  if search_no_ignore then
    builtin.find_files({
      find_command = {
        "rg", "--files", "--hidden", "--no-ignore",
        "-g", "!**/.git/*",
        "-g", "!**/node_modules/*",
        "-g", "!**/vendor/*",
      },
    })
  else
    builtin.find_files()
  end
end

local function grep_string()
  local opts = { search = vim.fn.input("Grep > ") }
  if search_no_ignore then
    opts.additional_args = { "--no-ignore", "--hidden" }
  end
  builtin.grep_string(opts)
end

local function toggle_ignore()
  search_no_ignore = not search_no_ignore
  vim.notify("Search no-ignore: " .. tostring(search_no_ignore), vim.log.levels.INFO)
end

vim.keymap.set('n', '<leader>pf', find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', grep_string)
vim.keymap.set('n', '<leader>fm', builtin.marks)
vim.keymap.set('n', '<leader>fi', toggle_ignore, { desc = "Toggle gitignore bypass" })
