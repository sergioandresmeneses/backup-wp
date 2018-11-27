#!/bin/bash
function backup() {
  echo "Inside the function $site..."
  if [[ -d /var/www/$site ]]; then
    echo "=== Backing up the site $site ==="
    echo "...backup in progress..."
    echo "Doing the dabatase backup...."
    DB_NAME=$(grep DB_NAME /var/www/$site/wp-config.php | awk -F"'" '{print $4}')
    DB_USER=$(grep DB_USER /var/www/$site/wp-config.php | awk -F"'" '{print $4}')
    DB_PASSWORD=$(grep DB_PASSWORD /var/www/$site/wp-config.php | awk -F"'" '{print $4}')
    mysqldump -u $DB_USER $DB_NAME -p$DB_PASSWORD > DB-$DB_NAME.sql
    zip -r backup-$site.zip /var/www/$site DB-$DB_NAME.sql
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
  if $(service apache2 status > /dev/null); then
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
  if $(service nginx status > /dev/null); then
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
