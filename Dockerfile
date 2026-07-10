FROM php:8.2-fpm-alpine

# ຕິດຕັ້ງສ່ວນເສີມສຳລັບເຊື່ອມຕໍ່ MySQL
RUN docker-php-ext-install pdo pdo_mysql mysqli

# ກັອບປີ້ໄຟລ໌ທັງໝົດເຂົ້າ Container
COPY . /var/www/html/

# ບັງຄັບໃຫ້ຣັນ PHP Server ພາຍໃນ ໂດຍໃຊ້ Port 80
CMD ["php", "-S", "0.0.0.0:80", "-t", "/var/www/html"]
EXPOSE 80
