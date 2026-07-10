<?php
// ຄ່າການເຊື່ອມຕໍ່ຖານຂໍ້ມູນ Railway
$host     = "kodama.proxy.rlwy.net";
$user     = "root";
$password = "DOwJyCtfteqvSLPqqktvGGKHxnZLRiiq";
$database = "railway";
$port     = 57395;

// ສ້າງການເຊື່ອມຕໍ່ດ້ວຍ PDO (ແນະນຳເພາະປອດໄພ ແລະ ເປັນມາດຕະຖານ)
try {
    $conn = new PDO("mysql:host=$host;port=$port;dbname=$database;charset=utf8", $user, $password);
    // ຕັ້ງຄ່າໃຫ້ສະແດງ Error ຖ້າມີບັນຫາ
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    // ເອົາເຄື່ອງໝາຍ // ອອກດ້ານລຸ່ມນີ້ ຖ້າຕ້ອງການທົດສອບວ່າເຊື່ອມຕໍ່ຜ່ານຫຼືບໍ່
    // echo "ເຊື່ອມຕໍ່ຖານຂໍ້ມູນສຳເລັດ!"; 
} catch(PDOException $e) {
    echo "ການເຊື່ອມຕໍ່ຫຼົ້ມເຫຼວ: " . $e->getMessage();
}
?>
