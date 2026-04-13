# quadlet-sync

helper quadlet container to enable rapid deployment of a quadlet-based fedora server

when configured properly, github can ping your server (via webhook) to instantly pull and sync your quadlet setup on push!

## setup

### local

install the demo quadlet file(s) in /example, change options as needed (documented in file)

also make sure that your quadlet file is in your git repo, or else quadlet-sync will delete the orphaned quadlet file!

### webhook server

by default, the webhook server is exposed at port `9191`.

portforward this, or if your system doesn't have a public ip, use a cloudflare tunnel or tailscale funnel. 
this needs to be publically accessible

### github

go to your repo > webooks > add webhook

- put `http://[YOUR PUBLIC INSTANCE]/hooks/sync-quadlets` as the payload url
  - replace `[YOUR PUBLIC INSTANCE]` with however you access it (public IP, url, cloudflare tunnel)
    - keep in mind that cloudflare tunnels ignore ports. if you set a cloudflare tunnel at `website.com` to point to `localhost:9191`, DO NOT PUT `http://website.com:9191/hooks/sync-quadlets` as the payload url, just put `http://website.com/hooks/sync-quadlets`
  - you may be able to change to https if youre using a cloudflare tunnel or a reverse proxy with ssl
- Content type to `application/json`
- leave "Which events would you like to trigger this webhook?" to "Just the `push` event."
  - you can configure this if you want other things to trigger the quadlet reload, but like idk why you'd want that
- click "Add webhook" to finalize

if your webhook was set up right, GitHub should have pinged it and triggered syncing.