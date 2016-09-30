#!/bin/bash

systemctl stop firewalld &>/dev/null
systemctl disable firewalld &>/dev/null

yum install ntp -y
systemctl start ntpd
systemctl enable ntpd


if grep -q kube-master /etc/hosts
then
    echo "kube hosts defined"
else
tee -a /etc/hosts << __EOF__

${KUBE_MASTER_IP:-172.26.136.186} kube-master
${KUBE_NODE_01_IP:-172.26.136.187} kube-node-01
${KUBE_NODE_02_IP:-172.26.136.188} kube-node-02
${KUBE_NODE_03_IP:-172.26.136.189} kube-node-03
__EOF__
fi
