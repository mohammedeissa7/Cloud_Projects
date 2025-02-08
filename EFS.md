# Create EFS File System

![EFS_Wp_APP](./assets/EFS_WP_APP.jpg)


* Move to the [EFS Console](https://console.aws.amazon.com/efs/home?region=us-east-1#/get-started)
* Create file System 
* Click on Customize
* **Name** : A4L-WORDPRESS-CONTENT
* **Storage Class** : Standard and ensure Enable Automatic Backups is enabled 
## for LifeCycle management : 
* **Transition into IA** : 30 days since last access
* **Transition out of IA** : None
* Untick Enable encryption of data at rest
* throughput modes choose Bursting
* Additional Settings : Performance Mode is set to General Purpose
* ***Next***

# Network Settings
In this part you will be configuing the **EFS Mount Targets** which are the network interfaces in the VPC which your instances will connect with : 

* **Virtual Private Cloud (VPC)** : A4LVPC
* Make sure us-east-1a, us-east-1b & us-east-1c are selected in each row.
* In *us-east-1a* row, select *sn-App-A* in the subnet ID dropdown, and in the security groups dropdown select **A4LVPC-SGEFS** & remove the default security group and make the same process for *us-east-1b* & *us-east-1c*
* **NEXT**

* Leave all these options as default and click next
* We wont be setting a file system policy so click Create
* The file system will start in the Creating State and then move to Available once it does..
* Click on the file system to enter it and click Network
* Scroll down and all the mount points will show as creating keep hitting refresh and wait for all 3 to show as available before moving on
* Note down the fs-XXXXXXXX or DNS name (either will work) once visible at the top of this screen, you will need it in the next step.

# Add an fsid to parameter store
Now that the file system has been created, you need to add another parameter store value for the file system ID so that the automatically built instance(s) can load this safely : 
* Move to the [Systems Manager console](https://console.aws.amazon.com/systems-manager/home?region=us-east-1#)
* Click on Parameter Store on the left menu
* Click Create Parameter
* **Name** : /A4L/Wordpress/EFSFSID
* **Description** : File System ID for Wordpress Content (wp-content)
* **Tier** : Standard
* **Type** : String
* **DataType** : text
* **Value** : set the file system ID fs-XXXXXXX which you just noted down
* **Create Parameter** 


