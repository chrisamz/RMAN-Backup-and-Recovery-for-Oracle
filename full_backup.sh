#!/bin/bash

# Load configuration
source ../config/backup_config.sh

# Create a timestamp
TIMESTAMP=$(date +"%F_%H-%M-%S")

# Define backup file name and directory
BACKUP_FILE="$BACKUP_DIR/full_backup_$TIMESTAMP"

# Perform the full backup using RMAN
$ORACLE_HOME/bin/rman target / <<EOF
RUN {
    ALLOCATE CHANNEL ch1 DEVICE TYPE DISK FORMAT '$BACKUP_FILE_%U';
    BACKUP DATABASE PLUS ARCHIVELOG;
    RELEASE CHANNEL ch1;
}
EXIT;
EOF

# Check if the backup was successful
if [ $? -eq 0 ]; then
  echo "[$(date)] Full backup successful: $BACKUP_FILE" >> ../logs/backup.log
else
  echo "[$(date)] Full backup failed" >> ../logs/backup.log
fi
