#!/bin/bash

# Get user_id variable if used
user_id=$1

if [ -z $user_id ]; then
  user_id=1000
else
  usermod -u $user_id user
  groupmod -g $user_id user
fi

chown -R $user_id:$user_id /opt/dev/atmosphere
if [[ $env_type = "dev" ]]
then
  sed -i "s/^bind 127.0.0.1 ::1$/bind 127.0.0.1/" /etc/redis/redis.conf
  sed -i "s/^CELERYD_USER=\"www-data\"$/CELERYD_USER=\"user\"/" /etc/init.d/celeryd
  sed -i "s/^CELERYD_GROUP=\"www-data\"$/CELERYD_GROUP=\"$user_id\"/" /etc/init.d/celeryd
  sed -i "s/^CELERY_USER=\"www-data\"$/CELERY_USER=\"user\"/" /etc/init.d/celerybeat
  sed -i "s/^CELERY_GROUP=\"www-data\"$/CELERY_GROUP=\"$user_id\"/" /etc/init.d/celerybeat
  chown -R $user_id:$user_id /opt/dev/atmosphere
else
  chown -R www-data:www-data /opt/dev/atmosphere
fi

service redis-server start
service celerybeat start
service celeryd start

tail -f /var/log/celery/*.log
