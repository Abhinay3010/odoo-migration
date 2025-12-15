# --------------------------
# Base image
# --------------------------
FROM ubuntu:22.04

# --------------------------
# Set working directory
# --------------------------
WORKDIR /opt/migration

# --------------------------
# Step 1: Install system dependencies + PostgreSQL repo
# --------------------------
RUN apt-get update && apt-get install -y \
        wget \
        curl \
        gnupg \
        lsb-release \
        git \
        build-essential \
        python3 \
        python3-pip \
        python3-dev \
        libpq-dev \
    && curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /etc/apt/trusted.gpg.d/postgresql.gpg \
    && echo "deb http://apt.postgresql.org/pub/repos/apt jammy-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
    && apt-get update && apt-get install -y postgresql-client-16 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# --------------------------
# Step 2: Set PATH for PostgreSQL client
# --------------------------
ENV PATH="/usr/lib/postgresql/16/bin/:$PATH"

# --------------------------
# Step 3: Copy Odoo & OpenUpgrade
# --------------------------
COPY odoo/ /opt/odoo
COPY openupgrade/ /opt/migration/openupgrade

# --------------------------
# Step 4: Copy migration scripts
# --------------------------
COPY scripts/ /opt/migration/scripts/
RUN chmod +x /opt/migration/scripts/*.sh

# --------------------------
# Step 5: Install Python dependencies
# --------------------------
RUN pip3 install --no-cache-dir wheel setuptools psycopg2-binary Babel lxml decorator

# --------------------------
# Step 6: Default entrypoint
# --------------------------
ENTRYPOINT ["/opt/migration/scripts/run_migration.sh"]
