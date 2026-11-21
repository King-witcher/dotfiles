#!/bin/sh
set -eu

[ "$(id -u)" -eq 0 ] || { echo "Must be root" >&2; exit 1; }

freebsd() {
  PACKAGES="cowsay sl doas zsh"
  echo "====> Installing Packages"
  pkg install -y $PACKAGES
}

fedora() {
  PACKAGES="cowsay sl zsh"
  echo "====> Installing Packages"
  dnf install -y $PACKAGES
}

case $(uname -s) in
  FreeBSD) OS=freebsd ;;
  Linux)   OS=$(. /etc/os-release && echo "$ID") ;;
  *)       OS=$(uname -s) ;;
esac

case $OS in
  freebsd) freebsd;;
  fedora) fedora;;
  *) echo Not supported OS >&2; exit 1;;
esac
