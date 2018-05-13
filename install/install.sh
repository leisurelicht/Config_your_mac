install_path=$(
  cd $(dirname $0)
  pwd
)
config_path=$(
  cd $install_path/..
  pwd
)
echo "====> Config file root path is: ${config_path}"

if ! command -v brew >/dev/null 2>&1; then
    echo "====> Command brew is not be installed, start to install"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    echo "====> Commnad brew is already install"
fi

echo "====> Use brew to intall necessary"
brew install zsh
brew install vim --with-override-system-vi
brew install node
brew install go
brew install fzf
brew install ctags
brew install ag
brew install tmux
brew install autojump

# 安装oh-my-zsh
echo "====> Install oh-my-zsh"
if command -v curl >/dev/null 2>&1; then
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
elif command -v wget >/dev/null 2>&1; then
    sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
fi

# tmux
echo "====> Install tumx plugins manage plugin tpm"
if [ ! -d ~/.tmux/plugins/tpm ]; then
    mkdir -p ~/.tmux/plugins/tpm
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# vim-plug
echo "====> Install vim plugins manage plugin vim-plug"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "====> Create back up dir"

echo "====> Back up dir path is: ${config_path}/bak"
mkdir -p $config_path/bak

if [ -f ~/.zshrc ]; then
    echo "====> Zsh config file zshrc is exist, backup and delete it."
    mv ~/.zshrc $config_path/bak/zshrc.bak
elif [ -e ~/.zshrc ]; then
    rm ~/.zshrc
fi
echo "====> Create zshrc link"
ln -s $config_path/zsh/zshrc ~/.zshrc

if [ -f ~/.vimrc ]; then
    echo "====> Vim config file vimrc is exist, backup and delete it."
    mv ~/.vimrc $config_path/bak/vimrc
elif [ -e ~/.vimrc ]; then
    rm ~/.vimrc
fi
echo "====> Create vimrc link"
ln -s $config_path/vim/vimrc ~/.vimrc.bak

if [ -f ~/.tmux.conf ]; then
    echo "====> Tmux config file tmux.confis exist, backup and delete it."
    mv ~/.tmux.conf $config_path/bak/tmux.conf.bak
elif [ -e ~/.tmux.conf ]; then
    rm ~/.tmux.conf
fi
echo "====> Create tmux.conf link"
ln -s $config_path/tmux/tmux.conf ~/.tmux.conf

if [ ! -d ~/.config/ ]; then
    mkdir ~/.config/
fi

if [ -d ~/.config/nvim ]; then
    echo "====> Neovim config dir nvim is exist, backup and delete it."
    mv ~/.config/nvim $config_path/bak/nvim_bak
fi
echo "====> Create neovim config file links"
ln -s ~/.vim ~/.config/nvim

if [ -f ~/.config/nvim/init.vim ]; then
    mv ~/.config/nvim/init.vim
elif [ -e ~/.config/nvim/init.vim ]; then
    rm ~/.config/nvim/init.vim
fi
echo "====> Create neovim init file links"
ln -s ~/.vimrc ~/.config/nvim/init.vim

function install_from_file(){
    while read -r line
    do
        if [[ ! $line =~ "#" ]]; then
            echo "$2 $3 $4 $line"
            `$2 $3 $4 $line`
        fi
    done < $1
}

for parm in $@; do
    if [[ param == "all" ]]; then
        echo "====> Use brew and brew cask install software"
        install_from_file $install_path/brew_install brew install
        install_from_file $install_path/brew_cask_install brew install
    fi

    if [[ param == "brew" ]];then
        echo "====> Use brew to install command"
        install_from_file $install_path/brew_install brew install
    fi

    if [[ param == "brewcask" ]]; then
        echo "====> Use brew cask to install software"
        install_from_file $install_path/brew_cask_install brew cask install
    fi
done

echo "====> Use pip to install package"
install_from_file $install_path/pip3_install /usr/local/bin/pip3 install

if command -v neovim >/dev/null 2>&1; then
    install_from_file $install_path/pip_install /usr/local/bin/pip install
fi

echo "====> Use gem to install package"
install_from_file $install_path/gem_install gem install

echo "====> Use npm to install package" 
install_from_file $install_path/npm_install npm install -g

echo "====> Use go to install package"
install_from_file $install_path/go_install go get -u

# 安装vim插件
echo "====> Install vim PlugInstall"
vim -c PlugInstall

