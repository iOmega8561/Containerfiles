# Remote Desktop (openbox flavour)
This container/image is based upon the official Alpine Linux image and packs a basic, ready to use, xfce4 desktop with a pre-configured xrdp daemon.

It exposes port 3389 by default. To connect with a Remote Desktop client, use the default credentials:

USERNAME: default
PASSWORD: alpinerdp

It is possible to change the password prior to building the container by editing the Containerfile.

Once built, simply run the container with the following command

```
# ROOTLESS
podman run -it --rm \
    --userns=keep-id \
    -p $PORTNUMBER:3389/tcp \
    -v $VOLUMENAME:/home/default \ # Optionally mount the home directory
    localhost/alpine-rdp:xfce4
```