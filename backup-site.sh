#!/bin/bash
function backup() {

  if [[ -d /var/www/$site ]]; then
    echo "=== Backing up the site $site ==="
    echo "...backup in progress..."

    wpconfipath=$(find /var/www/$site -name 'wp-config.php' -type f -print)
    if [[ $? ]]; then
      echo "Doing the dabatase backup...."
      DB_NAME=$(grep DB_NAME $wpconfipath | awk -F"'" '{print $4}')
      DB_USER=$(grep DB_USER $wpconfipath | awk -F"'" '{print $4}')
      DB_PASSWORD=$(grep DB_PASSWORD $wpconfipath | awk -F"'" '{print $4}')
      mysqldump -u $DB_USER $DB_NAME -p$DB_PASSWORD > DB-$DB_NAME.sql
    else
      echo "WP-cofig.php file not present at the site root... backing up only the files!"
    fi
    zip -r backup-$site.zip /var/www/$site DB-$DB_NAME.sql
    exit 0
  fi
}

function validation() {

  if [[ "$(id -u)" != "0" ]]; then
          echo "root privileges are required to run this script."
          exit 1
        fi

  if [ $# -lt 1 ] ; then
        echo "Please type the name of your site"
        exit 1
  fi

  #Format the site domain into lowercase
  site=$(echo $1 | tr [A-Z] [a-z])
  echo "The site: $site is going to be prepared for backup!"
  echo "..."

  #Check if Apache is the webserver in place
  if $(service apache2 status > /dev/null); then
    echo "Your webserver is Apache..."
    if [[ -f /etc/apache2/sites-available/$site ]]; then
      echo "The site: $site is going to be prepared for backup!"
      backup
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
