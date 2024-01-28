# Remote Desktop (multi-flavour)
This image is based upon the official Alpine Linux container and packs a basic, ready to use desktop with a pre-configured xrdp server daemon.
Port 3389 is by default exposed. 

Two desktop flavours are included, therefore a target must be explicitly set when building the container (as follows).
```
# XFCE or OPENBOX as target
podman build --target XFCE4 --tag xrdp-server:latest .
```

The default username is **default**, the password must be set using the environment variable **PASSWD**

Once built, simply run the container with the following command

```
podman run -it --rm \
    --userns=keep-id \
    -e PASSWD="your-password" \
    -p $PORTNUMBER:3389/tcp \
    -v $VOLUMENAME:/home/default \ # Optionally mount the home directory
    localhost/xrdp-server:openbox
```
