#!/bin/bash

# Error mgmt
set -e
on_error() { echo "Script failed. Error on line: $1. Terminating..."; }
trap 'on_error $LINENO' ERR


# Privilege check
if [[ "$EUID" -ne 0 ]]; then
   echo "Script not running as root. Terminating..."
   exit 1
fi

JDK_VERSION=25
BREW_JDK_PATH="/opt/homebrew/opt/openjdk"

# Manual steps
echo -e " \nRemove JAVA_HOME and PATH entries from user .bashrc or .zshrc to avoid conflicts!"
echo "Also consider removing old JDK installations."
read -p "Press [Enter] to continue..."

echo -e "\nInstalling JDK $JDK_VERSION via Homebrew...\n"

# Install Homebrew if missing
if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew not found. Exiting..."
    exit 1
fi

brew install openjdk@$JDK_VERSION

# Delete any lines starting with 'export JAVA_HOME='
sed -i '' '/^export JAVA_HOME=/d' "$ZSHRC"

# Environment setup
{
  echo "export JAVA_HOME=$BREW_JDK_PATH"
  echo 'export PATH=$JAVA_HOME/bin:$PATH'
  echo 'export CPPFLAGS="-I$JAVA_HOME/include"'
} >> ~/.zshrc

echo -e "\nDone. Restart terminal to persist environment variables."