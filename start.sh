#!/bin/sh
set -eu

cd /opt/MTProxy

echo "Downloading Telegram proxy configuration..."

curl -fsSL https://core.telegram.org/getProxySecret -o proxy-secret
curl -fsSL https://core.telegram.org/getProxyConfig -o proxy-multi.conf

: "${SECRET:?SECRET environment variable is required}"

PORT="${PORT:-24323}"
WORKERS="${WORKERS:-1}"

echo "======================================"
echo "MTProto Proxy starting..."
echo "======================================"
echo "Listening port: $PORT"
echo "Workers: $WORKERS"

exec ./objs/bin/mtproto-proxy \
    -u nobody \
    -p "$PORT" \
    -S "$SECRET" \
    -M "$WORKERS" \
    -P "$PROXY_TAG" \
    --aes-pwd proxy-secret \
    proxy-multi.conf
