FROM php:8.2-fpm-alpine

# 1. ຕິດຕັ້ງສ່ວນເສີມສຳລັບເຊື່ອມຕໍ່ MySQL ຖານຂໍ້ມູນ
RUN docker-php-ext-install pdo pdo_mysql mysqli

# 2. ຕິດຕັ້ງ Nginx ເວັບເຊີເວີ
RUN apk add --no-cache nginx

# 3. ສ້າງຄອນຟິກໃຫ້ Nginx ຣັນໃນ Port 8080 ແລະ ສົ່ງຫາ PHP
RUN mkdir -p /run/nginx && \
    echo 'server { \
        listen 8080; \
        root /var/www/html; \
        index index.php index.html; \
        location / { try_files $uri $uri/ /index.php?$query_string; } \
        location ~ \.php$ { \
            fastcgi_pass 127.0.0.1:9000; \
            fastcgi_index index.php; \
            include fastcgi_params; \
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name; \
        } \
    }' > /etc/nginx/http.d/default.conf

# 4. ກັອບປີ້ໄຟລ໌ເວັບທັງໝົດເຂົ້າ Container
COPY . /var/www/html/

# 5. ບັງຄັບໃຫ້ເປີດໃຊ້ງານທັງ PHP-FPM ແລະ Nginx ພ້ອມກັນ
CMD php-fpm -D && nginx -g "daemon off;"
EXPOSE 8080
