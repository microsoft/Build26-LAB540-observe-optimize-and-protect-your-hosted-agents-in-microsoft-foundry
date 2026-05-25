#!/bin/bash
set -e

echo "Upgrading Azure CLI to latest version..."
curl -fsSL https://aka.ms/install-azd.sh | bash

# echo "Installing Marp CLI ..."
# npm install -g @marp-team/marp-cli

echo "Installing uv ..."
curl -LsSf https://astral.sh/uv/install.sh | sh

echo "Installing Python dependencies ..."
pip install --upgrade pip
pip install -r requirements.txt --quiet

echo "Post-create setup complete."\