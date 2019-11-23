#!/usr/bin/env bash

SERVICEACCOUNT=/var/run/secrets/kubernetes.io/serviceaccount
TOKEN=$(cat ${SERVICEACCOUNT}/token)
CACERT=${SERVICEACCOUNT}/ca.crt

if [ -z $TOKEN ]; then
  echo "FATAL: Environment Variable KUBE_TOKEN must be specified."
  exit ${2:-1}
fi

if [ -z $NAMESPACE ]; then
  echo "FATAL: Environment Variable NAMESPACE must be specified."
  exit ${2:-1}
fi

echo
echo "Namespace $NAMESPACE"

status_code=$(curl -sSk --cacert ${CACERT} -H "Authorization: Bearer $TOKEN" \
    "https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_PORT_443_TCP_PORT/apis/apps/v1beta2/namespaces/$NAMESPACE/deployments/codeigniter-example-deployment" \
    -X GET -o /dev/null -w "%{http_code}")

if [ $status_code == 200 ]; then
  echo
  echo "Creating temporary deployment"
  curl --fail --cacert ${CACERT} -H 'Content-Type: application/json' -sSk -H "Authorization: Bearer $TOKEN" \
    "https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_PORT_443_TCP_PORT/apis/apps/v1beta2/namespaces/$NAMESPACE/deployments" \
    -X POST -d @codeigniter-example-deployment-tmp.json
  sleep 60
  echo "Delete deployment"
  curl -X DELETE --fail --cacert ${CACERT} -H 'Accept: application/json' -sSk -H "Authorization: Bearer $TOKEN" \
    "https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_PORT_443_TCP_PORT/apis/apps/v1beta2/namespaces/$NAMESPACE/deployments/codeigniter-example-deployment"
  sleep 60
  echo "Creating deployment"
  curl --fail --cacert ${CACERT} -H 'Content-Type: application/json' -sSk -H "Authorization: Bearer $TOKEN" \
    "https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_PORT_443_TCP_PORT/apis/apps/v1beta2/namespaces/$NAMESPACE/deployments" \
    -X POST -d @codeigniter-example-deployment.json
  sleep 60
  echo "Delete temporary deployment"
  curl -X DELETE --fail --cacert ${CACERT} -H 'Accept: application/json' -sSk -H "Authorization: Bearer $TOKEN" \
    "https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_PORT_443_TCP_PORT/apis/apps/v1beta2/namespaces/$NAMESPACE/deployments/codeigniter-example-deployment-tmp"

else
 echo
 echo "Creating deployment"
 curl --fail --cacert ${CACERT} -H 'Content-Type: application/json' -sSk -H "Authorization: Bearer $TOKEN" \
    "https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_PORT_443_TCP_PORT/apis/apps/v1beta2/namespaces/$NAMESPACE/deployments" \
    -X POST -d @codeigniter-example-deployment.json
fi

status_code=$(curl -sSk --cacert ${CACERT} -H "Authorization: Bearer $TOKEN" \
    "https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_PORT_443_TCP_PORT/api/v1/namespaces/$NAMESPACE/services/codeigniter-example-service" \
    -X GET -o /dev/null -w "%{http_code}")

if [ $status_code == 404 ]; then
 echo
 echo "Creating service"
 curl --fail --cacert ${CACERT} -H 'Content-Type: application/json' -sSk -H "Authorization: Bearer $TOKEN" \
    "https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_PORT_443_TCP_PORT/api/v1/namespaces/$NAMESPACE/services" \
    -X POST -d @codeigniter-example-service.json
fi
