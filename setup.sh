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

PNPM_GLOBAL_APPS=(
	typescript
	wrangler
)

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

add_macos_login_items() {
	# https://apple.stackexchange.com/a/310502
	osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/Things3.app", hidden:false}'
}

# EXECUTE ALL
#############

install_homebrew
brew bundle --file="~/.Brewfile"

. ~/.dotfiles/scripts/setup_ssh.sh
. ~/.dotfiles/scripts/setup_gh.sh

. ~/.dotfiles/scripts/setup_gh.sh
setup_node_with_corepack

. ~/.dotfiles/scripts/set_macos_dock.sh
. ~/.dotfiles/scripts/set_macos_preferences.sh
. ~/.dotfiles/scripts/install_mas_apps.sh
add_macos_login_items

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
