<?php
require 'config.php';
$method = $_SERVER['REQUEST_METHOD'];

/* ensure extra columns exist */
try { $pdo->exec("ALTER TABLE products ADD COLUMN colors     TEXT    DEFAULT NULL"); } catch(Exception $e) {}
try { $pdo->exec("ALTER TABLE products ADD COLUMN cost_price DECIMAL(12,2) DEFAULT 0"); } catch(Exception $e) {}
try { $pdo->exec("ALTER TABLE products ADD COLUMN pre_order  TINYINT(1) DEFAULT 0"); } catch(Exception $e) {}
try { $pdo->exec("ALTER TABLE products ADD COLUMN sizes      TEXT       DEFAULT NULL"); } catch(Exception $e) {}
try { $pdo->exec("ALTER TABLE products ADD COLUMN sort_order INT        DEFAULT NULL"); } catch(Exception $e) {}
try { $pdo->exec("ALTER TABLE products ADD COLUMN preorder_days VARCHAR(20) DEFAULT NULL"); } catch(Exception $e) {}

function decodeColors($val) {
  if (!$val) return [];
  $arr = json_decode($val, true);
  return is_array($arr) ? $arr : array_filter(array_map('trim', explode(',', $val)));
}

header('Content-Type: application/json');

try {
switch($method) {
  case 'GET':
    if(isset($_GET['id']) || (isset($_GET['action']) && $_GET['action']==='single')) {
      $id = $_GET['id'] ?? 0;
      $stmt = $pdo->prepare(
        "SELECT p.*, p.image AS image_url, p.name AS name_lo,
                c.name AS category_name, c.name AS category_name_lo
         FROM products p LEFT JOIN categories c ON p.category_id=c.id
         WHERE p.id=?"
      );
      $stmt->execute([$id]);
      $row = $stmt->fetch(PDO::FETCH_ASSOC);
      if($row) {
        $images = [];
        if($row['image_url']) $images[] = $row['image_url'];
        try {
          $imgStmt = $pdo->prepare("SELECT image_path FROM product_images WHERE product_id=? ORDER BY sort_order ASC");
          $imgStmt->execute([$id]);
          foreach($imgStmt->fetchAll(PDO::FETCH_COLUMN) as $ep) {
            if($ep && $ep !== $row['image_url']) $images[] = $ep;
          }
        } catch(Exception $e) {}
        $row['images']    = $images;
        $row['colors']    = decodeColors($row['colors'] ?? '');
        $row['sizes']     = $row['sizes'] ? json_decode($row['sizes'], true) : [];
        $row['old_price'] = null;
        $row['is_new']    = false;
      }
      echo json_encode($row);
    } else if (isset($_GET['action']) && $_GET['action'] === 'check_stock') {
      $raw = $_GET['ids'] ?? '';
      $ids = array_filter(array_map('intval', explode(',', $raw)));
      if (!$ids) { echo json_encode([]); break; }
      $ph   = implode(',', array_fill(0, count($ids), '?'));
      $stmt = $pdo->prepare("SELECT id, name, stock FROM products WHERE id IN ($ph)");
      $stmt->execute($ids);
      echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
      break;
    } else {
      $where = isset($_GET['all']) ? "WHERE 1=1" : "WHERE p.status='active'";
      $params = [];
      if(isset($_GET['category'])) { $where .= " AND p.category_id=?"; $params[] = $_GET['category']; }
      if(isset($_GET['search']))   { $where .= " AND (p.name LIKE ? OR p.description LIKE ?)"; $params[] = '%'.$_GET['search'].'%'; $params[] = '%'.$_GET['search'].'%'; }
      $stmt = $pdo->prepare(
        "SELECT p.*, p.image AS image_url, p.name AS name_lo,
                c.name AS category_name, c.name AS category_name_lo
         FROM products p LEFT JOIN categories c ON p.category_id=c.id
         $where ORDER BY (p.sort_order IS NULL) ASC, p.sort_order ASC, p.created_at DESC"
      );
      $stmt->execute($params);
      $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
      foreach($rows as &$r) {
        $r['colors']    = decodeColors($r['colors'] ?? '');
        $r['sizes']     = $r['sizes'] ? json_decode($r['sizes'], true) : [];
        $r['old_price'] = null;
        $r['is_new']    = false;
      }
      echo json_encode(['products' => $rows, 'total' => count($rows)]);
    }
    break;

  case 'POST':
    $data = json_decode(file_get_contents('php://input'), true);
    $colors = json_encode(isset($data['colors']) && is_array($data['colors']) ? $data['colors'] : []);
    $sizes  = json_encode(isset($data['sizes'])  && is_array($data['sizes'])  ? $data['sizes']  : []);
    $costPrice = isset($data['cost_price']) ? (float)$data['cost_price'] : 0;
    $preOrder = isset($data['pre_order']) ? (int)$data['pre_order'] : 0;
    $status = $data['status'] ?? 'active';
    $categoryId = !empty($data['category_id']) ? (int)$data['category_id'] : null;
    $weight = isset($data['weight']) && $data['weight'] !== '' ? (float)$data['weight'] : null;
    $stock = isset($data['stock']) && $data['stock'] !== '' ? max(0, (int)$data['stock']) : 0;
    $price = isset($data['price']) && $data['price'] !== '' ? (float)$data['price'] : 0;
    $preorderDays = trim($data['preorder_days'] ?? '') ?: null;
    $stmt = $pdo->prepare("INSERT INTO products (category_id,name,description,price,cost_price,stock,image,sku,weight,dimensions,colors,sizes,pre_order,status,preorder_days) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
    $stmt->execute([$categoryId,$data['name'],$data['description'],$price,$costPrice,$stock,$data['image'],$data['sku'],$weight,$data['dimensions'],$colors,$sizes,$preOrder,$status,$preorderDays]);
    $productId = $pdo->lastInsertId();
    if(!empty($data['extra_images']) && is_array($data['extra_images'])) {
      $imgStmt = $pdo->prepare("INSERT INTO product_images (product_id,image_path,sort_order) VALUES (?,?,?)");
      foreach($data['extra_images'] as $i => $imgPath) {
        if($imgPath) $imgStmt->execute([$productId, $imgPath, $i]);
      }
    }
    echo json_encode(['success'=>true,'id'=>$productId]);
    break;

  case 'PUT':
    $data = json_decode(file_get_contents('php://input'), true);
    if(isset($data['action']) && $data['action'] === 'update_stock') {
      $pdo->prepare("UPDATE products SET stock=? WHERE id=?")->execute([max(0, (int)$data['stock']), (int)$data['id']]);
      echo json_encode(['success'=>true]);
      break;
    }
    if(isset($data['action']) && $data['action'] === 'reorder') {
      $stmt = $pdo->prepare("UPDATE products SET sort_order=? WHERE id=?");
      foreach((array)($data['items'] ?? []) as $item) {
        $stmt->execute([(int)$item['sort_order'], (int)$item['id']]);
      }
      echo json_encode(['success'=>true]);
      break;
    }
    $colors = json_encode(isset($data['colors']) && is_array($data['colors']) ? $data['colors'] : []);
    $sizes  = json_encode(isset($data['sizes'])  && is_array($data['sizes'])  ? $data['sizes']  : []);
    $costPrice = isset($data['cost_price']) ? (float)$data['cost_price'] : 0;
    $preOrder = isset($data['pre_order']) ? (int)$data['pre_order'] : 0;
    $categoryId = !empty($data['category_id']) ? (int)$data['category_id'] : null;
    $weight = isset($data['weight']) && $data['weight'] !== '' ? (float)$data['weight'] : null;
    $stock = isset($data['stock']) && $data['stock'] !== '' ? max(0, (int)$data['stock']) : 0;
    $price = isset($data['price']) && $data['price'] !== '' ? (float)$data['price'] : 0;
    $preorderDays = trim($data['preorder_days'] ?? '') ?: null;
    $stmt = $pdo->prepare("UPDATE products SET category_id=?,name=?,description=?,price=?,cost_price=?,stock=?,image=?,sku=?,weight=?,dimensions=?,colors=?,sizes=?,status=?,pre_order=?,preorder_days=? WHERE id=?");
    $stmt->execute([$categoryId,$data['name'],$data['description'],$price,$costPrice,$stock,$data['image'],$data['sku'],$weight,$data['dimensions'],$colors,$sizes,$data['status'],$preOrder,$preorderDays,$data['id']]);
    $pdo->prepare("DELETE FROM product_images WHERE product_id=?")->execute([$data['id']]);
    if(!empty($data['extra_images']) && is_array($data['extra_images'])) {
      $imgStmt = $pdo->prepare("INSERT INTO product_images (product_id,image_path,sort_order) VALUES (?,?,?)");
      foreach($data['extra_images'] as $i => $imgPath) {
        if($imgPath) $imgStmt->execute([$data['id'], $imgPath, $i]);
      }
    }
    echo json_encode(['success'=>true]);
    break;

  case 'DELETE':
    $id = $_GET['id'];
    $pdo->prepare("DELETE FROM product_images WHERE product_id=?")->execute([$id]);
    try {
      $pdo->prepare("DELETE FROM products WHERE id=?")->execute([$id]);
      echo json_encode(['success'=>true]);
    } catch (PDOException $e) {
      if ($e->getCode() === '23000') {
        /* product has existing order history referencing it -- can't hard delete, hide it instead */
        $pdo->prepare("UPDATE products SET status='inactive' WHERE id=?")->execute([$id]);
        echo json_encode(['success'=>true,'soft'=>true]);
      } else {
        throw $e;
      }
    }
    break;
}
} catch (Throwable $e) {
    http_response_code(500);
    echo json_encode(['success' => false, 'error' => $e->getMessage()]);
}
?>
