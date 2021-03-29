# Mine0Vim
My personal experimental Vim-like enviroment configs

# Preview

![](https://s1.ax1x.com/2020/04/02/GtPMGR.png)

# Installation
```bash
git clone https://github.com/StrayDragon/Mine0Vim.git # or your forked repo
```

## NeoVim
```bash
$ cd Mine0Vim/NeoVim; pwd | clipcopy       # if you don't have command clipcopy, just copy the `pwd` of this repo
$ mkdir -p ~/.config; cd ~/.config  # if you have the nvim/ directory, just backup it(rename to another directory)
$ ln -n -s <pwd for this repo> ~/.config/nvim
$ nvim +PlugUpdate
```

### Ensure other deps
#### Python2/3
> use [pyenv/pyenv-virtualenv](https://github.com/pyenv/pyenv-installer) manage versions
```bash
# py2
pyenv install 2.7.18
# use Chinese mirror
# v=2.7.18 ; wget https://npm.taobao.org/mirrors/python/$v/Python-$v.tar.xz -P ~/.pyenv/cache/;pyenv install $v
pyenv virtualenv 2.7.18 pynvim2
pyenv activate pynvim2
pip install pynvim

# py3
pyenv install 3.8.5
# use Chinese mirror
# v=3.8.5 ; wget https://npm.taobao.org/mirrors/python/$v/Python-$v.tar.xz -P ~/.pyenv/cache/;pyenv install $v
pyenv virtualenv 3.8.5 pynvim3
pyenv activate pynvim3
pip install pynvim
```
#### Nodejs 
> use [n](https://github.com/tj/n)  manage versions
```bash
n lts
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
