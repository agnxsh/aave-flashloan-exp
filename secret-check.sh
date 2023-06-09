#!/usr/bin/env sh

OUTPUT="$(grep "(0x)?[a-fA-F0-9]{64}" src -r -E -o --exclude-dir=artifacts)"
RED='\033[0;31m'          # Red
GREEN='\033[0;32m'        # Green
if [ -n "$OUTPUT" ]; then
    echo "${GREEN} You have a Private Key Committed"
    echo -e ${RED} $OUTPUT
    exit 1
fi