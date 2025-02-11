FROM certbot/certbot:latest

WORKDIR /certs

# Instala o plugin para Cloudflare
RUN apk add --no-cache bash curl jq && \
    pip install certbot-dns-cloudflare

# Copia o script de entrada
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
