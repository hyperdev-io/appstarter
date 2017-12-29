#!/bin/bash
CUR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BASE_PATH="$1"
set -e

COMPOSE_FILE=$BASE_PATH/docker-compose.yml
echo -e "COMPOSE_FILE = $COMPOSE_FILE\n"

echo "======================"
echo "[PUSHING TO DASHBOARD]"
echo "======================"
echo "DASHBOARD_API_KEY: $DASHBOARD_API_KEY"
echo "COMPOSE_FILE: $COMPOSE_FILE"
echo "DASHBOARD: $DASHBOARD"
echo "APPLICATION_NAME: $APPLICATION_NAME"
echo "INSTANCE_NAME: $INSTANCE_NAME"

curl -X PUT -H "Content-Type: text/plain;charset=UTF-8" -H "api-key: $DASHBOARD_API_KEY" --data-binary @$COMPOSE_FILE "https://jenkins:G75CdIxQgPrn@$DASHBOARD/api/v2/apps/$APPLICATION_NAME/$INSTANCE_NAME/files/dockerCompose"

echo "======="
echo "[START]"
echo "======="

echo curl -sS -XPUT  -H 'Content-Type: application/json' -H "api-key: $DASHBOARD_API_KEY" \
     -d "{ \"app\": \"$APPLICATION_NAME\", \"version\": \"${INSTANCE_NAME}\", \"parameters\": {}, \"options\": {}}" \
     "https://jenkins:G75CdIxQgPrn@$DASHBOARD/api/v2/instances/$INSTANCE_NAME"

curl -sS -XPUT  -H 'Content-Type: application/json' -H "api-key: $DASHBOARD_API_KEY" \
     -d "{ \"app\": \"$APPLICATION_NAME\", \"version\": \"${INSTANCE_NAME}\", \"parameters\": {}, \"options\": {}}" \
     "https://jenkins:G75CdIxQgPrn@$DASHBOARD/api/v2/instances/$INSTANCE_NAME"
sleep 15

a=0
TIMEOUT=200
INSTANCE_STATUS=$(curl -sS -XGET https://jenkins:G75CdIxQgPrn@$DASHBOARD/api/v2/instances/${INSTANCE_NAME}?api-key=$DASHBOARD_API_KEY)
echo "\n[INFO] Waiting for instance ${INSTANCE_NAME} to start"
while [ "$a" -lt "$TIMEOUT" ]
do
        a=$(($a+1))
        if [[ $INSTANCE_STATUS == *"\"current\":\"running\""* ]]; then
                echo "[INFO] Instance $INSTANCE_NAME has successfully started!"
                break
        fi
        echo "[INFO] Still waiting for ${INSTANCE_NAME} ..."
        echo "[INFO] Current status is -> ${INSTANCE_STATUS}"
        INSTANCE_STATUS=$(curl -sS -XGET https://jenkins:G75CdIxQgPrn@$DASHBOARD/api/v2/instances/${INSTANCE_NAME}?api-key=$DASHBOARD_API_KEY)
        sleep 5
done

if [[ "$a" -eq "$TIMEOUT" ]]; then
        echo "[INFO] Instance ${INSTANCE_NAME} could not be started. Please contact a system administrator!"
        exit 110
fi

echo ""
echo "========"
echo "[END]"
echo "========"

