#!/bin/bash

# Creating Cvn Project Name
echo "Enter the Svn Projectname you want to create"

read -p"Enter Svn Folder name:" svnproject

cd /srv/svn
if [ -d "$svnproject" ]; then
  echo " Svn Repo Name Already Exists , Please Enter Unic Name"
  
  exit  

  else
svnadmin create $svnproject
fi
cd /etc/httpd/conf.d
echo "Enter the Svnapache filename you want to create"
read -p "Enter file Name:" svnconf
if [ -f "$svnconf.conf" ]; then
  echo " Svn configuration file Already Exists , Please Enter Unic Name"
  else
touch $svnconf.conf
fi
echo " Inserting svn Configuration Line TO conf File"

sleep 2

cat > $svnconf.conf << EOL
<Location /$svnproject> 

DAV svn 

SVNPath /srv/svn/$svnproject 

Order deny,allow
Deny from all
Allow from 10.0.0.0/24

AuthType Basic
AuthName "SVN Auth"
AuthBasicProvider "ldap"
AuthLDAPURL ldap://nmg-new-dc.newmediaguruorg.com:3268/DC=newmediaguruorg,DC=com?sAMAccountName?sub?(objectClass=user)
AuthLDAPBindDN     
AuthLDAPBindPassword 
authzldapauthoritative Off
AuthzSVNAccessFile /etc/svn/$svnconf
require valid-user 

</Location>
EOL


#svnadmin create $svnproject

echo " Enter numer of user you want to Allow "
read  a
touch /etc/svn/$svnconf
echo '[/]' > /etc/svn/$svnconf
i=0
for (( i=1; i <= $a; i++ ))
do
read -p "enter the username:" username

echo "inserting username to file svn configuration file"

echo  $username = rw >> /etc/svn/$svnconf

done
chown -R apache:apache /srv/svn/$svnproject
chcon -h system_u:object_r:httpd_sys_content_t /srv/svn/$svnproject
chcon -R -h apache:object_r:httpd_sys_content_t /srv/svn/$svnproject
service httpd restart
chkconfig httpd on

