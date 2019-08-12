FROM calvinmclean/atmosphere:remote-celery

RUN apt-get update && apt-get install -y redis-server

WORKDIR /root
COPY . .

RUN cp flower.initd /etc/init.d/flower && \
    cp celeryd.initd /etc/init.d/celeryd && \
    cp celerybeat.initd /etc/init.d/celerybeat && \
    chmod -R 755 /etc/init.d

RUN chmod +x ./entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]
