#!/bin/sh
set -eu

[ "$(id -u)" -eq 0 ] || { echo "[dotfile] must be root" >&2; exit 1; }

freebsd() {
  PACKAGES="cowsay sl doas zsh"
  echo "[dotfile] installing packages"
  pkg install -y $PACKAGES

  echo "[dotfile] setting up procfs"
  grep --quiet --extended-regexp '^[^#]*[[:space:]]/proc[[:space:]]' /etc/fstab \
  || printf 'proc\t/proc\tprocfs\trw\t0\t0\n' >> /etc/fstab
  [ -e /proc/curproc ] || mount /proc
}

fedora() {
  PACKAGES="cowsay sl zsh"
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
  *) echo "[dotfile] not supported OS" >&2; exit 1;;
esac
