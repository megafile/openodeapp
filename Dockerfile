FROM alpine:latest
RUN apk add --no-cache --virtual .build-deps ca-certificates nginx curl wget unzip git

ENV V2_UUID="953ecf9e-dfe8-4016-afa2-ea66a02b4bd5" V2_PATH="ws" V2_PORT=34567
ENV NGINX_HTTP_PORT=8080

RUN mkdir /tmp/v2ray
RUN curl -L -H "Cache-Control: no-cache" -o /tmp/v2ray/v2ray.zip https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip
RUN unzip /tmp/v2ray/v2ray.zip -d /tmp/v2ray
RUN install -m 755 /tmp/v2ray/v2ray /usr/local/bin/v2ray
RUN install -m 755 /tmp/v2ray/v2ctl /usr/local/bin/v2ctl

# Remove temporary directory
RUN rm -rf /tmp/v2ray

# V2Ray configuration directory
RUN install -d /usr/local/etc/v2ray

RUN mkdir /run/nginx
ADD default.conf /etc/nginx/conf.d/default.conf
ADD index.html /var/lib/nginx/html/index.html

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE $NGINX_HTTP_PORT

ENTRYPOINT ["/entrypoint.sh"]
