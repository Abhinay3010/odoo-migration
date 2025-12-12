#!/bin/bash
set -e

echo "----------------------------------"
echo "Starting migration for DB: $DB_NAME"
echo "----------------------------------"

REPORT_DIR="/workspace/migration_reports"
mkdir -p $REPORT_DIR

echo "Taking backup..."
PGPASSWORD=$DB_PASS pg_dump -h $DB_HOST -p $DB_PORT -U $DB_USER -Fc $DB_NAME \
    -f $REPORT_DIR/backup_before_migration.dump
echo "Backup completed."

echo "Collecting DB analysis (before migration)..."
PGPASSWORD=$DB_PASS psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME \
    -c "SELECT name, state FROM ir_module_module ORDER BY name;" \
    -t -A -F"," > $REPORT_DIR/db_analysis_before.csv

echo "Running OpenUpgrade..."
python3 /opt/odoo/odoo-bin \
    -c /workspace/odoo.conf \
    -d $DB_NAME \
    --upgrade-path=$UPGRADE_PATH \
    --update all \
    --stop-after-init \
    --load=base,web,openupgrade_framework \
    2>&1 | tee $REPORT_DIR/openupgrade.log

echo "Extracting warnings..."
grep -i "WARNING" $REPORT_DIR/openupgrade.log > $REPORT_DIR/openupgrade_warnings.log || true

echo "Extracting errors..."
grep -i "ERROR" $REPORT_DIR/openupgrade.log > $REPORT_DIR/openupgrade_errors.log || true

echo "Collecting DB analysis (after migration)..."
PGPASSWORD=$DB_PASS psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME \
    -c "SELECT name, state FROM ir_module_module ORDER BY name;" \
    -t -A -F"," > $REPORT_DIR/db_analysis_after.csv

echo "Generating module change report..."
diff -u $REPORT_DIR/db_analysis_before.csv $REPORT_DIR/db_analysis_after.csv \
    > $REPORT_DIR/module_changes.txt || true

echo "----------------------------------"
echo "Migration completed. Reports saved at:"
echo "/workspace/migration_reports/"
echo "----------------------------------"
