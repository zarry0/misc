#!/bin/bash

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
fi

# Adding x86 emulation to terminal
echo Downloading rosetta script
curl https://raw.githubusercontent.com/zarry0/misc/refs/heads/main/setup/rosettaScript >> ${ZDOTDIR:-~}/.zshrc

# Install asdf 
if command -v asdf &> /dev/null; then
    echo "asdf is already installed."
else
    echo "asdf is not installed."
    echo "Installing asdf prerequisites..."
    brew install coreutils curl git
    check_installation_error
    echo "Installing asdf..."
    brew install asdf
    check_installation_error
    echo -e "\n. $(brew --prefix asdf)/libexec/asdf.sh" >> ${ZDOTDIR:-~}/.zshrc
fi

# Installing apps
# app list
declare -a apps=("arc" "iterm2" "1password" "rectangle" "hiddenbar" "nordvpn" "notion" "the-unarchiver" "visual-studio-code" "discord")
for i in "${apps[@]}"
do
   brew install --cask $i
   check_installation_error
done
