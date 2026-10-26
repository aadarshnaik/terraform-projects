#!/bin/bash
set -e

# Prevent interactive prompts during automated package installation
export DEBIAN_FRONTEND=noninteractive

# Update package index and install Nginx
sudo apt-get update -y
sudo apt-get install -y nginx

# Overwrite the default webpage with custom text
echo "<h1>Hello ! Welcome to my website</h1>" | sudo tee /var/www/html/index.html > /dev/null

# Start Nginx and enable it to run on boot
sudo systemctl start nginx
sudo systemctl enable nginx