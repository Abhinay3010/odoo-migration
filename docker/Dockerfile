FROM python:3.11-slim

WORKDIR /opt/migration

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
        wget curl git build-essential libpq-dev postgresql-client \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Python dependencies
COPY scripts/requirements.txt /opt/migration/scripts/requirements.txt
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r /opt/migration/scripts/requirements.txt

# Copy Odoo & OpenUpgrade
COPY odoo/ /opt/odoo
COPY openupgrade/ /opt/migration/openupgrade

# Copy migration scripts
COPY scripts/ /opt/migration/scripts/
RUN chmod +x /opt/migration/scripts/*.sh

# Set PATH for PostgreSQL
ENV PATH="/usr/lib/postgresql/*/bin/:$PATH"

# Default command: keep container running with bash
CMD ["bash"]
