#!/bin/bash

# Function to check for errors during installation
check_installation_error() {
    if [ $? -ne 0 ]; then
        echo "Error during installation. Exiting..."
        exit 1
    fi
}

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

echo "Installing NodeJS"
asdf plugin add nodejs
asdf install nodejs 18.18.0

echo "Installing Python3"
asdf plugin add python
asdf install python 3.10.0

echo "Installing java"
asdf plugin add java
asdf install java temurin-23.0.1+11
