## Docker版本的EasyImage2.0

在 [DDS-Derek](https://github.com/DDS-Derek)/[**EasyImage**](https://github.com/DDS-Derek/EasyImage) 的基础上只保留了amd64位版本

在原来项目 [icret](https://github.com/icret)/[**EasyImages2.0**](https://github.com/icret/EasyImages2.0) 的基础上去掉了 `config.php` 、 `EasyImage.js`  的百度统计

具体修改见：[EasyImages2.0](https://github.com/BaeKey/EasyImages2.0/commits/master)

## 使用docker-compose

docker-compose

```bash
version: '3.3'
services:
  easyimage:
    image: shiguang2021/easyimage:latest
    container_name: easyimage
    ports:
      - 80:80
      - 443:443
    volumes:
      - ./data/easyimages/config:/app/web/config
      - ./data/easyimages/i:/app/web/i
      - ./data/nginx/conf.d:/etc/nginx/conf.d
    restart: unless-stopped
```
## Nginx 配置文件示例

```
server {
        listen       80;
        listen  [::]:80;

        # 域名
        server_name  example.com;

        client_max_body_size 512M;
        sendfile on;
        location / {
          return 301 https://$host$request_uri;
        }
}
    server {
        listen 443 ssl http2;
        listen [::]:443 ssl http2;
        # 域名
        server_name example.com;
        # 证书文件，在 docker-compose 映射出来的 nginx/conf.d 目录下建立 certs 目录
        ssl_certificate /etc/nginx/conf.d/certs/example.com.crt;
        ssl_certificate_key /etc/nginx/conf.d/certs/example.com.key;

        add_header X-Request-ID $request_id;
        root   /app/web;
        index  index.php index.html;

        ssl_session_timeout 5m;
        ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
        ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:HIGH:!aNULL:!MD5:!RC4:!DHE;
        ssl_prefer_server_ciphers on;
        client_max_body_size 512M;
        sendfile on;

        location ~* ^/(i|public)/.*\.(php|php5)$ {
            deny all;
        }

        location ~ \.php$ {
            fastcgi_pass   unix:/var/run/php-fpm.sock;
            fastcgi_index  index.php;
            fastcgi_param  SCRIPT_FILENAME  /$document_root$fastcgi_script_name;
            fastcgi_param  X_REQUEST_ID  $request_id;
            include        fastcgi_params;
            fastcgi_read_timeout 180s;
        }
    }
```

## 更新

```bash
docker-compose pull
docker-compose up -d
docker exec -it easyimage rm -rf /app/web/install
```
