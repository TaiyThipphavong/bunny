<?php
require 'config.php';
header('Content-Type: application/json');

if (empty($_FILES['image'])) {
    echo json_encode(['success' => false, 'error' => 'no file received']);
    exit;
}
if ($_FILES['image']['error'] !== UPLOAD_ERR_OK) {
    echo json_encode(['success' => false, 'error' => 'upload error code ' . $_FILES['image']['error']]);
    exit;
}

$dir = __DIR__ . '/../uploads/';
if (!is_dir($dir)) mkdir($dir, 0777, true);

$ext      = pathinfo($_FILES['image']['name'], PATHINFO_EXTENSION);
$filename = 'uploads/' . uniqid('prod_') . '.' . $ext;
$dest     = __DIR__ . '/../' . $filename;

if (move_uploaded_file($_FILES['image']['tmp_name'], $dest)) {
    echo json_encode(['success' => true, 'path' => $filename]);
} else {
    echo json_encode([
        'success'      => false,
        'error'        => 'move_uploaded_file failed',
        'dir_writable' => is_writable($dir),
        'dest'         => $dest,
    ]);
}
