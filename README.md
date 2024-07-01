# RMAN Backup and Recovery for Oracle

## Overview

This project involves implementing backup and recovery strategies using Oracle RMAN (Recovery Manager). It includes RMAN scripts for full, incremental, and differential backups, automated backup scheduling, and disaster recovery plans.

## Technologies

- Oracle RMAN

## Key Features

- RMAN scripts for full, incremental, and differential backups
- Automated backup schedules
- Disaster recovery plans

## Project Structure

```
rman-backup-recovery/
├── backup/
│   ├── full_backup.sh
│   ├── incremental_backup.sh
│   ├── differential_backup.sh
│   └── schedule_backups.sh
├── recovery/
│   ├── restore_full_backup.sh
│   ├── restore_incremental_backup.sh
│   ├── restore_differential_backup.sh
├── logs/
│   ├── backup.log
│   ├── recovery.log
├── config/
│   ├── backup_config.sh
├── README.md
└── LICENSE
```

## Instructions

### 1. Clone the Repository

Start by cloning the repository to your local machine:

```bash
git clone https://github.com/your-username/rman-backup-recovery.git
cd rman-backup-recovery
```

### 2. Configure Backup Settings

Update the configuration file with your Oracle RMAN settings.

#### `config/backup_config.sh`

```bash
#!/bin/bash

# Oracle configuration
ORACLE_SID="your_oracle_sid"
ORACLE_HOME="/path/to/your/oracle_home"
RMAN_LOG_DIR="/path/to/your/rman_logs"
BACKUP_DIR="/path/to/your/backup/dir"
```

### 3. Perform Full Backup

Run the full backup script to create a complete backup of your Oracle database.

```bash
./backup/full_backup.sh
```

### 4. Perform Incremental Backup

Run the incremental backup script to create an incremental backup of your Oracle database.

```bash
./backup/incremental_backup.sh
```

### 5. Perform Differential Backup

Run the differential backup script to create a differential backup of your Oracle database.

```bash
./backup/differential_backup.sh
```

### 6. Schedule Automated Backups

Use the scheduling script to automate the backup process. This script uses `cron` for scheduling.

```bash
./backup/schedule_backups.sh
```

### 7. Restore from Backup

Use the restoration scripts to restore your Oracle database from full, incremental, or differential backups.

#### Restore Full Backup

```bash
./recovery/restore_full_backup.sh /path/to/your/full_backup_file
```

#### Restore Incremental Backup

```bash
./recovery/restore_incremental_backup.sh /path/to/your/incremental_backup_file
```

#### Restore Differential Backup

```bash
./recovery/restore_differential_backup.sh /path/to/your/differential_backup_file
```

## Detailed Scripts and Explanations

### Full Backup Script (`full_backup.sh`)

This script performs a full backup of the Oracle database using RMAN.

```bash
#!/bin/bash

source ../config/backup_config.sh

rman target / <<EOF
RUN {
    ALLOCATE CHANNEL ch1 DEVICE TYPE DISK FORMAT '$BACKUP_DIR/full_%U';
    BACKUP DATABASE PLUS ARCHIVELOG;
    RELEASE CHANNEL ch1;
}
EXIT;
EOF

if [ $? -eq 0 ]; then
  echo "[$(date)] Full backup successful" >> ../logs/backup.log
else
  echo "[$(date)] Full backup failed" >> ../logs/backup.log
fi
```

### Incremental Backup Script (`incremental_backup.sh`)

This script performs an incremental backup of the Oracle database using RMAN.

```bash
#!/bin/bash

source ../config/backup_config.sh

rman target / <<EOF
RUN {
    ALLOCATE CHANNEL ch1 DEVICE TYPE DISK FORMAT '$BACKUP_DIR/incremental_%U';
    BACKUP INCREMENTAL LEVEL 1 DATABASE;
    RELEASE CHANNEL ch1;
}
EXIT;
EOF

if [ $? -eq 0 ]; then
  echo "[$(date)] Incremental backup successful" >> ../logs/backup.log
else
  echo "[$(date)] Incremental backup failed" >> ../logs/backup.log
fi
```

### Differential Backup Script (`differential_backup.sh`)

This script performs a differential backup of the Oracle database using RMAN.

```bash
#!/bin/bash

source ../config/backup_config.sh

rman target / <<EOF
RUN {
    ALLOCATE CHANNEL ch1 DEVICE TYPE DISK FORMAT '$BACKUP_DIR/differential_%U';
    BACKUP INCREMENTAL LEVEL 1 CUMULATIVE DATABASE;
    RELEASE CHANNEL ch1;
}
EXIT;
EOF

if [ $? -eq 0 ]; then
  echo "[$(date)] Differential backup successful" >> ../logs/backup.log
else
  echo "[$(date)] Differential backup failed" >> ../logs/backup.log
fi
```

### Scheduling Script (`schedule_backups.sh`)

This script sets up `cron` jobs to schedule automated backups.

```bash
#!/bin/bash

# Add cron job for full backup at 2 AM every Sunday
(crontab -l 2>/dev/null; echo "0 2 * * 0 /path/to/your/repo/backup/full_backup.sh") | crontab -

# Add cron job for incremental backup at 2 AM every day except Sunday
(crontab -l 2>/dev/null; echo "0 2 * * 1-6 /path/to/your/repo/backup/incremental_backup.sh") | crontab -

# Add cron job for differential backup at 2 AM every Saturday
(crontab -l 2>/dev/null; echo "0 2 * * 6 /path/to/your/repo/backup/differential_backup.sh") | crontab -

echo "Backup schedules added to cron."
```

### Restore Full Backup Script (`restore_full_backup.sh`)

This script restores a full backup of the Oracle database using RMAN.

```bash
#!/bin/bash

source ../config/backup_config.sh

BACKUP_FILE=$1

rman target / <<EOF
RUN {
    ALLOCATE CHANNEL ch1 DEVICE TYPE DISK;
    RESTORE DATABASE FROM '$BACKUP_FILE';
    RECOVER DATABASE;
    RELEASE CHANNEL ch1;
}
EXIT;
EOF

if [ $? -eq 0 ]; then
  echo "[$(date)] Full backup restoration successful: $BACKUP_FILE" >> ../logs/recovery.log
else
  echo "[$(date)] Full backup restoration failed" >> ../logs/recovery.log
fi
```

### Restore Incremental Backup Script (`restore_incremental_backup.sh`)

This script restores an incremental backup of the Oracle database using RMAN.

```bash
#!/bin/bash

source ../config/backup_config.sh

BACKUP_FILE=$1

rman target / <<EOF
RUN {
    ALLOCATE CHANNEL ch1 DEVICE TYPE DISK;
    RESTORE DATABASE FROM '$BACKUP_FILE';
    RECOVER DATABASE;
    RELEASE CHANNEL ch1;
}
EXIT;
EOF

if [ $? -eq 0 ]; then
  echo "[$(date)] Incremental backup restoration successful: $BACKUP_FILE" >> ../logs/recovery.log
else
  echo "[$(date)] Incremental backup restoration failed" >> ../logs/recovery.log
fi
```

### Restore Differential Backup Script (`restore_differential_backup.sh`)

This script restores a differential backup of the Oracle database using RMAN.

```bash
#!/bin/bash

source ../config/backup_config.sh

BACKUP_FILE=$1

rman target / <<EOF
RUN {
    ALLOCATE CHANNEL ch1 DEVICE TYPE DISK;
    RESTORE DATABASE FROM '$BACKUP_FILE';
    RECOVER DATABASE;
    RELEASE CHANNEL ch1;
}
EXIT;
EOF

if [ $? -eq 0 ]; then
  echo "[$(date)] Differential backup restoration successful: $BACKUP_FILE" >> ../logs/recovery.log
else
  echo "[$(date)] Differential backup restoration failed" >> ../logs/recovery.log
fi
```

## Contributing

We welcome contributions to improve this project. If you would like to contribute, please follow these steps:

1. Fork the repository.
2. Create a new branch.
3. Make your changes.
4. Submit a pull request.

## License

This project is licensed under the MIT License. See the `LICENSE` file for more details.

## Contact

For questions or issues, please open an issue in the repository or contact the project maintainers at [your-email@example.com].

---

Thank you for using our RMAN Backup and Recovery for Oracle project! We hope this guide helps you set up a reliable backup and recovery solution for your Oracle database.
