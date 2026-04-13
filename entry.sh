#!/bin/bash

/app/sync.sh
/usr/local/bin/webhook -hooks /app/hooks.json -verbose -port 9191