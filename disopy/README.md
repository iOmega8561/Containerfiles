# Disopy

This container provides a ready-to-use setup for the [Disopy](https://pypi.org/project/disopy/) Discord bot, which enables music playback from a Subsonic-compatible server. The image is based on the official Alpine Linux container and includes **FFmpeg** to handle audio processing.

## Requirements

- A Subsonic-compatible server is required for Disopy to function.
- Configure the `disopy.json` file with your Discord bot token and Subsonic server credentials before building the image. Without proper configuration, the container will exit due to authentication failure.

## Building the Image

Build the image using the following command:
```bash
podman build --tag disopy:latest .
```

## Running the Container

Run the container with:
```bash
podman run -it --rm \
    localhost/disopy:latest
```

### Example Usage
1. Ensure `disopy.json` is correctly configured with:
   - Your Discord bot token.
   - Subsonic server URL and credentials.
2. Build the image.
3. Start the container to enable your Discord bot to play music.

This container simplifies the deployment of a Disopy-powered Discord bot, providing everything needed to bridge Discord and Subsonic for music playback.
