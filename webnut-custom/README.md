# webNUT
This container/image is based upon the official Alpine Linux image and packs a [fork](https://github.com/jasonhensler/webNUT.git) of [webNUT](https://github.com/rshipp/webNUT), a simple web interface for NUT ([Network UPS Tools](https://networkupstools.org/)) servers, built on Pyramid, Bootstrap, and python-nut2.

Once built, simply run the container with the following command

```
podman run -it --rm \
    -e UPS_HOST=my.server.ip.address \
    -e UPS_PORT=3493 \
    -e UPS_USER=monuser \
    -e UPS_PASSWD=password \
    -p 6543:6543 \
    localhost/webnut-custom:latest
```