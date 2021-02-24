#!/bin/sh

# generate v2ray config file
cat << EOF > /usr/local/etc/v2ray/config.json
{
  "inbounds": [
    {
      "port": $V2_PORT,
      "listen": "127.0.0.1",
      "protocol": "vmess",
      "settings": {
        "clients": [
          {
            "id": "$V2_UUID",
            "alterId": 64
          }
        ]
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {
          "path": "/$V2_PATH"
        }
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    }
  ]
}
EOF

# match nginx forwarding port and path to v2ray
sed -i "s/NGINX_HTTP_PORT/$NGINX_HTTP_PORT/g" /etc/nginx/conf.d/default.conf
sed -i "s/V2_PATH/$V2_PATH/g" /etc/nginx/conf.d/default.conf
sed -i "s/V2_PORT/$V2_PORT/g" /etc/nginx/conf.d/default.conf

# Start Nginx
nginx

# Run V2Ray
/usr/local/bin/v2ray -config /usr/local/etc/v2ray/config.json

