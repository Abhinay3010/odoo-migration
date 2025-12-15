# -------------------------------
# Odoo 17 Base Dockerfile
# -------------------------------

FROM python:3.11-slim

# -------------------------------
# Install system dependencies
# -------------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    wget \
    build-essential \
    libpq-dev \
    postgresql-client \
    libldap2-dev \
    libsasl2-dev \
    libssl-dev \
    libxml2-dev \
    libxslt1-dev \
    libjpeg-dev \
    zlib1g-dev \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# -------------------------------
# Set working directory
# -------------------------------
WORKDIR /opt

# -------------------------------
# Clone Odoo 17 source code
# -------------------------------
RUN git clone --depth 1 --branch 17.0 https://github.com/odoo/odoo.git /opt/odoo

# -------------------------------
# Upgrade pip and install Python requirements
# -------------------------------
WORKDIR /opt/odoo
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# -------------------------------
# Set default command
# -------------------------------
CMD ["python3", "-m", "odoo"]
