#!/usr/bin/env bash

curl -k -v -XPOST  -H "Accept: application/json, */*" -H "Content-Type: application/json" -H "Authorization: Bearer $KUBE_TOKEN" 'https://master.openshift.local:8443/apis/build.openshift.io/v1/namespaces/$NAMESPACE/buildconfigs/codeigniter-example-build/instantiate'
