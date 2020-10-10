
2 Ekim 2020 - Cuma---> Wordpress ve RDS (LAMP Stack) Lab

# 1.Create 2 Sec.Group:

    Wordpress_Instance_Sec_group: SSH 22, HTTP 80, Mysql/Aurora 3306  > anywhere(0:/00000)
    RDS_database_Sec_Group: Mysql/Aurora 3306 > anywhere (0:/00000)

# 2.Create RDS mysql instance.
Master username: admin
Password: Clarusway_1

# 3.Create EC2 that is installed LAMP with user data seen below for Wordpress app.

#!/bin/bash

yum update -y
amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
yum install -y httpd
systemctl start httpd
systemctl enable httpd
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
sudo cp -r wordpress/* /var/www/html/
cd /var/www/html/
cp wp-config-sample.php wp-config.php
chown -R apache /var/www
chgrp -R apache /var/www
chmod 775 /var/www
find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;
systemctl restart httpd

# 4. Paste the DNS of EC2 instance to the browser 
Error establishing a database connection

# 5. Check the httpd status
sudo systemctl status  httpd

# 6. Check the PHP version
php --version 
   #(you'll see HP 7.2.30)

# 7. Check the mariadb status
sudo systemctl status mariadb
   #(you'll see mariadb not found)

# 8. Install mariadb 
sudo yum install -y mariadb-server

# 9. Start mariadb service
sudo systemctl start mariadb

# 10. Enable mariadb service, so that mariadb service will be activated on restarts
sudo systemctl enable mariadb

# 11. Setup secure installation of MariaDB
sudo mysql_secure_installation

# 12. Connect mysql terminal without password anymore
mysql -u root -p

# 13.Show that test db is gone.
SHOW databases;

# 14. Select msql and List the users defined in the server
USE mysql;

SELECT Host, User, Password FROM user;

# 15. Create new database named "clarusway";
CREATE DATABASE clarusway;

# 16. Show newly created database
SHOW DATABASES;

# 17. Create a user named "admin"; 
CREATE USER admin IDENTIFIED BY 'Clarusway_1';

# 18. Grant permissions to the user "admin" for database "clarusway"
GRANT ALL ON clarusway.* TO admin IDENTIFIED BY 'Clarusway_1' WITH GRANT OPTION;  

# 19. Update privileges
FLUSH PRIVILEGES;

# 20. List the users defined.
SELECT Host, User, Password FROM user;

# 21. Close the mysql terminal
EXIT;


# 22. Login databse again for upload an tables 
mysql -u admin -p

# 23. Show databases and Select the database "clarusway"
SHOW DATABASES;
USE clarusway;

# 24. Create a table named "store" 

CREATE TABLE `store` (
  `store_id` int(11) NOT NULL,
  `address` varchar(50) NOT NULL,
  `city` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  PRIMARY KEY (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

# 25. Insert some data into the table named "store"

INSERT INTO `store` VALUES (1,'03 Reinke Trail','Cincinnati','OH');
INSERT INTO `store` VALUES (2,'5507 Becker Terrace','New York City','NY');
INSERT INTO `store` VALUES (3,'54 Northland Court','Richmond','VA');
INSERT INTO `store` VALUES (4,'08 South Crossing','Cincinnati','OH');
INSERT INTO `store` VALUES (5,'553 Maple Drive','Minneapolis','MN');
INSERT INTO `store` VALUES (6,'23 North Plaza','Aurora','CO');
INSERT INTO `store` VALUES (7,'9658 Wayridge Court','Boise','ID');
INSERT INTO `store` VALUES (8,'9 Grayhawk Trail','New York City','NY');
INSERT INTO `store` VALUES (9,'16862 Westend Hill','Knoxville','TN');
INSERT INTO `store` VALUES (10,'4 Bluestem Parkway','Savannah','GA');

# 26. Create a table named "Client"

CREATE TABLE `client` (
  `client_id` int(11) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  PRIMARY KEY (`client_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

# 27. Insert some data into the table named "client"

INSERT INTO `client` VALUES (37270,'Yovonnda','Magrannell');
INSERT INTO `client` VALUES (33391,'Darcy','Nortunen');
INSERT INTO `client` VALUES (37851,'Sayer','Matterson');
INSERT INTO `client` VALUES (40448,'Mindy','Crissil');
INSERT INTO `client` VALUES (56274,'Keriann','Alloisi');
INSERT INTO `client` VALUES (63196,'Alaster','Scutchin');
INSERT INTO `client` VALUES (67009,'North','de Clerc');
INSERT INTO `client` VALUES (67370,'Elladine','Rising');
INSERT INTO `client` VALUES (68249,'Nisse','Voysey');
INSERT INTO `client` VALUES (72540,'Guthrey','Iacopetti');
INSERT INTO `client` VALUES (72913,'Kass','Hefferan');
INSERT INTO `client` VALUES (75900,'Virge','Goodrum');
INSERT INTO `client` VALUES (76196,'Mirilla','Janowski');
INSERT INTO `client` VALUES (80529,'Lynde','Aronson');

# 28. Show newly created tables;
SHOW tables;

# 29. Check the tables
SELECT * FROM store;
SELECT * FROM client;

# 30. Exit from database
EXIT;

# 31. Go to the "cd /var/www/html/" to secure config file before change

cd /var/www/html/
sudo cp wp-config-sample.php wp-config.php

# 32. Change the config file for database assosiation
sudo vi wp-config.php
click i (insert)

     #define( 'DB_NAME', 'clarusway' );

     #define( 'DB_USER', 'admin' );

     #define( 'DB_PASSWORD', 'Clarusway_1' );

esc+:wq
sudo systemctl restart httpd

# 33. Check the browser. You'll see the home page of Wordpress
      # enter pasword,user name etc... 


#connect to your wordpress website in different browser with EC2 DNS and write 2 comments in the yorum subsection

#connect to the database
mysql -u admin -p

#Show databases and Select the database "clarusway"
SHOW DATABASES;
USE clarusway;
select * from wp_comments;  # you can see the written two comments in here
exit


# 34. Connect to the RDS instance to create "clarusway" database with HOST
mysql -u admin -h [your-own-RDS-endpoint] -p

# 35. Show databases and select "mysql"
SHOW DATABASES;
USE mysql;

# 36. Create new database named "clarusway";
CREATE DATABASE clarusway;

# 37. Show newly created database and exit
SHOW DATABASES;
EXIT;

# 38.Create Messanger Instance and connce with SSH: 
  
---> Sec group: ssh-mysql aurora:0/00000 (or Wordpress_Instance_sec_group )
  
userdata:
    
#!/bin/bash
yum update -y
yum install -y https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
yum install -y mysql-community-client


# 39. Create dumb of "clarusway" database via connecting from "Messenger EC2" to the "Database Instance"
mysqldump -u admin -h [your-own-database-instance-DNS] -p clarusway > clarusway_migration.sql

# 40. Transfer the dumb file to the RDS instance 
mysql -u admin -h [your-own-RDS-endpoint] -p clarusway < clarusway_migration.sql


# 41. Loging for checking "clarusway"
mysql -u admin -h [your-own-RDS-endpoint] -p
USE clarusway;
SHOW tables;
SELECT * FROM client;
SELECT * FROM store;
SELECT * FROM wp_comments;

# 42. Go to the Workbrech and connect;
SELECT * FROM clarusway.client;
SELECT * FROM clarusway.store;


# 43. Go to wordpress website and write an another comment and save it
# 44. Go to client and show the wp-comments table. There isn't shown any new comment
why?
# 45. Go to First instance and show the wp_comments table
# 46. Login databse again for upload an tables 
mysql -u admin -p

# 47. Show databases and Select the database "clarusway"
SHOW DATABASES;
USE clarusway;
select * from wp_comments;

#48. it can be shown that the latest comment was written here. Why? 

cd /var/www/html/

# 49. Change the config file for database assosiation
sudo vi wp-config.php
click i (insert)

    #define( 'DB_HOST', '[RDS-end-point]' );

esc+:wq
sudo systemctl restart httpd

#51 Go to client EC2 and conneect to the rds instance;
mysql -u admin -h [your-own-RDS-endpoint] -p

# 47. Show databases and Select the database "clarusway"

select * from wp_comments;
# 50. go to the wordpress website and add new comment and look at the clarusway table again
select * from wp_comments;


