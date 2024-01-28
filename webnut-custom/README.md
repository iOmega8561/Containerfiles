# webNUT
This container/image is based upon the official Alpine Linux image and packs a web user interface that displays information about the Network UPS Tools' server to which it connects.

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