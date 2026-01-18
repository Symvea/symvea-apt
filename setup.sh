#!/bin/bash
set -e

echo "Setting up Symvea APT Repository..."

# Add repository
echo "deb [trusted=yes] https://symvea.github.io/symvea-apt stable main" | sudo tee /etc/apt/sources.list.d/symvea.list

# Update package list
sudo apt update

echo "✅ Symvea repository added!"
echo "Install with: sudo apt install symvea"