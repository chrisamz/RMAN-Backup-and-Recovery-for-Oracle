#!/bin/bash

# Load configuration
source ../config/backup_config.sh

# Ensure the backup scripts are executable
chmod +x $FULL_BACKUP_SCRIPT
chmod +x $INCREMENTAL_BACKUP_SCRIPT
chmod +x $DIFFERENTIAL_BACKUP_SCRIPT

# Add cron job for full backup at 2 AM every Sunday
(crontab -l 2>/dev/null; echo "0 2 * * 0 $FULL_BACKUP_SCRIPT") | crontab -

# Add cron job for incremental backup at 2 AM every day except Sunday
(crontab -l 2>/dev/null; echo "0 2 * * 1-6 $INCREMENTAL_BACKUP_SCRIPT") | crontab -

# Add cron job for differential backup at 2 AM every Saturday
(crontab -l 2>/dev/null; echo "0 2 * * 6 $DIFFERENTIAL_BACKUP_SCRIPT") | crontab -

echo "Backup schedules added to cron."
