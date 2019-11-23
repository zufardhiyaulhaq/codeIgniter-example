#!/usr/bin/env bash

if [ -z $KUBE_TOKEN ]; then
  echo "FATAL: Environment Variable KUBE_TOKEN must be specified."
  exit ${2:-1}
fi

if [ -z $NAMESPACE ]; then
  echo "FATAL: Environment Variable NAMESPACE must be specified."
  exit ${2:-1}
fi

echo
echo "Namespace $NAMESPACE"

echo "curl --fail -XPOST -H 'Accept: application/json, */*' -H 'Content-Type: application/json' -sSk -H 'Authorization: Bearer $KUBE_TOKEN' 'https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_PORT_443_TCP_PORT/apis/build.openshift.io/v1/namespaces/$NAMESPACE/buildconfigs/codeigniter-example-build/instantiate'"

curl --fail -XPOST -H 'Accept: application/json, */*' -H "Content-Type: application/json" -sSk -H "Authorization: Bearer $KUBE_TOKEN" "https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_PORT_443_TCP_PORT/apis/build.openshift.io/v1/namespaces/$NAMESPACE/buildconfigs/codeigniter-example-build/instantiate" 

