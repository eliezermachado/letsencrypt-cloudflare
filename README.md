# 🚀 Certificado Wildcard com Let's Encrypt e Cloudflare via Docker
Escrito por Eliezer Machado - 01/2025

Este projeto permite gerar certificados **Wildcard SSL (`*.exemplo.com`)** automaticamente utilizando **Let's Encrypt** e o desafio DNS via **API Cloudflare**.

## 📌 Requisitos

Antes de começar, certifique-se de ter:

- **Conta Cloudflare** (para configurar a API Token)
- **Domínio gerenciado no Cloudflare**
- **Docker e Docker Compose instalados**

## ⚙️ Configuração

### 1️⃣ Clonar o Repositório

```bash
git clone https://github.com/eliezermachado/letsencrypt-cloudflare.git
cd letsencrypt-cloudflare
```

### 2️⃣ Configurar o Token da Cloudflare

Crie um arquivo `.env` e adicione a API Key:

```env
CLOUDFLARE_API_TOKEN=seu_token_aqui
```

Ou exporte no terminal:

```bash
export CLOUDFLARE_API_TOKEN="seu_token_aqui"
```

### 3️⃣ Criar e Configurar os Arquivos Necessários

- **Dockerfile** (para construir a imagem Docker)
- **entrypoint.sh** (script que executa o Certbot)
- **docker-compose.yml** (para facilitar a execução do contêiner)

## 🚀 Como Usar

### 🔨 1. Construir e Rodar com Docker Compose

```bash
docker-compose up --build
```

Isso gerará automaticamente o certificado e o armazenará em `./certs/live/exemplo.com/`.

### 🛠️ 2. Parar o Contêiner Após Execução

```bash
docker-compose down
```

### 🔑 3. Acessar os Certificados

Depois da execução, os certificados estarão disponíveis na pasta:

```bash
ls -l certs/live/exemplo.com/
```

Você verá os arquivos:

- `fullchain.pem` → Certificado completo
- `privkey.pem` → Chave privada do certificado
- `cert.pem` → Certificado sem intermediários

## 🔄 Renovação Automática

O Let's Encrypt expira em **90 dias**. Para renovar, execute:

```bash
docker run --rm -v $(pwd)/certs:/etc/letsencrypt certbot-wildcard certbot renew
```

Ou configure um **cron job** para rodar mensalmente:

```bash
0 3 * * 1 docker-compose run --rm certbot certbot renew
```

## 🛠️ Debug e Problemas Comuns

1️⃣ **Permissão negada ao acessar `docker.sock`?**

- Certifique-se de que o usuário do contêiner tem permissão para acessar o Docker.

2️⃣ **Cloudflare bloqueando a API?**

- Verifique se o token tem permissão para modificar registros DNS.

3️⃣ **Erro de certificado?**

- Aguarde alguns minutos após a propagação do DNS e tente novamente.

