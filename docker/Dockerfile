# Base image: lightweight Python 3.11
FROM python:3.11-slim

# Set working directory
WORKDIR /opt/migration

# --------------------------
# Step 1: Install system dependencies
# --------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
        wget \
        curl \
        git \
        build-essential \
        libpq-dev \
        postgresql-client-16 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# --------------------------
# Step 2: Install Python dependencies
# --------------------------
# Copy only requirements to cache this layer for faster builds
COPY scripts/requirements.txt /opt/migration/scripts/requirements.txt
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r /opt/migration/scripts/requirements.txt

# --------------------------
# Step 3: Copy Odoo & OpenUpgrade
# --------------------------
COPY odoo/ /opt/odoo/
COPY openupgrade/ /opt/migration/openupgrade/

# --------------------------
# Step 4: Copy migration scripts
# --------------------------
COPY scripts/ /opt/migration/scripts/
RUN chmod +x /opt/migration/scripts/*.sh

# --------------------------
# Step 5: Set PATH for PostgreSQL client
# --------------------------
ENV PATH="/usr/lib/postgresql/16/bin/:$PATH"

# --------------------------
# Step 6: Default entrypoint
# --------------------------
ENTRYPOINT ["/opt/migration/scripts/run_migration.sh"]
