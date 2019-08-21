FROM python:2.7-slim-stretch

# Install dependencies with apt
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y  \
      python-psycopg2 \
      sudo && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /root
COPY . .

RUN useradd user
RUN cp flower.initd /etc/init.d/flower && \
    cp celeryd.initd /etc/init.d/celeryd && \
    cp celerybeat.initd /etc/init.d/celerybeat && \
    chmod -R 755 /etc/init.d

RUN chmod +x ./entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]
