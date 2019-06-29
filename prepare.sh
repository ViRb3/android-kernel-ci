#!/usr/bin/env bash

echo "Installing required packages ..."

apt update > /dev/null || exit "$?"

# required
apt install git make build-essential ccache curl zip -y > /dev/null || exit "$?"
# per kernel
apt install bc libssl-dev python -y > /dev/null || exit "$?"

echo "Done!"
