# LNMP ( Linux Nginx MySQL PHP )
This repository contains bash script for Easy Install LNMP Stack onto Ubuntu environment 20.04 and later

# Stack 
Setups
- Nginx
	- Install Nginx web server
	- Setup vhost with user input server_name
	- Setup and create project path directory following by User input
	- Nginx optimized and security configuration added
- MySQL
	- Install latest MySQL
	- Setup root password following by user input
	- Creating Database following by user input
	- Setup and create new separate user&password with permission to the project database
- PHP
	- Install PHP FPM specific version following by user input
	- PHP optimized settings added

# Run Setup
bash ./installer.sh

# Installed Packages
The script will install, Configure & Start the services for Nginx, MySQL and PHP FPM with linux system services enabled.

#Author
- Ahmer [ DevOps Engineer ]
https://github.com/ahmer47/