#!/bin/bash

set -e

echo "Beginning sync..."

if [ -z "$REPO" ]; then
  echo "ERROR: Set REPO env var to a git repo"
  exit 1
fi

if [ ! -d "/host-systemd" ]; then
  echo "Cannot find host systemd mount. Add /etc/containers/systemd:/host-systemd:rw to your container mounts"
  exit 1
fi

echo "1. Pull the latest from Git"
if [ -d "/repo" ]; then
  echo "1a. Repo already exists, pulling latest changes"
  git -C /repo pull origin main
else
  echo "1a. Cloning repo for the first time"
  git clone "$REPO" /repo
fi

echo "2. Prep a clean, temporary staging directory"
mkdir -p /tmp/flattened-quadlets
rm -rf /tmp/flattened-quadlets/*

echo "3. Find all Quadlet files in nested folders and copy them FLAT into staging."
find /repo/"${REPO_SUBDIR}" -type f -exec cp -v {} /tmp/flattened-quadlets/ \;

if [ -d "/persist" ]; then
  echo "3a. Also copy and flatten persist dir"
  find /persist -type f -exec cp {} -v /tmp/flattened-quadlets/ \;
fi

echo "4. Sync the flattened staging folder to the real systemd directory."
# Because we use --delete, any file you removed from Git will now be safely deleted from systemd!
rsync -av --delete /tmp/flattened-quadlets/ /host-systemd

echo "5. Reload systemd on the host so it sees the changes"
nsenter -t 1 -m -u -i -n -p env SYSTEMD_LOG_LEVEL=debug /usr/bin/systemctl daemon-reload

echo "Sync done!"