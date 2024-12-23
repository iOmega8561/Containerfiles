# AlpineRDP (Multi-Flavoured Remote Desktop Server)

This container provides a lightweight, ready-to-use desktop environment with a pre-configured **xrdp** server based on the official Alpine Linux container. It exposes **port 3389** for remote desktop connections.

## Desktop Flavours

The image includes two desktop flavours:
- **XFCE4**
- **Openbox**

Specify the target desktop environment during the build process:

```bash
# Replace TARGET with **xfce4** or **openbox**
podman build --target TARGET --tag alpinerdp:latest .
```

## Usage

### Environment Configuration
- **Username**: `default`
- **Password**: Must be set via the `PASSWD` environment variable.

### Running the Container

```bash
podman run -it --rm \
    --userns=keep-id \
    -e PASSWD="your-password" \
    -p $PORTNUMBER:3389/tcp \
    -v $VOLUMENAME:/home/default \ # Optional: Mount a home directory
    localhost/alpinerdp:openbox
```

Replace:
- `$PORTNUMBER` with the port you want to expose on your host.
- `$VOLUMENAME` with the volume or path you want to mount as the user’s home directory.

### Example
To use XFCE4 with a mounted home directory:
```bash
podman run -it --rm \
    --userns=keep-id \
    -e PASSWD="securepassword" \
    -p 3390:3389/tcp \
    -v myvolume:/home/default \
    localhost/alpinerdp:xfce4
```
