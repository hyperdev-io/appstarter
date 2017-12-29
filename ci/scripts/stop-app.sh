#!/bin/bash
CUR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BASE_PATH="$1"
set -e

echo "[INFO] Stopping application instance ${INSTANCE_NAME}"
curl -sS -XDELETE "https://jenkins:G75CdIxQgPrn@$DASHBOARD/api/v2/instances/${INSTANCE_NAME}" -H "api-key:$DASHBOARD_API_KEY"
E_CODE=$?
echo ""
echo "========"
echo "[END STOP]"
echo "========"
exit $E_CODE
