# web app - single server
## Stage 1 - Setup the environment and manually build wordpress
-  Create an EC2 Instance to run wordpress
Move to the [EC2 console](https://console.aws.amazon.com/ec2/v2/home?region=us-east-1)
**Name** : Wordpress-MAnual
**AMI** : Amazone Linux 2023
**Architecture** : 64-bit (x86)
**Instance type** : t2 or t3.micro cause Iam in Free tier
**Keypair** : Under Key Pair(login) select Proceed without a KeyPair (not recommended) I make it without key pair cause this project for practice only
**Network Settings** :  click Edit and in the VPC download select A4LVPC
**Subnet** : select sn-Pub-A
**Auto-assign public IP** : Enable
**Auto-assign IPv6 IP** : Enable
**security Group** : Select an existing security group --> A4LVPC-SGWordpress
**storage** : Defult
*open Advanced Details*
**IAM instance profile role** : A4LVPC-WordpressInstanceProfile
**Credit Specification** : Standard

```NOW Launch Instance```


