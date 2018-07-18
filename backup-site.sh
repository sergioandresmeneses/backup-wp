#!/bin/bash
if [ $# -lt 1 ] ; then
       echo "Please type the name of your site"
        exit 1
fi

site=`echo $1 | tr [A-Z] [a-z]`
echo "site: $site"
if [ ! -f /etc/nginx/sites-enabled/$site ] ||  [ ! -f /etc/apache2/sites-available/$site ] ; then
        echo "The site is not configured in the server"
        exit 1
fi

echo "The site to backup is $1..."

siteFolder="/var/www/$1"
echo "siteFolder: $siteFolder"
[ -d "$siteFolder" ] || echo "The site doesn't have a folder at /var/www/ ... closing process"

#backupFolder="/var/backups"
#[ -d "$backupFolder"] || mkdir "$backupFolder"

##End of the Script
exit 0
