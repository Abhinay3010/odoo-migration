# --------------------------
# Phase 1: Base image
# --------------------------
FROM python:3.11-slim

# --------------------------
# System dependencies
# --------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    wget \
    build-essential \
    libpq-dev \
    postgresql-client \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# --------------------------
# Working directory
# --------------------------
WORKDIR /opt

# --------------------------
# Clone Odoo (TARGET VERSION)
# Change branch later for migration
# --------------------------
RUN git clone --depth 1 --branch 17.0 https://github.com/odoo/odoo.git /opt/odoo

# --------------------------
# Install Odoo Python deps
# --------------------------
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r /opt/odoo/requirements.txt

# --------------------------
# Keep container alive (DEBUG MODE)
# --------------------------
CMD ["sleep", "infinity"]
