#!/bin/bash

set -e

# Create a timestamp for the backup
TIMESTAMP=$(date +%Y:%m:%d_%H:%M)

# Set the backup directory
BACKUP_DIR="/var/lib/postgresql/backup/"

# Create a compressed archive of the PostgreSQL data directory
tar czf "${BACKUP_DIR}backup_${TIMESTAMP}.tar.gz" -C /var/lib/postgresql data

# Delete backups older than the specified retention period
find "$BACKUP_DIR" -name "backup_*.tar.gz" -type f -mtime +"$BACKUP_RETENTION" -exec rm {} \;
