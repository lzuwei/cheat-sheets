"""
vim /etc/apache2/sites-available/jenkins.conf
"""

<VirtualHost *:80>
ServerName [DNS NAME of EC2]
ProxyRequests Off
<Proxy *>
Order deny,allow
Allow from all
</Proxy>
ProxyPreserveHost on
ProxyPass / http://localhost:8080/
</VirtualHost>

"""
sudo a2ensite jenkins
sudo service apache2 reload
"""
