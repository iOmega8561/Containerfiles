# Disopy
This image is based upon python:3.11.5 and packs the Disopy discord bot and al the necessary packages to run ffmpeg.
A compatible Subsonic server is required for Disopy to work.

Prior to building the image, it is necessary to input the correct information in config.json otherwise the container will just exit due to not being correctly configured.

Once built, simply run the container with the following command

```
podman run -it --rm \
    localhost/disopy-ffmpeg:latest
```