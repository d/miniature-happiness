#!/bin/bash

set -e -u
set -x

softwareupdate --install --all

brew install caskroom/cask/brew-cask
brew update

brew cask install iterm2 eclipse-cpp p4v
brew install fish git
