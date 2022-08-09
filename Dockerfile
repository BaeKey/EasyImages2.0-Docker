FROM taobig/nginx-php74:focal_fossa

ENV TAG=2.6.6

ADD start.sh /

WORKDIR /opt

RUN apt update && apt install -y unzip wget && \
    wget --no-check-certificate https://github.com/BaeKey/EasyImages2.0/archive/refs/tags/${TAG}.zip && \
    unzip ${TAG}.zip && \
    mv /opt/EasyImages2.0-${TAG} /opt/web && \
    cp -r /opt/web /app && \
    cp -r /opt/web/config / && \
    cp -r /opt/web/i / && \
    rm -rf /opt && \
    apt-get remove -y wget zip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    chmod 755 start.sh

WORKDIR /app/web
