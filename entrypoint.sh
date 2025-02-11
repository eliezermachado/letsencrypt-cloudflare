#!/bin/sh
set -e

# Verifica se a API Key está configurada
if [ -z "$CLOUDFLARE_API_TOKEN" ]; then
    echo "ERRO: Defina a variável CLOUDFLARE_API_TOKEN para usar o DNS da Cloudflare."
    exit 1
fi
echo "dns_cloudflare_api_token = $CLOUDFLARE_API_TOKEN" > /cloudflare.ini
chmod 600 /cloudflare.ini

echo "✅ Iniciando processo de criação/renovação do certificado para *.$DOMAIN..."

# Caminho do certificado esperado
CERT_PATH="/etc/letsencrypt/live/$DOMAIN/fullchain.pem"

# Se o certificado já existir, verifica a validade
if [ -f "$CERT_PATH" ]; then
  echo "🔍 Certificado existente encontrado. Verificando vencimento..."

  # Se o certificado for válido por mais de 30 dias, não faz nada
  if openssl x509 -checkend 2592000 -noout -in "$CERT_PATH"; then
    echo "✅ O certificado ainda é válido por mais de 30 dias. Nenhuma renovação necessária."
    exit 0
  else
    echo "⚠️ O certificado está próximo de expirar. Renovando..."
  fi
else
  echo "⚠️ Nenhum certificado encontrado. Gerando um novo..."
fi

# Executa o Certbot para criar ou renovar o certificado
certbot certonly --dns-cloudflare \
  --dns-cloudflare-credentials /cloudflare.ini \
  --email "$EMAIL" \
  -d "*.$DOMAIN" \
  --agree-tos \
  --no-eff-email \
  --force-renewal \
  --non-interactive

echo "✅ Certificado gerado/renovado com sucesso. Encerrando o container."

# Encerra o container
exit 0