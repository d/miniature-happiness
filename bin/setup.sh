#!/bin/bash

set -e -u
set -x

softwareupdate --install --all

brew install caskroom/cask/brew-cask
brew update

brew cask install iterm2 p4v

brew install fish git

brew cask install eclipse-cpp
