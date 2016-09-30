# kubernetes-cluster

Setup environment for Kubernetes on Centos 7 minimal, ensure that your nodes have 7 minimal installed and that there up and available on a subnet.

## Before setting up the master or a node
You need to identify the ip's for the cluster and source these in the working shell

     export KUBE_MASTER_IP=172.26.136.186; export KUBE_NODE_01_IP=172.26.136.187; export KUBE_NODE_02_IP=172.26.136.188; export KUBE_NODE_03_IP=172.26.136.189

## To setup the Kubernetes master (done once)

     curl -s https://raw.githubusercontent.com/damianoneill/kubernetes-cluster/master/install/kube-master.bash | bash

## To setup a Kubernetes node (one time per minion)

     curl -s https://raw.githubusercontent.com/damianoneill/kubernetes-cluster/master/install/kube-node.bash | bash

## To verify the setup

```bash
[root@kube-master ~]# kubectl get nodes
NAME           STATUS    AGE
kube-node-01   Ready     1m
kube-node-02   Ready     38s
kube-node-03   Ready     12s
```

## To add a Redis Cluster to the Kubernetes Cluster

     wget https://raw.githubusercontent.com/kubernetes/kubernetes/master/examples/guestbook/all-in-one/guestbook-all-in-one.yaml
     kubectl create -f guestbook-all-in-one.yaml

To confirm this is working correct

     kubectl get pods -o wide

## TODO
