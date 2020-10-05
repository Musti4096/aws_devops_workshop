# Hands-on DB-02 : Introduction to MariaDB Server

Purpose of the this hands-on training is to set up EC2 instance as a MariaDB server.

## Learning Outcomes

At the end of the this hands-on training, students will be able to;

- install MariaDB environment on EC2 Instance.

- learn basic concepts of MariaDB database.

- configure MariaDB server.

- install MariaDB client.

- learn how to connect to MariaDB Server remotely from the MariaDB Client.

## Outline

- Part 1 - Creating EC2 Instance and Installing MariaDB Server

- Part 2 - Connecting and Configuring MariaDB Database

- Part 3 - Manipulating MariaDB Database

- Part 4 - Creating a Client Instance and Connecting to MariaDB Server Instance Remotely

## Part 1 - Creating EC2 Instance and Installing MariaDB Server

- Launch EC2 Instance.

```text
AMI: Amazon Linux 2
Instance Type: t2.micro
Security Group
  - SSH           -----> 22    -----> Anywhere
  - MYSQL/Aurora  -----> 3306  -----> Anywhere
```

- Connect to EC2 instance with SSH.

- Update yum package management and install MariaDB server.

```bash
sudo yum update -y
sudo yum install mariadb-server -y
```

- Start MariaDB service.

```bash
sudo systemctl start mariadb
```

- Check status of MariaDB service.

```bash
sudo systemctl status mariadb
```

- Enable MariaDB service, so that MariaDB service will be activated on restarts.

```bash
sudo systemctl enable mariadb
```

## Part 2 - Connecting and Configuring MariaDB Database

- Connect to the MariaDB Server and open MySQL CLI with root user, no password set as default.

```bash
mysql -u root
```

- Show default databases in the MariaDB Server.

```bash
SHOW databases;
```

- Choose a database (`mysql` db) to work with. :warning: `Caution`: We have chosen `mysql` db as demo purposes, normally database mysql is used by server itself, it shouldn't be changed or altered by the user.

```bash
USE mysql;
```

- Show tables within the `mysql` db.

```bash
SHOW tables;
```

- Show users defined in the db server currently.

```bash
SELECT Host, User, Password FROM user;
```

- Close the `mysql` terminal.

```bash
EXIT;
```

- Setup secure installation of MariaDB.

```bash
sudo mysql_secure_installation
```

- Show that you can not log into `mysql` terminal without password anymore.

```bash
mysql -u root
```

- Connect to the MariaDB Server and open MySQL CLI with root user and password.

```bash
mysql -u root -p
```

- Show that `test` db is gone.

```bash
SHOW databases;
```

- List the users defined in the server and show that it has now password and its encrypted.

```bash
USE mysql;
SELECT Host, User, Password FROM user;
```

- Create new database named `clarusway`.

```bash
CREATE DATABASE clarusway;
```

- Show newly created database.

```bash
SHOW DATABASES;
```

- Create a user named `hr_guy`.

```bash
CREATE USER hr_guy IDENTIFIED BY 'Hr_guy1234';
```

- Grant permissions to the user `hr_guy` for database `clarusway`.

```bash
GRANT ALL ON clarusway.* TO hr_guy IDENTIFIED BY 'Hr_guy1234' WITH
GRANT OPTION;
```

- Update privileges.

```bash
FLUSH PRIVILEGES;
```

- Close the `mysql` terminal.

```bash
EXIT;
```

## Part 3 - Manipulating MariaDB Database

- Login back as `hr_guy` using the password defined.

```bash
mysql -u hr_guy -p
```

- Show databases for `hr_guy`.

```bash
SHOW DATABASES;
```

- Select the database `clarusway`.

```bash
USE clarusway;
```

- Create a table named `offices`.

```sql
CREATE TABLE `offices` (
  `office_id` int(11) NOT NULL,
  `address` varchar(50) NOT NULL,
  `city` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  PRIMARY KEY (`office_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

- Insert some data into the table named `offices`.

```sql
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
```

- Create a table named `employees`.

```sql
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
```

- Insert some data into the table named `employees`.

```sql
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
```

- Show newly created tables.

```sql
SHOW tables;
```

- List all records within `employees` table.

```sql
SELECT * FROM offices;
```

- List all records within `offices` table.

```sql
SELECT * FROM employees;
```

- Close the `mysql` terminal.

```sql
EXIT;
```

- Enter mysql as a `hr_guy`.

```sql
mysql -u hr_guy -p
```

- Use `clarusway` database.

```sql
USE clarusway;
```

- Filter the `first_name`, `last_name`, `salary`, `city`, `state` information of `employees` having salary more than `$100000`.

```sql
SELECT first_name, last_name, salary, city, state FROM employees INNER JOIN offices ON employees.office_id=offices.office_id WHERE employees.salary > 100000;
```

## Part 4 - Creating a Client Instance and Connecting to MariaDB Server Instance Remotely

- Launch EC2 Instance (Ubuntu 18.04) and name it as `MariaDB-Client on Ubuntu`.

```text
AMI: Ubuntu 18.04
Instance Type: t2.micro
Security Group
  - SSH           -----> 22    -----> Anywhere
  - MYSQL/Aurora  -----> 3306  -----> Anywhere
```

- Connect to EC2 instance with SSH.

- Update instance.

```bash
sudo apt update -y
```

- Install the `mariadb-client`.

```bash
sudo apt-get install mariadb-client -y
```

- Connect the `clarusway` db on MariaDB Server on the other EC2 instance.

```bash
mysql -h [ec2-public-dns-name] -u hr_guy -p Hr_guy1234
```

- Show that `hr_guy` can do same db operations on MariaDB Server instance.
