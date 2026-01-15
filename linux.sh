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

# Manual steps
echo -e " \nRemove JAVA_HOME and PATH=\$JAVA_HOME/bin:\$PATH entries from user .bashrc or .zshrc to avoid conflicts!"
echo "Also consider removing old JDK installations."
echo "If you need to remove something, terminate the script now (Ctrl + C), then restart after manual steps are done."
sleep 8

echo -e "\nInstalling JDK 25...\n"

# Determine architecture and download JDK
ARCH=$(uname -m)
if [[ "$ARCH" == "x86_64" ]]; then
    JDK_URL="https://download.oracle.com/java/25/latest/jdk-25_linux-x64_bin.tar.gz"
elif [[ "$ARCH" == "aarch64" ]]; then
    JDK_URL="https://download.oracle.com/java/25/latest/jdk-25_linux-aarch64_bin.tar.gz"
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

# Install dir
JDK_DIR=/opt/jdk
mkdir -p $JDK_DIR
cd /tmp

# Download and extract
wget $JDK_URL -O jdk.tar.gz
tar -xzf jdk.tar.gz -C $JDK_DIR

# Detect extracted folder
JDK_PATH=$(ls -d $JDK_DIR/jdk-25*)
if [[ -z "$JDK_PATH" ]]; then
    echo "JDK directory not found after extraction!"
    exit 1
fi

# Environment setup
tee /etc/profile.d/java.sh > /dev/null <<EOF
export JAVA_HOME=$JDK_PATH
export PATH=\$JAVA_HOME/bin:\$PATH
EOF

# Delete temp files
rm -f /tmp/jdk.tar.gz

echo -e "\nDone. Restart terminal to persist environment variables."
