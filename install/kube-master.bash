#!/bin/bash

# tweak it as per your setup
curl -s https://raw.githubusercontent.com/damianoneill/kubernetes-cluster/master/install/kube-base.bash | bash

yum install etcd flannel kubernetes -y

cat > /etc/etcd/etcd.conf << '__EOF__'
# [member]
ETCD_NAME=default
ETCD_DATA_DIR="/var/lib/etcd/default.etcd"
ETCD_LISTEN_CLIENT_URLS="http://0.0.0.0:2379"
#[cluster]
ETCD_ADVERTISE_CLIENT_URLS="http://localhost:2379"
__EOF__

cat > /etc/kubernetes/apiserver << '__EOF__'
KUBE_API_ADDRESS="--address=0.0.0.0"
KUBE_API_PORT="--port=8080"
KUBELET_PORT="--kubelet_port=10250"
KUBE_ETCD_SERVERS="--etcd_servers=http://127.0.0.1:2379"
KUBE_SERVICE_ADDRESSES="--service-cluster-ip-range=10.254.0.0/16"
KUBE_ADMISSION_CONTROL="--admission_control=NamespaceLifecycle,NamespaceExists,LimitRanger,SecurityContextDeny,ResourceQuota"
KUBE_API_ARGS=""
__EOF__

cat > /etc/sysconfig/flanneld << '__EOF__'
FLANNEL_ETCD="http://kube-master:2379"
FLANNEL_ETCD_KEY="/atomic.io/network"
__EOF__

for SERVICES in etcd kube-apiserver kube-controller-manager kube-scheduler docker flanneld; do
    systemctl restart $SERVICES
    systemctl enable $SERVICES
    systemctl status $SERVICES
done


etcdctl mk /atomic.io/network/config '{"Network":"172.17.0.0/16"}'
