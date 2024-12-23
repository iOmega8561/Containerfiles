# Unbound

This container provides a lightweight and ready-to-use setup for [Unbound](https://nlnetlabs.nl/projects/unbound/about/), a validating, recursive, and caching DNS resolver. The image is based on the official Alpine Linux container and comes preconfigured as a recursive DNS server.

## Features
- **Recursive DNS Server**: Handles DNS queries recursively.
- **Automatic Root Hints Refresh**: Updates root hints on container start to ensure up-to-date resolution.

## Building the Image

Build the image using the following command:
```bash
podman build --tag unbound:latest .
```

## Running the Container

Run the container with:
```bash
podman run -it --rm \
    -p 1053:1053 \
    localhost/unbound:latest
```

### Example Usage
- Maps port **1053** inside the container to port **1053** on the host.
- After starting the container, you can configure your local network or devices to use it as a DNS server (e.g., `127.0.0.1:1053`).

This container simplifies deploying Unbound for secure and efficient DNS resolution.
