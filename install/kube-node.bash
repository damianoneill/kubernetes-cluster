#!/bin/bash

curl -s https://raw.githubusercontent.com/damianoneill/kubernetes-cluster/master/install/kube-base.bash | bash

yum -y install flannel kubernetes

cat > /etc/sysconfig/flanneld << '__EOF__'
FLANNEL_ETCD="http://kube-master:2379"
FLANNEL_ETCD_KEY="/atomic.io/network"
__EOF__

cat > /etc/kubernetes/config << '__EOF__'
KUBE_MASTER="--master=http://kube-master:8080"
__EOF__

cat > /etc/kubernetes/kubelet << '__EOF__'
KUBELET_ADDRESS="--address=0.0.0.0"
KUBELET_PORT="--port=10250"
# change the hostname to this host’s IP address
# KUBELET_HOSTNAME="--hostname_override=192.168.50.131"
KUBELET_API_SERVER="--api_servers=http://kube-master:8080"
KUBELET_ARGS=""
__EOF__

for SERVICES in kube-proxy kubelet docker flanneld; do
    systemctl restart $SERVICES
    systemctl enable $SERVICES
    systemctl status $SERVICES
done
