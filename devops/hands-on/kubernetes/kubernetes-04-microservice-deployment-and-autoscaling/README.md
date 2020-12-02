# Hands-on Kubernetes-04 : Deploying Microservices and Service Level Autoscaling

Purpose of the this hands-on training is to give students the knowledge of  Autoscaling and Microservices

## Learning Outcomes

At the end of the this hands-on training, students will be able to;

- Understand deployment and management of microservices

- Explain the Kubernetes Autoscaling

- Explain Horizontal Pod Autoscaler Business Logic

- Understand the Need for Metric Server

## Outline

- Part 1 - Setting up the Kubernetes Cluster

- Part 2 - Outline of the Hands-on Setup

- Part 3 - Microservices

- Part 4 - Autoscaling in Kubernetes

## Part 1 - Setting up the Kubernetes Cluster

- Launch a Kubernetes Cluster of Ubuntu 20.04 with two nodes (one master, one worker) using the [Cloudformation Template to Create Kubernetes Cluster](./cfn-template-to-create-k8s-cluster.yml). *Note: Once the master node up and running, worker node automatically joins the cluster.*

>*Note: If you have problem with kubernetes cluster, you can use this link for lesson.*
>https://www.katacoda.com/courses/kubernetes/playground

- Check if Kubernetes is running and nodes are ready.

```bash
kubectl cluster-info
kubectl get no
```

## Part 2 - Outline of the Hands-on Setup

In this study, we will present an application that contains 2 unrelated sub-application. 

- First one is simple web&database application to hold the to-do-lists. This sub-application uses MongoDB to store to-do lists created through the web application. For the front-end web application layer, Node.JS is used. Thus, this sub-aplication has 2 microservices.
  
- Second one is used to demonstrate Horizontal Pod Autoscaler fuctionality based on the php-apache image.

- Download the lesson folder from "https://github.com/clarusway/clarusway-aws-devops-4-20/tree/master/devops/hands-on/kubernetes/kubernetes-04-microservice-deployment-and-autoscaling".

```bash
$ mkdir microservices
$ cd microservices/
$ TOKEN="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
$ FOLDER="https://$TOKEN@raw.githubusercontent.com/clarusway/clarusway-aws-devops-4-20/master/devops/hands-on/kubernetes/kubernetes-04-microservice-deployment-and-autoscaling//"
$ curl -s --create-dirs -o "/home/ubuntu/microservices/microservices.tar.gz" -L "$FOLDER"microservices-yaml-files.tar.gz
$ tar -xvf microservices.tar.gz
```

- Alternatively, you can copy from local host to a remote host's directory.

```bash
$ scp -i <your-pem-file> -r cohort-4-20/clarusway-aws-devops-4-20/devops/hands-on/kubernetes/kubernetes-04-microservice-deployment-and-autoscaling/microservices-yaml-files ubuntu@<master-ip>:/home/ubuntu/microservices
```

The directory structure is as follows:
```text
hands-on
├── auto-scaling
│   ├── components.yaml
│   ├── hpa-php-apache.yaml
│   └── hpa-web.yaml
├── php-apache
│   └── php-apache.yaml
└── to-do
    ├── db-deployment.yaml
    ├── db-pv.yaml
    ├── db-pvc.yaml
    ├── db-service.yaml
    ├── web-deployment.yaml
    └── web-service.yaml
```

### Steps of execution:

1. We will deploy the `to-do` app first and look at some key points.
2. And then deploy the `php-apache` app and highligts some important points.
3. The Autoscaling in Kubernetes will be  demonstrated as a last step.

Let's check the state of the cluster and see that evertyhing works fine.

```bash
kubectl cluster-info
kubectl get no
```

## Part 3 - Microservices

Go to the `microservices-yaml-files/to-do` directory and look at the contents.

The MongoDB application will use a static volume provisioning with the help of persistent volume (PV) and persistent volume claim (PVC). <br>

Check the contents of the `db-pv.yaml` file.

```bash
$ cat db-pv.yaml

apiVersion: v1
kind: PersistentVolume
metadata:
  name: db-pv-vol
  labels:
    type: local
spec:
  storageClassName: manual
  capacity:
    storage: 5Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/home/ubuntu/pv-data"
```

Check the contents of the `db-pvc.yaml` file.

```bash
$ cat db-pvc.yaml

apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: database-persistent-volume-claim
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: manual
  resources:
    requests:
      storage: 1Gi

```

It will provision storage from `hostpath`.

Let's check the MongoDB deployment yaml file to see how the PVC is used. 

```bash
cat db-deployment.yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: db-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      name: mongo
  template:
    metadata:
      labels:
        name: mongo
        app: todoapp
    spec:
      containers:
      - image: mongo
        name: mongo
        ports:
        - containerPort: 27017
        volumeMounts:
          - name: mongo-storage
            mountPath: /data/db
      volumes:
        #- name: mongo-storage
        #  hostPath:
        #    path: /home/ubuntu/pv-data
        - name: mongo-storage
          persistentVolumeClaim:
            claimName: database-persistent-volume-claim
```
The commented part directly uses the local hostpath for storage. Students can try it on their own later.

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
  type: NodePort
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
persistentvolume/db-pv-vol created
persistentvolumeclaim/database-persistent-volume-claim created
service/db-service created
deployment.apps/web-deployment created
service/web-service created
```
Note that we can use `directory` with `kubectl apply -f` command.

Check the persistent-volume and persistent-volume-claim.

```bash
$ kubectl get pv
NAME        CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                                      STORAGECLASS   REASON   AGE
db-pv-vol   5Gi        RWO            Retain           Bound    default/database-persistent-volume-claim   manual                  23s

$ kubectl get pvc
NAME                               STATUS   VOLUME      CAPACITY   ACCESS MODES   STORAGECLASS   AGE
database-persistent-volume-claim   Bound    db-pv-vol   5Gi        RWO            manual         56s
```

Check the pods.
```bash
$ kubectl get pods
NAME                              READY   STATUS    RESTARTS   AGE
db-deployment-8597967796-q7x5s    1/1     Running   0          4m30s
web-deployment-658cc55dc8-2h2zc   1/1     Running   2          4m30s
```

Check the services.
```bash
$ kubectl get svc
NAME          TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
db-service    ClusterIP   10.105.0.75     <none>        27017/TCP        4m39s
kubernetes    ClusterIP   10.96.0.1       <none>        443/TCP          2d8h
web-service   NodePort    10.107.136.54   <none>        3000:30634/TCP   4m38s
```
Note the `PORT(S)` difference between `db-service` and `web-service`. Why?

- We can visit http://<public-node-ip>:<node-port> and access the application. Note: Do not forget to open the Port <node-port> in the security group of your node instance.

We see the home page. You can add to-do's.


Now deploy the second aplication

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
  type: NodePort	
```

Note how the `Deployment` and `Service` `yaml` files are merged in one file. 

Deploy this `php-apache` file.
```bash
$ kubectl apply -f php-apache.yaml 
deployment.apps/php-apache created
service/php-apache-service created
```

Get the pods.
```bash
$ kubectl get po
NAME                              READY   STATUS    RESTARTS   AGE
db-deployment-8597967796-q7x5s    1/1     Running   0          17m
php-apache-7869bd4fb-xsvnh        1/1     Running   0          24s
web-deployment-658cc55dc8-2h2zc   1/1     Running   2          17m
```

Get the services.
```bash
$ kubectl get svc
NAME                 TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
db-service           ClusterIP   10.105.0.75     <none>        27017/TCP        17m
kubernetes           ClusterIP   10.96.0.1       <none>        443/TCP          2d9h
php-apache-service   NodePort    10.101.242.84   <none>        80:32748/TCP     35s
web-service          NodePort    10.107.136.54   <none>        3000:30634/TCP   17m
```

Let's check what web app presents us.

- On opening browser (http://<public-node-ip>:<node-port>) we see

```text
OK!
```

Alternatively, you can use;
```text
curl <public-worker node-ip>:<node-port>
OK!
```

## Part 4 - Autoscaling in Kubernetes

### Benefits of Autoscaling
To understand better where autoscaling would provide the most value, let’s start with an example. Imagine you have a 24/7 production service with a load that is variable in time, where it is very busy during the day in the US, and relatively low at night. Ideally, we would want the number of nodes in the cluster and the number of pods in deployment to dynamically adjust to the load to meet end user demand. The new Cluster Autoscaling feature together with Horizontal Pod Autoscaler can handle this for you automatically.

### Run & expose php-apache server  

To demonstrate Horizontal Pod Autoscaler we will use a custom docker image based on the php-apache image. The Dockerfile has the following content:

```text
FROM php:5-apache
COPY index.php /var/www/html/index.php
RUN chmod a+rx index.php
```

It defines an `index.php` page which performs some CPU intensive computations:  
```text
<?php
  $x = 0.0001;
  for ($i = 0; $i <= 1000000; $i++) {
    $x += sqrt($x);
  }
  echo "OK!";
?> 
```

First, let's check the php-apache `Services` and `Pods` to see if they are still running.

Observe pods and services:
```bash
$ kubectl get po
NAME                              READY   STATUS    RESTARTS   AGE
db-deployment-8597967796-q7x5s    1/1     Running   0          96m
php-apache-7869bd4fb-xsvnh        1/1     Running   0          79m
web-deployment-658cc55dc8-2h2zc   1/1     Running   2          96m


$ kubectl get svc
NAME                 TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
db-service           ClusterIP   10.105.0.75     <none>        27017/TCP        96m
kubernetes           ClusterIP   10.96.0.1       <none>        443/TCP          2d10h
php-apache-service   NodePort    10.101.242.84   <none>        80:32748/TCP     79m
web-service          NodePort    10.107.136.54   <none>        3000:30634/TCP   96m
```

Add `watch` board to verify the latest status of Cluster by below Commands.(This is Optional as not impacting the Functionality of Cluster). Observe in a separate terminal.

```bash
$ kubectl get service,hpa,pod -o wide
$ watch -n1 !!
```

### Create Horizontal Pod Autoscaler   

Now that the server is running, we will create the autoscaler using kubectl autoscale. The following command will create a Horizontal Pod Autoscaler that maintains between 2 and 10 replicas of the Pods controlled by the php-apache deployment we created in the first step of these instructions. Roughly speaking, HPA will increase and decrease the number of replicas (via the deployment) to maintain an average CPU utilization across all Pods of 50% (since each pod requests 200 milli-cores by kubectl run), this means average CPU usage of 100 milli-cores). See [here]( https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/#algorithm-details ) for more details on the algorithm.

Now activate the  HPAs; 


```bash
kubectl autoscale deployment php-apache --cpu-percent=50 --min=2 --max=10 
kubectl autoscale deployment web-deployment --cpu-percent=50 --min=3 --max=5 
```
or

```bash
$ cat hpa-php-apache.yaml

apiVersion: autoscaling/v1
kind: HorizontalPodAutoscaler
metadata:
  name: php-apache
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: php-apache
  minReplicas: 2
  maxReplicas: 10
  targetCPUUtilizationPercentage: 50 
```

```bash
$ cat hpa-web.yaml

apiVersion: autoscaling/v1
kind: HorizontalPodAutoscaler
metadata:
  name: web
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: web-deployment
  minReplicas: 3
  maxReplicas: 5
  targetCPUUtilizationPercentage: 50 
```

```bash
$ kubectl apply -f hpa-php-apache.yaml
$ kubectl apply -f hpa-web.yaml
```

Let's look at the status:
```bash
$ watch -n3 kubectl get service,hpa,pod -o wide 

Every 3,0s: kubectl get service,hpa,pod -o wide                                                                       ubuntu: Sat Sep 12 17:48:18 2020

NAME                         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE     SELECTOR
service/db-service           ClusterIP   10.105.0.75     <none>        27017/TCP        105m    name=mongo
service/kubernetes           ClusterIP   10.96.0.1       <none>        443/TCP          2d10h   <none>
service/php-apache-service   NodePort    10.101.242.84   <none>        80:32748/TCP     88m     run=php-apache
service/web-service          NodePort    10.107.136.54   <none>        3000:30634/TCP   105m    name=web

NAME                                             REFERENCE                   TARGETS         MINPODS   MAXPODS   REPLICAS   AGE
horizontalpodautoscaler.autoscaling/php-apache   Deployment/php-apache       <unknown>/50%   2         10        2          81s
horizontalpodautoscaler.autoscaling/web          Deployment/web-deployment   <unknown>/50%   3         5         3          76s

NAME                                  READY   STATUS    RESTARTS   AGE    IP           NODE       NOMINATED NODE   READINESS GATES
pod/db-deployment-8597967796-q7x5s    1/1     Running   0          105m   172.18.0.5   minikube   <none>           <none>
pod/php-apache-7869bd4fb-fgkpf        1/1     Running   0          66s    172.18.0.7   minikube   <none>           <none>
pod/php-apache-7869bd4fb-xsvnh        1/1     Running   0          88m    172.18.0.6   minikube   <none>           <none>
pod/web-deployment-658cc55dc8-2h2zc   1/1     Running   2          105m   172.18.0.4   minikube   <none>           <none>
pod/web-deployment-658cc55dc8-88nxz   1/1     Running   0          61s    172.18.0.8   minikube   <none>           <none>
pod/web-deployment-658cc55dc8-c7hdl   1/1     Running   0          61s    172.18.0.9   minikube   <none>           <none>
```
- php-apache Pod number increased to 2, minimum number. 
- web-deployment Pod number increased to 3, minimum number. 
- The HPA line under TARGETS shows `<unknown>/50%`. The `unknown` means the HPA can't idendify the current use of CPU.


We may check the current status of autoscaler by running:  
```bash
$ kubectl get hpa
NAME         REFERENCE                   TARGETS         MINPODS   MAXPODS   REPLICAS   AGE
php-apache   Deployment/php-apache       <unknown>/50%   2         10        2          2m4s
web          Deployment/web-deployment   <unknown>/50%   3         5         3          117s
```

```bash
$ kubectl describe hpa
....
Reference:                                             Deployment/php-apache
Metrics:                                               ( current / target )
  resource cpu on pods  (as a percentage of request):  <unknown> / 50%
....
Conditions:
  Type           Status  Reason                   Message
  ----           ------  ------                   -------
  AbleToScale    True    SucceededGetScale        the HPA controller was able to get the target's current scale
  ScalingActive  False   FailedGetResourceMetric  the HPA was unable to compute the replica count: unable to get metrics for resource cpu: unable to fetch metrics from resource metrics API: the server could not find the requested resource (get pods.metrics.k8s.io)

.....
Reference:                                             Deployment/web-deployment
Metrics:                                               ( current / target )
  resource cpu on pods  (as a percentage of request):  <unknown> / 50%
....
Conditions:
  Type           Status  Reason                   Message
  ----           ------  ------                   -------
  AbleToScale    True    SucceededGetScale        the HPA controller was able to get the target's current scale
  ScalingActive  False   FailedGetResourceMetric  the HPA was unable to compute the replica count: unable to get metrics for resource cpu: unable to fetch metrics from resource metrics API: the server could not find the requested resource (get pods.metrics.k8s.io)
.....
```
The `metrics` can't be calculated. So, the `metrics server` should be uploaded to the cluster.

### Install Metric Server 

- First Delete the existing Metric Server if any.

```bash
$ kubectl delete -n kube-system deployments.apps metrics-server
```

- Get the Metric Server form [GitHub](https://github.com/kubernetes-sigs/metrics-server/releases/tag/v0.3.7).

```bash
$ wget https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.3.7/components.yaml
```


- Edit the file `components.yaml`. Add the following arguments to the `metrics-server`. (We have already done for this lesson) 

```text
          - --kubelet-insecure-tls
          - --kubelet-preferred-address-types=InternalIP,Hostname,InternalDNS,ExternalDNS,ExternalIP
```

You will select the `Deployment` part in the file.
```text
apiVersion: apps/v1
kind: Deployment
......
      containers:
      - name: metrics-server
        image: k8s.gcr.io/metrics-server/metrics-server:v0.3.7
        imagePullPolicy: IfNotPresent
        args:
          - --cert-dir=/tmp
          - --secure-port=4443
          - --kubelet-insecure-tls
          - --kubelet-preferred-address-types=InternalIP,Hostname,InternalDNS,ExternalDNS,ExternalIP	
        ports:
        - name: main-port
          containerPort: 4443 
......	
```

- Add `metrics-server` to your Kubernetes instance.

```bash
$ kubectl apply -f components.yaml
```
Wait 1-2 minute or so.

Verify the existace of `metrics-server` run by below command

```bash
$ kubectl -n kube-system get pods
```

Verify `metrics-server` can access resources of the pods and nodes.

```bash
$ kubectl top pods
NAME                              CPU(cores)   MEMORY(bytes)   
db-deployment-8597967796-8lwzr    6m           140Mi           
php-apache-7869bd4fb-4q6mz        1m           11Mi            
php-apache-7869bd4fb-wmhtl        1m           10Mi            
web-deployment-6d8d8c777b-2fr9h   1m           22Mi            
web-deployment-6d8d8c777b-z5xd2   1m           24Mi              
```

```bash         
$ kubectl top nodes
NAME     CPU(cores)   CPU%   MEMORY(bytes)   MEMORY%
master   188m         9%     1245Mi          32%
node1    108m         5%     1035Mi          27% 
```

```bash
$ kubectl get hpa
NAME         REFERENCE                   TARGETS   MINPODS   MAXPODS   REPLICAS   AGE
php-apache   Deployment/php-apache       1%/50%    2         10        2          26m
web          Deployment/web-deployment   2%/50%    3         5         3          15m
```
- Look at the the values under TARGETS. The values are changed from `<unknown>/50%` to `1%/50%` & `2%/50%`, means the HPA can now idendify the current use of CPU.

### Increase load
Now, we will see how the autoscaler reacts to increased load. We will start a container, and send an infinite loop of queries to the php-apache service (please run it in a different terminal): 

First look at the services.

```bash
$ kubectl get svc
NAME                 TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
db-service           ClusterIP      10.97.2.64      <none>        27017/TCP        23m
kubernetes           ClusterIP      10.96.0.1       <none>        443/TCP          18d
php-apache-service   LoadBalancer   10.102.71.34    <pending>     80:31138/TCP     18m
web-service          NodePort       10.96.115.134   <none>        3000:32040/TCP   23m
```

```bash
$ kubectl run -it --rm load-generator --image=busybox /bin/sh  

Hit enter for command prompt

while true; do wget -q -O- http://<puplic ip>:<port number of php-apache-service>; done 
```

Within a minute or so, we should see the higher CPU load by executing:

- Open new terminal and check the hpa.

```bash
$ kubectl get hpa 
```

On the watch board:
```bash
$ watch -n3 kubectl get service,hpa,pod -o wide

Every 3.0s: kubectl get service,hpa,pod -o wide                                                                     master: Thu Sep 17 11:27:18 2020

NAME                         TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE   SELECTOR
service/db-service           ClusterIP      10.97.2.64      <none>        27017/TCP        46m   name=mongo
service/kubernetes           ClusterIP      10.96.0.1       <none>        443/TCP          18d   <none>
service/php-apache-service   LoadBalancer   10.102.71.34    <pending>     80:31138/TCP     41m   run=php-apache
service/web-service          NodePort       10.96.115.134   <none>        3000:32040/TCP   46m   name=web

NAME                                             REFERENCE                   TARGETS   MINPODS   MAXPODS   REPLICAS   AGE
horizontalpodautoscaler.autoscaling/php-apache   Deployment/php-apache       40%/50%   2         10        2          35m
horizontalpodautoscaler.autoscaling/web          Deployment/web-deployment   0%/50%    3         5         3          34m

NAME                                  READY   STATUS        RESTARTS   AGE     IP               NODE    NOMINATED NODE   READINESS GATES
pod/db-deployment-8597967796-h952d    1/1     Running       0          46m     172.16.166.160   node1   <none>           <none>
pod/load-generator                    1/1     Running       0          2m18s   172.16.166.129   node1   <none>           <none>
pod/php-apache-7869bd4fb-bcxt4        1/1     Running       0          34m     172.16.166.163   node1   <none>           <none>
pod/php-apache-7869bd4fb-xc5d6        1/1     Running       0          41m     172.16.166.164   node1   <none>           <none>
pod/web-deployment-6d8d8c777b-hh2t4   1/1     Running       0          34m     172.16.166.157   node1   <none>           <none>
pod/web-deployment-6d8d8c777b-q9c4t   1/1     Running       0          34m     172.16.166.172   node1   <none>           <none>
pod/web-deployment-6d8d8c777b-tgkzc   1/1     Running       0          46m     172.16.166.159   node1   <none>           <none>
```

Now, let's introduce load for to-do web app with load-generator pod as follows (in a couple of terminals):
```bash
$ kubectl exec -it load-generator -- /bin/sh
/ # while true; do wget -q -O- http://<puplic ip>:<port number of web-service> > /dev/null; done
```

Watch table
```bash
$ watch -n3 kubectl get service,hpa,pod -o wide

Every 3.0s: kubectl get service,hpa,pod -o wide                                                                     master: Thu Sep 17 11:29:19 2020

NAME                         TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE   SELECTOR
service/db-service           ClusterIP      10.97.2.64      <none>        27017/TCP        48m   name=mongo
service/kubernetes           ClusterIP      10.96.0.1       <none>        443/TCP          18d   <none>
service/php-apache-service   LoadBalancer   10.102.71.34    <pending>     80:31138/TCP     43m   run=php-apache
service/web-service          NodePort       10.96.115.134   <none>        3000:32040/TCP   48m   name=web

NAME                                             REFERENCE                   TARGETS   MINPODS   MAXPODS   REPLICAS   AGE
horizontalpodautoscaler.autoscaling/php-apache   Deployment/php-apache       42%/50%   2         10        3          37m
horizontalpodautoscaler.autoscaling/web          Deployment/web-deployment   62%/50%   3         5         3          36m

NAME                                  READY   STATUS    RESTARTS   AGE     IP               NODE    NOMINATED NODE   READINESS GATES
pod/db-deployment-8597967796-h952d    1/1     Running   0          48m     172.16.166.160   node1   <none>           <none>
pod/load-generator                    1/1     Running   0          4m19s   172.16.166.129   node1   <none>           <none>
pod/php-apache-7869bd4fb-bcxt4        1/1     Running   0          36m     172.16.166.163   node1   <none>           <none>
pod/php-apache-7869bd4fb-r22p4        1/1     Running   0          69s     172.16.166.176   node1   <none>           <none>
pod/php-apache-7869bd4fb-xc5d6        1/1     Running   0          43m     172.16.166.164   node1   <none>           <none>
pod/web-deployment-6d8d8c777b-2nf9x   1/1     Running   0          8s      172.16.166.188   node1   <none>           <none>
pod/web-deployment-6d8d8c777b-hh2t4   1/1     Running   0          36m     172.16.166.157   node1   <none>           <none>
pod/web-deployment-6d8d8c777b-q9c4t   1/1     Running   0          36m     172.16.166.172   node1   <none>           <none>
pod/web-deployment-6d8d8c777b-tgkzc   1/1     Running   0          48m     172.16.166.159   node1   <none>           <none>
```

### Stop load
We will finish our example by stopping the user load.

In the terminal where we created the container with busybox image, terminate the load generation by typing `Ctrl` + `C`. Close the load introducing terminals grafecully and observe the behaviour at the watch board.

Then we will verify the result state (after a minute or so):
  
```bash
$ kubectl get hpa 
```
  
```bash
$ kubectl get deployment
```

# References: 
https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/

https://www.digitalocean.com/community/tutorials/webinar-series-deploying-and-scaling-microservices-in-kubernetes
