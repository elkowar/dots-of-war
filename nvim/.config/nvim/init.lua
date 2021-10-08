



-- not even used, but epic. stores the path to the root config directory.
local vim_config_root = vim.fn.expand("<sfile>:p:h")

local pack_path = vim.fn.stdpath("data") .. "/site/pack"

function ensure(user, repo, branch, commit)
  -- Ensures a given github.com/USER/REPO is cloned in the pack/packer/start directory.
  local install_path = pack_path .. "/packer/start/" .. repo
  -- local install_path = string.format("%s/packer/start/%s", pack_path, repo, repo)
  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.system({"git", "clone", "--depth", "1", "--branch", branch, "https://github.com/" .. user .. "/" .. repo, install_path})
    if commit ~= nil then
      vim.fn.system({"git", "--git-dir", install_path .. "/.git", "reset", "--hard", commit})
    end
    vim.api.nvim_command(string.format("packadd %s", repo))
  end
end

-- Bootstrap essential plugins required for installing and loading the rest.
ensure("wbthomason", "packer.nvim", "master")
ensure("Olical", "aniseed", "develop")
-- ensure("Olical", "aniseed", "v3.22.0")
--ensure("wbthomason", "packer.nvim", "master", "daec6c759f95cd8528e5dd7c214b18b4cec2658c")
--ensure("Olical", "aniseed", "v3.21.0")


vim.g["aniseed#env"] = {
  compile = true
}
--require("aniseed.env").init({compile = true})


vim.cmd ("source "..vim_config_root.."/amulet.vim")
