#!/bin/bash

# Oracle configuration
export ORACLE_SID="your_oracle_sid"
export ORACLE_HOME="/path/to/your/oracle_home"

# Backup configuration
RMAN_LOG_DIR="/path/to/your/rman_logs"
BACKUP_DIR="/path/to/your/backup/dir"

# Paths to backup scripts
FULL_BACKUP_SCRIPT="/path/to/your/repo/backup/full_backup.sh"
INCREMENTAL_BACKUP_SCRIPT="/path/to/your/repo/backup/incremental_backup.sh"
DIFFERENTIAL_BACKUP_SCRIPT="/path/to/your/repo/backup/differential_backup.sh"
