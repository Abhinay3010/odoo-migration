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
# Step 2: Copy Odoo 17 & OpenUpgrade
# --------------------------
COPY odoo/ /opt/odoo
COPY openupgrade/ /opt/migration/openupgrade

# --------------------------
# Step 3: Copy migration scripts
# --------------------------
COPY scripts/ /opt/migration/scripts/
RUN chmod +x /opt/migration/scripts/*.sh

# --------------------------
# Step 4: Set PATH for PostgreSQL client
# --------------------------
ENV PATH="/usr/lib/postgresql/*/bin/:$PATH"

# --------------------------
# Step 5: Keep container alive for inspection
# --------------------------
CMD ["bash"]
