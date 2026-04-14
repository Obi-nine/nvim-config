local function load_env()
  local env_file = vim.fn.stdpath('config') .. '/.env'
  if vim.fn.filereadable(env_file) == 1 then
    for line in io.lines(env_file) do
      local key, value = line:match('([^=]+)=(.+)')
      if key and value then
        vim.fn.setenv(key, value)
      end
    end
  end
end

load_env()
