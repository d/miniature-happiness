#!/bin/bash

set -e -u
set -x

_main() {
	softwareupdate --install --all

	install_packages
	install_vimfiles

	hella_slow
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
	)
	local readonly CASK_APPS=(
		iterm2
		p4v
		macvim
		fluid
	)

	brew install caskroom/cask/brew-cask
	brew update

	brew cask install "${CASK_APPS[@]}"

	brew install "${APPS[@]}"
}

hella_slow() {
	brew cask install eclipse-cpp
}

_main
