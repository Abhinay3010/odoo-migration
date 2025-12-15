# --------------------------
# Base image: lightweight Python 3.11
# --------------------------
FROM python:3.11-slim

# --------------------------
# Set working directory
# --------------------------
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
        postgresql-client \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# --------------------------
# Step 2: Copy Python requirements and install
# --------------------------
COPY scripts/requirements.txt /opt/migration/scripts/requirements.txt
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r /opt/migration/scripts/requirements.txt

# --------------------------
# Step 3: Download Odoo source inside container
# --------------------------
RUN git clone --branch 16.0 --depth 1 https://github.com/odoo/odoo.git /opt/odoo

# --------------------------
# Step 4: Copy OpenUpgrade
# --------------------------
COPY openupgrade/ /opt/migration/openupgrade

# --------------------------
# Step 5: Copy migration scripts
# --------------------------
COPY scripts/ /opt/migration/scripts/
RUN chmod +x /opt/migration/scripts/*.sh

# --------------------------
# Step 6: Set PATH for PostgreSQL client
# --------------------------
ENV PATH="/usr/lib/postgresql/*/bin/:$PATH"

# --------------------------
# Step 7: Default entrypoint
# --------------------------
ENTRYPOINT ["/opt/migration/scripts/run_migration.sh"]
