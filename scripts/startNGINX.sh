#!/bin/bash

sudo apt update


sudo apt install -y nginx

cd /var/www

if [ ! -e /var/www/tutorial ]; then
    sudo mkdir tutorial
fi

cd tutorial



if [ ! -e /var/www/tutorial/index.html ]; then
    # Create the file and write the HTML content
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
fi


cd /etc/nginx/sites-enabled



if [ ! -e /etc/nginx/sites-enabled/tutorial ]; then
    sudo bash -c 'cat <<EOF > /etc/nginx/sites-enabled/tutorial
server {
       listen 81;
       listen [::]:81;

       server_name example.ubuntu.com;

       root /var/www/tutorial;
       index index.html;

       location / {
               try_files $uri $uri/ =404;
       }
}
EOF'
fi

sudo service nginx restart
