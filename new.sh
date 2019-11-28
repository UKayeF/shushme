#!/usr/bin/env bash
echo "Script #$$ running with $# args: $@"

# First ensure that vim is installed
#if [ -f /etc/os-release ]; then
#  # freedesktop.org and systemd
#  . /etc/os-release
#  OS=$NAME
#  VER=$VERSION_ID
#elif type lsb_release >/dev/null 2>&1; then
#  # linuxbase.org
#  OS=$(lsb_release -si)
#  VER=$(lsb_release -sr)
#elif [ -f /etc/lsb-release ]; then
#  # For some versions of Debian/Ubuntu without lsb_release command
#  . /etc/lsb-release
#  OS=$DISTRIB_ID
#  VER=$DISTRIB_RELEASE
#elif [ -f /etc/debian_version ]; then
#  # Older  Debian/Ubuntu/etc.
#  OS=Debian
#  VER=$(cat /etc/debian_version)
#else
#  OS=$(uname -s)
#  VER=$(uname -r)
#fi
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
  * )
    ;;
esac

echo "Congratulations, you have successfully installed git and vim!"
