#!/bin/bash

set -e -u
set -x

_main() {
	install_google_signing_key
	install_packages
	install_git_pair
	install_vimfiles
	install_fishfiles
}

install_git_pair() {
	if ! which git-pair; then
		sudo /usr/bin/gem install pivotal_git_scripts
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
		vim-gnome
		python-dev
		ruby
		ruby-dev

		p7zip
		ctags
		cscope
		# rbenv
		# ruby-build
		byobu
		screen-

		indicator-multiload

		google-chrome-unstable
	)
	sudo apt-get update
	sudo apt-get install -y "${APPS[@]}"
}

install_google_signing_key() {
	readonly local google_key_id=7fac5991
	if ! gpg --keyring /etc/apt/trusted.gpg --list-key "${google_key_id}"; then
		wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
	fi
	echo "deb http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list > /dev/null
}

_main "$@"
