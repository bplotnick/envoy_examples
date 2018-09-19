#!/bin/bash

SERVICE1_1_IP=$(getent hosts service1_1 | tail -n1 | awk '{print $1}')
SERVICE1_2_IP=$(getent hosts service1_2 | tail -n1 | awk '{print $1}')

cp /etc/envoy/endpoints/service1_start.yaml.tmpl /tmp/endpoints.yaml
sed -i "s/{{service1_1_ip}}/$SERVICE1_1_IP/g" /tmp/endpoints.yaml
sed -i "s/{{service1_2_ip}}/$SERVICE1_2_IP/g" /tmp/endpoints.yaml

mv /tmp/endpoints.yaml /tmp/envoy/endpoints/service1.yaml

cp /etc/envoy/clusters_start.yaml /tmp/envoy/clusters.yaml
