#!/usr/bin/env bash

INSTALL_NAME="dizzy"
INSTALLED_BIN=`which "$INSTALL_NAME" 2> /dev/null`

mkdir -p ~/.dizzy/run/scripts

if [ -n "$INSTALLED_BIN" ]; then
    cp ./dizzy.sh $INSTALLED_BIN
    chmod +x $INSTALLED_BIN
    echo "Done upgrading."
else
    echo "'$INSTALL_NAME' is not installed, or is not in your '\$PATH' locations, install first before trying upgrade."
fi
