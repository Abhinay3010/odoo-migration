#!/bin/bash
set -e

BACKUP_FILE="/opt/migration/backups/${DB_NAME}-pre.dump"

echo "--------------------------"
echo "Starting migration for DB: $DB_NAME"
echo "--------------------------"

mkdir -p /opt/migration/backups /opt/migration/logs

# Backup
echo "Taking backup..."
pg_dump -h $DB_HOST -p $DB_PORT -U $DB_USER -F c $DB_NAME > $BACKUP_FILE
echo "Backup completed: $BACKUP_FILE"

# Migration
echo "Running migration..."
if python3 /opt/odoo/odoo-bin \
    -c /opt/migration/scripts/odoo.conf \
    -d $DB_NAME \
    --upgrade-path=$UPGRADE_PATH \
    --update all \
    --stop-after-init \
    --load base,web,openupgrade_framework
then
    echo "Migration SUCCESS ✅"
else
    echo "Migration FAILED ❌ — restoring backup"

    dropdb -h $DB_HOST -p $DB_PORT -U $DB_USER $DB_NAME
    createdb -h $DB_HOST -p $DB_PORT -U $DB_USER $DB_NAME

    pg_restore -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME $BACKUP_FILE

    echo "Rollback completed 🔄"
    exit 1
fi
