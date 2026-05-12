#!/bin/bash
set -e

echo "Upgrading Azure CLI to latest version..."
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

echo "Installing GitHub Copilot CLI..."
npm install -g @github/copilot

# echo "Installing Marp CLI ..."
# npm install -g @marp-team/marp-cli

echo "Installing uv ..."
curl -LsSf https://astral.sh/uv/install.sh | sh

echo "Installing Python dependencies ..."
pip install --upgrade pip
pip install -r requirements.txt --quiet

echo "Post-create setup complete."