# Unbound
This image is based upon the official Alpine Linux container and packs a version of [Unbound](https://nlnetlabs.nl/projects/unbound/about/), a validating, recursive, caching DNS resolver. With the included default configuration, Unbound is set up as a recursive dns server. Root hints are automatically refreshed at start.

Once built, simply run the container with the following command

```
podman run -it --rm \
    -p 1053:1053 \
    localhost/unbound-dns:latest
```
