#!/bin/bash
function backup() {
  echo "Inside the function $site..."
  if [[ -d /var/www/$site ]]; then
    echo "backing up the site $site ...."
    echo "...backup in progress..."
    zip -r backup-$site.zip /var/www/$site
  fi
}

function validation() {

  if [ $# -lt 1 ] ; then
         echo "Please type the name of your site"
          exit 1
  fi

  #Format the site domain into lowercase
  site=`echo $1 | tr [A-Z] [a-z]`
  echo "The site: $site is going to be prepared for backup!"
  echo "..."

  #Check if Apache is the webserver in place
  #service apache2 status
  if [[ $(service apache2 status) ]]; then
    echo "Your webserver is Apache..."
    if [[ -f /etc/apache2/sites-available/$site ]]; then
      echo "The site: $site is going to be prepared for backup!"
      #Backup site!
    else
      echo "The site: $site is not properly configured on the server!"
      exit 1
    fi
  fi

  #Checks if Nginx is the webserver in place.
  if [[ $(service nginx status) ]]; then
    echo "Your webserver is Nginx..."
    if [[ -f /etc/nginx/sites-enabled/$site ]]; then
      echo "The site: $site is going to be prepared for backup!"
      backup
    else
      echo "The site: $site is not properly configured on the server!"
      exit 1
    fi
  fi
}

validation $@
exit 0
