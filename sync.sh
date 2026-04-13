#!/bin/bash

if [ -z "$REPO" ]; then
  echo "ERROR: Set REPO env var to a git repo"
  exit 1
fi

if [ ! -d "/host-systemd" ]; then
  echo "Cannot find host systemd mount. Add /etc/containers/systemd:/host-systemd:rw to your container mounts"
  exit 1
fi

# 1. Pull the latest from GitHub
if [ -d "/repo" ]; then
  git -C /repo pull origin main
else
  git clone "$REPO" /repo
fi

# 2. Prep a clean, temporary staging directory
mkdir -p /tmp/flattened-quadlets
rm -rf /tmp/flattened-quadlets/*

# 3. Find all Quadlet files in nested folders and copy them FLAT into staging.
find /repo/"${REPO_SUBDIR}" -type f -exec cp {} /tmp/flattened-quadlets/ \;

# 4. Sync the flattened staging folder to the real systemd directory.
# Because we use --delete, any file you removed from Git will now be safely deleted from systemd!
rsync -av --delete /tmp/flattened-quadlets/ /host-systemd

# 5. Reload systemd on the host so it sees the changes
nsenter -t 1 -m -u -i -n -p systemctl daemon-reload