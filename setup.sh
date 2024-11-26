#!/usr/bin/bash

pip install -r requirements.txt
[ ! -d ~/.local/bin ] && mkdir -p ~/.local/bin
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

mkdir ~/scripts
cp  api.py ~/scripts/api.py
chmod +x ~/scripts/api.py

ln -s ~/scripts/api.py ~/.local/bin/sapi
