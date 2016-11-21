echo -e "\n---- Install python pakages ----"
sudo apt-get install python-pip python-dev build-essential libpq-dev poppler-utils antiword libldap2-dev libsasl2-dev libssl-dev git python-dateutil python-feedparser python-gdata python-ldap python-lxml python-mako python-openid python-psycopg2 python-pychart python-pydot python-pyparsing python-reportlab python-tz python-vatnumber python-vobject python-webdav python-xlwt python-yaml python-zsi python-docutils wget python-unittest2 python-mock python-jinja2 libevent-dev bzr subversion python-svn libxslt1-dev libfreetype6-dev libjpeg8-dev python-werkzeug wkhtmltopdf libjpeg-dev nginx libcups2-dev python-cups -y


echo -e "\n---- Install wkhtml and place on correct place for ODOO 8 ----"
sudo wget http://download.gna.org/wkhtmltopdf/0.12/0.12.2.1/wkhtmltox-0.12.2.1_linux-trusty-amd64.deb
sudo dpkg -i wkhtmltox-0.12.2.1_linux-trusty-amd64.deb
sudo apt-get install -f -y


echo -e "\n---- Install PostgreSQL Server ----"
sudo apt-get install postgresql -y


echo -e "\n---- Creating postgres user named odoo ----"
sudo -u postgres createuser odoo80 -P -d


echo -e "\n---- Download and install odoo----"
git clone -b 8.0 https://github.com/odoo/odoo.git server
cd server
python setup.py install


echo -e "\n---- Creating odoo.conf ----"
odoo.py -c odoo.conf -s


echo -e "\n---- Edit generated file odoo.conf ---"

sed -i s/"db_host = False"/"db_host = localhost"/g odoo.conf
sed -i s/"db_port = False"/"db_port = 5432"/g odoo.conf
sed -i s/"db_user = False"/"db_user = odoo"/g odoo.conf
sed -i s/"db_password = False"/"db_password = odoo"/g odoo.conf


echo -e "\n---- Install Git ----"
sudo apt-get install git -y


echo -e "\n---- Install AerooLib ----"
sudo apt-get install python-genshi python-cairo python-lxml libreoffice-script-provider-python libreoffice-base python-cups -y
sudo apt-get install python-setuptools python3-pip -yf
sudo mkdir /opt/aeroo
cd /opt/aeroo
sudo git clone https://github.com/aeroo/aeroolib.git
cd /opt/aeroo/aeroolib
sudo python setup.py install


echo -e "\n---- create init script for LibreOffice (Headless Mode) ----"
sudo touch /etc/init.d/office
sudo su root -c "echo '### BEGIN INIT INFO' >> /etc/init.d/office"
sudo su root -c "echo '# Provides:          office' >> /etc/init.d/office"
sudo su root -c "echo '# Required-Start:    $remote_fs $syslog' >> /etc/init.d/office"
sudo su root -c "echo '# Required-Stop:     $remote_fs $syslog' >> /etc/init.d/office"
sudo su root -c "echo '# Default-Start:     2 3 4 5' >> /etc/init.d/office"
sudo su root -c "echo '# Default-Stop:      0 1 6' >> /etc/init.d/office"
sudo su root -c "echo '# Short-Description: Start daemon at boot time' >> /etc/init.d/office"
sudo su root -c "echo '# Description:       Enable service provided by daemon.' >> /etc/init.d/office"
sudo su root -c "echo '### END INIT INFO' >> /etc/init.d/office"
sudo su root -c "echo '#! /bin/sh' >> /etc/init.d/office"
sudo su root -c "echo '/usr/bin/soffice --nologo --nofirststartwizard --headless --norestore --invisible \"--accept=socket,host=localhost,port=8100,tcpNoDelay=1;urp;\" &' >> /etc/init.d/office"


# Setup Permissions and test LibreOffice Headless mode connection


sudo chmod +x /etc/init.d/office
sudo update-rc.d office defaults


# Install AerooDOCS
echo -e "\n---- Install AerooDOCS (see: https://github.com/aeroo/aeroo_docs/wiki/Installation-example-for-Ubuntu-14.04-LTS for original post): ----"


sudo pip3 install jsonrpc2 daemonize


echo -e "\n---- create conf file for AerooDOCS ----"
sudo touch /etc/aeroo-docs.conf
sudo su root -c "echo '[start]' >> /etc/aeroo-docs.conf"
sudo su root -c "echo 'interface = localhost' >> /etc/aeroo-docs.conf"
sudo su root -c "echo 'port = 8989' >> /etc/aeroo-docs.conf"
sudo su root -c "echo 'oo-server = localhost' >> /etc/aeroo-docs.conf"
sudo su root -c "echo 'oo-port = 8100' >> /etc/aeroo-docs.conf"
sudo su root -c "echo 'spool-directory = /tmp/aeroo-docs' >> /etc/aeroo-docs.conf"
sudo su root -c "echo 'spool-expire = 1800' >> /etc/aeroo-docs.conf"
sudo su root -c "echo 'log-file = /var/log/aeroo-docs/aeroo_docs.log' >> /etc/aeroo-docs.conf"
sudo su root -c "echo 'pid-file = /tmp/aeroo-docs.pid' >> /etc/aeroo-docs.conf"
sudo su root -c "echo '[simple-auth]' >> /etc/aeroo-docs.conf"
sudo su root -c "echo 'username = anonymous' >> /etc/aeroo-docs.conf"
sudo su root -c "echo 'password = anonymous' >> /etc/aeroo-docs.conf"


cd /opt/aeroo
sudo git clone https://github.com/aeroo/aeroo_docs.git
sudo touch /etc/init.d/office
sudo python3 /opt/aeroo/aeroo_docs/aeroo-docs start -c /etc/aeroo-docs.conf
sudo ln -s /opt/aeroo/aeroo_docs/aeroo-docs /etc/init.d/aeroo-docs
sudo update-rc.d aeroo-docs defaults
sudo service aeroo-docs restart


# If you encounter and error "Unable to lock on the pidfile while trying #16 just restart the service (sudo service aeroo-docs restart).


echo -e "\n---- Instalamos algunos paquetes pip que tipicamente son necesarios ---"
pip install genshi==0.6.1 BeautifulSoup geopy==0.95.1 odfpy werkzeug==0.8.3 http pyPdf xlrd


echo -e "\n---- Creamos una carpeta para otros repositoriso, descargamos los repositorios propuestos ---"
mkdir sources
cd sources
git clone https://github.com/ingadhoc/odoo-argentina
git clone https://github.com/ingadhoc/odoo-addons
git clone https://github.com/aeroo/aeroo_reports
git clone https://github.com/oca/server-tools
git clone https://github.com/oca/web


# Agregamos los paths correspondientes en el archivo odoo.conf
#addons_path = /usr/local/lib/python2.7/dist-packages/odoo-8.0-py2.7.egg/openerp/addons,
#/home/user/odoo/80/sources/aeroo_reports,
#/home/user/odoo/80/sources/odoo-addons,
#/home/user/odoo/80/sources/odoo-argentina,
#/home/user/odoo/80/sources/server-tools,
#/home/user/odoo/80/sources/web, 
#/home/user/odoo/80/server/addons

# Ahora estamos listos para utilizar nuestro odoo que debería levantar corriendo el comando
#odoo.py -c odoo.conf
