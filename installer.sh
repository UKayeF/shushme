#!/usr/bin/env bash
echo "Script #$$ running with $# args: $@"

for arg in $@; do
  # Use -y or -yy flag for skipping prompts
  if [ "$arg" == "-y" ] || [ "$arg" == "-yy" ]; then
    y="-y"
  fi

  if [ "$arg" == "-yy" ]; then
    yes="yes"
  fi

  # Clean up directories
  if [ "$arg" == "-c" ]; then
    echo "Clean up directories? [Y]es/[N]o"
    read accept
    if [[ "$accept" =~ [Y|y](es)* ]]; then
      echo "Cleaning up directories now..."
      rm -rf ~/{.vim,.vimrc,dotfiles}
      else echo "No changes made, exiting now...";
    fi
    exit 0;
  fi
done

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
    pacman -Su $y
    pacman -S git $y
    pacman -S vim $y
    ;;
  apt-get )
    apt-get update $y
    apt-get install git $y
    apt-get install vim $y
    ;;
  zypper )
    zypper patch $y
    zypper in git $y
    zypper in vim $y
    ;;
  yum )
    yum update $y
    yum install git $y
    yum install vim $y
    ;;
  * )
    ;;
esac
echo "Congratulations, you have successfully installed git and vim!"

# Set up vim config
git clone https://github.com/UKayeF/dotfiles ~/dotfiles

function install_bundle()
{
	echo $2
  pathexists=$(ls -A ~/.vim/bundle | grep "$2")
  if [ "$pathexists" != "" ]; then
    echo $pathexists; return;
   else git clone $1 ~/.vim/bundle/"$2"
  fi
}

if [ "$(ls -A ~ | grep .vimrc)" != ".vimrc" ]; then
  cp ~/dotfiles/.vimrc ~/.vimrc
  mkdir -p ~/.vim/{bundle,autoload}
  if [ "$yes" != "yes" ]; then
    echo "Install Pathogen? [Y]es/[N]o"
    read yes
  fi
  if [[ "$yes" =~ [Y|y](es)* ]]; then
    # Pathogen Vim
    git clone https://github.com/tpope/vim-pathogen ~/.vim/vim-pathogen
    mv ~/.vim/vim-pathogen/autoload/pathogen.vim ~/.vim/autoload/
    rm -rf ~/.vim/vim-pathogen
    gruvbox="https://github.com/morhetz/gruvbox"
    palenight="https://github.com/drewtempelmeyer/palenight.vim"
    nerdtree="https://github.com/scrooloose/nerdtree"
    airline="https://github.com/vim-airline/vim-airline"

    echo "Pathogen installed! Which bundles do you want to install?\n
    1) gruvbox color theme\n
    2) palenight color theme\n
    3) nerdtree file explorer\n
    4) airline-vim powerline\n
    5) all of them\n
    6) I'm fine, thanks!"
    read num
    case "$num" in
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

echo "Plugins have been installed! Do you want to run vim now? [Y]es/[N]o"
read openvim
if [[ "$openvim" =~ [Y|y](es)* ]]; then
  vim ~/.vimrc
fi
exit 0




