<?php
// เปลี่ยนมาใช้โฮสต์และพอร์ตภายในของ Railway
$host     = "mysql"; 
$user     = "root";
$password = "DOwJyCtfteqvSLPqqktvGGKHxnZLRiiq";
$database = "railway";
$port     = 3306; // พอร์ตภายในของ MySQL

try {
    $conn = new PDO("mysql:host=$host;port=$port;dbname=$database;charset=utf8", $user, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch(PDOException $e) {
    // บรรทัดนี้จะช่วยพ่น Error ออกมาบนหน้าจอขาวๆ ทันทีถ้าเชื่อมต่อไม่ได้
    echo "Database Error: " . $e->getMessage();
    exit();
}
?>
