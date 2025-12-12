#!/bin/bash

echo "--------------------------"
echo "Starting migration for DB: $DB_NAME"
echo "--------------------------"

# REQUIRED: pass password to pg_dump and psql
export PGPASSWORD="$DB_PASS"

echo "Taking backup..."
pg_dump -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" "$DB_NAME" > /workspace/${DB_NAME}_backup.sql

if [ $? -ne 0 ]; then
    echo "Backup failed!"
    exit 1
fi

echo "Backup taken successfully."

echo "Running OpenUpgrade..."
python3 /opt/odoo/odoo-bin \
    -c /opt/migration/scripts/odoo.conf \
    -d "$DB_NAME" \
    --upgrade-path="$UPGRADE_PATH" \
    --update all \
    --stop-after-init \
    --load=base,web,openupgrade_framework

echo "Migration completed."
