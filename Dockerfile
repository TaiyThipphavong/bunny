FROM php:8.2-fpm-alpine

# 1. ຕິດຕັ້ງສ່ວນເສີມສຳລັບເຊື່ອມຕໍ່ MySQL ຖານຂໍ້ມູນ ແລະ curl (ສຳລັບສົ່ງ SMS ຜ່ານ Twilio)
RUN apk add --no-cache curl-dev && docker-php-ext-install pdo pdo_mysql mysqli curl

# 2. ຕິດຕັ້ງ Nginx ເວັບເຊີເວີ ແລະ rsync (ສຳລັບຄືນຄ່າຮູບເດີມໃສ່ Volume ຕອນ container ເລີ່ມແລ່ນ)
RUN apk add --no-cache nginx rsync

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

# 4b. ເກັບສຳເນົາຮູບທີ່ມາພ້ອມກັບໂຄ້ດໄວ້ນອກເສັ້ນທາງ Volume (uploads/) ເພື່ອນຳມາຄືນຄ່າຕອນ
#     container ເລີ່ມແລ່ນ ຖ້າ Volume ຍັງບໍ່ມີໄຟລ໌ນັ້ນ (Volume mount ຈະທັບຮູບເດີມທັງໝົດ)
RUN cp -r /var/www/html/uploads /var/www/html/uploads-seed

# 5. ເປີດສິດໃຫ້ລະບົບສາມາດຂຽນ ແລະ ອ່ານໄຟລ໌ຮູບພາບໃນໂຟນເດີອັບໂຫລດໄດ້ 100%
RUN mkdir -p /var/www/html/uploads && chmod -R 777 /var/www/html/uploads

# 6. ຕອນ container ເລີ່ມແລ່ນ: ຄືນຄ່າຮູບເດີມທີ່ຂາດຫາຍໄປໃສ່ Volume ກ່ອນ (ບໍ່ທັບຮູບທີ່ອັບໂຫລດໄວ້ແລ້ວ),
#    ແລ້ວຈຶ່ງຕັ້ງສິດຂຽນໄຟລ໌ (ຕ້ອງເຮັດ "ຫຼັງ" rsync ສະເໝີ ເພາະ rsync ຈະເອົາສິດເກົ່າຈາກ image
#    ມາທັບໃສ່ໄຟລ໌/ໂຟນເດີທີ່ມັນສ້າງ), ແລ້ວເປີດໃຊ້ງານ PHP-FPM ແລະ Nginx
CMD rsync -r --ignore-existing /var/www/html/uploads-seed/ /var/www/html/uploads/ && chmod -R 777 /var/www/html/uploads && php-fpm -D && nginx -g "daemon off;"
EXPOSE 8080
