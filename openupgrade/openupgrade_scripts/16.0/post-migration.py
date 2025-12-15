from openupgradelib import openupgrade

@openupgrade.migrate()
def migrate(env, version):
    env.cr.execute("""
        CREATE TABLE IF NOT EXISTS migration_audit (
            id serial primary key,
            migrated_at timestamp default now(),
            version text
        )
    """)
    env.cr.execute("""
        INSERT INTO migration_audit(version)
        VALUES ('16.0 migration executed')
    """)
