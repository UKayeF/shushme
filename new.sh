#!/usr/bin/env bash
echo "Script #$$ running with $# args: $@"

function packman
{
  case `uname` in
    Linux )
      LINUX=1
      which yum > /dev/null 2>&1 && { PM=yum; return; }
      which zypper > /dev/null  2>&1 && { PM=zypper; return; }
      which apt-get > /dev/null  2>&1 && { PM=apt-get; return; }
      which pacman > /dev/null  2>&1 && { PM=pacman; return; }
      ;;
    Darwin )
      DARWIN=1
      ;;
    * )
      ;;
  esac
}
packman
echo $PM

# Install git and vim which are needed for the next steps
case $PM in
  pacman )
    pacman -Syu
    pacman -S git
    pacman -S vim
    ;;
  apt-get )
    apt-get update
    apt-get install git
    apt-get install vim
    ;;
  zypper )
    zypper patch
    zypper in git
    zypper in vim
    ;;
  yum )
    yum update
    yum install git
    yum install vim
    ;;
  * )
    ;;
esac
echo "Congratulations, you have successfully installed git and vim!"

# Set up vim config
git clone https://github.com/UKayeF/dotfiles ~

function install_bundle()
{
  pathexists=$(ls -A ~/.vim/bundle | grep ${$2})
  if [ "$pathexists" != "" ] then
    return
  fi
  git clone $1 ~/.vim/bundle/${$2}
}

if [ "$(ls -A ~ | grep .vimrc)" != ".vimrc" ] then
  cp ~/dotfiles/.vimrc ~/.vimrc
  mkdir -p ~/.vim/{bundle,autoload}
  echo "Install Pathogen? [Y]es/[N]o"
  read yes
  if [[ "$yes" =~ [Y|y]?(es) ]] then
    # Pathogen Vim
    git clone https://github.com/tpope/vim-pathogen ~/.vim
    mv ~/.vim/vim-pathogen/autoload/ ~/.vim/autoload/
    $gruvbox="https://github.com/morhetz/gruvbox"
    $palenight="https://github.com/drewtempelmeyer/palenight.vim"
    $nerdtree="https://github.com/scrooloose/nerdtree"
    $airline="https://github.com/vim-airline/vim-airline"

    echo "Pathogen installed! Which bundles do you want to install?\n
    1) gruvbox color theme\n
    2) palenight color theme\n
    3) nerdtree file explorer\n
    4) airline-vim powerline\n
    5) all of them\n
    6) I'm fine, thanks!"
    read num
    case `num` in
      1 )
        install_bundle $gruvbox gruvbox
        ;;
      2 )
        install_bundle $palenight palenight
        ;;
      3 )
        install_bundle $nerdtree nerdtree
        ;;
      4 )
        install_bundle $airline airline-vim
        ;;
      5 )
        install_bundle $gruvbox gruvbox
        install_bundle $palenight palenight
        install_bundle $nerdtree nerdtree
        install_bundle $airline airline
        ;;
      * )
        exit 0;
    esac
  fi
fi

echo "Plugins have been installed! Do you want to run vim now?"
read openvim
if [[ "$openvim" =~ [Y|y]?(es) ]] then
  vim ~/.vimrc
fi
exit 0



fi

