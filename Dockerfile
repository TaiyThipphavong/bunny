FROM php:8.2-fpm-alpine

# 1. ติดตั้งไดรเวอร์สำหรับเชื่อมต่อ MySQL ฐานข้อมูล
RUN docker-php-ext-install pdo pdo_mysql mysqli

# 2. ติดตั้ง Nginx เว็บเซิร์ฟเวอร์
RUN apk add --no-cache nginx

# 3. ปรับคอนฟิก Nginx ให้รองรับโฟลเดอร์ย่อยทั้งหมด
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

# 4. คัดลอกโค้ดเว็บทั้งหมดเข้า Container
COPY . /var/www/html/

# 5. เปิดสิทธิ์ให้ระบบสามารถเขียนและอ่านไฟล์รูปภาพในโฟลเดอร์อัปโหลดได้ 100%
RUN mkdir -p /var/www/html/uploads && chmod -R 777 /var/www/html/uploads

# 6. เปิดใช้งานทั้ง PHP-FPM และ Nginx พร้อมกัน
CMD php-fpm -D && nginx -g "daemon off;"
EXPOSE 8080
