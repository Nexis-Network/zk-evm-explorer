FROM nginx

RUN apt update && \
    apt install -y certbot python3-certbot-nginx vim && \
    certbot certonly --nginx -d zkevm-testnet.nexscan.io --agree-tos -m marius@nexislabs.io -n
