#!/usr/bin/env bash
set -euo pipefail
[[ $# -ne 1 ]] && echo "Usage: $0 filename (without .tar.xz.enc)" && exit 1
BASENAME=$1
PASSFILE='pass.txt'
[[ ! -f "$PASSFILE" ]] && echo "Error: password file '$PASSFILE' does not exist" && exit 1
ARCHIVE="${BASENAME}.tar.xz"
ENCRYPTED="${ARCHIVE}.enc"
echo "[1/4] Joining split files..."
cat "${ENCRYPTED}.part."* > "$ENCRYPTED"
echo "[2/4] Decrypting..."
openssl enc -d -aes-256-cbc -pbkdf2 \
    -in "$ENCRYPTED" \
    -out "$ARCHIVE" \
    -pass file:"$PASSFILE"
echo "[3/4] Extracting archive..."
tar -xJf "$ARCHIVE"
echo "[4/4] Cleaning temporary files..."
rm -f "$ENCRYPTED" "$ARCHIVE"
echo "Done."
echo "Restored:"
echo "$BASE_NAME"
