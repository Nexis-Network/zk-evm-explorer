Certbot cetificates have been manually obtained inside a running nginx container and copied over into ./letsencrypt

This folder is copied inside the container, as instructed by ./Dockerfile and at some point these will expire

To renew the certificates run this inside the container:

```
certbot certonly --nginx -d zkevm-testnet.nexscan.io --agree-tos -m marius@nexislabs.io -n
```

Then copy out the `letsencrypt` folder from container to persist the new certificate.


TODO: automatic renewal and pulling out from docker container
