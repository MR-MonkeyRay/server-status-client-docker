FROM alpine:3.19.1
LABEL maintainer=mr.monkeyray@gmail.com description="A simple server monitoring tool's client"

WORKDIR /tmp
ENV RUST_BACKTRACE=1 \
    SERVER_HOST=127.0.0.1 \
    SERVER_PORT=8080 \
    USERNAME=user1 \
    GID=group1 \
    PASSWORD=changeme \
    ALIAS=unknown \
    INTERVAL=5 \
    HOST_TYPE=kvm \
    IP_SOURCE=ip-api.com

ARG VERSION=v1.8.1

RUN apk update \
&&  apk add --no-cache unzip curl vnstat iproute2 procps \
&&  curl -LO "https://github.com/zdz/ServerStatus-Rust/releases/download/${VERSION}/client-x86_64-unknown-linux-musl.zip" \
&&  unzip client-x86_64-unknown-linux-musl.zip \
&&  chmod +x stat_client \
&&  mv stat_client /usr/bin \
&&  rm -f client-x86_64-unknown-linux-musl.zip stat_client.service


ENTRYPOINT ["/bin/sh", "-c"]
CMD ["stat_client -a ${SERVER_HOST}:${SERVER_PORT}/report -g ${GID} -p ${PASSWORD} --alias=${ALIAS} --interval=${INTERVAL} -n -t ${HOST_TYPE} --ip-source ${IP_SOURCE}"]
