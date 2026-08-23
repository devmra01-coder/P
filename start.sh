#!/bin/sh
set -eu

cd /opt/MTProxy

echo "Downloading Telegram proxy configuration..."

curl -fsSL https://core.telegram.org/getProxySecret -o proxy-secret
curl -fsSL https://core.telegram.org/getProxyConfig -o proxy-multi.conf

if [ -z "${SECRET:-}" ]; then
    echo "ERROR: SECRET environment variable is not set."
    exit 1
fi

PORT="${PORT:-443}"
WORKERS="${WORKERS:-1}"

echo ""
echo "======================================"
echo "MTProto Proxy starting..."
echo "======================================"
echo "Internal port: $PORT"
echo "Workers: $WORKERS"

if [ -n "${RAILWAY_TCP_PROXY_DOMAIN:-}" ] && [ -n "${RAILWAY_TCP_PROXY_PORT:-}" ]; then
    echo ""
    echo "Telegram Proxy Link:"
    echo "tg://proxy?server=${RAILWAY_TCP_PROXY_DOMAIN}&port=${RAILWAY_TCP_PROXY_PORT}&secret=${SECRET}"
    echo ""
fi

exec ./objs/bin/mtproto-proxy \
    -u nobody \
    -p 8888 \
    -H "$PORT" \
    -S "$SECRET" \
    --aes-pwd proxy-secret \
    proxy-multi.conf \
    -M "$WORKERS" \
    -P "$PROXY_TAG"
