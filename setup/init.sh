#!/usr/bin/env zsh

# Function to check for errors during installation
check_installation_error() {
    if [ $? -ne 0 ]; then
        echo "Error during installation. Exiting..."
        exit 1
    fi
}

# Install xcode command line tools
echo "Installing xcode command line tools"
xcode-select --install
check_installation_error

# Install rosetta
echo "Installing Rosetta"
softwareupdate --install-rosetta
check_installation_error


# Check if Brew is installed
if command -v brew &> /dev/null; then
    echo "Brew is already installed."
else
    echo "Brew is not installed. Installing Brew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    check_installation_error
    echo >> ${ZDOTDIR:-~}/.zprofile
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ${ZDOTDIR:-~}/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
    source ${ZDOTDIR:-~}/.zprofile
fi

# Adding x86 emulation to terminal
echo "Downloading rosetta script"
curl https://raw.githubusercontent.com/zarry0/misc/refs/heads/main/setup/rosettaScript >> ${ZDOTDIR:-~}/.zshrc
source ${ZDOTDIR:-~}/.zshrc

echo "Installing Brew in rosetta terminal"
izsh
if command -v brew &> /dev/null; then
    echo "Brew is already installed."
else
    echo "Brew is not installed. Installing Brew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    check_installation_error
fi
mzsh

# Installing apps
declare -a apps=("arc" "iterm2" "1password" "rectangle" "hiddenbar" "nordvpn" "notion" "the-unarchiver" "visual-studio-code" "discord" "maccy" "alt-tab" "obsidian")
for i in "${apps[@]}"
do
   brew install --cask $i
   check_installation_error
done

# Installing packages
declare -a pkgs=("bat" "lazygit" "tmux" "neovim" "fzf")
for i in "${pkgs[@]}"
do
   brew install $i
   check_installation_error
done
$(brew --prefix)/opt/fzf/install

# Adding config to .zshrc
ZSHRC="$HOME/.zshrc"

append_if_missing() {
  local line="$1"
  local file="$2"
  if grep -Fxq "$line" "$file"; then
    return 1  
  else
    echo "$line" >> "$file"
    return 0  
  fi
}

echo "Adding vi mode to ~/.zshrc..."

if append_if_missing "# vi mode" "$ZSHRC": then
    echo "bindkey -v" >> "$ZSHRC"
    echo "export KEYTIMEOUT=1" >> "$ZSHRC"
    echo "" >> "$ZSHRC"
fi

if append_if_missing "# bat theme" "$ZSHRC"; then
    echo 'export BAT_THEME="TwoDark"' >> "$ZSHRC"
fi

if append_if_missing "# fzf config" "$ZSHRC"; then
    echo "[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh" >> "$ZSHRC"
    echo "export FZF_DEFAULT_OPTS=' --height=40% --preview=\"bat --color=always {}\" --preview-window=right:60%:wrap'"
fi

# Change launchpad icon size
defaults write com.apple.dock springboard-columns -int 9
defaults write com.apple.dock springboard-rows -int 8
killall Dock

# source .zshrc
source ${ZDOTDIR:-~}/.zprofile

