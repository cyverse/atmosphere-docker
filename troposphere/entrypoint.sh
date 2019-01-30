#!/bin/bash

echo -e $SSH_KEY > /opt/my_key
chmod 600 /opt/my_key
echo -e "Host gitlab.cyverse.org\n\tStrictHostKeyChecking no\n\tIdentityFile /opt/my_key" >> ~/.ssh/config
git clone $SECRETS_REPO $SECRETS_DIR

# Setup Troposphere
source /opt/env/troposphere/bin/activate && \
pip install -r /opt/dev/troposphere/requirements.txt
chmod o+rw /opt/dev/troposphere/logs

cp $SECRETS_DIR/inis/troposphere.ini /opt/dev/troposphere/variables.ini
/opt/env/troposphere/bin/python /opt/dev/troposphere/configure

# Allow user to edit/delete logs
touch /opt/dev/troposphere/logs/troposphere.log
chown -R www-data:www-data /opt/dev/troposphere/logs
chmod o+rw /opt/dev/troposphere/logs

sed -i "s/^            api_root=settings.API_V2_ROOT,$/            api_root\=\'https\:\/\/nginx\/api\/v2\'\,/" /opt/dev/troposphere/troposphere/views/web_desktop.py
sed -i "s/^    url = .+$/    url = data.get('token_url').replace('guacamole','localhost',1)/" /opt/dev/troposphere/troposphere/views/web_desktop.py

# Configure and run nginx
. $SECRETS_DIR/tropo_vars.env
echo "cp $TLS_BYO_PRIVKEY_DIR /etc/ssl/private/localhost.key"
cp $TLS_BYO_PRIVKEY_DIR /etc/ssl/private/localhost.key
echo "cp $TLS_BYO_CERT_DIR /etc/ssl/certs/localhost.crt"
cp $TLS_BYO_CERT_DIR /etc/ssl/certs/localhost.crt
echo "cp $TLS_BYO_CACHAIN_DIR /etc/ssl/certs/localhost.cachain.crt"
cp $TLS_BYO_CACHAIN_DIR /etc/ssl/certs/localhost.cachain.crt
echo "cat /etc/ssl/certs/localhost.crt /etc/ssl/certs/localhost.cachain.crt > /etc/ssl/certs/localhost.fullchain.crt"
cat /etc/ssl/certs/localhost.crt /etc/ssl/certs/localhost.cachain.crt > /etc/ssl/certs/localhost.fullchain.crt
nginx

# Wait for DB to be active
echo "Waiting for postgres..."
while ! nc -z postgres 5432; do sleep 5; done

mkdir /opt/dev/troposphere/troposphere/tropo-static
/opt/env/troposphere/bin/python /opt/dev/troposphere/manage.py collectstatic --noinput --settings=troposphere.settings --pythonpath=/opt/dev/troposphere
/opt/env/troposphere/bin/python /opt/dev/troposphere/manage.py migrate --noinput --settings=troposphere.settings --pythonpath=/opt/dev/troposphere

cd /opt/dev/troposphere
npm install --unsafe-perm
npm run build --production

sudo su -l www-data -s /bin/bash -c "UWSGI_DEB_CONFNAMESPACE=app UWSGI_DEB_CONFNAME=troposphere /opt/env/troposphere/bin/uwsgi --daemonize2 /opt/dev/troposphere/logs/uwsgi.log --ini /usr/share/uwsgi/conf/default.ini --ini /etc/uwsgi/apps-enabled/troposphere.ini"
npm run serve -- --public localhost
