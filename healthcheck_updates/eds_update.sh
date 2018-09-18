#!/bin/bash
# usage: ./eds_update.sh <eds_template_file> <hostname_of_service1>
# example: ./eds_update.sh /etc/envoy/endpoints/service1_start.yaml.tmpl service1

SERVICE1_IP=$(getent hosts service1 | tail -n1 | awk '{print $1}')
SERVICE2_IP=$(getent hosts service2 | tail -n1 | awk '{print $1}')

cp $1 /tmp/endpoints.yaml
sed -i "s/{{service1_ip}}/$SERVICE1_IP/g" /tmp/endpoints.yaml
sed -i "s/{{service2_ip}}/$SERVICE2_IP/g" /tmp/endpoints.yaml

mv /tmp/endpoints.yaml /tmp/envoy/endpoints/service1.yaml
