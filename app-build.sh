#!/usr/bin/env bash

SERVICEACCOUNT=/var/run/secrets/kubernetes.io/serviceaccount
NAMESPACE=$(cat ${SERVICEACCOUNT}/namespace)
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

curl --fail --cacert ${CACERT} -XPOST -H 'Accept: application/json, */*' -H "Content-Type: application/json" -sSk -H "Authorization: Bearer ${TOKEN}" "https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_PORT_443_TCP_PORT/apis/build.openshift.io/v1/namespaces/$NAMESPACE/buildconfigs/codeigniter-example-build/instantiate" 

