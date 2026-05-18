#!/usr/bin/env bash
set -euo pipefail

# Run on the target VPS as root:
#   bash server-setup-kittygram.sh
#
# This prepares the host for Kittygram on:
#   https://kittygram2.ddns.net -> Docker gateway on 127.0.0.1:9000
#
# Taski must also run on this same host and be routed by a separate nginx
# server block for taski2.ddns.net.

DOMAIN="kittygram2.ddns.net"
DOCKERHUB_USERNAME="bepwyta"
PROJECT_DIR="/root/kittygram"

apt update
apt install -y curl nginx certbot python3-certbot-nginx

if ! command -v docker >/dev/null 2>&1; then
  curl -fSL https://get.docker.com -o /tmp/get-docker.sh
  sh /tmp/get-docker.sh
fi

apt install -y docker-compose-plugin

mkdir -p "$PROJECT_DIR"

if [ ! -f "$PROJECT_DIR/.env" ]; then
  cat > "$PROJECT_DIR/.env" <<EOF
POSTGRES_USER=kittygram_user
POSTGRES_PASSWORD=change_this_password_before_final_check
POSTGRES_DB=kittygram_db
POSTGRES_HOST=db
POSTGRES_PORT=5432

SECRET_KEY=change_this_secret_key_before_final_check
DEBUG=False
ALLOWED_HOSTS=${DOMAIN},localhost,127.0.0.1

DOCKERHUB_USERNAME=${DOCKERHUB_USERNAME}
EOF
  chmod 600 "$PROJECT_DIR/.env"
fi

cat > /etc/nginx/sites-available/kittygram.conf <<EOF
server {
    listen 80;
    server_name ${DOMAIN};

    location / {
        proxy_set_header Host \$http_host;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_pass http://127.0.0.1:9000;
        client_max_body_size 20M;
    }
}
EOF

ln -sf /etc/nginx/sites-available/kittygram.conf /etc/nginx/sites-enabled/kittygram.conf
nginx -t
systemctl reload nginx

echo "Host is prepared. Next steps:"
echo "1. Ensure docker-compose.production.yml is in ${PROJECT_DIR}"
echo "2. Run GitHub Actions deploy or run manually:"
echo "   cd ${PROJECT_DIR}"
echo "   docker compose -f docker-compose.production.yml pull"
echo "   docker compose -f docker-compose.production.yml up -d"
echo "   docker compose -f docker-compose.production.yml exec -T backend python manage.py migrate"
echo "   docker compose -f docker-compose.production.yml exec -T backend python manage.py collectstatic --noinput"
echo "3. After DNS points here, enable HTTPS:"
echo "   certbot --nginx -d ${DOMAIN}"
