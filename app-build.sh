#!/usr/bin/env bash

curl --fail -XPOST -H "Content-Type: application/json" -H "Authorization: Bearer $KUBE_TOKEN" 'https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_PORT_443_TCP_PORT/apis/build.openshift.io/v1/namespaces/$NAMESPACE/buildconfigs/codeigniter-example-build/instantiate'
