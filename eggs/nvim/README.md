# Nvim

My Neovim configuration using LazyVim as a base for stability.

Try it, however some features might be broken in docker. Mason I am looking at you.

```
docker run -w /root -it --rm alpine:edge sh -uelic '
  apk add git neovim ripgrep alpine-sdk --update
  git clone https://github.com/druskus20/dots ~/.config/dots
  mv ~/.config/dots/nvim-lazyvim/.config/nvim ~/.config/nvim
  cd ~/.config/nvim
  nvim 
'
```

## Tips

`'<space>+C` will print the highlight group under the cursor. For treesitter
highlights `nvim-treesitter/playground` can be used with TSHighlightCapturesUnderCursor
