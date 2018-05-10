#!/bin/bash
centos=`cat /etc/redhat-release  | cut -d ' ' -f 1`
amilinux=`cat /etc/os-release  | head -1 | cut -d"=" -f  2 | sed 's/"//g'`
ubuntu=`cat /etc/os-release  | head -1 | cut -d"=" -f  2 | sed 's/"//g'`
apacheconf='/etc/apache2/sites-available/000-default.conf'
ubuntu1='lsb-release -$1'
#dppassword='bKjB3VxNmk'
#dbname="nmglivedb"
read -p " Insert db name here:" dbname
read -p " Insert Password here" dbpass

if [ $(id -u) -ne 0 ]
then
   echo " please login through root"
   exit
else
   echo " You are root"
fi

centos_update () {

yum -y install wget
wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
wget http://rpms.remirepo.net/enterprise/remi-release-6.rpm
rpm -Uvh remi-release-6.rpm epel-release-latest-6.noarch.rpm
yum -y  install yum-utils
yum-config-manager --enable remi-php72
yum -y install httpd
yum -y install php
yum -y install php-intl
yum -y install php-mysql
yum -y install php-mbstring
yum -y install php-mcrypt
rm -f /etc/httpd/conf.d/welcome.conf
rm -f /var/www/error/noindex.html 
ln -s /usr/bin/perl /usr/local/bin/perl
sed -i -e 's/ServerTokens Os/ServerTokens Prod/g' /etc/httpd/conf/httpd.conf
sed -i -e 's/KeepAlive Off/ KeepAlive On/g' /etc/httpd/conf/httpd.conf
sed -i -e 's/KeepAlive Off/ KeepAlive On/g' /etc/httpd/conf/httpd.conf
    
}   

ubuntu_install () {
apt-get -y update
apt-get -i install apache2
a2enmod rewrite
apt-get install python-software-properties
add-apt-repository -y ppa:ondrej/php
apt-get -y update
apt-get -y install  php7.2
apt-get -y  install  php7.2-intl 
apt-get -y  install php7.2-mysqlnd
apt-get -y  install php7.2-mbstring
apt-get -y  install php7.2-gd
apt-get -y  install php7.2-xml
apt-get -y  install php7.2-mcrypt
apt-get -y install vsftpd
sed -i -e 's/anonymous_enable=YES/ anonymous_enable=NO/g' /etc/vsftpd.conf
sed -i -e 's/listen=NO/ listen=YES/g' /etc/vsftpd.conf
sed -i -e  's/listen=NO/ listen=YES/g' /etc/vsftpd.conf
sed -i -e 's|#xferlog_file=/var/log/vsftpd.log|xferlog_file=/var/log/vsftpd.log|g' /etc/vsftpd.conf
sed -i -e 's|#chroot_local_user=YES|chroot_local_user=YES|g' /etc/vsftpd.conf
sed -i -e 's|auth   required        pam_shells.so|auth   required        pam_shells.so|g' /etc/pam.d/vsftpd

echo 'pasv_enable=YES' >> /etc/vsftpd.conf
echo 'pasv_min_port=40000' >> /etc/vsftpd.conf
echo 'pasv_min_port=40100' >> /etc/vsftpd.conf
echo 'port_enable=YES' >> /etc/vsftpd.conf
echo 'allow_writeable_chroot=YES'  >> /etc/vsftpd.conf

service :vsftpd restart

wget http://repo.mysql.com/mysql-apt-config_0.8.9-1_all.deb
dpkg -i mysql-apt-config_0.8.9-1_all.deb
apt-get -y update
apt-get -y install mysql-server








cat > $apacheconf << EOL
<VirtualHost *:80>
        

        DocumentRoot /var/www/html
         <Directory /var/www/html>
                Options Indexes FollowSymLinks MultiViews
                AllowOverride All
                Order allow,deny
                allow from all
        </Directory>

        
        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

        
</VirtualHost>
EOL

touch /tmp/setup.sql
mysqladmin -u root password '$dppass'

cat >/tmp/setup.sql << EOL
create database $dbanme;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY "$DBPASS";
FLUSH PRIVILEGES;
 
EOL

#Create database

mysql -uroot -p'$dbpass' < '/tmp/setup.sql'

 }

if [ "$amilinux" = "Amazon Linux AMI" || "$centos" = "Centos" ]
then
    
centos_update 

elif [ "$ubuntu" = "Ubuntu" ]
then
ubuntu_install

else

echo " No matching Os is found"
    
fi
