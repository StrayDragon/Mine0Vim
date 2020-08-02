# Mine0Vim
My personal experimental Vim-like enviroment configs

# Preview

![](https://s1.ax1x.com/2020/04/02/GtPMGR.png)

# Installation
```bash
git clone git@github.com:StrayDragon/Mine0Vim.git # or your forked repo
```

## NeoVim
```bash
$ cd Mine0Vim/NeoVim; pwd | clipcopy       # if you don't have command clipcopy, just copy the `pwd` of this repo
$ mkdir -p ~/.config; cd ~/.config  # if you have the nvim/ directory, just backup it(rename to another directory)
$ ln -n -s <pwd for this repo> ~/.config/nvim
$ nvim +PlugUpdate
```

## IdeaVim
```bash
$ cd Mine0Vim/IdeaVim; pwd | clipcopy       # if you don't have command clipcopy, just copy the `pwd` of this repo
$ ln -s <pwd for this repo> ~/.ideavimrc
```

# License

MIT

Thanks for [vim-plug](https://github.com/junegunn/vim-plug), it's very small, easy to use and high performance.
So I integrated it as default plugins manager :)
