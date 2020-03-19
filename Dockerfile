FROM alpine:edge
WORKDIR /opt
RUN apk add --no-cache mongodb-tools && \
    wget "https://dl.min.io/client/mc/release/linux-amd64/mc"  && \
    mv mc /usr/local/bin/ && \
    chmod +x /usr/local/bin/mc && \
    adduser -D mongo
USER mongo
COPY entrypoint.sh .
ENTRYPOINT ["/opt/entrypoint.sh"]
