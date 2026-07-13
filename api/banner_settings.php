<?php
require 'config.php';
header('Content-Type: application/json');

$pdo->exec(
    "CREATE TABLE IF NOT EXISTS banner_slides (
        id INT AUTO_INCREMENT PRIMARY KEY,
        position INT NOT NULL,
        image VARCHAR(255) NOT NULL,
        link VARCHAR(255) DEFAULT ''
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4"
);

$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'GET') {
    $rows = $pdo->query("SELECT image AS img, link FROM banner_slides ORDER BY position ASC")
                 ->fetchAll(PDO::FETCH_ASSOC);
    echo json_encode($rows);

} elseif ($method === 'POST' || $method === 'PUT') {
    $data   = json_decode(file_get_contents('php://input'), true);
    $slides = is_array($data['slides'] ?? null) ? $data['slides'] : [];

    $pdo->exec("DELETE FROM banner_slides");
    $stmt = $pdo->prepare("INSERT INTO banner_slides (position, image, link) VALUES (?,?,?)");
    $pos = 0;
    foreach ($slides as $s) {
        $img  = trim($s['img'] ?? '');
        $link = trim($s['link'] ?? '');
        if ($img === '') continue;
        $stmt->execute([$pos, $img, $link]);
        $pos++;
    }
    echo json_encode(['success'=>true]);
}
