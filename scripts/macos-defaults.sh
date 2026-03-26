#!/usr/bin/env bash
set -euo pipefail

# macOS Developer Defaults
# Run once on a fresh Mac. Reference: https://macos-defaults.com

osascript -e 'tell application "System Settings" to quit' 2>/dev/null || true
sleep 1

# Finder
defaults write NSGlobalDomain "AppleShowAllExtensions" -bool true
defaults write com.apple.finder "ShowPathbar" -bool true
defaults write com.apple.finder "ShowStatusBar" -bool true
defaults write com.apple.finder "FXPreferredViewStyle" -string "Nlsv"           # List view
defaults write com.apple.finder "_FXSortFoldersFirst" -bool true
defaults write com.apple.finder "FXDefaultSearchScope" -string "SCcf"           # Search current folder
defaults write com.apple.finder "FXEnableExtensionChangeWarning" -bool false
defaults write NSGlobalDomain "NSDocumentSaveNewDocumentsToCloud" -bool false
sudo defaults write com.apple.universalaccess "showWindowTitlebarIcons" -bool true
defaults write NSGlobalDomain "NSToolbarTitleViewRolloverDelay" -float 0
defaults write com.apple.desktopservices "DSDontWriteNetworkStores" -bool true
killall Finder 2>/dev/null || true

# Dock
defaults write com.apple.dock "autohide" -bool true
defaults write com.apple.dock "autohide-delay" -float 0
defaults write com.apple.dock "autohide-time-modifier" -float 0.3
defaults write com.apple.dock "show-recents" -bool false
defaults write com.apple.dock "tilesize" -int 40
defaults write com.apple.dock "mineffect" -string "scale"
defaults write com.apple.dock "mru-spaces" -bool false                          # Don't rearrange Spaces
killall Dock 2>/dev/null || true

# Keyboard
defaults write NSGlobalDomain "AppleKeyboardUIMode" -int 2                      # Full keyboard navigation

# Screenshots
defaults write com.apple.screencapture "show-thumbnail" -bool false
defaults write com.apple.screencapture "disable-shadow" -bool true

# Global UI
defaults write NSGlobalDomain "NSNavPanelExpandedStateForSaveMode" -bool true
defaults write NSGlobalDomain "NSNavPanelExpandedStateForSaveMode2" -bool true

# TextEdit
defaults write com.apple.TextEdit "RichText" -int 0
defaults write com.apple.TextEdit "SmartQuotes" -bool false
