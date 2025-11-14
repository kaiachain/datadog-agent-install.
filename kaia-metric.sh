#!/bin/bash

# This script needs to be executed with sudo privileges.

CONFIG_FILE="/etc/datadog-agent/conf.d/openmetrics.d/conf.yaml"

# List of new metrics to add (including 6 spaces and a hyphen for correct YAML formatting)
# \n is used for line breaks.
NEW_METRICS="      - kaiax_auction_bidpool_num_bids\n      - kaiax_auction_bidpool_num_bidreqs\n      - miner_balance"

# --- Script Execution Start ---

# Check if the configuration file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ ERROR: Configuration file not found: ${CONFIG_FILE}"
    exit 1
fi

echo "👉 Backing up file: Creating ${CONFIG_FILE}.bak..."
cp "${CONFIG_FILE}" "${CONFIG_FILE}.bak"

echo "⚙️  Adding new metrics to file: ${CONFIG_FILE}"

# Use sed to append the new metrics right after the '- klaytn_build_info' line.
if sed -i '/- klaytn_build_info/a\'"$NEW_METRICS"'' "${CONFIG_FILE}"; then
    echo "✅ Metrics added successfully."
    echo ""
    echo "--- Verification of Added Content (Last part of the file) ---"
    tail -n 10 "${CONFIG_FILE}"
    echo "------------------------------------------------------------"
    echo ""
    echo "🚨 You must restart the Datadog Agent for the changes to take effect (e.g., systemctl restart datadog-agent)."
else
    echo "❌ ERROR: Failed to modify the file. Please check permissions and the sed command."
fi