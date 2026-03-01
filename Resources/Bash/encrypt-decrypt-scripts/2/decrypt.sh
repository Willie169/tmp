#!/usr/bin/env bash
set -euo pipefail
[[ $# -ne 2 ]] && echo "Usage: $0 FILENAME PASS" && exit 1
FILE=$1
PASS=$2
ENCRYPTED="${FILE}.enc"
echo "[1/3] Joining split files..."
cat *.part.* > "$ENCRYPTED"
echo "[2/3] Decrypting..."
openssl enc -d -aes-256-cbc -pbkdf2 \
    -in "$ENCRYPTED" \
    -out "$FILE" \
    -pass pass:"$PASS"
echo "[3/3] Cleaning temporary files..."
rm -f "$ENCRYPTED"
echo "Done."
echo "Decrypted:"
echo "$FILE"
