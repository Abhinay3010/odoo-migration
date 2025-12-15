-- This SQL file is automatically executed by OpenUpgrade

-- Example: non-destructive metadata marker
CREATE TABLE IF NOT EXISTS migration_audit (
    id SERIAL PRIMARY KEY,
    executed_at TIMESTAMP DEFAULT now(),
    note TEXT
);

INSERT INTO migration_audit (note)
VALUES ('OpenUpgrade 16.0 migration executed');
