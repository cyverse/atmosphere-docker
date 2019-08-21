FROM calvinmclean/atmosphere:remote-celery

WORKDIR /root
COPY . .

RUN cp flower.initd /etc/init.d/flower && \
    cp celeryd.initd /etc/init.d/celeryd && \
    cp celerybeat.initd /etc/init.d/celerybeat && \
    chmod -R 755 /etc/init.d

RUN chmod +x ./entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]
