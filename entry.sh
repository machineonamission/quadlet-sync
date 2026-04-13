#!/bin/bash

/app/sync.sh
/usr/bin/webhook -hooks /app/hooks.json -verbose -port "${PORT:-9191}"