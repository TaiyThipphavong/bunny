<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('Access-Control-Allow-Headers: Content-Type');

// 1. ປ່ຽນໃຫ້ກົງກັບຊື່ Variables ເທິງ Railway ແລະ ໃສ່ຄ່າ Default ສຳຮອງໄວ້
$host = getenv('MYSQLHOST') ?: 'mysql.railway.internal';
$user = getenv('MYSQLUSER') ?: 'root';
$pass = getenv('MYSQLPASSWORD') ?: 'D0wJyCtfteqvSLPqqktvGGKHxnZLRiiq';
$db   = getenv('MYSQL_DATABASE') ?: 'railway';
$port = getenv('MYSQLPORT') ?: '3306';

try {
    // 2. ແກ້ໄຂຈາກ $dbname ເປັນ $db ໃຫ້ຖືກຕ້ອງ
    $pdo = new PDO("mysql:host=$host;dbname=$db;port=$port;charset=utf8mb4", $user, $pass);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    // (ຖ້າໂຄ້ດສ່ວນອື່ນໆຂອງທ່ານຮ້ອງໃຊ້ $conn ແບບ PDO ໃຫ້ເປີດບັນທັດລຸ່ມນີ້)
    // $conn = $pdo; 

} catch(PDOException $e) {
    echo json_encode(['error' => $e->getMessage()]);
    exit;
}
?>