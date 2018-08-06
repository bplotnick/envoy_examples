#!/bin/bash

/code/eds_update.sh /etc/envoy/endpoints/service1_start.yaml.tmpl service1

/usr/local/bin/envoy -c /etc/envoy/front-envoy.yaml --service-cluster front-proxy
