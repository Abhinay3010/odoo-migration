# --------------------------
# Base image
# --------------------------
FROM python:3.11-slim

# --------------------------
# Set environment
# --------------------------
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /opt

# --------------------------
# Install system dependencies
# --------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
        git \
        wget \
        curl \
        build-essential \
        libpq-dev \
        postgresql-client \
        nodejs \
        npm \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# --------------------------
# Clone Odoo 17 source
# --------------------------
RUN git clone --depth 1 --branch 17.0 https://github.com/odoo/odoo.git /opt/odoo

# --------------------------
# Install Python dependencies
# --------------------------
WORKDIR /opt/odoo
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# --------------------------
# Copy OpenUpgrade
# --------------------------
WORKDIR /opt/migration
COPY openupgrade/ /opt/migration/openupgrade

# --------------------------
# Copy migration scripts
# --------------------------
COPY scripts/ /opt/migration/scripts/
RUN chmod +x /opt/migration/scripts/*.sh

# --------------------------
# Default command (keep container running)
# --------------------------
CMD ["tail", "-f", "/dev/null"]
