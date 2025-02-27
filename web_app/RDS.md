# Create RDS Subnet Group

![EC2_RDS](./assets/ec2_Rds.jpg)

**RDS** to select from a range of subnets to put its databases inside
In this case you will give it a selection of *3 subnets* sn-db-A / B and C

* Move to the [RDS Console](https://console.aws.amazon.com/rds/home?region=us-east-1#)
* Click Subnet Groups
* Click Create [DB Subnet Group](https://us-east-1.console.aws.amazon.com/rds/home?region=us-east-1#create-db-subnet-group:)
* **Name** : WordPressRDSSubNetGroup
* **Description** : RDS Subnet Group for WordPress
* **VPC** : A4LVPC
* **Add subnets** : *Availability Zones* select us-east-1a & us-east-1b & us-east-1c
* Under Subnets check the box next to
   1. 10.16.16.0/20 (this is sn-db-A)
   2. 10.16.80.0/20 (this is sn-db-B)
   3. 10.16.144.0/20 (this is sn-db-C)
* **Create**

# Create RDS Instance

* Click **Databases**
* Click **Create Database**
* Click **Standard Create**
* Click **MySql**
* Under Version select **MySQL 8.0.40**
* select **Free Tier** under templates this ensures there will be no costs for the database but it will be single AZ only
* under Master Password and Confirm Password enter **4n1m4l54L1f3**
* Under **DB Instance size**, then DB instance class, then Burstable classes (includes t classes) make sure db.t3.micro or **db.t2.micro or db.t4g.micro** is selected
* Scroll down, under Connectivity, Compute resource select Don’t connect to an EC2 compute resource
* under Connectivity, Network type select **IPv4**
* under Connectivity, **Virtual private cloud (VPC)** select **A4LVPC**
* under Subnet group that **wordpressrdssubnetgroup** is selected
* Make sure **Public Access** is set to **No**
* Under VPC security groups make sure choose existing is selected, remove default and add **A4LVPC-SGDatabase**
* Under Availability Zone set **us-east-1a**
* ***IMPORTANT .. DON'T MISS*** THIS STEP Scroll down past Database **Authentication** & **Monitoring**  
* expand Additional configuration
* in the Initial database name box enter a4lwordpressdb
* Scroll to the bottom and click **create Database**

# Migrate WordPress data from MariaDB to RDS

* Open the [EC2 Console](https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#Home:)
* Click Instances
* Locate the WordPress-LT instance, right click, Connect and choose Session Manager and then click Connect
* Type ```sudo bash```
* Type ``cd``
* Type ```clear```

# Populate Environment Variables
You will find it in [environment variables EC2](./manual_env.md)

# Take a Backup of the local DB
To take a backup of the database run

```
mysqldump -h $DBEndpoint -u $DBUser -p$DBPassword $DBName > a4lWordPress.sql
```

# Restore that Backup into RDS

* Move to the [RDS Console](https://console.aws.amazon.com/rds/home?region=us-east-1#databases:)
* Click the **a4lWordPressdb** instance
* Copy the **endpoint** into your clipboard
* Move to the [Parameter store](https://console.aws.amazon.com/systems-manager/parameters?region=us-east-1)
* Check the box next to **/A4L/Wordpress/DBEndpoint** and click Delete 
* Click Create Parameter
 
* **UnderName** : **/A4L/Wordpress/DBEndpoint**
* **Descripton** : **WordPress DB** Endpoint Name
* **Tier** : Standard
* **Type** : select String
* **DataType** :  text
* **Value** : the RDS endpoint endpoint you just copied
* Click Create Parameter

Update the DbEndpoint environment variable with :

```
DBEndpoint=$(aws ssm get-parameters --region us-east-1 --names /A4L/Wordpress/DBEndpoint --query Parameters[0].Value)
DBEndpoint=`echo $DBEndpoint | sed -e 's/^"//' -e 's/"$//'`
```

Restore the database export into RDS using : 
```
mysql -h $DBEndpoint -u $DBUser -p$DBPassword $DBName < a4lWordPress.sql 
```
# Change the WordPress config file to use RDS 
this command will substitute localhost in the config file for the contents of $DBEndpoint which is the RDS instance :
```
sudo sed -i "s/'localhost'/'$DBEndpoint'/g" /var/www/html/wp-config.php
```

# Stop the MariaDB Service

```
sudo systemctl disable mariadb
sudo systemctl stop mariadb
```
# Test WordPress
* Move to the [EC2 Console](https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#Instances:sort=desc:tag:Name)
* Select the **WordPress-LT** Instance
* copy the **IPv4 Public IP** into your clipboard
* Open the IP in a new tab
* You should see the blog, working, even though MariaDB on the EC2 instance is stopped and disabled Its now running using RDS

# Update the LT so it doesnt install
Move to the [EC2 Console](https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#Home:)
Instances : Launch Templates
Select the WordPress launch Template (select, dont click) Click Actions and Modify Template (Create new version)
This template version will be based on the existing version ... so many of the values will be populated already
Template version description : Single server App Only - RDS DB

Advanced details and expand it
User Data and expand the text box as much as possible

Locate and remove the following lines 
```
systemctl enable mariadb
systemctl start mariadb
mysqladmin -u root password $DBRootPassword


echo "CREATE DATABASE $DBName;" >> /tmp/db.setup
echo "CREATE USER '$DBUser'@'localhost' IDENTIFIED BY '$DBPassword';" >> /tmp/db.setup
echo "GRANT ALL ON $DBName.* TO '$DBUser'@'localhost';" >> /tmp/db.setup
echo "FLUSH PRIVILEGES;" >> /tmp/db.setup
mysql -u root --password=$DBRootPassword < /tmp/db.setup
rm /tmp/db.setup
```
Click Create Template Version
Click View Launch Template
Select the template again (dont click) Click Actions and select Set Default Version
Under Template version select 2
Click Set as default version
