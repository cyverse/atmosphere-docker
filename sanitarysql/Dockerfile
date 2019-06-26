FROM alpine:latest

RUN apk update && \
    apk add openssh postgresql
RUN echo -e 'PermitRootLogin no\n\
AllowGroups users root\n\
PrintMotd no' >> /etc/ssh/sshd_config
RUN ssh-keygen -A

COPY crontab /etc/crontabs/sanitarysql

# Create user and unlock password-less account
RUN adduser -D -s '/home/sanitarysql/cat-sql-dump.sh' -G users sanitarysql &&\
    sed -i s/sanitarysql:!/"sanitarysql:*"/g /etc/shadow

COPY *.sh /home/sanitarysql/

RUN chmod +x /home/sanitarysql/*.sh &&\
    mkdir /home/sanitarysql/.ssh &&\
    chown -R sanitarysql /home/sanitarysql &&\
    echo "no sanitized dumps present yet" > /tmp/atmo_prod-sanitized.sql

EXPOSE 22
CMD sed -i "s/NFS_PORT/${NFS_PORT}/" /etc/crontabs/sanitarysql &&\
    sed -i "s/NFS_HOST/${NFS_HOST}/" /etc/crontabs/sanitarysql &&\
    crontab /etc/crontabs/sanitarysql &&\
    cp /root/.ssh/authorized_keys /home/sanitarysql/.ssh/authorized_keys &&\
    /home/sanitarysql/sanitize-dump.sh &&\
    /usr/sbin/sshd -D
