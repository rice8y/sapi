#!/usr/bin/bash

SYMLINK_NAME=""
SLACK_BOT_TOKEN=""
SLACK_USER_ID=""
SLACK_CHANNEL=""

while [ $# -gt 0 ]; do
  case "$1" in
    --SYMLINK_NAME=*)
      SYMLINK_NAME="${1#*=}"
      ;;
    --SLACK_BOT_TOKEN=*)
      SLACK_BOT_TOKEN="${1#*=}"
      ;;
    --SLACK_USER_ID=*)
      SLACK_USER_ID="${1#*=}"
      ;;
    --SLACK_CHANNEL=*)
      SLACK_CHANNEL="${1#*=}"
      ;;
    *)
      echo "Invalid argument: $1"
      exit 1
      ;;
  esac
  shift
done

if [ -z "$SLACK_BOT_TOKEN" ] || [ -z "$SLACK_USER_ID" ] || [ -z "$SLACK_CHANNEL" ]; then
  echo "Usage: $0 --SYMLINK_NAME=value --SLACK_BOT_TOKEN=value --SLACK_USER_ID=value --SLACK_CHANNEL=value"
  exit 1
fi

if [ -z "$SYMLINK_NAME" ]; then
  SYMLINK_NAME="sapi"
fi

if [ -f ".env.sample" ]; then
  rm -f .env.sample
fi

cat <<EOF > .env
SLACK_BOT_TOKEN=$SLACK_BOT_TOKEN
SLACK_USER_ID=$SLACK_USER_ID
SLACK_CHANNEL=$SLACK_CHANNEL
EOF

awk -v home="$HOME" 'NR==10 {$0="load_dotenv(\"" home "/scripts/.env\") # Rewritten by setup.sh."} {print}' api.py > tmp && mv tmp api.py

pip install -r requirements.txt

[ ! -d ~/.local/bin ] && mkdir -p ~/.local/bin

if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' ~/.bashrc; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
  source ~/.bashrc
fi

mkdir -p ~/scripts
cp api.py ~/scripts/api.py
cp .env ~/scripts/.env
chmod +x ~/scripts/api.py

ln -sf ~/scripts/api.py ~/.local/bin/"$SYMLINK_NAME"

echo "Setup complete! '$SYMLINK_NAME' is now available as a command."
