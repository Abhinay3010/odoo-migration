#!/bin/bash
set -euo pipefail

# --------------------------
# Environment variables
# --------------------------
DB_NAME="${DB_NAME:-mydb}"
DB_HOST="${DB_HOST:-127.0.0.1}"
DB_PORT="${DB_PORT:-5432}"
DB_USER="${DB_USER:-odoo_user_new}"
DB_PASS="${DB_PASS:-}"
UPGRADE_PATH="${UPGRADE_PATH:-/opt/migration/openupgrade}"
WORKDIR="/workspace"
BACKUP_DIR="$WORKDIR/backups"
LOG_DIR="$WORKDIR/migration_reports"

# --------------------------
# Prepare directories
# --------------------------
mkdir -p "$BACKUP_DIR"
mkdir -p "$LOG_DIR"

echo "Starting migration for DB: $DB_NAME"
echo "Backup directory: $BACKUP_DIR"
echo "Log directory: $LOG_DIR"

# --------------------------
# Step 1: Check Odoo binary
# --------------------------
ODOO_BIN="/opt/odoo/odoo-bin"
if [[ ! -f "$ODOO_BIN" ]]; then
    echo "❌ ERROR: Odoo binary not found at $ODOO_BIN"
    exit 1
fi

# --------------------------
# Step 2: Create DB backup
# --------------------------
echo "Taking backup..."
export PGPASSWORD="$DB_PASS"
BACKUP_FILE="$BACKUP_DIR/${DB_NAME}-pre.dump"
if pg_dump -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -Fc "$DB_NAME" > "$BACKUP_FILE"; then
    echo "✅ Backup completed: $BACKUP_FILE"
else
    echo "⚠️ Backup failed. Continuing with migration..."
fi

# --------------------------
# Step 3: Run migration
# --------------------------
echo "Running migration..."
if python3 "$ODOO_BIN" -d "$DB_NAME" --db_host="$DB_HOST" --db_port="$DB_PORT" --db_user="$DB_USER" --db_password="$DB_PASS" \
    --load-language=en_US --update=all --stop-after-init --addons-path="$UPGRADE_PATH" &> "$LOG_DIR/${DB_NAME}-migration.log"; then
    echo "✅ Migration finished successfully!"
else
    echo "❌ Migration FAILED. Restoring backup..."
    if createdb -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" "$DB_NAME"; then
        pg_restore -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" "$BACKUP_FILE"
        echo "✅ Backup restored successfully!"
    else
        echo "⚠️ Failed to restore backup. Check DB permissions."
    fi
    exit 1
fi
