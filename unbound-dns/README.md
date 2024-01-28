# Unbound
This container/image is based upon the official Alpine Linux image and packs a version of the Unbound recursive DNS server. This image automatically refreshes root dns hints when the container is deployed.

Once built, simply run the container with the following command

```
podman run -it --rm \
    -p 1053:1053 \
    localhost/unbound-dns:latest
```