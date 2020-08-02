# Mine0Vim

My personal experimental NeoVim structured configs, note that it is NOT tested on Vim now!

# Preview

![](https://s1.ax1x.com/2020/04/02/GtPMGR.png)

# Installation
```
$ git clone git@github.com:StrayDragon/Mine0Vim.git # or your forked repo
$ cd Mine0Vim; pwd | clipcopy # if you don't have command clipcopy, just copy the `pwd` of this repo
$ mkdir -p ~/.config; cd ~/.config # if you have the nvim/ directory, just backup it(rename to another directory)
$ ln -n -s <`pwd` for this repo> nvim
$ nvim +PlugUpdate
```

# License

MIT

Thanks for [vim-plug](https://github.com/junegunn/vim-plug), it's very small, easy to use and high performance.
So I integrated it as default plugins manager :)
