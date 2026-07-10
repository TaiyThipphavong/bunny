<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('Access-Control-Allow-Headers: Content-Type');

// 1. ดึงค่า Variables จาก Railway
$host = getenv('MYSQLHOST') ?: 'mysql.railway.internal';
$user = getenv('MYSQLUSER') ?: 'root';
$pass = getenv('MYSQLPASSWORD') ?: 'D0wJyCtfteqvSLPqqktvGGKHxnZLRiiq';
$db   = getenv('MYSQL_DATABASE') ?: 'railway';
$port = getenv('MYSQLPORT') ?: '3306';

try {
    // 2. เชื่อมต่อผ่าน PDO พร้อมกำหนด charset รองรับภาษาลาว/ไทย
    $pdo = new PDO("mysql:host=$host;dbname=$db;port=$port;charset=utf8mb4", $user, $pass);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $pdo->exec("set names utf8mb4");
    
    // 3. ประกาศตัวแปร $conn เผื่อไฟล์อื่นเรียกใช้งาน (เปิดใช้งานตรงนี้)
    $conn = $pdo; 

} catch(PDOException $e) {
    echo json_encode(['error' => $e->getMessage()]);
    exit;
}
?>
