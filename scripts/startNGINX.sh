#!/bin/bash

sudo apt update


sudo apt install -y nginx

cd /var/www

if [ ! -e /var/www/tutorial ]; then
    mkdir tutorial
fi

cd tutorial

if [ ! -e /var/www/tutorial/index.html ]; then
    touch  index.html <<EOf
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
EOf
fi



cd /etc/nginx/sites-enabled


if [ ! -e /var/www/tutorial ]; then
    touch  tutorial <<EOf
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
EOf
fi

sudo service nginx restart