#/bin/sh
sudo -s
yum install -y httpd php php-zlib php-iconv php-gd php-mbstring php-fileinfo php-curl php-mysql
systemctl enable httpd.service
systemctl start httpd
cd /var/www
wget www.wordpress.org/latest.zip
unzip latest.zip
rm latest.zip
mv wordpress/* html/
rm -r wordpress
chown -R apache:apache html/
apachectl start