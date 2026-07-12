<?php
require 'config.php';
header('Content-Type: application/json');

$pdo->exec(
    "CREATE TABLE IF NOT EXISTS payment_settings (
        id INT PRIMARY KEY,
        bank_name VARCHAR(100) DEFAULT '',
        account_name VARCHAR(150) DEFAULT '',
        account_number VARCHAR(100) DEFAULT '',
        qr_image VARCHAR(255) DEFAULT '',
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4"
);

$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'GET') {
    $row = $pdo->query("SELECT bank_name, account_name, account_number, qr_image FROM payment_settings WHERE id=1")
                ->fetch(PDO::FETCH_ASSOC);
    echo json_encode($row ?: ['bank_name'=>'', 'account_name'=>'', 'account_number'=>'', 'qr_image'=>'']);

} elseif ($method === 'POST' || $method === 'PUT') {
    $data     = json_decode(file_get_contents('php://input'), true);
    $bankName = trim($data['bank_name'] ?? '');
    $acctName = trim($data['account_name'] ?? '');
    $acctNum  = trim($data['account_number'] ?? '');
    $qrImage  = trim($data['qr_image'] ?? '');

    $exists = $pdo->query("SELECT id FROM payment_settings WHERE id=1")->fetch();
    if ($exists) {
        if ($qrImage !== '') {
            $pdo->prepare(
                "UPDATE payment_settings SET bank_name=?, account_name=?, account_number=?, qr_image=? WHERE id=1"
            )->execute([$bankName, $acctName, $acctNum, $qrImage]);
        } else {
            $pdo->prepare(
                "UPDATE payment_settings SET bank_name=?, account_name=?, account_number=? WHERE id=1"
            )->execute([$bankName, $acctName, $acctNum]);
        }
    } else {
        $pdo->prepare(
            "INSERT INTO payment_settings (id,bank_name,account_name,account_number,qr_image) VALUES (1,?,?,?,?)"
        )->execute([$bankName, $acctName, $acctNum, $qrImage]);
    }
    echo json_encode(['success'=>true]);
}
