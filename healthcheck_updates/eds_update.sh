#!/bin/bash
# usage: ./eds_update.sh <eds_template_file> <hostname_of_service1>
# example: ./eds_update.sh /etc/envoy/endpoints/service1_start.yaml.tmpl service1

SERVICE1_IP=$(getent hosts $2 | tail -n1 | awk '{print $1}')

sed "s/{{service1_ip}}/$SERVICE1_IP/g" $1 > /tmp/envoy/endpoints/service1.yaml
