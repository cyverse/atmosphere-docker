#!/bin/bash

if test ! -d /opt/dev/troposphere/.git/
then
  >&2 echo "ERROR: Troposphere repository does not exist and is required"
  exit 1
fi
if test ! -d /opt/dev/atmosphere-docker-secrets/.git/
then
  >&2 echo "ERROR: Atmosphere-docker-secrets repository does not exist and is required"
  exit 1
fi

# Setup Troposphere
source /opt/env/troposphere/bin/activate && \
pip install -r /opt/dev/troposphere/requirements.txt
chmod o+rw /opt/dev/troposphere/logs

ln -s /opt/dev/atmosphere-docker-secrets/inis/troposphere.ini /opt/dev/troposphere/variables.ini
/opt/env/troposphere/bin/python /opt/dev/troposphere/configure

# Allow user to edit/delete logs
touch /opt/dev/troposphere/logs/troposphere.log
chown -R www-data:www-data /opt/dev/troposphere/logs
chmod o+rw /opt/dev/troposphere/logs

# Wait for DB to be active
echo "Waiting for postgres..."
while ! nc -z postgres 5432; do sleep 5; done

mkdir /opt/dev/troposphere/troposphere/tropo-static
/opt/env/troposphere/bin/python /opt/dev/troposphere/manage.py collectstatic --noinput --settings=troposphere.settings --pythonpath=/opt/dev/troposphere
/opt/env/troposphere/bin/python /opt/dev/troposphere/manage.py migrate --noinput --settings=troposphere.settings --pythonpath=/opt/dev/troposphere

cd /opt/dev/troposphere
npm install --unsafe-perm

if [[ $1 = "dev" ]]
then
  ln -s /etc/nginx/sites-available/site-dev.conf /etc/nginx/sites-enabled/site.conf
  nginx
  sed -i "s/^    url = .+$/    url = data.get('token_url').replace('guacamole','localhost',1)/" /opt/dev/troposphere/troposphere/views/web_desktop.py
  /opt/env/troposphere/bin/python /opt/dev/troposphere/manage.py runserver 0.0.0.0:8001 &
  npm run serve -- --public localhost
else
  npm run build --production
  ln -s /etc/nginx/sites-available/site-prod.conf /etc/nginx/sites-enabled/site.conf
  nginx
  sudo su -l www-data -s /bin/bash -c "UWSGI_DEB_CONFNAMESPACE=app UWSGI_DEB_CONFNAME=troposphere /opt/env/troposphere/bin/uwsgi --ini /usr/share/uwsgi/conf/default.ini --ini /etc/uwsgi/apps-enabled/troposphere.ini"
fi
