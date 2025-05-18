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
    # echo "Installing asdf prerequisites..."
    # brew install coreutils curl git
    # check_installation_error
    echo "Installing asdf..."
    brew install asdf
    check_installation_error
    # echo -e "\n. $(brew --prefix asdf)/libexec/asdf.sh" >> ${ZDOTDIR:-~}/.zshrc
    export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

    echo "Adding asdf completions..."
    mkdir -p "${ASDF_DATA_DIR:-$HOME/.asdf}/completions"
    asdf completion zsh > "${ASDF_DATA_DIR:-$HOME/.asdf}/completions/_asdf"
    # append completions to fpath
    fpath=(${ASDF_DATA_DIR:-$HOME/.asdf}/completions $fpath)
    # initialise completions with ZSH's compinit
    autoload -Uz compinit && compinit
    
fi

echo "Installing NodeJS"
asdf plugin add nodejs
asdf install nodejs 18.18.0

echo "Installing Python3"
asdf plugin add python
asdf install python 3.10.0

echo "Installing java"
asdf plugin add java
asdf install java temurin-17.0.14+7

echo "Installing ruby"
asdf plugin add ruby
ruby_version=3.3.5
if asdf install ruby ${ruby_version}; then
    echo "Installed ruby ${ruby_version}"
else
    echo "Failed to install ruby ${ruby_version}. Trying again (forcing ruby-build update)."
    echo "Installing libyaml with brew..."
    if ! brew list libyaml &>/dev/null; then
      brew install libyaml
      check_installation_error
    else
      echo "libyaml already installed"
    fi
    echo "Installing ruby ${ruby_version} with asdf"
    ASDF_RUBY_BUILD_VERSION=master asdf install ruby ${ruby_version}
fi
