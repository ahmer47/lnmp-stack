#!/bin/bash

domain=""
filepath=""
db_user=""
db_pass=""
db_site=""
php_var=""
root_pass=""

read -p "Enter Domain name : " domain
read -p "Enter Website directory path : " filepath
read -p "Enter PHP version : " php_var
read -p "Enter MySQL Root password : " root_pass
read -p "Enter Database username for your Site : " db_user
read -p "Enter Password for Database username for your the site : " db_pass
read -p "Enter Database Name for your site : " db_site
printf "STARTING INSTALLATIONS \n \n"
sleep 3

echo "Updating Server"
sleep 3
sudo dpkg --configure -a
sudo apt update -y && sudo apt dist-upgrade -y 
printf "Installing Nginx Web Server \n \n"
sleep 1
sudo apt install nginx -y
sudo systemctl enable nginx
service nginx restart
printf "Configuring Mysql Server \n \n"
sleep 3
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $root_pass"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $root_pass"
printf "Installing MySql Server \n\n"
sudo apt-get -y install mysql-server
sudo systemctl stop mysql
sudo systemctl start mysql
sudo systemctl enable mysql
printf "\n Create database user \n \n"
sleep 3


mysql -uroot -p${root_pass} -e "CREATE DATABASE $db_site;"
mysql -uroot -p${root_pass} -e "CREATE USER $db_user@localhost IDENTIFIED BY '${db_pass}';"
mysql -uroot -p${root_pass} -e "GRANT ALL PRIVILEGES ON $db_site.*  TO '$db_user'@'localhost';"
mysql -uroot -p${root_pass} -e "FLUSH PRIVILEGES;"



printf "Installing PHP FPM \n"

sudo apt install software-properties-common apt-transport-https -y
echo  -ne "\n" | sudo add-apt-repository ppa:ondrej/php
sudo apt update -y 
sudo apt install php"$php_var"-fpm php"$php_var"-common php"$php_var"-mysql php"$php_var"-xml php"$php_var"-xmlrpc php"$php_var"-curl php"$php_var"-gd php"$php_var"-imagick php"$php_var"-cli php"$php_var"-dev php"$php_var"-imap php"$php_var"-mbstring php"$php_var"-opcache php"$php_var"-soap php"$php_var"-zip unzip -y



sudo cp php.ini /etc/php/"$php_var"/fpm/php.ini

sudo service php"$php_var"-fpm restart
sudo systemctl enable php"$php_var"-fpm

sed -i "s/server_name/server_name $domain/" default
sed -i "s/php-fpm/php$php_var-fpm/g" default
sed -i "s,root,root $filepath,g" default

sudo cp default /etc/nginx/sites-available/default
sudo cp nginx.conf /etc/nginx/
service nginx reload
service nginx restart
service php"$php_var"-fpm restart
mkdir -p "$filepath"

printf "Setting Permissions \n"
sleep 3
chown -R www-data:www-data "$filepath"
chmod -R "755 $filepath"

echo  -ne "\n" | sudo add-apt-repository ppa:certbot/certbot

sudo apt install python3-certbot-nginx -y

ufw allow 22
sudo ufw allow 'Nginx Full'

sleep 2

printf "\n \n Setup Complete !"
printf "\n\n\n Author : https://github.com/ahmer47/ \n\n\n"