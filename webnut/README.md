# WebNUT

This container provides a web-based interface for monitoring UPS devices using NUT ([Network UPS Tools](https://networkupstools.org/)). It is based on a [fork](https://github.com/jasonhensler/webNUT.git) of [WebNUT](https://github.com/rshipp/webNUT), a simple web UI built with Pyramid, Bootstrap, and python-nut2. The container is built on the official Alpine Linux image for lightweight and efficient deployment.

## Features
- **NUT API Integration**: Communicates with a NUT server to monitor UPS devices.
- **Web Interface**: Provides an easy-to-use web UI for status and information.
- **Customizable**: Supports environment variables for NUT server configuration.

## Building the Image

Build the container image with the following command:

```bash
podman build --tag webnut:latest .
```

## Running the Container

Run the container with:

```bash
podman run -it --rm \
    -e UPS_HOST=my.server.ip.address \
    -e UPS_PORT=3493 \
    -e UPS_USER=monuser \
    -e UPS_PASSWD=password \
    -p 6543:6543 \
    localhost/webnut:latest
```

### Environment Variables
- **`UPS_HOST`**: IP address or hostname of the NUT server (e.g., `my.server.ip.address`).
- **`UPS_PORT`**: Port of the NUT server (default: `3493`).
- **`UPS_USER`**: Username for authentication with the NUT server.
- **`UPS_PASSWD`**: Password for the NUT server.

### Port Mapping
- The WebNUT service listens on port **6543** inside the container. Map it to a port of your choice on the host using the `-p` option.

### Example Usage
To connect to a NUT server at `192.168.1.100` with default settings:

```bash
podman run -it --rm \
    -e UPS_HOST=192.168.1.100 \
    -e UPS_PORT=3493 \
    -e UPS_USER=monuser \
    -e UPS_PASSWD=mypassword \
    -p 6543:6543 \
    localhost/webnut:latest
```

Access the web interface at:  
`http://<host-ip>:6543`

This container provides a lightweight and efficient way to deploy WebNUT, enabling quick and easy access to your UPS device's status through a web interface.
