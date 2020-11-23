# Hands-on Ansible-06 : Using Roles
The purpose of this hands-on training is to give students knowledge of basic Ansible skills.

## Learning Outcomes

At the end of this hands-on training, students will be able to;

- Explain what is Ansible role
- Learn how to create, find and use a role.  

## Outline

- Part 1 - Install Ansible

- Part 2 - Using Ansible Roles 

- Part 3 - Using Ansible Roles from Ansible Galaxy



## Part 1 - Install Ansible


- Spin-up 3 Amazon Linux 2 instances and name them as:
    1. control node -->(SSH PORT 22)
    2. node1 ----> (SSH PORT 22, HTTP PORT 80)
    3. node2 ----> (SSH PORT 22, HTTP PORT 80)


- Connect to the control node via SSH and run the following commands.

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


- Run the command below to transfer your pem key to your Ansible Controller Node.

```bash
$ scp -i <PATH-TO-PEM-FILE> <PATH-TO-PEM-FILE> ec2-user@<CONTROLLER-NODE-IP>:/home/ec2-user
```


- Make a directory named ```working-with-roles``` under the home directory and cd into it.

```bash 
$ mkdir working-with-roles
$ cd working-with-roles
```

- Create a file named ```inventory.txt``` with the command below.

```bash
$ vi inventory.txt
```

- Paste the content below into the inventory.txt file.

- Along with the hands-on, public or private IPs can be used.

```txt
[servers]
db_server   ansible_host=<YOUR-DB-SERVER-IP>   ansible_user=ec2-user  ansible_ssh_private_key_file=~/<YOUR-PEM-FILE>
web_server  ansible_host=<YOUR-WEB-SERVER-IP>  ansible_user=ec2-user  ansible_ssh_private_key_file=~/<YOUR-PEM-FILE>
test_server  ansible_host=<YOUR-WEB-SERVER-IP>  ansible_user=ec2-user  ansible_ssh_private_key_file=~/<YOUR-PEM-FILE>
```
- Create file named ```ansible.cfg``` under the the ```working-with-roles``` directory.

```cfg
[defaults]
host_key_checking = False
inventory=inventory.txt
interpreter_python=auto_silent
```


- Create a file named ```ping-playbook.yml``` and paste the content below.

```bash
$ touch ping-playbook.yml
```

```yml
- name: ping them all
  hosts: all
  tasks:
    - name: pinging
      ping:
```

- Run the command below for pinging the servers.

```bash
$ ansible-playbook ping-playbook.yml
```

- Explain the output of the above command.



## Part 2 - Using Ansible Roles

- Install ngnix server and restart it with using Ansible roles.

ansible-galaxy init /home/ec2-user/ansible/roles/apache


cd /home/ec2-user/ansible/roles/apache
ll
sudo yum install tree
tree

- Create tasks/main.yml with the following.

vi tasks/main.yml

```yml
- name: installing apache
  yum:
    name: httpd
    state: latest

- name: index.html
  copy:
    content: "<h1>Hello Clarusway</h1>"
    dest: /var/www/html/index.html

- name: restart apache2
  service:
    name: httpd
    state: restarted
    enabled: yes
```

- Create a playbook named "role1.yml".

cd /home/ec2-user/working-with-roles/
vi role1.yml


---
- name: Install and Start apache
  hosts: _test_server
  become: yes
  roles:
    - apache
```


## Part 3 - Using Ansible Roles from Ansible Galaxy

- Go to Ansible Galaxy web site (www.galaxy.ansible.com)

- Click the Search option

- Write nginx

- Explane the difference beetween collections and roles

- Evaluate the results (stars, number of download, etc.)

- Go to command line and write:

```bash
$ ansible-galaxy search nginx
```

Stdout:
```
Found 1494 roles matching your search. Showing first 1000.

 Name                                                         Description
 ----                                                         -----------
 0x0i.prometheus                                              Prometheus - a multi-dimensional time-series data mon
 0x5a17ed.ansible_role_netbox                                 Installs and configures NetBox, a DCIM suite, in a pr
 1davidmichael.ansible-role-nginx                             Nginx installation for Linux, FreeBSD and OpenBSD.
 1it.sudo                                                     Ansible role for managing sudoers
 1mr.zabbix_host                                              configure host zabbix settings
 1nfinitum.php                                                PHP installation role.
 2goobers.jellyfin                                            Install Jellyfin on Debian.
 2kloc.trellis-monit                                          Install and configure Monit service in Trellis.
 ```


 - there are lots of. Lets filter them.

 ```bash
 $ ansible-galaxy search nginx --platform EL
```
"EL" for centos 

- Lets go more specific :

```bash
$ ansible-galaxy search nginx --platform EL | grep geerl

Stdout:
```
geerlingguy.nginx                                            Nginx installation for Linux, FreeBSD and OpenBSD.
geerlingguy.php                                              PHP for RedHat/CentOS/Fedora/Debian/Ubuntu.
geerlingguy.pimpmylog                                        Pimp my Log installation for Linux
geerlingguy.varnish                                          Varnish for Linux.

```
- Install it:

$ ansible-galaxy install geerlingguy.nginx

Stdout:
```
- downloading role 'nginx', owned by geerlingguy
- downloading role from https://github.com/geerlingguy/ansible-role-nginx/archive/2.8.0.tar.gz
- extracting geerlingguy.nginx to /home/ec2-user/.ansible/roles/geerlingguy.nginx
- geerlingguy.nginx (2.8.0) was installed successfully
```

- Inspect the role:

$ cd /home/ec2-user/.ansible/roles/geerlingguy.nginx

$ ls
defaults  handlers  LICENSE  meta  molecule  README.md  tasks  templates  vars

$ cd tasks
$ ls

main.yml             setup-Debian.yml   setup-OpenBSD.yml  setup-Ubuntu.yml
setup-Archlinux.yml  setup-FreeBSD.yml  setup-RedHat.yml   vhosts.yml

$ vi main.yml

```yml
--
# Variable setup.
- name: Include OS-specific variables.
  include_vars: "{{ ansible_os_family }}.yml"

- name: Define nginx_user.
  set_fact:
    nginx_user: "{{ __nginx_user }}"
  when: nginx_user is not defined

# Setup/install tasks.
- include_tasks: setup-RedHat.yml
  when: ansible_os_family == 'RedHat'

- include_tasks: setup-Ubuntu.yml
  when: ansible_distribution == 'Ubuntu'

- include_tasks: setup-Debian.yml
  when: ansible_os_family == 'Debian'

- include_tasks: setup-FreeBSD.yml
  when: ansible_os_family == 'FreeBSD'

- include_tasks: setup-OpenBSD.yml
  when: ansible_os_family == 'OpenBSD'

- include_tasks: setup-Archlinux.yml
  when: ansible_os_family == 'Archlinux'

# Vhost configuration.
- import_tasks: vhosts.yml

# Nginx setup.
- name: Copy nginx configuration in place.
  template:
    src: "{{ nginx_conf_template }}"
    dest: "{{ nginx_conf_file_path }}"
    owner: root
    group: "{{ root_group }}"
    mode: 0644
  notify:
    - reload nginx
```

- # use it in playbook:

- Create a playbook named "playbook-nginx.yml"

```yml
- name: use galaxy nginx role
  hosts: all
  user: ec2-user
  become: true
  vars:
    ansible_ssh_private_key_file: "/home/ec2-user/mykey.pem"

  roles:
    - role: geerlingguy.nginx
```

- Run the playbook.

$ ansible-playbook playbook-nginx.yml

- List the roles you have:

$ ansible-galaxy list

Stdout:
```
- geerlingguy.elasticsearch, 5.0.0
- geerlingguy.mysql, 3.3.0
```

- 
$ ansible-config dump | grep ROLE

Stdout:
```
DEFAULT_PRIVATE_ROLE_VARS(default) = False
DEFAULT_ROLES_PATH(default) = [u'/home/ercan/.ansible/roles', u'/usr/share/ansible/roles', u'/etc/ansible/roles']
GALAXY_ROLE_SKELETON(default) = None
GALAXY_ROLE_SKELETON_IGNORE(default) = ['^.git$', '^.*/.git_keep$']
```





