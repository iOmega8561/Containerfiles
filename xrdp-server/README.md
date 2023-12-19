# Remote Desktop (multi-flavour)
This container/image is based upon the official Alpine Linux image and packs a basic, ready to use, desktop with a pre-configured xrdp daemon.

It exposes port 3389 by default. To connect with a Remote Desktop client, use the default credentials:

USERNAME: default
PASSWORD: the-password-you-set

At build time a target must be explicitly set.
Available target (at the moment) are: XFCE4, OPENBOX

Once built, simply run the container with the following command

```
podman run -it --rm \
    --userns=keep-id \
    -e PASSWD="your-password" \
    -p $PORTNUMBER:3389/tcp \
    -v $VOLUMENAME:/home/default \ # Optionally mount the home directory
    localhost/xrdp-server:openbox
```