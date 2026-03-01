#!/usr/bin/env bash
set -euo pipefail
[[ $# -ne 2 ]] && echo "Usage: $0 FILE PASS" && exit 1
FILE=$1
PASS=$2
[[ ! -f "$FILE" ]] && echo "Error: directory '$FILE' does not exist" && exit 1

dicepass ()
{
    local n="$1";
    local sep="${2:--}";
    local file="eff_large_wordlist.txt";
    [[ ! -f "$file" ]] && printf 'ERROR: word list not found\n';
    local passphrase='';
    while true; do
        local word;
        word="$(awk -v k="$(shuf -i 1-6 -n 5 | tr -d '\n')" '$1 == k { print $2; exit }' "$file")";
        (( ${#passphrase} + ${#word} + ${#sep} > n )) && break;
        [[ -n "$passphrase" ]] && passphrase+="$sep";
        passphrase+="$word";
    done;
    (( ${#passphrase} > 0 )) && printf '%s\n' "$passphrase" || printf 'ERROR: length too short\n'
}

BASENAME=$(basename "$FILE")
ENCRYPTED="$(dicepass 100).enc"
echo "[1/3] Encrypting with AES-256-CBC..."
openssl enc -aes-256-cbc -pbkdf2 -salt \
    -in "$FILE" \
    -out "$ENCRYPTED" \
    -pass pass:"$PASS"
echo "[2/4] Splitting into 40MB chunks..."
split -b 40M -a 3 "$ENCRYPTED" "${ENCRYPTED}.part."
echo "[3/3] Cleaning temporary files..."
rm -f "$ENCRYPTED"
echo "Done."
echo "Generated parts:"
ls -1 "${ENCRYPTED}.part."*
