#!/bin/bash
# init-portainer.sh - Fully automated Portainer initialization

set -euo pipefail

PORTAINER_URL="${PORTAINER_URL:-http://10.0.0.244:9000}"
ADMIN_USER="${ADMIN_USER:-admin}"
ADMIN_PASS="${ADMIN_PASS:-ChangeMe123!}"
MAX_WAIT_SECONDS=120  # Wait up to 2 minutes for Portainer to start
SLEEP_INTERVAL=5

echo "=== Portainer Initialization Script ==="
echo "URL: $PORTAINER_URL"

# Step 1: Wait for Portainer to be ready
echo "Waiting for Portainer to be ready..."
elapsed=0
until curl -sf "${PORTAINER_URL}/api/system/status" > /dev/null 2>&1; do
  sleep $SLEEP_INTERVAL
  elapsed=$((elapsed + SLEEP_INTERVAL))
  if [ $elapsed -ge $MAX_WAIT_SECONDS ]; then
    echo "Timeout: Portainer did not become ready in ${MAX_WAIT_SECONDS}s"
    exit 1
  fi
  echo "  Still waiting... (${elapsed}s)"
done
echo "Portainer is ready!"

# Step 2: Check if already initialized
STATUS=$(curl -s "${PORTAINER_URL}/api/system/status")
IS_ADMIN=$(echo "$STATUS" | jq -r '.isAdmin // false')

if [ "$IS_ADMIN" = "true" ]; then
  echo "Portainer is already initialized. Skipping admin creation."
  exit 0
fi

# Step 3: Create initial admin user
echo "Creating initial admin user..."
RESPONSE=$(curl -s -X POST "${PORTAINER_URL}/api/users/admin/init" \
  -H "Content-Type: application/json" \
  -d "{\"username\":\"${ADMIN_USER}\",\"password\":\"${ADMIN_PASS}\"}")

if echo "$RESPONSE" | jq -e '.Id' > /dev/null 2>&1; then
  echo "Admin user '${ADMIN_USER}' created successfully (ID: $(echo $RESPONSE | jq -r '.Id'))"
else
  echo "ERROR creating admin: $RESPONSE" >&2
  exit 1
fi

# Step 4: Obtain JWT token
echo "Authenticating..."
TOKEN=$(curl -s -X POST "${PORTAINER_URL}/api/auth" \
  -H "Content-Type: application/json" \
  -d "{\"username\":\"${ADMIN_USER}\",\"password\":\"${ADMIN_PASS}\"}" | jq -r '.jwt')

echo "Authentication successful."

# Step 5: Additional setup tasks (optional)
# Disable telemetry
curl -s -X PUT -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  "${PORTAINER_URL}/api/settings" \
  -d '{"enableTelemetry": false}' > /dev/null

echo "=== Portainer initialization complete ==="
echo "URL:      $PORTAINER_URL"
echo "Username: $ADMIN_USER"