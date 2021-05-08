
-- not even used, but epic. stores the path to the root config directory.
local vim_config_root = vim.fn.expand("<sfile>:p:h")

local pack_path = vim.fn.stdpath("data") .. "/site/pack"

function ensure(user, repo)
  -- Ensures a given github.com/USER/REPO is cloned in the pack/packer/start directory.
  local install_path = string.format("%s/packer/start/%s", pack_path, repo, repo)
  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.api.nvim_command(string.format("!git clone https://github.com/%s/%s %s", user, repo, install_path))
    vim.api.nvim_command(string.format("packadd %s", repo))
  end
end

-- Bootstrap essential plugins required for installing and loading the rest.
ensure("wbthomason", "packer.nvim")
ensure("Olical", "aniseed")

vim.g["aniseed#env"] = { 
  compile = true 
}
