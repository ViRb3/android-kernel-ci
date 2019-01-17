#!/usr/bin/env bash

apt update

# required
apt install git make build-essential ccache zip -y
# per kernel
apt install curl bc libssl-dev python -y
