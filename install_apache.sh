#!/bin/bash
sudo apt update -y
sudo apt install apache2 git -y
git clone https://github.com/gabrielecirulli/2048.git
sudo cp -r 2048/* /var/www/html/
sudo chown -R www-data:www-data /var/www/html/
sudo systemctl start apache2 && sudo systemctl enable apache2