FROM php:8.2-fpm-alpine

# 1. ຕິດຕັ້ງສ່ວນເສີມສຳລັບເຊື່ອມຕໍ່ MySQL ຖານຂໍ້ມູນ ແລະ curl (ສຳລັບສົ່ງ SMS ຜ່ານ Twilio)
RUN apk add --no-cache curl-dev && docker-php-ext-install pdo pdo_mysql mysqli curl

# 2. ຕິດຕັ້ງ Nginx ເວັບເຊີເວີ
RUN apk add --no-cache nginx

# 3. ປັບຄອນຟິກ Nginx ໃຫ້ຮອງຮັບໂຟນເດີຍ່ອຍທັງໝົດ
RUN mkdir -p /run/nginx && \
    echo 'server { \
        listen 8080; \
        root /var/www/html; \
        index index.php index.html; \
        location / { \
            try_files $uri $uri/ =404; \
        } \
        location ~ \.php$ { \
            fastcgi_pass 127.0.0.1:9000; \
            fastcgi_index index.php; \
            include fastcgi_params; \
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name; \
        } \
    }' > /etc/nginx/http.d/default.conf

# 4. ກັອບປີ້ໄຟລ໌ເວັບທັງໝົດເຂົ້າ Container
COPY . /var/www/html/

# 5. ເປີດສິດໃຫ້ລະບົບສາມາດຂຽນ ແລະ ອ່ານໄຟລ໌ຮູບພາບໃນໂຟນເດີອັບໂຫລດໄດ້ 100%
RUN mkdir -p /var/www/html/uploads && chmod -R 777 /var/www/html/uploads

# 6. ຕັ້ງສິດຂຽນໄຟລ໌ໃໝ່ທຸກຄັ້ງທີ່ container ເລີ່ມແລ່ນ (Volume ຈະທັບສິດເກົ່າຕອນ mount)
#    ແລ້ວເປີດໃຊ້ງານທັງ PHP-FPM ແລະ Nginx ພ້ອມກັນ
CMD chmod -R 777 /var/www/html/uploads && php-fpm -D && nginx -g "daemon off;"
EXPOSE 8080
