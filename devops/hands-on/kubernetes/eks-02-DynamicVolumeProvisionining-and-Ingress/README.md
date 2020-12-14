# Hands-on EKS-02 : Dynamic Volume Provisioning and Ingress

Purpose of the this hands-on training is to give students the knowledge of  Dynamic Volume Provisionining and Ingress.

## Learning Outcomes

At the end of the this hands-on training, students will be able to;

- Learn to Create and Manage EKS Cluster with eksctl.

- Explain the need for persistent data management

- Learn PersistentVolumes and PersistentVolumeClaims

- Understand the Ingress and Ingress Controller Usage

## Outline

- Part 1 - Installing kubectl and eksctl on Amazon Linux 2

- Part 2 - Creating the Kubernetes Cluster on EKS

- Part 3 - Dynamic Volume Provisionining

- Part 4 - Ingress

## Prerequisites

1. AWS CLI with Configured Credentials

2. kubectl installed

3. eksctl installed

For information on installing or upgrading eksctl, see [Installing or upgrading eksctl.](https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html#installing-eksctl)

## Part 1 - Installing kubectl and eksctl on Amazon Linux 2

### Install kubectl

- Launch an AWS EC2 instance of Amazon Linux 2 AMI with security group allowing SSH.

- Connect to the instance with SSH.

- Update the installed packages and package cache on your instance.

```bash
$ sudo yum update -y
```

- Download the Amazon EKS vended kubectl binary.

```bash
$ curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.17.9/2020-08-04/bin/linux/amd64/kubectl
```

- Apply execute permissions to the binary.

```bash
$ chmod +x ./kubectl
```

- Move kubectl to a folder that is in your path.

```bash
$ sudo mv ./kubectl /usr/local/bin
```

- After you install kubectl , you can verify its version with the following command:

```bash
$ kubectl version --short --client
```

### Install eksctl

- Download and extract the latest release of eksctl with the following command.

```bash
$ curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
```

- Move the extracted binary to /usr/local/bin.

```bash
$ sudo mv /tmp/eksctl /usr/local/bin
```

- Test that your installation was successful with the following command.

```bash
$ eksctl version
```

## Part 2 - Creating the Kubernetes Cluster on EKS

- If needed create ssh-key with commnad `ssh-keygen -f ~/.ssh/id_rsa`

- Configure AWS credentials.

```bash
$ aws configure
```

- Create an EKS cluster via `eksctl`. It will take a while.

```bash
$ eksctl create cluster --region us-east-1 --node-type t2.medium --nodes 1 --nodes-min 1 --nodes-max 2 --node-volume-size 8 --name mycluster
```

- Explain the default values and pay attention that default value for node-type is m5.large.

```bash
$ eksctl create cluster --help
```

- Show the aws `eks service` on aws management console and explain `eksctl-mycluster-cluster` stack on `cloudformation service`.

## Part 3 - Dynamic Volume Provisionining

- Create a StorageClass with the following settings.

```bash
$ cat storage-class.yaml
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: aws-standard
  annotations:
    storageclass.kubernetes.io/is-default-class: "true"
provisioner: kubernetes.io/aws-ebs
parameters:
  type: gp2
  fsType: ext4           
```

- Pay attention to that storage-zone and kubernetes node must be in the same zone. If neither zone nor zones is specified, volumes are generally round-robin-ed across all active zones where Kubernetes cluster has a node.

```bash
$ kubectl apply -f storage-class.yaml
storageclass.storage.k8s.io/aws-standard created
```

- Explain the default storageclass

```bash
$ kubectl get storageclass
NAME                     PROVISIONER             RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
aws-standard (default)   kubernetes.io/aws-ebs   Delete          Immediate              false                  37s
gp2 (default)            kubernetes.io/aws-ebs   Delete          WaitForFirstConsumer   false                  112m
```

- Create a persistentvolumeclaim with the following settings and show that new volume is created on aws management console.

```bash
$ cat clarus-pv-claim.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: clarus-pv-claim
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 3Gi
  storageClassName: aws-standard
```

```bash
$ kubectl apply -f clarus-pv-claim.yaml
persistentvolumeclaim/clarus-pv-claim created
```

- List the pv and pvc and explain the connections.

```bash
$ kubectl get pv
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                     STORAGECLASS   REASON   AGE
pvc-1cd62230-2c0f-4678-b743-837291dcd61c   3Gi        RWO            Delete           Bound    default/clarus-pv-claim   aws-standard            12s
$ kubectl get pvc
NAME              STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
clarus-pv-claim   Bound    pvc-1cd62230-2c0f-4678-b743-837291dcd61c   3Gi        RWO            aws-standard   2m19s
```

- Create a pod with the following settings.

```bash
$ cat dynamic-storage-aws.yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-aws
  labels:
    app : web-nginx
spec:
  containers:
  - image: nginx:latest
    ports:
    - containerPort: 80
    name: test-aws
    volumeMounts:
    - mountPath: /usr/share/nginx/html
      name: aws-pd
  volumes:
  - name: aws-pd
    persistentVolumeClaim:
      claimName: clarus-pv-claim
```

```bash
$ kubectl apply -f dynamic-storage-aws.yaml
pod/test-aws created
```

- Enter the pod and see that ebs is mounted to  /usr/share/nginx/html path.

```bash
$ kubectl exec -it test-aws -- bash
root@test-aws:/# df -kh
Filesystem      Size  Used Avail Use% Mounted on
overlay          80G  3.5G   77G   5% /
tmpfs            64M     0   64M   0% /dev
tmpfs           2.0G     0  2.0G   0% /sys/fs/cgroup
/dev/xvda1       80G  3.5G   77G   5% /etc/hosts
shm              64M     0   64M   0% /dev/shm
/dev/xvdcj      2.9G  9.1M  2.9G   1% /usr/share/nginx/html
tmpfs           2.0G   12K  2.0G   1% /run/secrets/kubernetes.io/serviceaccount
tmpfs           2.0G     0  2.0G   0% /proc/acpi
tmpfs           2.0G     0  2.0G   0% /proc/scsi
tmpfs           2.0G     0  2.0G   0% /sys/firmware
root@test-aws:/#
```

- Delete the storageclass that we create.

```bash
$ kubectl get storageclass
NAME                     PROVISIONER             RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
aws-standard (default)   kubernetes.io/aws-ebs   Delete          Immediate              false                  21m
gp2 (default)            kubernetes.io/aws-ebs   Delete          WaitForFirstConsumer   false                  46m
$ kubectl delete storageclass gp2
storageclass.storage.k8s.io "gp2" deleted
$ kubectl get storageclass
NAME                     PROVISIONER             RECLAIMPOLICY   VOLUMEBINDINGMODE   ALLOWVOLUMEEXPANSION   AGE
aws-standard (default)   kubernetes.io/aws-ebs   Delete          Immediate           false                  22m
```

- Delete the pod

```bash
$ kubectl delete -f dynamic-storage-aws.yaml 
```

## Part 4 - Ingress

> - Download the lesson folder from "https://github.com/clarusway/clarusway-aws-devops-1-20/tree/master/aws/hands-on/eks-02-DynamicVolumeProvisionining-and-Ingress".

```bash
$ mkdir ingress
$ cd ingress/
$ TOKEN="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
$ FOLDER="https://$TOKEN@raw.githubusercontent.com/clarusway/clarusway-aws-devops-4-20/master/devops/hands-on/kubernetes/eks-02-DynamicVolumeProvisionining-and-Ingress/"
$ curl -s --create-dirs -o "$HOME/ingress/ingress.tar.gz" -L "$FOLDER"ingress-yaml-files.tar.gz
$ tar -xvf ingress.tar.gz
```

The directory structure is as follows:
```text
ingress-yaml-files
├── ingress-service.yaml
├── php-apache
│   └── php-apache.yaml
└── to-do
    ├── db-deployment.yaml
    ├── db-pvc.yaml
    ├── db-service.yaml
    ├── web-deployment.yaml
    └── web-service.yaml
```

### Steps of execution:

1. We will deploy the `to-do` app first and look at some key points.
2. And then deploy the `php-apache` app and highligts some important points.
3. We will introduce the `ingress-service` and talk about it.

Let's check the state of the cluster and see that evertyhing works fine.

```bash
$ kubectl cluster-info
$ kubectl get node
```

- Go to the `volume-and-ingress-yaml-files/to-do` directory and look at the contents.

Let's check the MongoDB `service`.

```bash
$ cat db-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: db-service
  labels:
    name: mongo
    app: todoapp
spec:
  selector:
    name: mongo
  type: ClusterIP
  ports:
    - name: db
      port: 27017
      targetPort: 27017
```

Note that a database has no direct exposure the outside world, so it's type is `ClusterIP`.

Now check the content of the front-end web application `service`.

```bash
$ cat web-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: web-service
  labels:
    name: web
    app: todoapp
spec:
  selector:
    name: web 
  type: LoadBalancer
  ports:
   - name: http
     port: 3000
     targetPort: 3000
     protocol: TCP
```
What should be the type of the service? ClusterIP, NodePort or LoadBalancer?

Check the web application `Deployment` file.
```bash
$ cat web-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      name: web
  template:
    metadata:
      labels:
        name: web
        app: todoapp
    spec:
      containers: 
        - image: clarusways/todo
          imagePullPolicy: Always
          name: myweb
          ports: 
            - containerPort: 3000
          env:
            - name: "DBHOST"
              value: "mongodb://db-service:27017"
          resources:
            limits:
              cpu: 100m
            requests:
              cpu: 80m			  
```
Note that this web app is connnected to MongoDB host/service via the `DBHOST` environment variable. What does `db-service:27017` mean here. How is the IP resolution handled?
When should we use `imagePullPolicy: Always`. Explain the `image` pull policy shortly. What does `replicas: 1` mean?

Let's deploy the to-do application.
```bash
$ cd ..
$ kubectl apply -f to-do
deployment.apps/db-deployment created
persistentvolumeclaim/database-persistent-volume-claim created
service/db-service created
deployment.apps/web-deployment created
service/web-service created
```
Note that we can use `directory` with `kubectl apply -f` command.

- Check the pods.
```bash
$ kubectl get pods
NAME                              READY   STATUS    RESTARTS   AGE
db-deployment-8597967796-q7x5s    1/1     Running   0          4m30s
web-deployment-658cc55dc8-2h2zc   1/1     Running   2          4m30s
```

- Check the services.
```bash
$ kubectl get svc
NAME                 TYPE           CLUSTER-IP       EXTERNAL-IP                                                               PORT(S)          AGE
db-service           ClusterIP      10.100.199.214   <none>                                                                    27017/TCP        22m
kubernetes           ClusterIP      10.100.0.1       <none>                                                                    443/TCP          120m
web-service          LoadBalancer   10.100.59.43     a2a513b28b46b4a20848f8303294e90f-1926642410.us-east-2.elb.amazonaws.com   3000:31860/TCP   22m
```
Note the `PORT(S)` difference between `db-service` and `web-service`. Why?

- We can visit a2a513b28b46b4a20848f8303294e90f-1926642410.us-east-2.elb.amazonaws.com:3000 and access the application.

or

```bash
curl a2a513b28b46b4a20848f8303294e90f-1926642410.us-east-2.elb.amazonaws.com:3000 
OK!
```
We see the home page. You can add to-do's.

- Now deploy the second aplication

```bash
$ cd php-apache/
$ cat php-apache.yaml 
apiVersion: apps/v1
kind: Deployment
metadata:
  name: php-apache
spec:
  selector:
    matchLabels:
      run: php-apache
  replicas: 1
  template:
    metadata:
      labels:
        run: php-apache
    spec:
      containers:
      - name: php-apache
        image: k8s.gcr.io/hpa-example
        ports:
        - containerPort: 80
        resources:
          limits:
            cpu: 100m
          requests:
            cpu: 80m
---
apiVersion: v1
kind: Service
metadata:
  name: php-apache-service
  labels:
    run: php-apache
spec:
  ports:
  - port: 80
  selector:
    run: php-apache 
  type: LoadBalancer	
```

Note how the `Deployment` and `Service` `yaml` files are merged in one file. 

- Deploy this `php-apache` file.

```bash
$ kubectl apply -f php-apache.yaml 
deployment.apps/php-apache created
service/php-apache-service created
```

- Get the pods.

```bash
$ kubectl get po
NAME                              READY   STATUS    RESTARTS   AGE
db-deployment-8597967796-q7x5s    1/1     Running   0          17m
php-apache-7869bd4fb-xsvnh        1/1     Running   0          24s
web-deployment-658cc55dc8-2h2zc   1/1     Running   2          17m
```

- Get the services.

```bash
$ kubectl get svc
NAME                 TYPE           CLUSTER-IP       EXTERNAL-IP                                                               PORT(S)          AGE
db-service           ClusterIP      10.100.199.214   <none>                                                                    27017/TCP        22m
kubernetes           ClusterIP      10.100.0.1       <none>                                                                    443/TCP          120m
php-apache-service   LoadBalancer   10.100.191.10    ac4c071f935d64c3cb535e87e50c8216-186981612.us-east-2.elb.amazonaws.com    80:31850/TCP     59m
web-service          LoadBalancer   10.100.59.43     a2a513b28b46b4a20848f8303294e90f-1926642410.us-east-2.elb.amazonaws.com   3000:31860/TCP   22m
```

Let's check what web app presents us.

- On opening browser (ac4c071f935d64c3cb535e87e50c8216-186981612.us-east-2.elb.amazonaws.com ) we see

```text
OK!
```

Alternatively, you can use;
```bash
curl ac4c071f935d64c3cb535e87e50c8216-186981612.us-east-2.elb.amazonaws.com 
OK!
```

## Ingress

Briefly explain ingress and ingress controller. For additional information a few portal can be visited like;

- https://kubernetes.io/docs/concepts/services-networking/ingress/
  
- https://banzaicloud.com/blog/k8s-ingress/
  
- Open the offical [ingress-nginx]( https://kubernetes.github.io/ingress-nginx/deploy/ ) explain the `ingress-controller` installation steps for different architecture.

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.35.0/deploy/static/provider/aws/deploy.yaml
```

- Now, check the contents of the `ingress-service`.

```bash
$ cat ingress-service.yaml

apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: ingress-service
  annotations:
    kubernetes.io/ingress.class: 'nginx'
    nginx.ingress.kubernetes.io/use-regex: 'true'
    nginx.ingress.kubernetes.io/rewrite-target: /$1
spec:
  rules:
    - http:
        paths:
          - path: /?(.*)
            backend:
              serviceName: web-service
              servicePort: 3000
          - path: /load/?(.*)
            backend:
              serviceName: php-apache-service
              servicePort: 80
```

- Explain the rules part.

```bash
$ kubectl apply -f ingress-service.yaml
ingress.networking.k8s.io/ingress-service created
```

```bash
$ kubectl get ingress
NAME              HOSTS   ADDRESS                                                                            PORTS   AGE
ingress-service   *       a26be57ce12e64883a5ad050025f2c5b-94ab4c4b033cf5fa.elb.eu-central-1.amazonaws.com   80      2m8s
```

On browser, type this  ( a26be57ce12e64883a5ad050025f2c5b-94ab4c4b033cf5fa.elb.eu-central-1.amazonaws.com ), you must see the to-do app web page. If you type `a26be57ce12e64883a5ad050025f2c5b-94ab4c4b033cf5fa.elb.eu-central-1.amazonaws.com/load`, then the apache-php page, "OK!". Notice that we don't use the exposed ports at the services.

- Lets add an host name to ingress-service.yaml. 

```bash
$ cat ingress-service.yaml

apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: ingress-service
  annotations:
    kubernetes.io/ingress.class: 'nginx'
    nginx.ingress.kubernetes.io/use-regex: 'true'
    nginx.ingress.kubernetes.io/rewrite-target: /$1
spec:
  rules:
  - host: todo.clarusway.us  # Note: Use your domain name instead of clarusway.us
    http:
      paths:
        - path: /?(.*)
          backend:
            serviceName: web-service
            servicePort: 3000
        - path: /load/?(.*)
          backend:
            serviceName: php-apache-service
            servicePort: 80
```

- Execute ingress-service.yaml again and list the ingress.

```bash
$ kubectl apply -f ingress-service.yaml 
ingress.networking.k8s.io/ingress-service configured

$ kubectl get ingress 
NAME              HOSTS                   ADDRESS                                                                            PORTS   AGE
ingress-service   todo.clarusway.us       a26be57ce12e64883a5ad050025f2c5b-94ab4c4b033cf5fa.elb.eu-central-1.amazonaws.com   80      2m8s
```

- Add `A record` in route53 to your hosted zone for connecting your ingress DNS name.

On browser, type this  (todo.clarusway.us), you must see the to-do app web page. If you type `todo.clarusway.us/load`, then the apache-php page, "OK!". Notice that we don't use the exposed ports at the services.

- Delete the cluster

```bash
$ eksctl get cluster
NAME            REGION
mycluster       us-east-2
$ eksctl delete cluster mycluster
```

- Do no forget to delete related ebs volumes.
