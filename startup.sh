#!/bin/sh
set -e

# print env variables
echo "APP_DOMAIN: ${APP_DOMAIN}"
echo "R2_ACCOUNT_ID: ${R2_ACCOUNT_ID}"
echo "R2_BUCKET_NAME: ${R2_BUCKET_NAME}"
echo "AWS_ACCESS_KEY_ID: ${AWS_ACCESS_KEY_ID}"
echo "AWS_SECRET_ACCESS_KEY: ${AWS_SECRET_ACCESS_KEY}"

# dynamic variables
MOUNT_PATH="/mnt/${R2_BUCKET_NAME}"
R2_ENDPOINT="https://${R2_ACCOUNT_ID}.r2.cloudflarestorage.com"

# mount bucket
mkdir -p "$MOUNT_PATH"
echo "Mounting bucket ${R2_BUCKET_NAME}..."
tigrisfs --endpoint "${R2_ENDPOINT}" -f "${R2_BUCKET_NAME}" "$MOUNT_PATH" & sleep 3

# read bucket
echo "Contents of mounted bucket: ${R2_BUCKET_NAME}..."
ls -lah "$MOUNT_PATH"

# copyparty config settings
cat <<EOF > copyparty.conf
[global]
  acao: $APP_DOMAIN
EOF

# start copyparty
copyparty -p 4000 -v /::rwmd --theme 4 --wram -c copyparty.conf
