#!/bin/bash

set -e -u
set -x

_main() {
	softwareupdate --install --recommended

	install_git_pair
	install_brew
	install_packages
	install_vimfiles
	install_fishfiles

	hella_slow
}

install_git_pair() {
	sudo env RBENV_VERSION=system gem install pivotal_git_scripts
}

install_brew() {
	if ! which brew; then
		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	fi
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
	readonly local APPS=(
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
		rbenv
		ruby-build
		autoconf
		homebrew/binary/perforce
		node
		go
	)
	readonly local CASK_APPS=(
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

	brew update

	brew cask install "${CASK_APPS[@]}"

	brew install "${APPS[@]}"

	brew untap homebrew/binary
}

hella_slow() {
	readonly local CASK_APPS=(
		pycharm
		intellij-idea
		eclipse-cpp
		clion
	)
	brew cask install "${CASK_APPS[@]}"
}

_main "$@"
