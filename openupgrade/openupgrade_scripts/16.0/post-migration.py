from openupgradelib import openupgrade
import logging

_logger = logging.getLogger(__name__)

@openupgrade.migrate()
def migrate(env, version):
    _logger.info("🔧 OpenUpgrade POST-migration started for version 16.0")

    # Example: sanity check table
    env.cr.execute("""
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = 'public'
        LIMIT 1
    """)

    _logger.info("✅ POST-migration completed successfully")
