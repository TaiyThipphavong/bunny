<?php
header('Content-Type: application/json');
set_error_handler(function($severity, $message, $file, $line) {
    throw new ErrorException($message, 0, $severity, $file, $line);
});

try {
    require 'config.php';

    if (empty($_FILES['image'])) {
        throw new Exception('no file received');
    }
    if ($_FILES['image']['error'] !== UPLOAD_ERR_OK) {
        throw new Exception('upload error code ' . $_FILES['image']['error']);
    }

    $dir = __DIR__ . '/../uploads/';
    if (!is_dir($dir)) mkdir($dir, 0777, true);

    $ext      = pathinfo($_FILES['image']['name'], PATHINFO_EXTENSION);
    $filename = 'uploads/' . uniqid('prod_') . '.' . $ext;
    $dest     = __DIR__ . '/../' . $filename;

    if (!move_uploaded_file($_FILES['image']['tmp_name'], $dest)) {
        throw new Exception('move_uploaded_file failed (dir writable: ' . (is_writable($dir) ? 'yes' : 'no') . ')');
    }

    echo json_encode(['success' => true, 'path' => $filename]);
} catch (Throwable $e) {
    http_response_code(500);
    echo json_encode(['success' => false, 'error' => $e->getMessage()]);
}
