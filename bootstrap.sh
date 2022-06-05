#!/usr/bin/env bash

set -xeu

# install_aura() {
#   local TMPDIR
#   TMPDIR=$(mktemp -d -p /tmp aura-bin)
#   pushd "$TMPDIR"
#   git clone https://aur.archlinux.org/aura-bin.git
#   cd aura-bin
#   makepkg
#   sudo pacman -U --noconfirm *.pkg.tar.zst
#   popd
# }

install_rpw() {
  mkdir -p "$HOME/bin/"
  wget https://github.com/thalesmg/rpw/releases/download/v1.4.0/rpw -o "$HOME/bin/rpw"
  chmod +x "$HOME/bin/rpw"
}

sudo pacman -Sy --noconfirm git curl wget ansible

[[ -f "$HOME/bin/rpw" ]] || install_rpw && echo re-run with rpw! && exit 1

ansible-playbook -i hosts default.yml -K -t aura_install

ansible-playbook -i hosts default.yml -K -t bootstrap,gnupg,emacs

ansible-playbook -i hosts default.yml -K -t xmonad,cl-scripts,asdf

ansible-playbook -i hosts default.yml -K -t ntpd,swap,bluetooth

ansible-playbook -i hosts default.yml -K -t stack,docker
