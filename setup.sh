#!/bin/zsh

# INSTRUCTIONS
##############

## RUN REMOTELY
# /bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/chantastic/dotfiles/master/setup.sh)"

# MAKE SCRIPT EXECUTABLE
# https://linuxopsys.com/topics/make-bash-script-executable-using-chmod
# chmod u+x setup.sh
# run with ./setup.sh

# VARIABLES
###########
EMAIL=mijoch@gmail.com

BREW_TAPS=(
	oven-sh/bun
)

BREW_APPS=(
	"1password"
	bun
	dockutil # manage dock apps
	flctl
	git
	gh  # GitHub CLI
	mas # Search Mac App Store for ids
	neovim
	rcm # dotfile management
	tmux
	volta # Node.js manager
	sqlite
)

BREW_CASK_APPS=(
	visual-studio-code
	arc
	karabiner-elements
	tableplus
	recut
)

MAS_APPS=(
	904280696  # Things 3
	441258766  # Magnet
	1365531024 # 1Blocker
	1569813296 # 1Password for Safari
	1616822987 # Affinity Photo 2
	1616831348 # Affinity Designer 2
	1606941598 # Affinity Publisher 2
)

set_macos_preferences() {
	echo "Setting up mac"

	# change keyboard to dvorak at system login level
	# https://vkritis.blogspot.com/2014/01/change-default-keyboard-of-osx-login.html

	# Close any open System Preferences panes, to prevent them from overriding
	# settings we’re about to change
	osascript -e 'tell application "System Preferences" to quit'

	# list of plist commands
	# https://macos-defaults.com

	# Autohide the Dock when the mouse is out
	defaults write com.apple.dock "autohide" -bool "true"

	# Set the default view style for folders without custom setting: Column
	defaults write com.apple.finder "FXPreferredViewStyle" -string "clmv"

	# Set the default search scope when performing a search: Search the current folder
	defaults write com.apple.finder "FXDefaultSearchScope" -string "SCcf"

	# Remove items in the bin after 30 days: automatic
	defaults write com.apple.finder "FXRemoveOldTrashItems" -bool "true"

	# Keep folders on top when sorting
	defaults write com.apple.finder "_FXSortFoldersFirstOnDesktop" -bool "true"

	# Enable dragging with three finger drag
	defaults write com.apple.AppleMultitouchTrackpad "TrackpadThreeFingerDrag" -bool "true"

	# Do not display recent apps in the Dock
	defaults write com.apple.dock "show-recents" -bool "true"

	###############################################################################
	# Time Machine                                                                #
	###############################################################################

	# Prevent Time Machine from prompting to use new hard drives as backup volume
	defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

	###############################################################################
	# Text Editing / Keyboards                                                    #
	###############################################################################

	# Disable smart quotes and smart dashes
	defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
	defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

	# Disable auto-correct
	defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

	# Use plain text mode for new TextEdit documents
	defaults write com.apple.TextEdit RichText -int 0

	# Open and save files as UTF-8 in TextEdit
	defaults write com.apple.TextEdit PlainTextEncoding -int 4
	defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

	###############################################################################
	# Trackpad, mouse, keyboard, Bluetooth accessories, and input                 #
	###############################################################################

	# Enable full keyboard access for all controls
	# (e.g. enable Tab in modal dialogs)
	defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

	# Set key repeat rate to fast
	defaults write NSGlobalDomain KeyRepeat -int 2

	# Reduce delay to repeat
	defaults write NSGlobalDomain InitialKeyRepeat -int 15

	# Increase trackpad speed
	defaults write NSGlobalDomain com.apple.trackpad.scaling -int 2.5

	###############################################################################
	# Mac App Store                                                               #
	###############################################################################

	# Enable the automatic update check
	defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

	# Download newly available updates in background
	defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

	# Install System data files & security updates
	defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

	killall Dock
	killall Finder
}

install_mac_app_store_apps() {
	# https://github.com/mas-cli/mas
	echo "Installing Mac App Store apps…"

	mas install ${MAS_APPS[@]}
}

install_homebrew() {
	which -s brew
	if [[ $? != 0 ]]; then
		echo "Installing homebrew..."
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	else
		echo "Updating brew..."
		brew upgrade
	fi
}

install_brew_apps() {
	# brew tap
	brew tap ${BREW_TAPS[@]}

	# install apps
	echo "installing apps..."
	brew install ${BREW_APPS[@]}

	echo "installing apps with Cask..."
	brew install --cask ${BREW_CASK_APPS[@]}

	brew cleanup

	eval "$(/opt/homebrew/bin/brew shellenv)"
}

# (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/chan/.zprofile
# eval "$(/opt/homebrew/bin/brew shellenv)"

log_into_github() {
	# https://cli.github.com/manual/gh_auth_login
	# logging in will automatically prompt to add ssh keys
	gh auth login -p ssh -w
}

setup_ssh() {
	if [ -e ~/.ssh/id_ed25519 ]; then
		echo "Skipping setup_ssh"
	else
		# https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
		echo "Initializing setup_ssh"
		ssh-keygen -t ed25519 -C "$EMAIL"
		eval "$(ssh-agent -s)"
	fi

	if [ -e ~/.ssh/config ]; then
		echo "ssh config already exists. Skipping adding osx specific settings... "
	else
		ssh-add --apple-use-keychain ~/.ssh/id_ed25519
		echo "Writing osx specific settings to ssh config... "
		ssh-keyscan github.com >>~/.ssh/known_hosts
		cat <<EOT >>~/.ssh/config
Host *
	AddKeysToAgent yes
	UseKeychain yes
	IdentityFile ~/.ssh/id_ed25519
EOT
	fi
}

setup_dotfiles() {
	if [ -d ~/.dotfiles ]; then
		echo "dotfiles installed at path ~/.dotfiles"
	else
		echo "installing dotfiles"
		git clone git@github.com:chantastic/dotfiles.git ~/.dotfiles
	fi

	rcup -v -d ~/.dotfiles
}

setup_sites() {
	if [ -d ~/sites ]; then
		echo "sites installed at path ~/sites"
	else
		echo "installing sites"
		git clone git@github.com:chantastic/sites.git ~/sites
	fi
}

setup_node_with_volta() {
	https://docs.volta.sh/guide/#features
	volta install node@lts
	volta install pnpm@latest

	npm install -g npm@10.2.3
	npm install --global typescript
}

# EXECUTE ALL
#############

install_homebrew
install_brew_apps

setup_ssh
log_into_github

set_macos_preferences
install_mac_app_store_apps

setup_node_with_volta

setup_sites

# MANUAL FOLLOW-UPS
###################

# Enable Safari Addons
# Launch magnet, give permissions, and enable at startup
# Add Affinity licences

# TAKE IT FURTHER
#################

# modify CAPS LOCK to CTRL
# Use dockutils to cleanup dock (had trouble because python recip is not linking)

# REFERENCES
############

# https://github.com/mathiasbynens/dotfiles/blob/master/.macos
# https://github.com/gricard/new-mac/blob/master/setup.sh
