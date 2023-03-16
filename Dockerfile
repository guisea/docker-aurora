FROM debian:latest AS build
ARG TARGETARCH
ARG AURORA_VERSION="2.2"

ADD https://github.com/xuri/aurora/releases/download/2.2/aurora_linux_${TARGETARCH}_v${AURORA_VERSION}.tar.gz /opt/aurora_linux_${TARGETARCH}_v${AURORA_VERSION}.tar.gz

RUN tar xzvf /opt/aurora_linux_${TARGETARCH}_v${AURORA_VERSION}.tar.gz -C /opt && mkdir -p /opt/conf

COPY conf/aurora.toml /opt/conf/aurora.toml

RUN \
    sed -i "s/127.0.0.1/0.0.0.0/g" /opt/conf/aurora.toml



FROM scratch

COPY --from=build /opt /opt

EXPOSE 3000
VOLUME /opt/conf
ENTRYPOINT ["/opt/aurora", "-c", "/opt/conf/aurora.toml"]

