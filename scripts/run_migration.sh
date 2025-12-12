#!/bin/bash
set -e

echo "--------------------------"
echo "Starting migration for DB: $DB_NAME"
echo "--------------------------"

mkdir -p /opt/migration/backups /opt/migration/logs

# Backup
echo "Taking backup..."
pg_dump -h $DB_HOST -p $DB_PORT -U $DB_USER -F c $DB_NAME > /opt/migration/backups/${DB_NAME}-pre.dump
echo "Backup completed: /opt/migration/backups/${DB_NAME}-pre.dump"

# Run migration
echo "Running migration using Odoo 18 and OpenUpgrade scripts..."
python3 /opt/odoo/odoo-bin -c /opt/migration/scripts/odoo.conf -d $DB_NAME \
--upgrade-path=$UPGRADE_PATH --update all --stop-after-init --load base,web,openupgrade_framework

echo "Migration finished!"
