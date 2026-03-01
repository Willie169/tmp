#!/usr/bin/env bash
set -euo pipefail
[[ $# -ne 1 ]] && echo "Usage: $0 DIR" && exit 1
DIR=$1
PASSFILE='pass.txt'
[[ ! -d "$DIR" ]] && echo "Error: directory '$DIR' does not exist" && exit 1
[[ ! -f "$PASSFILE" ]] && echo "Error: password file '$PASSFILE' does not exist" && exit 1
BASENAME=$(basename "$DIR")
ARCHIVE="${BASENAME}.tar.xz"
ENCRYPTED="${ARCHIVE}.enc"
echo "[1/4] Creating tar.xz archive..."
tar -C "$(dirname "$DIR")" -cJf "$ARCHIVE" "$BASENAME"
echo "[2/4] Encrypting with AES-256-CBC..."
openssl enc -aes-256-cbc -pbkdf2 -salt \
    -in "$ARCHIVE" \
    -out "$ENCRYPTED" \
    -pass file:"$PASSFILE"
echo "[3/4] Splitting into 40MB chunks..."
split -b 40M -a 3 "$ENCRYPTED" "${ENCRYPTED}.part."
echo "[4/4] Cleaning temporary files..."
rm -f "$ARCHIVE" "$ENCRYPTED"
echo "Done."
echo "Generated parts:"
ls -1 "${ENCRYPTED}.part."*
