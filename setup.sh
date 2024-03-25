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
	oven-sh/bun/bun
	tursodatabase/tap/turso
)

BREW_APPS=(
	"1password-cli"
	bun
	dockutil # manage dock apps
	elixir
	flyctl
	git
	gh # GitHub CLI
	go
	# imageoptim-cli # not m1 compatible
	jakehilborn/jakehilborn/displayplacer
	mas     # Search Mac App Store for ids
	mysides # customize finder sidebar
	neovim
	"node@20" # use pnpm via corepack
	pandoc
	python
	rcm # dotfile management
	rust
	swiftdefaultappsprefpane # pref. pane to see available url schemas
	tldr
	tmux
	sqlite
	openai-whisper
)

BREW_CASK_APPS=(
	"1password"
	visual-studio-code
	arc
	cleanshot
	ecamm-live
	iterm2
	karabiner-elements
	keyboard-maestro
	obs
	obsidian
	tableplus
	raycast
	recut
	rode-central
	# rode-connect # current version is busted
	warp
)

MAS_APPS=(
	# "-2143728525" # Klack, not sure why i'm getting an invalid negative id here
	441258766  # Magnet
	904280696  # Things 3
	1365531024 # 1Blocker
	1452453066 # Hidden Bar
	1569813296 # 1Password for Safari
	1616822987 # Affinity Photo 2
	1616831348 # Affinity Designer 2
	1606941598 # Affinity Publisher 2
)

PNPM_GLOBAL_APPS=(
	netlify-cli
	typescript
	storybook
	wrangler
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

	# Set the default view style for folders without custom setting: Column
	defaults write com.apple.finder "FXPreferredViewStyle" -string "clmv"

	# Set the default search scope when performing a search: Search the current folder
	defaults write com.apple.finder "FXDefaultSearchScope" -string "SCcf"

	# Remove items in the bin after 30 days: automatic
	defaults write com.apple.finder "FXRemoveOldTrashItems" -bool "true"

	# Keep folders on top when sorting
	defaults write com.apple.finder "_FXSortFoldersFirstOnDesktop" -bool "true"

	# Show path bar and status bar
	defaults write com.apple.finder ShowStatusBar -bool true
	defaults write com.apple.finder ShowPathbar -bool true

	# Items to display on the desktop
	defaults write com.apple.finder ShowHardDrivesOnDesktop -int 0
	defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -int 1
	defaults write com.apple.finder ShowRemovableMediaOnDesktop -int 1
	defaults write com.apple.finder ShowMountedServersOnDesktop -int 0

	# Open home in new window
	defaults write com.apple.finder NewWindowTarget -string "PfLo"
	defaults write com.apple.finder NewWindowTargetPath -string "'file://$HOME/"

	# Enable dragging with three finger drag
	defaults write com.apple.AppleMultitouchTrackpad "TrackpadThreeFingerDrag" -bool "true"

	# Do not display recent apps in the Dock
	defaults write com.apple.dock "show-recents" -bool "true"

	# Autohide the Dock when the mouse is out
	defaults write com.apple.dock "autohide" -bool "true"

	# Dock: Make it popup faster
	defaults write com.apple.dock autohide-delay -float 0
	defaults write com.apple.dock autohide-time-modifier -float 0

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
	# Hot corners                                                                 #
	###############################################################################
	# Hot corners
	# Possible values: 0 no-op; 2 Mission Control; 3 Show application windows;
	# 4 Desktop; 5 Start screen saver; 6 Disable screen saver; 7 Dashboard;
	# 10 Put display to sleep; 11 Launchpad; 12 Notification Center

	# defaults write com.apple.dock wvous-tl-corner -int 3
	# defaults write com.apple.dock wvous-tl-modifier -int 0

	# defaults write com.apple.dock wvous-tr-corner -int 4
	# defaults write com.apple.dock wvous-tr-modifier -int 0

	# defaults write com.apple.dock wvous-bl-corner -int 2
	# defaults write com.apple.dock wvous-bl-modifier -int 0

	# defaults write com.apple.dock wvous-br-corner -int 5
	# defaults write com.apple.dock wvous-br-modifier -int 0

	###############################################################################
	# Mac App Store                                                               #
	###############################################################################

	# Enable the automatic update check
	defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

	# Download newly available updates in background
	defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

	# Install System data files & security updates
	defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

	###############################################################################
	# mysides (third party)													      #
	###############################################################################
	# Remove things I don't want
	mysides remove Recents >/dev/null 2>&1
	mysides remove Movies >/dev/null 2>&1
	mysides remove Music >/dev/null 2>&1
	mysides remove Pictures >/dev/null 2>&1

	# Remove and append to maintain order
	mysides remove chan >/dev/null 2>&1
	mysides add chan file:///Users/chan/

	mysides remove Documents >/dev/null 2>&1
	mysides add Documents file:///Users/chan/Documents/

	mysides remove Downloads >/dev/null 2>&1
	mysides add Downloads file:///Users/chan/Downloads/

	mysides remove Desktop >/dev/null 2>&1
	mysides add Desktop file:///Users/chan/Desktop/

	mysides remove Applications >/dev/null 2>&1
	mysides add Applications file:///Applications/

	###############################################################################
	# Commit it!													      #
	###############################################################################

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
	# brew ~~tap~~ install tapped apps
	# brew tap ${BREW_TAPS[@]}
	brew install ${BREW_TAPS[@]}

	# install tap apps
	echo "installing apps from taps..."
	brew install ${BREW_TAP_APPS[@]}

	# install apps
	echo "installing apps..."
	brew install ${BREW_APPS[@]}

	# install cask apps
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
	# https://stackoverflow.com/a/73465507
	if ! command -v gh >/dev/null 2>&1; then
		echo "Install gh first"
		exit 1
	fi

	if ! gh auth status >/dev/null 2>&1; then
		gh auth login -p ssh -w
	else
		echo "Logged into GitHub. Skipping..."
	fi

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

setup_node_with_corepack() {
	if ! command -v node >/dev/null 2>&1; then
		echo "Attempting to source node…"
		(
			echo
			echo 'eval "$(/opt/homebrew/bin/brew shellenv)"'
		) >>~/.zprofile
		eval "$(/opt/homebrew/bin/brew shellenv)"
	fi

	source ~/.zprofile

	if ! command -v node >/dev/null 2>&1; then
		echo "Install node first"
		exit 1
	else
		corepack enable
		# https://pnpm.io/installation#using-corepac
		corepack prepare pnpm@latest --activate
		corepack prepare yarn@stable --activate

		# install other globals
		for i in $PNPM_GLOBAL_APPS; do
			# pnpm outdated -g $i &>/dev/null
			# if [ $? -eq 0 ]; then
			# 	echo "Skipping $i. Already up to date"
			# else
			pnpm install -g $i@latest
			# fi
		done

	fi
}

setup_mac_dock() {
	dockutil --remove all >/dev/null 2>&1
	# add an app like so:
	# dockutil --add /System/Applications/Messages.app > /dev/null 2>&1
}

add_macos_login_items() {
	# https://apple.stackexchange.com/a/310502
	osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/Things3.app", hidden:false}'
}

# EXECUTE ALL
#############

install_homebrew
install_brew_apps

setup_ssh
log_into_github

setup_dotfiles
setup_node_with_corepack

setup_mac_dock
set_macos_preferences
install_mac_app_store_apps
add_macos_login_items

setup_sites

# MANUAL FOLLOW-UPS
###################

# Launch Safari. Enable extensions.
# Launch magnet. Give permissions and enable at startup.
# Launch one Affinity Product. Apply license.
# Launch CleanShot. Give permissions and enable at startup.
# Launch Raycast. Login. Change default command to CMD+Space.
# Launch Obsidian. Settings > General > Commercial License > Activate
#
# System Settings
# > Keyboard > Shortcuts > Input Sources > Disabled All [frees up Things quick input]
# > Keyboard > Screenshots > Disable All [frees up Cleanshot]. Then set Cleanshot shortcuts in Cleanshot preferences.
#
# Install Davinc Resolve Studio. Add license
# Setup Finder preferences
# Keyboard shortcuts >
# - Keyboard > Press 🌐 key to: select `Change Input Source`.
# - Unregister `⌘^Space` (https://www.reddit.com/r/MacOS/comments/15j3pza/comment/juxx8ib/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button).
#   - Register to ^⌥⌘Space so still available.
#   - Add keyboard system keyboard shortcut to Raycast alias (if not coming from shared settings).
# Privacy >
# - Screen & System Audio Recording >
#   - Enable CleanShot X

# Move 1Password shortcuts around `/`
# - Show Quick Access: ⌘ shift \
# - Autofill: ^ shift \
# - ⌘\ should be open in new view, VS Code

# REFERENCES
############

# https://github.com/mathiasbynens/dotfiles/blob/master/.macos
# https://github.com/gricard/new-mac/blob/master/setup.sh
# https://macowners.club/posts/sane-defaults-for-macos/
