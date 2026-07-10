FROM php:8.2-apache

# 1. ຕິດຕັ້ງສ່ວນເສີມສຳລັບເຊື່ອມຕໍ່ MySQL
RUN docker-php-ext-install pdo pdo_mysql mysqli

# 2. ຕັ້ງຄ່າໃຫ້ Apache ຣັນໃນ Port 8080 (ເພື່ອໃຫ້ລະບົບ Railway ເຂົ້າເຖິງໄດ້)
RUN sed -i 's/Listen 80/Listen 8080/g' /etc/apache2/ports.conf
RUN sed -i 's/<VirtualHost \*:80>/<VirtualHost \*:8080>/g' /etc/apache2/sites-available/000-default.conf

# 3. ກັອບປີ້ໄຟລ໌ເວັບທັງໝົດເຂົ້າ Container
COPY . /var/www/html/

# 4. ເປີດພອດ 8080
EXPOSE 8080
