# Create RDS Subnet Group
**RDS** to select from a range of subnets to put its databases inside
In this case you will give it a selection of *3 subnets* sn-db-A / B and C

* Move to the [RDS Console]( https://console.aws.amazon.com/rds/home?region=us-east-1#)
* Click Subnet Groups
* Click Create DB Subnet Group
* Under Name enter WordPressRDSSubNetGroup
* Under Description enter RDS Subnet Group for WordPress
* Under VPC select A4LVPC
* Under Add subnets In Availability Zones select us-east-1a & us-east-1b & us-east-1c
* Under Subnets check the box next to
   1. 10.16.16.0/20 (this is sn-db-A)
   2. 10.16.80.0/20 (this is sn-db-B)
   3. 10.16.144.0/20 (this is sn-db-C)
* **Create**

# Create RDS Instance

* Click Databases
* Click Create Database
* Click Standard Create
* Click MySql
* Under Version select MySQL 8.0.32


