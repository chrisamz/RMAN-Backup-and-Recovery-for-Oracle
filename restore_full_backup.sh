#!/bin/bash

# Load configuration
source ../config/backup_config.sh

# Check if the backup file is provided as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 /path/to/full_backup_file"
  exit 1
fi

BACKUP_FILE=$1

# Perform the restoration using RMAN
$ORACLE_HOME/bin/rman target / <<EOF
RUN {
    SHUTDOWN IMMEDIATE;
    STARTUP MOUNT;
    ALLOCATE CHANNEL ch1 DEVICE TYPE DISK;
    RESTORE DATABASE FROM '$BACKUP_FILE';
    RECOVER DATABASE;
    ALTER DATABASE OPEN RESETLOGS;
    RELEASE CHANNEL ch1;
}
EXIT;
EOF

# Check if the restoration was successful
if [ $? -eq 0 ]; then
  echo "[$(date)] Full backup restoration successful: $BACKUP_FILE" >> ../logs/recovery.log
else
  echo "[$(date)] Full backup restoration failed: $BACKUP_FILE" >> ../logs/recovery.log
fi
