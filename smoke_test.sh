#!/usr/bin/env bash
# SENTINEL v4 — Stage 0 end-to-end smoke test.
# Sends one transaction through the whole pipeline and confirms a
# decision row landed in Postgres. Run after `docker compose up -d`.
set -euo pipefail

BASE_URL="${BASE_URL:-http://localhost:8000}"

echo "1) Requesting auth token..."
TOKEN=$(curl -s -X POST "$BASE_URL/auth/token" \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}' \
  | python3 -c "import sys, json; print(json.load(sys.stdin)['access_token'])")
echo "   token acquired."

echo "2) Submitting a test transaction..."
RESPONSE=$(curl -s -X POST "$BASE_URL/transactions" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
        "channel": "UPI",
        "amount": 4999.00,
        "sender_id": "user-1001",
        "beneficiary_id": "ben-2002",
        "device_id": "device-abc",
        "ip_address": "10.0.0.5"
      }')
echo "   gateway response: $RESPONSE"

TXN_ID=$(echo "$RESPONSE" | python3 -c "import sys, json; print(json.load(sys.stdin)['transaction_id'])")

echo "3) Waiting for the pipeline to process transaction $TXN_ID ..."
sleep 5

echo "4) Checking the decision landed in Postgres..."
docker exec sentinel-postgres psql -U "${POSTGRES_USER:-sentinel}" -d "${POSTGRES_DB:-sentinel}" -c \
  "SELECT transaction_id, decision, reason, decided_at FROM fraud_decisions WHERE transaction_id = '$TXN_ID';"

echo
echo "If you see a row above with decision=ALLOW, Stage 0 is wired correctly end to end."
