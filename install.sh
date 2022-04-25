#!/usr/bin/env bash

INSTALL_LOC="$(realpath ~)/.local/bin"
INSTALL_NAME="dizzy"

if [ -n "$1" ]; then
    INSTALL_LOC="$1"
fi

mkdir -p $INSTALL_LOC
cp ./dizzy.sh $INSTALL_LOC/$INSTALL_NAME
chmod +x $INSTALL_LOC/$INSTALL_NAME

echo "Done installing, make sure '$INSTALL_LOC' is configured in your \$PATH variable."

