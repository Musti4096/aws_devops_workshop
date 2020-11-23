# Hands-on Kubernetes-01 : Installing Kubernetes on Ubuntu 20.04 running on AWS EC2 Instances

Purpose of the this hands-on training is to give students the knowledge of how to install and configure Kubernetes on Ubuntu 20.04 EC2 Instances.

## Learning Outcomes

At the end of the this hands-on training, students will be able to;

- install Kubernetes on Ubuntu 20.04.

- explain steps of the Kubernetes installation.

- set up a Kubernetes cluster.

- explain the Kubernetes architecture.

- deploy a simple server on Kubernetes cluster.

## Outline

- Part 1 - Setting Up Kubernetes Environment on All Nodes

- Part 2 - Setting Up Master Node for Kubernetes

- Part 3 - Adding the Slave/Worker Nodes to the Cluster

- Part 4 - Deploying a Simple Nginx Server on Kubernetes

- Part 5  - Adding master or worker node

## Part 1 - Setting Up Kubernetes Environment on All Nodes

- In this hands-on, we will prepare two nodes for Kubernetes on `Ubuntu 20.04`. One of the node will be configured as the Master node, the other will be the worker node. Following steps should be executed on all nodes. *Note: It is recommended to install Kubernetes on machines with `2 CPU Core` and `2GB RAM` at minimum to get it working efficiently. For this reason, we will select `t2.medium` as EC2 instance type, which has `2 CPU Core` and `4 GB RAM`.*

- Explain briefly [required ports](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)  for Kubernetes. 

- Create two security groups. Name the first security group as master-sec-group and apply the following Control-plane (Master) Node(s) table to your master node.

- Name the second security group as worker-sec-group, and apply the following Worker Node(s) table to your worker nodes.

### Control-plane (Master) Node(s)

|Protocol|Direction|Port Range|Purpose|Used By|
|---|---|---|---|---|
|TCP|Inbound|6443|Kubernetes API server|All|
|TCP|Inbound|2379-2380|`etcd` server client API|kube-apiserver, etcd|
|TCP|Inbound|10250|Kubelet API|Self, Control plane|
|TCP|Inbound|10251|kube-scheduler|Self|
|TCP|Inbound|10252|kube-controller-manager|Self|

### Worker Node(s)

|Protocol|Direction|Port Range|Purpose|Used By|
|---|---|---|---|---|
|TCP|Inbound|10250|Kubelet API|Self, Control plane|
|TCP|Inbound|30000-32767|NodePort Services†|All|

> **Ignore this section for AWS instances. But, it must be applied for real servers/workstations.**
>
> - Find the line in `/etc/fstab` referring to swap, and comment out it as following.
>
> ```bash
> # Swap a usb extern (3.7 GB):
> #/dev/sdb1 none swap sw 0 0
>```
>
> or,
>
> - Disable swap from command line
>
> ```bash
> free -m
> sudo swapoff -a && sudo sed -i '/ swap / s/^/#/' /etc/fstab
> ```
>

- Hostname change of the nodes, so we can discern the roles of each nodes. For example, you can name the nodes (instances) like `kube20-master, kube20-worker-1`

```bash
sudo hostnamectl set-hostname <node-name-master-or-worker>
bash
```

- Install helper packages for Kubernetes.

```bash
sudo apt-get update && sudo apt-get install -y apt-transport-https gnupg2

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
```

- Update app repository and install Kubernetes packages and Docker.

```bash
sudo apt-get update

sudo apt-get install -y kubectl kubeadm kubelet kubernetes-cni docker.io
```

- Start and enable Docker service.

```bash
sudo systemctl start docker
sudo systemctl enable docker
```

- Start and enable `kubelet` service.

```bash
sudo systemctl start kubelet
sudo systemctl enable kubelet
```

- Add the current user to the `Docker group`, so that the `Docker commands` can be run without `sudo`.

```bash
sudo usermod -aG docker $USER
newgrp docker
```

- As a requirement, update the `iptables` of Linux Nodes to enable them to see bridged traffic correctly. Thus, you should ensure `net.bridge.bridge-nf-call-iptables` is set to `1` in your `sysctl` config and activate `iptables` immediately.

```bash
cat << EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system
```


## Part 2 - Setting Up Master Node for Kubernetes

- Following commands should executed on Master Node only.

- Pull the packages for Kubernetes beforehand

```bash
sudo kubeadm config images pull
```

- Let `kubeadm` prepare the environment for you. Note: Do not forget to change `<ec2-private-ip>` with your master node private IP.

```bash
sudo kubeadm init --apiserver-advertise-address=<ec2-private-ip> --pod-network-cidr=172.16.0.0/16
```

> :warning: **Note**: If you are working on `t2.micro` or `t2.small` instances,  use the command with `--ignore-preflight-errors=NumCPU` as shown below to ignore the errors.

>```bash
>sudo kubeadm init --apiserver-advertise-address=<ec2 private ip> --pod-network-cidr=172.16.0.0/16 --ignore-preflight-errors=NumCPU
>```

> **Note**: There are a bunch of pod network providers and some of them use pre-defined `--pod-network-cidr` block. Check the documentation at the References part. We will use Calico for pod network. Calico can use any `--pod-network-cidr` block.

- In case of problems, use following command to reset the initialization and restart from Part 2 (Setting Up Master Node for Kubernetes).

```bash
sudo kubeadm reset
```

- After successful initialization, you should see something similar to the following output (shortened version).

```bash
...
Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

  kubeadm join 172.31.3.109:6443 --token 1aiej0.kf0t4on7c7bm2hpa \
      --discovery-token-ca-cert-hash sha256:0e2abfb56733665c0e6204217fef34be2a4f3c4b8d1ea44dff85666ddf722c02
```

> Note to the Instructor: Note down the `kubeadm join ...` part in order to connect your worker nodes to the master node. Remember to run this command with `sudo`.

- Run following commands to set up local `kubeconfig` on master node.

```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

- Activate the `Calico` pod networking and explain briefly the about network add-ons on `https://kubernetes.io/docs/concepts/cluster-administration/addons/`.

```bash
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
```

- Master node (also named as Control Plane) should be ready, show existing pods created by user. Since we haven't created any pods, list should be empty.

```bash
kubectl get nodes
```

- Show the list of the pods created for Kubernetes service itself. Note that pods of Kubernetes service are running on the master node.

```bash
kubectl get pods -n kube-system
```

- Show the details of pods in `kube-system` namespace. Note that pods of Kubernetes service are running on the master node.

```bash
kubectl get pods -n kube-system -o wide
```

- Get the services available. Since we haven't created any services yet, we should see only Kubernetes service.

```bash
kubectl get services
```

- Show the list of the Docker images running on the Master node to enable Kubernetes service.

```bash
docker container ls
```

## Part 3 - Adding the Slave/Worker Nodes to the Cluster

- Show the list of nodes. Since we haven't added worker nodes to the cluster, we should see only master node itself on the list.

```bash
kubectl get nodes
```

- Run `docker container ls` on the worker nodes command to list the Docker images running on the worker nodes. We should see an empty list.

- Log into worker nodes and run `sudo kubeadm join...` command to have them join the cluster.

```bash
sudo kubeadm join 172.31.3.109:6443 --token 1aiej0.kf0t4on7c7bm2hpa \
    --discovery-token-ca-cert-hash sha256:0e2abfb56733665c0e6204217fef34be2a4f3c4b8d1ea44dff85666ddf722c02
```

- Get the list of nodes. Now, we should see the new worker nodes in the list.

```bash
kubectl get nodes
```

- Get the details of the nodes.

```bash
kubectl get nodes -o wide
```

## Part 4 - Deploying a Simple Nginx Server on Kubernetes

- Check the readiness of nodes at the cluster on master node.

```bash
kubectl get nodes
```

- Show the list of existing pods in default namespace on master. Since we haven't created any pods, list should be empty.

```bash
kubectl get pods
```

- Get the details of pods in all namespaces on master. Note that pods of Kubernetes service are running on the master node and also additional pods are running on the worker nodes to provide communication and management for Kubernetes service.

```bash
kubectl get pods -o wide --all-namespaces
```

- Create and run a simple `Nginx` Server image in a pod on master.

```bash
kubectl run nginx-server --image=nginx  --port=80
```

- Get the list of pods in default namespace on master and check the status and readyness of `nginx-server`

```bash
kubectl get pods -o wide
```

- Expose the nginx-server pod as a new Kubernetes service on master.

```bash
kubectl expose pod nginx-server --port=80 --type=NodePort
```

- Get the list of services and show the newly created service of `nginx-server`

```bash
kubectl get service -o wide
```

- You will get an output like this.

```text
kubernetes     ClusterIP   10.96.0.1       <none>        443/TCP        13m    <none>
nginx-server   NodePort    10.110.144.60   <none>        80:32276/TCP   113s   run=nginx-server
```

- Open a browser and check the `public ip:<NodePort>` of worker node to see Nginx Server is running. In this example, NodePort is 32276.

- Clean the service and pod from the cluster.

```bash
kubectl delete svc nginx-server
kubectl delete pods nginx-server
```

- Check there is no pod left in default namespace.

```bash
kubectl get pods
```

- To delete a worker/slave node from the cluster, follow the below steps.

  - Drain and delete worker node on the master.

  ```bash
  kubectl get nodes
  kubectl drain kube20-worker-1 --ignore-daemonsets --delete-local-data
  kubectl cordon kube20-worker-1
  kubectl delete node kube20-worker-1
  ```

  - Remove and reset settings on the worker node.

  ```bash
  sudo kubeadm reset
  ```
  
> Note: If you try to have worker rejoin cluster, it might be necessary to clean `kubelet.conf` and `ca.crt` files and free the port `10250`, before rejoining.
>
> ```bash
>  sudo rm /etc/kubernetes/kubelet.conf
>  sudo rm /etc/kubernetes/pki/ca.crt
>  sudo netstat -lnp | grep 1025
>  sudo kill <process-id>
>  ```

## Part 5 - Adding master or worker node
```shell
kubeadm token create --help | less
```
To create a new certificate key you must use `kubeadm init phase upload-certs --upload-certs`

```shell
sudo kubeadm init phase upload-certs --upload-certs

W0930 13:31:46.569841    7809 configset.go:348] WARNING: kubeadm cannot validate component configs for API groups [kubelet.config.k8s.io kubeproxy.config.k8s.io]
[upload-certs] Storing the certificates in Secret "kubeadm-certs" in the "kube-system" Namespace
[upload-certs] Using certificate key:
64d2cd309721253168568aacd418eb5c4d0c1d09a1fe6a8906fb929a6e1ebec6
```

- To create a bootstrap token use the `kubeadm token create` command. When used together with `--print-join-command`, print the full `kubeadm join` flag needed to join the cluster as a control-plane.

```shell
sudo kubeadm token create  --certificate-key 64d2cd309721253168568aacd418eb5c4d0c1d09a1fe6a8906fb929a6e1ebec6 --print-join-command

W0930 13:37:01.510930   13146 configset.go:348] WARNING: kubeadm cannot validate component configs for API groups [kubelet.config.k8s.io kubeproxy.config.k8s.io]
kubeadm join 192.20.10.150:6443 --token tc1gh1.t216ykzitqu2f9bc     --discovery-token-ca-cert-hash sha256:ecb9724ae3e69fbfc65a8350184b3a2dbfce891e172029df6a282068fa9db90b     --control-plane --certificate-key 64d2cd309721253168568aacd418eb5c4d0c1d09a1fe6a8906fb929a6e1ebec6 
```
> Not: Token-key valid for only a few hours.

## For join as worker node
```shell
sudo kubeadm join 192.20.10.150:6443 --token tc1gh1.t216ykzitqu2f9bc     --discovery-token-ca-cert-hash sha256:ecb9724ae3e69fbfc65a8350184b3a2dbfce891e172029df6a282068fa9db90b 
```

## For join as master node
```shell
sudo kubeadm join 192.20.10.150:6443 --token tc1gh1.t216ykzitqu2f9bc     --discovery-token-ca-cert-hash sha256:ecb9724ae3e69fbfc65a8350184b3a2dbfce891e172029df6a282068fa9db90b     --control-plane --certificate-key 64d2cd309721253168568aacd418eb5c4d0c1d09a1fe6a8906fb929a6e1ebec6 --apiserver-advertise-address <new master ip>
```


# References

- https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

- https://kubernetes.io/docs/concepts/cluster-administration/addons/

- https://kubernetes.io/docs/reference/

- https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#-strong-getting-started-strong-
