# Unbound

This container provides a lightweight and ready-to-use setup for [Unbound](https://nlnetlabs.nl/projects/unbound/about/), a validating, recursive, and caching DNS resolver. The image is based on the official Alpine Linux container and brings a completely stock Unbound install.

## Building the Image

Build the image using the following command:
```bash
podman build --tag unbound:latest .
```

## Running the Container

Run the container with:
```bash
podman run -it --rm \
    -p 1053:53 \
    localhost/unbound:latest
```

### Example Usage
- Maps port **53** inside the container to port **1053** on the host.
- After starting the container, you can configure your local network or devices to use it as a DNS server (e.g., `127.0.0.1:1053`).


## Custom Configuration

You can mount a custom configuration directory to the container to override or extend the default Unbound settings. The container expects the configuration directory to be mounted at `/etc/unbound`, and it will specifically look for a file named `unbound.conf` in that directory as the main configuration file.

### Example

```bash
podman run -it --rm \
    -p 1053:53 \
    -v /path/to/your/config:/etc/unbound:ro \
    localhost/unbound-dns:latest
```

Replace `/path/to/your/config` with the path to your local configuration directory.

### Notes
- **Main Configuration File**: The container reads the file named `unbound.conf` located in the mounted directory.
- **Read-Only Mount (`ro`)**: The `:ro` flag ensures the container cannot modify your local configuration files.
- **Customizing Configuration**: Include `unbound.conf` and any other required files in the mounted directory to customize Unbound's behavior.
- **Fallback to Defaults**: If no custom configuration is provided, the default Alpine's unbound.conf is used.

This setup allows you to define and manage custom Unbound configurations while maintaining flexibility and control over the DNS resolver's behavior.
