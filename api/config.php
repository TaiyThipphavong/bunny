<?php
$host     = "mysql"; 
$user     = "root";
$password = "DOwJyCtfteqvSLPqqktvGGKHxnZLRiiq";
$database = "railway";
$port     = 3306;  

try {
    // ເພີ່ມ charset=utf8mb4 ຢູ່ທາງທ້າຍຂອງຊື່ຖານຂໍ້ມູນ
    $pdo = new PDO("mysql:host=$host;port=$port;dbname=$database;charset=utf8mb4", $user, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    // ບັງຄັບໃຫ້ MySQL ຣັນຄຳສັ່ງ SET NAMES UTF8MB4 ທຸກຄັ້ງທີ່ເຊື່ອມຕໍ່ (ປ້ອງກັນພາສາຕ່າງດ້າວ)
    $pdo->exec("SET NAMES utf8mb4");
} catch(PDOException $e) {
    die("Database Connection Failed: " . $e->getMessage());
}
?>
