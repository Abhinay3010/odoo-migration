# Use lightweight Python 3.11 image
FROM python:3.11-slim

# Set working directory
WORKDIR /opt/migration

# --------------------------
# Step 1: Install system dependencies
# --------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget curl git build-essential libpq-dev postgresql-client \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# --------------------------
# Step 2: Copy Odoo & OpenUpgrade
# --------------------------
COPY odoo/ /opt/odoo
COPY openupgrade/ /opt/migration/openupgrade

# Ensure Odoo exists
RUN ls -la /opt/odoo

# --------------------------
# Step 3: Copy migration scripts
# --------------------------
COPY scripts/ /opt/migration/scripts/
RUN chmod +x /opt/migration/scripts/*.sh

# --------------------------
# Step 4: Install Python dependencies
# --------------------------
RUN pip install --no-cache-dir wheel setuptools psycopg2-binary Babel lxml decorator

# --------------------------
# Step 5: Set PATH for PostgreSQL client
# --------------------------
ENV PATH="/usr/lib/postgresql/bin/:$PATH"

# --------------------------
# Step 6: Default entrypoint
# --------------------------
ENTRYPOINT ["/opt/migration/scripts/run_migration.sh"]
