#!/bin/bash
apt update -y
apt install -y nginx git

systemctl enable nginx
systemctl start nginx

rm -rf /usr/share/nginx/html/*
git clone https://github.com/Sharayu1707/Static-Website-Architecture.git /tmp/site

cp -r /tmp/site/* /usr/share/nginx/html/

