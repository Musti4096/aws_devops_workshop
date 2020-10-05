# Part-1
# setup MariaDB Server on EC2 Instance (Amazon Linux 2)
sudo yum update -y
sudo yum install mariadb-server -y
# start mariadb service
sudo systemctl start mariadb 
# show status of mariadb service
sudo systemctl status mariadb
# enable mariadb service, so that mariadb service will be activated on restarts
sudo systemctl enable mariadb #Bu surec mySQL demon da yok, çünkü o otomatik enable yapıyor
# connect to the mariadb-server and open mysql cli with root user, no password set as default
mysql -u root 
# show default databases in the mariadb server
SHOW databases;
# choose a database ('mysql' db) to work with. Caution: We have chosen mysql db as demo purposes, normally database mysql is used by server itself, it shouldnt be changed or altered by the user.
USE mysql;
# show tables within the mysql db
SHOW tables;
# show users defined in the db server currently.
SELECT Host, User, Password FROM user;
# close the mysql terminal
EXIT;
# setup secure installation of MariaDB
sudo mysql_secure_installation #cikan yerde sadece enter a bas. cunku 
#root un password u yok. Sonrasında password belirlemen istenecek
#show that you can not log into mysql terminal without password anymore
mysql -u root 
# connect to the mariadb-server and open mysql cli with root user and password
mysql -u root -p #mysql -u root komutunu denersen artık error verir ve girişine izin vermez
# show that test db is gone.
SHOW databases;
# list the users defined in the server and show that it has now  password and its encrypted
USE mysql;
SELECT Host, User, Password FROM user;
# create new database named "clarusway";
CREATE DATABASE clarusway;
# show newly created database
SHOW DATABASES;
# create a user named "hr_guy"; 
CREATE USER hr_guy IDENTIFIED BY 'Hr_guy1234';
# grant permissions to the user "hr_guy" for database "clarusway"
GRANT ALL ON clarusway.* TO hr_guy IDENTIFIED BY 'Hr_guy1234' WITH 
GRANT OPTION;
# update privileges
FLUSH PRIVILEGES;
# close the mysql terminal
EXIT;
# login back as "hr_guy" using the password defined
mysql -u hr_guy -p
# show databases for hr_guy
SHOW DATABASES;
# select the database clarusway
USE clarusway;
# create a table named "offices" 
CREATE TABLE `offices` (
  `office_id` int(11) NOT NULL,
  `address` varchar(50) NOT NULL,
  `city` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  PRIMARY KEY (`office_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
# insert some data into the table named "offices"
INSERT INTO `offices` VALUES (1,'03 Reinke Trail','Cincinnati','OH');
INSERT INTO `offices` VALUES (2,'5507 Becker Terrace','New York City','NY');
INSERT INTO `offices` VALUES (3,'54 Northland Court','Richmond','VA');
INSERT INTO `offices` VALUES (4,'08 South Crossing','Cincinnati','OH');
INSERT INTO `offices` VALUES (5,'553 Maple Drive','Minneapolis','MN');
INSERT INTO `offices` VALUES (6,'23 North Plaza','Aurora','CO');
INSERT INTO `offices` VALUES (7,'9658 Wayridge Court','Boise','ID');
INSERT INTO `offices` VALUES (8,'9 Grayhawk Trail','New York City','NY');
INSERT INTO `offices` VALUES (9,'16862 Westend Hill','Knoxville','TN');
INSERT INTO `offices` VALUES (10,'4 Bluestem Parkway','Savannah','GA');
# create a table named "employees"
CREATE TABLE `employees` (
  `employee_id` int(11) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `job_title` varchar(50) NOT NULL,
  `salary` int(11) NOT NULL,
  `reports_to` int(11) DEFAULT NULL,
  `office_id` int(11) NOT NULL,
  PRIMARY KEY (`employee_id`),
  KEY `fk_employees_offices_idx` (`office_id`),
  CONSTRAINT `fk_employees_offices` FOREIGN KEY (`office_id`) REFERENCES `offices` (`office_id`) ON UPDATE CASCADE) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
# insert some data into the table named "employees"
INSERT INTO `employees` VALUES (37270,'Yovonnda','Magrannell','Executive Secretary',63996,NULL,10);
INSERT INTO `employees` VALUES (33391,'Darcy','Nortunen','Account Executive',62871,37270,1);
INSERT INTO `employees` VALUES (37851,'Sayer','Matterson','Statistician III',98926,37270,1);
INSERT INTO `employees` VALUES (40448,'Mindy','Crissil','Staff Scientist',94860,37270,1);
INSERT INTO `employees` VALUES (56274,'Keriann','Alloisi','VP Marketing',110150,37270,1);
INSERT INTO `employees` VALUES (63196,'Alaster','Scutchin','Assistant Professor',32179,37270,2);
INSERT INTO `employees` VALUES (67009,'North','de Clerc','VP Product Management',114257,37270,2);
INSERT INTO `employees` VALUES (67370,'Elladine','Rising','Social Worker',96767,37270,2);
INSERT INTO `employees` VALUES (68249,'Nisse','Voysey','Financial Advisor',52832,37270,2);
INSERT INTO `employees` VALUES (72540,'Guthrey','Iacopetti','Office Assistant I',117690,37270,3);
INSERT INTO `employees` VALUES (72913,'Kass','Hefferan','Computer Systems Analyst IV',96401,37270,3);
INSERT INTO `employees` VALUES (75900,'Virge','Goodrum','Information Systems Manager',54578,37270,3);
INSERT INTO `employees` VALUES (76196,'Mirilla','Janowski','Cost Accountant',119241,37270,3);
INSERT INTO `employees` VALUES (80529,'Lynde','Aronson','Junior Executive',77182,37270,4);
INSERT INTO `employees` VALUES (80679,'Mildrid','Sokale','Geologist II',67987,37270,4);
INSERT INTO `employees` VALUES (84791,'Hazel','Tarbert','General Manager',93760,37270,4);
INSERT INTO `employees` VALUES (95213,'Cole','Kesterton','Pharmacist',86119,37270,4);
INSERT INTO `employees` VALUES (96513,'Theresa','Binney','Food Chemist',47354,37270,5);
INSERT INTO `employees` VALUES (98374,'Estrellita','Daleman','Staff Accountant IV',70187,37270,5);
INSERT INTO `employees` VALUES (115357,'Ivy','Fearey','Structural Engineer',92710,37270,5);
# show newly created tables;
SHOW tables;
# list all records within employees table
SELECT * FROM offices;
# list all records within offices table
SELECT * FROM employees;
# close the mysql terminal
EXIT;
#enter mysql as a hr_guy
mysql -u hr_guy -p
# use clarusway database
USE clarusway;
# filter the first_name, last_name, salary, city, state information of employees havinga salary more then $100000
SELECT first_name, last_name, salary, city, state FROM employees INNER JOIN offices ON employees.office_id=offices.office_id WHERE employees.salary > 100000;
# connect the clarusway db on MySQL DB Server from the other hosts  
mysql -h [you instance\'s DNS name] -u hr_guy -p 
# show that hr_guy can do same db operations from the other host

