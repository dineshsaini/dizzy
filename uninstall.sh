#!/usr/bin/env bash

INSTALL_NAME="dizzy"
INSTALLED_BIN=`which "$INSTALL_NAME" 2> /dev/null`

if [ -n "$INSTALLED_BIN" ]; then
    rm -f "$INSTALLED_BIN"
    HOME_DIR="$(realpath ~)/.dizzy"
    if [ -d "$HOME_DIR" ]; then
        rm -rf "$HOME_DIR" 
        echo "Done uninstalling."
    fi
else
    echo "'$INSTALL_NAME' is not installed, or is not in your '\$PATH' locations."
fi
