#!/bin/bash

set -e -u
set -x

_main() {
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

	softwareupdate --install --all

	brew install caskroom/cask/brew-cask
	brew update

	brew cask install "${CASK_APPS[@]}"

	brew install "${APPS[@]}"

	hella_slow
}

hella_slow() {
	brew cask install eclipse-cpp
}

_main
