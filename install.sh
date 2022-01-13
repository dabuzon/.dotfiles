#!/bin/sh

echo "Setting up Mac..."

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update Homebrew recipes
brew update

# Install all our dependencies with bundle (See Brewfile)
brew tap homebrew/bundle
brew bundle

# Make ZSH the default shell environment
sudo sh -c 'echo $(brew --prefix)/bin/zsh >> /etc/shells' && \
chsh -s $(brew --prefix)/bin/zsh

# Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles
rm -rf $HOME/.zshrc
ln -s $HOME/.dotfiles/.zshrc $HOME/.zshrc

# Setup Antibody
antibody bundle <"$DOTFILES/zsh_plugins.txt" >"$DOTFILES/zsh_plugins.sh"
antibody update

# Symlink Neovim
rm -rf $HOME/.local
ln -s $HOME/.dotfiles/nvim $HOME/.config/nvim

# Symlink the Mackup config file to the home directory
ln -s $HOME/.dotfiles/.mackup.cfg $HOME/.mackup.cfg

# Symlink VSCode configuration
ln -s $HOME/.dotfiles/vscode $HOME/.vscode

# Remove .CFUserTextEncoding
rm .CFUserTextEncoding

# Ensure to source .zshrc file
source .zshrc

# Set macOS preferences
# We will run this last because this will reload the shell
source .macos
