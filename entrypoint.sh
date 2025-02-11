#!/bin/bash

set -e

# Domínio e email para Let's Encrypt
DOMAIN="exemplo.com.br"
EMAIL="seu-emailaqui"
CLOUDFLARE_API_TOKEN="token_qui"

# Verifica se a API Key está configurada
if [ -z "$CLOUDFLARE_API_TOKEN" ]; then
    echo "ERRO: Defina a variável CLOUDFLARE_API_TOKEN para usar o DNS da Cloudflare."
    exit 1
fi

echo "✅ Criando certificado wildcard para *.$DOMAIN com Cloudflare DNS..."

echo "dns_cloudflare_api_token = $CLOUDFLARE_API_TOKEN" > /cloudflare.ini
chmod 600 /cloudflare.ini

# Gera o certificado automaticamente usando o desafio DNS-01
certbot certonly --dns-cloudflare --dns-cloudflare-credentials /cloudflare.ini \
    --agree-tos --email "$EMAIL" \
    -d "*.$DOMAIN" -d "$DOMAIN"

echo "🎉 Certificado gerado com sucesso! Os arquivos estão em:"
echo "📂 /etc/letsencrypt/live/$DOMAIN/"

exec "$@"
