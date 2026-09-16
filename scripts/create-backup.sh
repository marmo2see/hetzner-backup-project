#!/bin/bash

# Hetzner Backup Project
# Creates a compressed full-disk image of the Hetzner server.

SERVER="wordpress.multinomial.se"
OUTPUT="$HOME/hetzner-backup/hetzner-sda.img.gz"

mkdir -p "$HOME/hetzner-backup"

echo "Starting full-disk backup of /dev/sda..."
echo "Output: $OUTPUT"

ssh -o IdentitiesOnly=no root@"$SERVER" \
"dd if=/dev/sda bs=64M status=progress | gzip -1" \
> "$OUTPUT"

if [ $? -eq 0 ]; then
    echo "Backup completed successfully."
    echo "Backup file: $OUTPUT"
else
    echo "Backup failed."
    exit 1
fi
