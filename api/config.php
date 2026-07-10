<?php
// ປ່ຽນມາໃຊ້ Host ແລະ Port ພາຍໃນຂອງ Railway ໃຫ້ຖືກຕ້ອງ
$host     = "mysql"; // ຫ້າມໃຊ້ kodama.proxy.rlwy.net
$user     = "root";
$password = "DOwJyCtfteqvSLPqqktvGGKHxnZLRiiq";
$database = "railway";
$port     = 3306;  // ພອດພາຍໃນຂອງ MySQL ຕ້ອງເປັນ 3306 (ຫ້າມໃຊ້ 57395)

try {
    // $conn = new PDO("mysql:host=$host;port=$port;dbname=$database;charset=utf8", $user, $password);
    // $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    // // เปลี่ยนเป็น $pdo ให้ตรงกับโค้ดตัวระบบหลัก
    $pdo = new PDO("mysql:host=$host;port=$port;dbname=$database;charset=utf8", $user, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

} catch(PDOException $e) {
    // ຫາກເຊື່ອມຕໍ່ບໍ່ຜ່ານ ໃຫ້ມັນພົ່ນ Error ອອກມາເທິງໜ້າຈໍຂາວໆທັນທີ
    die("Database Connection Failed: " . $e->getMessage());
}
?>
