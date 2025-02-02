#!/bin/bash

# Update and install NGINX
sudo apt update
sudo apt install -y nginx

# Create the web directory
sudo mkdir -p /var/www/tutorial
sudo chown -R www-data:www-data /var/www/tutorial
sudo chmod -R 755 /var/www/tutorial

# Create the index.html file
sudo bash -c 'cat <<EOF > /var/www/tutorial/index.html
<!doctype html>
<html>
<head>
    <meta charset="utf-8">
    <title>Hello, Nginx!</title>
</head>
<body>
    <h1>Hello, Nginx!</h1>
    <p>We have just configured our Nginx web server on Ubuntu Server!</p>
</body>
</html>
EOF'

# Create the NGINX configuration file
sudo bash -c 'cat <<EOF > /etc/nginx/sites-enabled/tutorial
server {
       listen 81;
       listen [::]:81;

       server_name _;

       root /var/www/tutorial;
       index index.html;

       location / {
               try_files \$uri \$uri/ =404;
       }
}
EOF'

# Remove the default configuration if it exists
if [ -e /etc/nginx/sites-enabled/default ]; then
    sudo rm /etc/nginx/sites-enabled/default
fi

# Test and restart NGINX
sudo nginx -t && sudo systemctl restart nginx