#!/bin/bash

set -e -u
set -x

_main() {
	softwareupdate --install --all

	install_git_pair
	install_brew
	install_packages
	install_pip
	install_python_packages
	install_vimfiles
	install_fishfiles

	git_config
}

install_pip() {
	if ! command -v pip; then
		sudo easy_install pip
	fi
}

install_python_packages() {
	local packages=(
		psutil
		lockfile
		paramiko
	)
	pip install --user "${packages[@]}"
}

gem_installed() {
	env RBENV_VERSION=system gem which "$1" > /dev/null
}

install_gem() {
	sudo env RBENV_VERSION=system gem install "$1"
}

install_git_pair() {
	if ! gem_installed pivotal_git_scripts/git_pair ; then
		install_gem pivotal_git_scripts
	fi
}

install_brew() {
	if ! command -v brew; then
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
		make
		p7zip
		ninja
		bear
		ctags
		cscope
		ssh-copy-id
		hub
		rbenv
		ruby-build
		autoconf
		wget
		ccache
		parallel
		shellcheck
		git-duet/tap/git-duet
		direnv
		tmux
		watch
		findutils
		coreutils
	)

	local LIBS=(
		libevent
		libyaml
		zstd
		readline
		apr
	)

	readonly local CASK_APPS=(
		iterm2
		macvim
		fluid
		keycastr
		flycut
		google-chrome
		shiftit
		homebrew/cask-versions/docker-edge
		zoomus
	)

	brew update

	brew cask install "${CASK_APPS[@]}"

	brew install "${APPS[@]}" "${LIBS[@]}"
}

git_config() {
	git config --global submodule.fetchJobs 0
	git config --global protocol.version 2
}


_main "$@"
