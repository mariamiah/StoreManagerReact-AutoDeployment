#!/bin/bash
#let script exit if a command fails
set -o errexit

#let script exit if an unsed variable is used
set -u
# variables
REPO_FOLDER="Store-Manager-React"
REMOTE_REPO="https://github.com/mariamiah/Store-Manager-React.git"
BASE_URL="https://storemanager15.herokuapp.com"
function updateInstance(){
    echo "---------Update Instance----------"
    sudo apt-get update
}
function install(){
    echo "---------- Install Nginx----------"
    sudo apt-get install nginx
    echo "---------- Install NodeJs---------"
    sudo apt-get install curl software-properties-common
    curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
    sudo apt-get install nodejs
}
function cloneRepo(){
    echo "..........cloning the repository........."
     echo "..........cloning the repository........."
    if [ ! -d "$REPO_FOLDER" ]; then
        git clone $REMOTE_REPO
    else
        rm -rf "$REPO_FOLDER"
        git clone $REMOTE_REPO
    fi
}
function setUpProjectEnvironment(){
     cd $REPO_FOLDER
     echo "---------Installing Dependencies--------"
     npm install
     echo "--------Creating .env file.............."
     touch .env
     echo "BASE_URL =$BASE_URL" >> .env
}
	
function setUpNginx(){
    cd ~
    cd /etc/nginx/sites-available
    echo '--------Removing existent configuration files------'
    if [[ -e "default" ]]; then
       sudo rm default
       sudo touch customconfig
    else
       sudo touch customconfig
    fi
    echo '-------Adding custom configurations--------'
    sudo bash -c 'cat > customconfig << EOF
    server {
    listen 80;
    location / {
      proxy_pass http://localhost:3000;
    }
  }
EOF'
   # Create a symlink between file in sites-available and that in sites-enabled
   cd ~
   if [ -f "/etc/nginx/sites-enabled/customconfig" ];then
      sudo rm /etc/nginx/sites-enabled/customconfig
      sudo ln -s /etc/nginx/sites-available/customconfig /etc/nginx/sites-enabled/customconfig
   else
      sudo ln -s /etc/nginx/sites-available/customconfig /etc/nginx/sites-enabled/customconfig
  fi
   # Test nginx configuration
  sudo nginx -t
  # Start nginx
  sudo systemctl start nginx
  echo "-------Nginx configuration successful-----"
}
function installPm2(){
	sudo npm install -g pm2
}
function startApplication(){
     cd $REPO_FOLDER
     npm run build
     sudo pm2 start -f server.js
     echo "...APPLICATION DEPLOYMENT SUCCESSFUL....."
     echo "....Please navigate the address below and find your deployed application..."
     sudo curl ifconfig.co 
}
main(){
    updateInstance
    install
    cloneRepo
    setUpProjectEnvironment
    setUpNginx
    installPm2
    startApplication
}

main
