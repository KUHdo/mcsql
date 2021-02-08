FROM alpine:3.13

RUN \
    apk add --no-cache mysql-client mariadb-connector-c && \
    wget https://dl.min.io/client/mc/release/linux-amd64/mc -O /usr/local/bin/mc && \
    chmod +x /usr/local/bin/mc

ADD entrypoint.sh /usr/local/bin

WORKDIR /data

ENTRYPOINT [ "entrypoint.sh" ]
CMD ["run"]
