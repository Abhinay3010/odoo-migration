FROM ubuntu:22.04

# Install system dependencies and PostgreSQL repo
RUN apt-get update && apt-get install -y \
    wget curl gnupg \
    && curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /etc/apt/trusted.gpg.d/postgresql.gpg \
    && sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt jammy-pgdg main" > /etc/apt/sources.list.d/pgdg.list' \
    && apt-get update

# Install packages + PostgreSQL 16 client
RUN apt-get install -y \
    python3 python3-pip python3-dev build-essential git \
    libpq-dev postgresql-client-16 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV PATH="/usr/lib/postgresql/16/bin/:$PATH"
WORKDIR /opt/migration

# Copy migration scripts
COPY scripts/ /opt/migration/scripts/
RUN chmod +x /opt/migration/scripts/*.sh

# Copy Odoo & OpenUpgrade
COPY odoo/ /opt/odoo
COPY openupgrade/ /opt/migration/openupgrade

# Install Python dependencies
RUN pip3 install --no-cache-dir wheel setuptools psycopg2-binary Babel lxml decorator

ENTRYPOINT ["/opt/migration/scripts/run_migration.sh"]
