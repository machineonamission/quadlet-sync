#!/bin/bash

/app/sync.sh
echo "Starting webhook server..."
/usr/bin/webhook -hooks /app/hooks.json -verbose -port "${PORT:-9191}"