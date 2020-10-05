# Hands-on EC2-05 : Working with EC2 Snapshots

Purpose of the this hands-on training is to teach students how to take a snapshot of EC2 instance and create an image from EC2 instance.

## Learning Outcomes

At the end of the this hands-on training, students will be able to;

- take snapshots of EC2 instances on AWS console.

- create images from EC2 instances on AWS console.

- understand of difference between the image and the snapshot.

- create different types of AMI.

## Outline

- Part 1 - Creating an Image from the Snapshot of the Nginx Server and Launching a new Instance

- Part 2 - Creating an Image and Launching an Instance from the same Image

- Part 3 - Creating an Image from the Snapshot of the Root Volume and Launching a new Instance

- Part 4 - Creating an Image from Customized Instance and Launching an instance from the same AMI

![Apache HTTP Server](./ami_lifecycle.png)

## Part 1 - Creating an Image from the Snapshot of the Nginx Server and Launching a new Instance

1. Launch an instance with following configurations.

  a. Security Group: Allow SSH and HTTP ports from anywhere with named "SSH and HTTP"

  b. User data (paste it for Nginx)

  
  #!/bin/bash

  yum update -y
  amazon-linux-extras install nginx1.12
  yum install wget -y
  chkconfig nginx on
  cd /usr/share/nginx/html
  chmod o+w /usr/share/nginx/html
  rm index.html
  wget https://raw.githubusercontent.com/awsdevopsteam/route-53/master/index.html
  wget https://raw.githubusercontent.com/awsdevopsteam/route-53/master/ken.jpg
  service nginx start
  

  c. Key: Name --> Value: SampleInstance  

2. Firt copy the Instance ID and then go to EC2 dashboard and click "Snapshot" section from left-hand menu.

3. Click `create snapshot` button.


Select resource type : Instance
Instance ID          : Select the instance ID of Nginx
Name                 : Instance-Snapshot_First

4. Click create snapshot.

5. Click snapshot `Action` menu and select `create image`


Name        : ClaruswayAMI_1
Description : ClaruswayAMI_1


6. Click the `launch instance` tab.

7. Click `myAMI` from left-hand menu.

8. Select `Instance-snapshot_1
`

9. Show that security group rules (SSH, HTTP) and `user data` same as original EC2 Nginx instance.

10. Launch instance.

11. Copy the public IP of the newly created instance and paste it to the browser.

13. Show that the Nginx Web Server is working.

## Part 2 - Creating an Image and Launching an Instance from the same Image

14. Go to `SampleInstance`

15. Click the actions menu.

16. Select image >> create image.

Name        : ClaruswayAMI_2
Description : ClaruswayAMI_2


17. Click AMI section from left hand menu and show `ClaruswayAMI_2`

18. After ClaruswayAMI creation process is completed, click snapshot section from left-hand menu.

19. Show that AWS has created a new snapshot for newly created `ClaruswayAMI_2` image.

20. Click the `launch instance` tab.

21. Click `myAMI` from left-hand menu.

22. Select `ClaruswayAMI_2`.

23. Show that security group rules (SSH, HTTP) and `user data` same as original EC2 Nginx instance.

24. Launch instance.

25. Copy the public IP of the newly created instance and paste it to the browser.

26. Show that the Nginx Web Server is working.

## Part 3 - Creating an Image from the Snapshot of the Root Volume and Launching a new Instance

27. Go to EC2 menu and click snapshot section from left-hand menu.

28. Click `create snapshot` button.

Select resource type : Volume
Instance ID : select the root volume of the SampleInstance


29. Click create snapshot.


Name        : ClaruswayAMI_3
Description : ClaruswayAMI_3

30. Click the `launch instance` tab.

31. Click `myAMI` from left-hand menu.

32. Select `ClaruswayAMI_3`.

33. Show that security group rules (SSH, HTTP) and `user data` same as original EC2 Nginx instance.

34. Launch instance.

35. Copy the public IP of the newly created instance and paste it to the browser.

36. Show that the Nginx Web Server is working.

## Part 4 - Creating an Image from Customized Instance and Launching an instance from the same AMI

37. Connect to `SampleInstance` with SSH.

38. Create a file named `i_am_here.txt`


touch i_am_here.txt
ls


39. Exit from the instance.

40. Go to EC2 console.

41. Select the instance named `SampleInstance`.

42. Click the actions menu.

43. Select image >> create image.


Name        : ClaruswayAMI_4
Description : ClaruswayAMI_4


44. Click the `launch instance` tab.

45. Click `myAMI` from left-hand menu

46. Select `ClaruswayAMI_4`

47. Launch instance.


Name        : ClaruswayAMI_5
Description : ClaruswayAMI_5


48. Connect to `ClaruswayAMI_5` with SSH. Dont forget to connect with "ec2-user" ıf you copy from the conncet tab you'll see "root@...."

49. Show `i_am_here.txt` with `ls`.

ls
