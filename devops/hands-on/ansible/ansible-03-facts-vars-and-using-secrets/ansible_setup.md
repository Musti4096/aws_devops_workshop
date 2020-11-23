# Hands-on Setup



## Part 1 - Build the Infrastructure

- Get to the AWS Console and spin-up 3 EC2 Instances with ```Red Hat Enterprise Linux 8``` AMI.

- Configure the security groups as shown below:

    - Controller Node ----> Port 22 SSH

    - Target Node1 -------> Port 22 SSH, Port 80 HTTP

    - Target Node2 -------> Port 22 SSH, Port 80 HTTP

## Part 2 - Install Ansible on the Controller Node

- Connect to your ```Controller Node```.

- Optionally you can connect to your instances using VS Code.

                    -------------------- OPTIONAL BELOW ----------------------

- You can also use connect to the Controller Node via VS Code's ```Remote SSH``` Extension. 

- Open up your VS Code editor. 

- Click on the ```Extensions``` icon. 

- Write down ```Remote - SSH``` on the search bar. 

- Click on the first option on the list.

- Click on the install button.

- When the extension is installed, restart your editor.

- Click on the green button (```Open a Remote Window``` button) at the most bottom left.

- Hit enter. (```Connect Current Window to Host...```)

- Enter a name for your connection on the input field and click on ```Add New SSH Host``` option.

- Enter your ssh connection command (```ssh -i <YOUR-PEM-FILE> ec2-user@<YOUR SERVER IP>```) on the input field and hit enter.

- Hit enter again.

- Click on the ```connect``` button at the bottom right.

- Click on ```continue``` option.

- Click on the ```Open Folder``` button and then click on the ```Ok``` button.

- Lastly, open up a new terminal on the current window.

                    -------------------- OPTIONAL ABOVE ----------------------


- Run the command below to transfer your pem key to your Ansible Controller Node.

```bash
$ scp -i <PATH-TO-PEM-FILE> <PATH-TO-PEM-FILE> ec2-user@<CONTROLLER-NODE-IP>:/home/ec2-user
```

- to pretend to be disconnected

```bash
$ echo 'ClientAliveInterval 60' | sudo tee --append /etc/ssh/sshd_config
$ sudo service sshd restart
```

- Run the commands below to install Python3 and Ansible. 

```bash
$ sudo yum install -y python3 
```

```bash
$ pip3 install --user ansible
```

- Check Ansible's installation with the command below.

```bash
$ ansible --version
```

## Part 3 - Pinging the Target Nodes


- Make a directory named ```Project``` under the home directory and cd into it.

```bash 
$ mkdir Project
$ cd Project
```

- Create a file named ```inventory.txt``` with the command below.

```bash
$ vi inventory.txt
```

- Paste the content below into the inventory.txt file.

- Along with the hands-on, public or private IPs can be used.

```txt
[webservers]
node1 ansible_host=<node1_ip> ansible_user=ec2-user

[ubuntuservers]
node2 ansible_host=<node2_ip> ansible_user=ubuntu

[all:vars]
ansible_ssh_private_key_file=/home/ec2-user/<pem file>
```


- ping the nodes 

```bash
$ ansible all -m ping -i inventory.txt
```

- Create another file named ```.ansible.cfg``` in the "project" directory.

```
[defaults]
host_key_checking = False
inventory=inventory.txt
interpreter_python=auto_silent

```
