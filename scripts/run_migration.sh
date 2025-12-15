#!/bin/bash
# --------------------------
# Simple container entrypoint for Odoo 17 migration testing
# --------------------------

echo "Starting migration container..."

# Show current Odoo version
if [ -f /opt/odoo/odoo-bin ]; then
    echo "Current Odoo version (inside container):"
    python3 /opt/odoo/odoo-bin --version
else
    echo "❌ odoo-bin not found in /opt/odoo/"
fi

# Keep container running for inspection
echo "Container is running. Access it using: docker exec -it <container_name> bash"
tail -f /dev/null
