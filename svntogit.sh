#!/bin/bash


svn_create() {
svn co http://10.0.0.27/$line  /opt/svn/$line
if [ -d "/opt/svn/$line" ]; then
  echo " Svn checkout already Exists , Please try once again"
  exit
   else
      cd /opt/svn/$line
      touch /etc/httpd/$line.txt
   svn log -q | awk -F '|' '/^r/ {sub("^ ", "", $2); sub(" $", "", $2); print $2" "}' | sort -u > /etc/httpd/$line.txt
   cat /etc/httpd/$line.txt |tr "\n" " " > /etc/httpd/$line.txt
   sed -i -e 's/^/Require ldap-user jayant.bhagat /' /etc/httpd/$line.txt
   find . -name "*.svn" --exec rm -rf {}\;

fi
}


git_create() {
cd /var/www/git
if [ -d "$line" ]; then
  echo " Svn Repo Name Already Exists , Please Enter Unic Name"
 exit  
  else
 mkdir -p /var/www/git/$line && cd /var/www/git/$line
 git init --bare --shared
 git config --file config http.receivepack true
 chown -R apache:apache /var/www
fi

cd /etc/httpd/conf.d

if [ -f "$line.conf" ]; then
  echo " Svn configuration file Already Exists , Please Enter Unic Name"
  else
touch $line.conf
fi
echo " Inserting svn Configuration Line TO conf File"

sleep 2

cat > $line.conf << EOL

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
            Include $line.txt
#            Satisfy any
   </LocationMatch>


EOL

}

git_push() {
cd /root/$line
git init
git add --all
git remote add origin http://10.0.0.29/git/$line
git commit -am "changes in git"
git push origin master
cd && rm -rf /root/$line
}

while read line
do
svn_create
#git_create
#git_push
done</root/list.txt
