#!/bin/bash

/code/config_update_start.sh

/usr/local/bin/envoy -c /etc/envoy/front-envoy.yaml --service-cluster front-proxy
