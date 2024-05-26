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
	typescript
	wrangler
)

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
brew bundle --file="~/.Brewfile"

setup_ssh
log_into_github

setup_dotfiles
setup_node_with_corepack

setup_mac_dock
. ~/.dotfiles/scripts/set_macos_preferences.sh
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
