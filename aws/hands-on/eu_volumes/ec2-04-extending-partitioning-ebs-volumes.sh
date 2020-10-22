
# Hands-on EC2-04 : Extending and Partitioning EBS Volumes

Purpose of the this hands-on training is to teach the students how to add or attach an EBS (Elastic Block Storage) volume on an AWS instance, how to extend and resize volumes, and how to create partitions in volumes on running Amazon Linux 2 EC2 instances.

## Learning Outcomes

At the end of the this hands-on training, students will be able to;

- understand what is the difference between root volume and EBS Volume.

- list volumes to show current status of primary (root) and additional volumes

- demonstrate their knowledge on how to create EBS volume.

- create mounting point on EC2 instances.

- partition volume on EC2 instances.

- resize the volume or partitions on the new EBS volumes.

- understand how to auto-mount EBS volumes and partitions after reboots.

## Outline

- Part 1 - Extend EBS Volume without Partitioning

- Part 2 - Extend EBS Volume with Partitioning

- Part 3 - Auto-mount EBS Volumes and Partitions on Reboot

![EBS Volumes](./ebs_backed_instance.png)

# PART 1 - EXTEND EBS VOLUME WITHOUT PARTITIONING

# launch an instance from aws console
# check volumes which volumes attached to instance. 
# only root volume should be listed
lsblk
# create a new volume in the same AZ with the instance from aws console (2 GB for this demo).
# attach the new volume from aws console, then list block storages again.
# root volume and secondary volume should be listed
lsblk
# check if the attached volume is already formatted or not and has data on it.
sudo file -s /dev/xvdf
# if not formatted, format the new volume
sudo mkfs -t ext4 /dev/xvdf
# check the format of the volume again after formatting
sudo file -s /dev/xvdf
# create a mounting point path for new volume
sudo mkdir /mnt/2nd-vol
# mount the new volume to the mounting point path
sudo mount /dev/xvdf /mnt/2nd-vol/
# check if the attached volume is mounted to the mounting point path
lsblk
# show the available space, on the mounting point path
df -h
# check if there is data on it or not.
ls -lh /mnt/2nd-vol/
# if there is no data on it, create a new file to show persistence in later steps
cd /mnt/2nd-vol
sudo touch guilewashere.txt
ls
# modify the new volume in aws console, and enlarge capacity to double gb (from 2GB to 4GB for this demo).
# check if the attached volume is showing the new capacity
lsblk
# show the real capacity used currently at mounting path, old capacity should be shown.
df -h
# resize the file system on the new volume to cover all available space.
sudo resize2fs /dev/xvdf
# show the real capacity used currently at mounting path, new capacity should reflect the modified volume size.
df -h
# show that the data still persists on the newly enlarged volume.
ls -lh /mnt/2nd-vol/
# show that mounting point path will be gone when instance rebooted 
sudo reboot now
# show the new volume is still attached, but not mounted
lsblk
# check if the attached volume is already formatted or not and has data on it.
sudo file -s /dev/xvdf
# mount the new volume to the mounting point path
sudo mount /dev/xvdf /mnt/2nd-vol/
# show the used and available capacity is same as the disk size.
lsblk
df -h
# if there is data on it, check if the data still persists.
ls -lh /mnt/2nd-vol/

# PART 2 - EXTEND EBS VOLUME WITH PARTITIONING

# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/recognize-expanded-volume-linux.html

# https://www.tecmint.com/fdisk-commands-to-manage-linux-disk-partitions/

# list volumes to show current status, primary (root) and secondary volumes should be listed
lsblk
# show the used and available capacities related with volumes
df -h
# create tertiary volume (2 GB for this demo) in the same AZ with the instance on aws console
# attach the new volume from aws console, then list volumes again.
#  primary (root), secondary and tertiary volumes should be listed
lsblk
# show the used and available capacities related with volumes
df -h
# show the current partitions... use "fdisk -l /dev/xvda" for specific partition
sudo fdisk -l
# check all available fdisk commands and using "m".
sudo fdisk /dev/xvdg
# n -> add new partition (with 1G size)
# p -> primary
# Partition number: 1
# First sector: default - use Enter to select default
# Last sector: 2100000
# n -> add new partition (with rest of the size-1G)
# p -> primary
# Partition number: 2
# First sector: default - use Enter to select default
# Last sector: default - use Enter to select default
# w -> write partition table
# show new partitions
lsblk
# format the new partitions
sudo mkfs -t ext4 /dev/xvdg1
sudo mkfs -t ext4 /dev/xvdg2
# create a mounting point path for new volume
sudo mkdir /mnt/3rd-vol-part1
sudo mkdir /mnt/3rd-vol-part2
# mount the new volume to the mounting point path
sudo mount /dev/xvdg1 /mnt/3rd-vol-part1/
sudo mount /dev/xvdg2 /mnt/3rd-vol-part2/
# list volumes to show current status, all volumes and partittions should be listed
lsblk
# show the used and available capacities related with volumes and partitions
df -h
# if there is no data on it, create a new file to show persistence in later steps
sudo touch /mnt/3rd-vol-part2/guilewasalsohere.txt
ls -lh /mnt/3rd-vol-part2/
# modify the new (3rd) volume in aws console, and enlarge capacity 1 GB more (from 2GB to 3GB for this demo).
# check if the attached volume is showing the new capacity
lsblk
# show the real capacity used currently at mounting path, old capacity should be shown.
df -h
# extend the partition 2 and occupy all newly avaiable space
sudo growpart /dev/xvdg 2
# ​show the real capacity used currently at mounting path, updated capacity should be shown.
lsblk
# resize and extend the file system
sudo resize2fs /dev/xvdg2
# show the newly created file to show persistence
ls -lh /mnt/3rd-vol-part2/
# reboot and show that configuration is gone
sudo reboot now


# PART 3 - AUTOMOUNT EBS VOLUMES AND PARTITIONS ON REBOOT

# back up the /etc/fstab file.
sudo cp /etc/fstab /etc/fstab.bak
# open /etc/fstab file and add the following info to the existing.(UUID's can also be used)

# /dev/xvdf       mnt/2nd-vol   ext4    defaults,nofail        0       0
# /dev/xvdg1      mnt/3rd-vol-part1   ext4  defaults,nofail        0       0
# /dev/xvdg2      mnt/3rd-vol-part2   ext4  defaults,nofail        0       0
sudo nano /etc/fstab  # sudo vim /etc/fstab   >>> for vim

# reboot and show that configuration exists (NOTE)
sudo reboot now
# list volumes to show current status, all volumes and partittions should be listed
lsblk
# show the used and available capacities related with volumes and partitions
df -h
# if there is data on it, check if the data still persists.
ls -lh /mnt/2nd-vol/
ls -lh /mnt/3rd-vol-part2/


# NOTE: You can use "sudo mount -a" to mount volumes and partitions after editing fstab file without rebooting.
