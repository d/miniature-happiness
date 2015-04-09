#!/bin/bash

set -e -u
set -x

_main() {
	softwareupdate --install --all

	install_packages
	install_vimfiles
	install_fishfiles

	hella_slow
}

install_fishfiles() {
	if [[ -e ~/.config/fish ]]; then
		return
	fi
	git clone https://github.com/d/fishfiles ~/.config/fish
}

install_vimfiles() {
	# Assume .vim is colonized
	if [[ -e ~/.vim ]]; then
		return
	fi
	git clone https://github.com/d/vimfiles ~/.vim
	~/.vim/bin/setup.sh
}

install_packages() {
	local readonly APPS=(
		fish
		git
		cmake
		p7zip
		ctags
		cscope
		docker
		boot2docker
		docker-machine
		ssh-copy-id
		hub
		autoconf
		homebrew/binary/perforce
	)
	local readonly CASK_APPS=(
		iterm2
		p4v
		macvim
		fluid
		keycastr
		vagrant
		google-chrome
		virtualbox
		java
		packer
	)

	brew install caskroom/cask/brew-cask
	brew update

	brew cask install "${CASK_APPS[@]}"

	brew install "${APPS[@]}"

	brew untap homebrew/binary
}

hella_slow() {
	local readonly CASK_APPS=(
		pycharm
		intellij-idea
		eclipse-cpp
		clion-eap
	)
	brew cask install "${CASK_APPS[@]}"
}

_main
