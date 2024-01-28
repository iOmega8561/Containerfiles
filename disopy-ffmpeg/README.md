# Disopy
This image is based upon the official Alpine Linux container and packs a version of the Disopy discord bot. FFmpeg is also included since it is required in order for Disopy to be capable of handling audio.
A compatible Subsonic server is obviously required in order for Disopy to work.

Before building the image, it is required to adjust disopy.json according to your setup, otherwise the container will just exit due to not being able to authenticate with both discord and a working Subsonic server.

Once built, simply run the container with the following command

```
podman run -it --rm \
    localhost/disopy-ffmpeg:latest
```
