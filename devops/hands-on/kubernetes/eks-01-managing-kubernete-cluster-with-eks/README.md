# Hands-on EKS-01 : Creating and Managing Kubernetes Cluster with AWS EKS

Purpose of the this hands-on training is to give students the knowledge of how to use AWS Elastic Kubernetes Service


## Learning Outcomes

At the end of the this hands-on training, students will be able to;

- Learn to Create and Manage EKS Cluster with Worker Nodes

## Outline

- Part 1 - Creating the Kubernetes Cluster on EKS

- Part 2 - Creating a kubeconfig file

- Part 3 - Adding Worker Nodes to the Cluster

- Part 4 - Configuring Cluster Autoscaler

- Part 5 - Deploying a Sample Application

## Prerequisites

1. AWS CLI with Configured Credentials

    <i>Short recap about </i> ***```aws configure```*** <i>command could be made,</i> ```.aws``` <i>directory and its contents might be shown to the students.</i>

2. kubectl installed

if not;

- AWS CLI installation
  
```text
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```
- `kubectl` installation
  
```text
curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.18.9/2020-11-02/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && mv ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bash_profile
kubectl version --short --client
```

- aws configuration

```text
$ aws configure
  AWS Access Key ID [None]: AKIAIOSFODNN7EXAMPLE
  AWS Secret Access Key [None]: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
  Default region name [None]: us-east-1
  Default output format [None]: json
```

- Verify that you can see your cluster listed, when authenticated

```text
$ aws eks list-clusters
{
  "clusters": [
    "my-cluster"
  ]
}
```

## Part 1 - Creating the Kubernetes Cluster on EKS

1. Direct the students to AWS EKS Service webpage. 

2. Give general description about the page and *****the pricing***** of the services.

3. Select ```Cluster``` on the left-hand menu and click on "Create cluster" button. You will be directed to the ```Configure cluster``` page:

    - Give general descriptions about the page and the steps of creating the cluster.

    - Fill the ```Name``` and ```Kubernetes version``` fields. (Ex: MyCluster, 1.17)

        <i>Mention the durations for minor version support and the approximate release frequency.</i>

    - On the ```Cluster Service Role``` field; give general description about why we need this role. 

    - Create EKS Cluster Role with ```EKS - Cluster``` use case and ```AmazonEKSClusterPolicy```.
                
        - EKS Cluster Role :                                                                                              
           - use case   :  ```EKS - Cluster``` 
           - permissions: ```AmazonEKSClusterPolicy```.

    - Select the recently created role, back on the ```Cluster Service Role``` field.

    - Proceed to the ```Secrets Encryption``` field. 
    
    - Activate the field, give general description about ```KMS Service``` and describe where we use those keys and give an example about a possible key.

    - Deactivate back the ```Secrets Encryption``` field and keep it as is.

    - Proceed to the next step (Specify Networking).

4. On the ```Specify Networking``` page's ```Networking field```:

    - Select the default VPC and 2 public subnets.

        <i>Explain the necessity of using dedicated VPC for the cluster.</i>

    - Select default VPC security or create one with SSH connection. 

        <i>Explain the necessity of using dedicated Securitygroup for the cluster.</i>

    - Proceed to ```Cluster Endpoint Access``` field.

    - Give general description about the options on the field.

    - Explain ```Advanced Settings```.

    - Select ```Public``` option on the field.

    - Proceed to the next step (Configure Logging).

5. On the ```Configure Logging``` page:

    - Give general descriptions about the logging options.

    - Proceed to the final step (Review and create).

6. On the ```Review and create``` page:

    - Create the cluster.


## Part 2 - Creating a kubeconfig file

1. Give general descriptions about what ```config file``` is.

2. Run the command ```aws sts get-caller-identity``` on your terminal to show the current caller identity.

3. Show the content of the $HOME directory including hidden files and folders. If there is a ```.kube``` directory, show what it has inside.  

4. Run the command
```bash
aws eks --region <us-west-2> update-kubeconfig --name <cluster_name>
``` 

5. Explain what the above command does.

6. Then run the command on your terminal
```bash
kubectl get svc
```
You should see the output below
```bash
NAME             TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
svc/kubernetes   ClusterIP   10.100.0.1   <none>        443/TCP   1m
```
7. Run the command below to show that there is no node for now.
```bash
kubectl get node
```

7. Show again the content of the $HOME directory including hidden files and folders. Find the ```config``` file inside ```.kube``` directory. Then show the content of the file.


## Part 3 - Adding Worker Nodes to the Cluster

1. Get to the cluster page that is recently created.

2. Wait until seeing the ```ACTIVE``` status for the cluster.

```bash
$ aws eks describe-cluster --name <cluster-name> --query cluster.status
  "ACTIVE"
```

3. On the cluster page, click on ```Compute``` tab and ```Add Node Group``` button.

4. On the ```Configure node group``` page:

    - Give a unique name for the managed node group.

    - For the node's IAM Role, get to IAM console and create a new role with ```EC2 - Common``` use case having the policies of ```AmazonEKSWorkerNodePolicy, AmazonEC2ContainerRegistryReadOnly, AmazonEKS_CNI_Policy```.
    
        - ```Use case:    EC2 ```
        - ```Policies: AmazonEKSWorkerNodePolicy, AmazonEC2ContainerRegistryReadOnly, AmazonEKS_CNI_Policy```
    
        <i>Give a short description about why we need these policies.</i>
        <i>Explain the necessity of using dedicated IAM Role.</i>

    -  Proceed to the next page.

5. On the ```Set compute and scaling configuration``` page:
 
    - Choose the appropriate AMI type for Non-GPU instances. (Amazon Linux 2 (AL2_x86_64))

    - Choose ```t3.medium``` as the instance type.

        <i>Explain why we can't use</i> ```t2.micro```.
    - Choose appropriate options for other fields. (2 nodes are enough for maximum, minimum and desired sizes.)

    - Proceed to the next step.

6. On the ```Specify networking``` page:

    - Choose the subnets to launch your nodes.
    
    - Allow remote access to your nodes.
    <i>Mention that if we don't allow remote access, it's not possible to enable it after the node group is created.</i>
    
    - Select your SSH Key to for the connection to your nodes.
    
    - You can also limit the IPs for the connection.

    - Proceed to the next step. Review and create the ```Node Group```.

7. Run the command below on your local.
```bash
kubectl get nodes --watch
```

8. Show the EC2 instances newly created.


## Part 4 - Configuring Cluster Autoscaler

1. Explain what ```Cluster Autoscaler``` is and why we need it.

2. Create a policy with following content. You can name it as ClusterAutoscalerPolicy. 
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeAutoScalingInstances",
                "autoscaling:DescribeLaunchConfigurations",
                "autoscaling:DescribeTags",
                "autoscaling:SetDesiredCapacity",
                "autoscaling:TerminateInstanceInAutoScalingGroup",
                "ec2:DescribeLaunchTemplateVersions"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
}
```

3. Attach this policy to the IAM Worker Node Role which is already in use.

4. Deploy the ```Cluster Autoscaler``` with the following command.
```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/autoscaler/master/cluster-autoscaler/cloudprovider/aws/examples/cluster-autoscaler-autodiscover.yaml
```

5. Add an annotation to the deployment with the following command.
```bash
kubectl -n kube-system annotate deployment.apps/cluster-autoscaler cluster-autoscaler.kubernetes.io/safe-to-evict="false"
```

6. Edit the Cluster Autoscaler deployment with the following command.
```bash
kubectl -n kube-system edit deployment.apps/cluster-autoscaler
```
This command will open the yaml file for your editting. Replace <CLUSTER NAME> value with your own cluster name, and add the following command option ```--skip-nodes-with-system-pods=false``` to the command section under ```containers``` under ```spec```. Save and exit the file by pressing ```:wq```. The changes will be applied.

7. Find an appropriate version of your cluster autoscaler in the [link](https://github.com/kubernetes/autoscaler/releases). The version number should start with version number of the cluster Kubernetes version. For example, if you have selected the Kubernetes version 1.17, you should find something like ```1.17.x```.

8. Then, in the following command, set the Cluster Autoscaler image tag as that version you have found in the previous step.
```bash
kubectl -n kube-system set image deployment.apps/cluster-autoscaler cluster-autoscaler=us.gcr.io/k8s-artifacts-prod/autoscaling/cluster-autoscaler:<YOUR-VERSION-HERE>
```
You can also replace ```us``` with ```asia``` or ```eu```.


## Part 5 - Deploying a Sample Application

1. Create a Kubernetes namespace on your terminal with following command.
```bash
kubectl create namespace my-namespace
```

2. Create a .yml file in your local environment with the following content.
```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
  namespace: my-namespace
  labels:
    app: my-app
spec:
  type: LoadBalancer
  selector:
    app: my-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-deployment
  namespace: my-namespace
  labels:
    app: my-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: nginx
        image: nginx:1.19.2
        ports:
        - containerPort: 80
```

3. Deploy the application with following command.
```bash
kubectl apply -f <your-sample-app>.yaml
```

4. Run the command below.
```bash
kubectl get svc
```

5. Get the ```External IP``` value from the previous command's output and visit that ip.
