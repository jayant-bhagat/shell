#!/bin/bash

# Creating Cvn Project Name
echo "Enter the git project name you want to create"

read -p"Enter git Folder name:" gitproject

cd /var/www/git
if [ -d "$gitproject" ]; then
  echo " Svn Repo Name Already Exists , Please Enter Unic Name"
  
  exit  

  else
mkdir -p /var/www/git/$gitproject && cd /var/www/git/$gitproject
git init --bare --shared
git config --file config http.receivepack true
chown -R apache:apache /var/www
fi
cd /etc/httpd/conf.d
echo "Enter the Svnapache filename you want to create"
read -p "Enter file Name:" gitconf
if [ -f "$gitconf.conf" ]; then
  echo " Svn configuration file Already Exists , Please Enter Unic Name"
  else
touch $gitconf.conf
fi
echo " Inserting svn Configuration Line TO conf File"

sleep 2

cat > $gitconf.conf << EOL

SetEnv GIT_PROJECT_ROOT /var/www/git
 SetEnv GIT_HTTP_EXPORT_ALL
 ScriptAlias /git/ /usr/libexec/git-core/git-http-backend/

 <LocationMatch "^/git/$gitproject.*$">
            Options all
            Order deny,allow
            AuthType Basic
            AuthName "Staratafair git repository"
            AuthBasicProvider ldap
            AuthzLDAPAuthoritative on
            AuthLDAPURL ldap://nmg-new-dc.newmediaguruorg.com:3268/DC=newmediaguruorg,DC=com?sAMAccountName?sub?(objectClass=user)
            AuthLDAPBindDN     svnauth@NEWMEDIAGURUORG.COM
            AuthLDAPBindPassword svn0098#
            Include $gitconf.txt
#            Satisfy any
   </LocationMatch>


EOL

echo " Enter numer of user you want to Allow "
read username
touch /etc/httpd/$gitconf.txt
echo   Require ldap-user $username >> /etc/httpd/$gitconf.txt

service httpd restart
