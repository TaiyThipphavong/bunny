<?php
require 'config.php';
$method = $_SERVER['REQUEST_METHOD'];
try { $pdo->exec("ALTER TABLE order_items ADD COLUMN is_preorder TINYINT(1) DEFAULT 0"); } catch(Exception $e) {}
try { $pdo->exec("ALTER TABLE orders ADD COLUMN preorder_confirmed TINYINT(1) DEFAULT 0"); } catch(Exception $e) {}
try { $pdo->exec("ALTER TABLE orders ADD COLUMN stock_deducted TINYINT(1) DEFAULT 0"); } catch(Exception $e) {}

if($method === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);
    $baseOrderNum = 'BUN-' . date('Ymd') . '-' . strtoupper(substr(uniqid(),6));

    $shippingFee     = isset($data['shipping_fee'])     ? (int)$data['shipping_fee']      : 0;
    $shippingCompany = isset($data['shipping_company']) ? trim($data['shipping_company']) : '';
    $memberNumber    = isset($data['member_number'])    ? trim($data['member_number'])    : '';
    $paymentMethod   = isset($data['payment_method'])   ? trim($data['payment_method'])   : 'transfer';
    $memberId        = isset($data['member_id'])        ? (int)$data['member_id']         : null;
    $customerPhone   = preg_replace('/\D/', '', trim($data['phone'] ?? ''));
    $customerName    = trim($data['name'] ?? '');
    $customerAddress = trim($data['address'] ?? '');
    $slip            = $data['slip'] ?? '';
    $note            = trim($data['note'] ?? '');

    /* split cart into a regular-stock bill and a pre-order bill */
    $regularItems = []; $preorderItems = [];
    foreach($data['items'] as $item) {
        if (empty($item['is_preorder'])) $regularItems[] = $item; else $preorderItems[] = $item;
    }
    $groups = [];
    if ($regularItems)  $groups[] = ['items' => $regularItems,  'is_preorder' => 0];
    if ($preorderItems) $groups[] = ['items' => $preorderItems, 'is_preorder' => 1];
    $split = count($groups) > 1;

    /* shipping fee goes on the regular-stock bill if one exists, else the single bill */
    $shipGroupIdx = 0;
    foreach ($groups as $gi => $g) { if (!$g['is_preorder']) { $shipGroupIdx = $gi; break; } }

    $orderNumbers = [];
    foreach ($groups as $i => $g) {
        $groupItemsTotal = array_reduce($g['items'], function($s,$it){ return $s + $it['price']*$it['qty']; }, 0);
        $groupShipping = ($i === $shipGroupIdx) ? $shippingFee : 0;
        $groupTotal    = $groupItemsTotal + $groupShipping;
        $orderNum      = $split ? $baseOrderNum . '-' . ($i === 0 ? 'A' : 'B') : $baseOrderNum;

        $stmt = $pdo->prepare(
            "INSERT INTO orders
             (order_number,customer_name,customer_phone,customer_address,
              total_amount,items_total,shipping_fee,shipping_company,member_number,
              payment_method,payment_slip,note,member_id)
             VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)"
        );
        $stmt->execute([
            $orderNum, $customerName, $customerPhone, $customerAddress,
            $groupTotal, $groupItemsTotal, $groupShipping, $shippingCompany, $memberNumber,
            $paymentMethod, $slip, $note, $memberId ?: null
        ]);
        $orderId = $pdo->lastInsertId();

        foreach($g['items'] as $item) {
            $isPre = $g['is_preorder'];
            $pdo->prepare("INSERT INTO order_items (order_id,product_id,quantity,price,is_preorder) VALUES (?,?,?,?,?)")
                ->execute([$orderId, $item['id'], $item['qty'], $item['price'], $isPre]);
            /* stock is deducted when admin confirms the order, not at checkout --
               see the status-update handler below */
        }
        $orderNumbers[] = $orderNum;
    }

    echo json_encode(['success'=>true,'order_number'=>$orderNumbers[0],'order_numbers'=>$orderNumbers,'split'=>$split]);

} elseif($method === 'GET') {
    if(isset($_GET['id'])) {
        $stmt = $pdo->prepare(
            "SELECT oi.*, p.name AS product_name, p.image AS product_image
             FROM order_items oi
             LEFT JOIN products p ON p.id = oi.product_id
             WHERE oi.order_id = ?"
        );
        $stmt->execute([$_GET['id']]);
        echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));

    } elseif(isset($_GET['member_id'])) {
        $mid = (int)$_GET['member_id'];
        $stmt = $pdo->prepare(
            "SELECT * FROM orders WHERE member_id = ? ORDER BY created_at DESC"
        );
        $stmt->execute([$mid]);
        echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));

    } elseif(isset($_GET['phone'])) {
        $phone = preg_replace('/\D/', '', trim($_GET['phone']));
        $right8 = substr($phone, -8);
        $stmt = $pdo->prepare(
            "SELECT * FROM orders
             WHERE RIGHT(REPLACE(REPLACE(REPLACE(customer_phone,' ',''),'-',''),'+856',''), 8) = ?
             ORDER BY created_at DESC"
        );
        $stmt->execute([$right8]);
        echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));

    } else {
        $stmt = $pdo->query(
            "SELECT o.*,
               (SELECT COUNT(*) FROM order_items oi
                WHERE oi.order_id=o.id AND oi.is_preorder=1) AS has_preorder
             FROM orders o ORDER BY o.created_at DESC"
        );
        echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
    }

} elseif($method === 'PUT') {
    $data = json_decode(file_get_contents('php://input'), true);

    /* customer self-cancel: action=cancel, must still be pending */
    if(isset($data['action']) && $data['action'] === 'cancel') {
        $id = (int)($data['id'] ?? 0);
        if(!$id) { echo json_encode(['success'=>false,'error'=>'ບໍ່ພົບ ID']); exit; }
        $row = $pdo->prepare("SELECT status FROM orders WHERE id=?");
        $row->execute([$id]);
        $ord = $row->fetch(PDO::FETCH_ASSOC);
        if(!$ord) { echo json_encode(['success'=>false,'error'=>'ບໍ່ພົບຄຳສັ່ງ']); exit; }
        if($ord['status'] !== 'pending') {
            echo json_encode(['success'=>false,'error'=>'ຍົກເລີກບໍ່ໄດ້ — ຄຳສັ່ງນີ້ຖືກຢືນຢັນແລ້ວ']);
            exit;
        }
        /* stock was never deducted while pending, so nothing to restore here */
        $pdo->prepare("UPDATE orders SET status='cancelled' WHERE id=?")->execute([$id]);
        echo json_encode(['success'=>true]);
        exit;
    }

    /* customer update address */
    if(isset($data['action']) && $data['action'] === 'update_address') {
        $id   = (int)($data['id'] ?? 0);
        $addr = trim($data['address'] ?? '');
        if(!$id) { echo json_encode(['success'=>false,'error'=>'ບໍ່ພົບ ID']); exit; }
        $pdo->prepare("UPDATE orders SET customer_address=? WHERE id=?")->execute([$addr, $id]);
        echo json_encode(['success'=>true]);
        exit;
    }

    /* admin update item quantity */
    if(isset($data['action']) && $data['action'] === 'update_item') {
        $itemId  = (int)($data['item_id'] ?? 0);
        $qty     = (int)($data['quantity'] ?? 1);
        $orderId = (int)($data['order_id'] ?? 0);
        if(!$itemId || $qty < 1 || !$orderId) {
            echo json_encode(['success'=>false,'error'=>'ຂໍ້ມູນບໍ່ຄົບ']); exit;
        }
        $pdo->prepare("UPDATE order_items SET quantity=? WHERE id=?")->execute([$qty, $itemId]);
        $totStmt = $pdo->prepare("SELECT COALESCE(SUM(price*quantity),0) FROM order_items WHERE order_id=?");
        $totStmt->execute([$orderId]);
        $newItemsTotal = (int)$totStmt->fetchColumn();
        $sfStmt = $pdo->prepare("SELECT COALESCE(shipping_fee,0) FROM orders WHERE id=?");
        $sfStmt->execute([$orderId]);
        $sf = (int)$sfStmt->fetchColumn();
        $newTotal = $newItemsTotal + $sf;
        $pdo->prepare("UPDATE orders SET items_total=?, total_amount=? WHERE id=?")->execute([$newItemsTotal, $newTotal, $orderId]);
        echo json_encode(['success'=>true,'items_total'=>$newItemsTotal,'total'=>$newTotal]);
        exit;
    }

    /* admin delete item */
    if(isset($data['action']) && $data['action'] === 'delete_item') {
        $itemId  = (int)($data['item_id'] ?? 0);
        $orderId = (int)($data['order_id'] ?? 0);
        if(!$itemId || !$orderId) {
            echo json_encode(['success'=>false,'error'=>'ຂໍ້ມູນບໍ່ຄົບ']); exit;
        }
        $itStmt = $pdo->prepare("SELECT product_id, quantity, is_preorder FROM order_items WHERE id=?");
        $itStmt->execute([$itemId]);
        $it = $itStmt->fetch(PDO::FETCH_ASSOC);
        if(!$it) { echo json_encode(['success'=>false,'error'=>'ບໍ່ພົບລາຍການ']); exit; }
        $sdStmt = $pdo->prepare("SELECT stock_deducted FROM orders WHERE id=?");
        $sdStmt->execute([$orderId]);
        $stockWasDeducted = (bool)$sdStmt->fetchColumn();
        if(!$it['is_preorder'] && $stockWasDeducted) {
            $pdo->prepare("UPDATE products SET stock=stock+? WHERE id=?")->execute([$it['quantity'],$it['product_id']]);
        }
        $pdo->prepare("DELETE FROM order_items WHERE id=?")->execute([$itemId]);
        $totStmt = $pdo->prepare("SELECT COALESCE(SUM(price*quantity),0) FROM order_items WHERE order_id=?");
        $totStmt->execute([$orderId]);
        $newItemsTotal = (int)$totStmt->fetchColumn();
        $sfStmt = $pdo->prepare("SELECT COALESCE(shipping_fee,0) FROM orders WHERE id=?");
        $sfStmt->execute([$orderId]);
        $sf = (int)$sfStmt->fetchColumn();
        $newTotal = $newItemsTotal + $sf;
        $pdo->prepare("UPDATE orders SET items_total=?, total_amount=? WHERE id=?")->execute([$newItemsTotal, $newTotal, $orderId]);
        echo json_encode(['success'=>true,'items_total'=>$newItemsTotal,'total'=>$newTotal]);
        exit;
    }

    /* admin: confirm pre-order stock has arrived */
    if(isset($data['action']) && $data['action'] === 'confirm_preorder') {
        $id = (int)($data['id'] ?? 0);
        if(!$id) { echo json_encode(['success'=>false,'error'=>'ບໍ່ພົບ ID']); exit; }
        $pdo->prepare("UPDATE orders SET preorder_confirmed=1 WHERE id=?")->execute([$id]);
        echo json_encode(['success'=>true]);
        exit;
    }

    /* admin status update */
    $id = (int)($data['id'] ?? 0);
    $newStatus = $data['status'] ?? '';

    $chk = $pdo->prepare(
        "SELECT COUNT(*) total, COALESCE(SUM(is_preorder),0) pre FROM order_items WHERE order_id=?"
    );
    $chk->execute([$id]);
    $counts = $chk->fetch(PDO::FETCH_ASSOC);
    $isPreorderOrder = $counts['total'] > 0 && $counts['pre'] == $counts['total'];

    if ($isPreorderOrder && !in_array($newStatus, ['pending','confirmed','cancelled','returned'], true)) {
        $confStmt = $pdo->prepare("SELECT preorder_confirmed FROM orders WHERE id=?");
        $confStmt->execute([$id]);
        if (!$confStmt->fetchColumn()) {
            echo json_encode(['success'=>false,'error'=>'ຕ້ອງກົດຢືນຢັນວ່າເຄື່ອງອໍເດີຮອດແລ້ວກ່ອນຈຶ່ງອັບເດດສະຖານະຕໍ່ໄດ້']);
            exit;
        }
    }

    /* stock moves only once, the first time an order leaves "pending" into
       confirmed/shipped/completed -- and reverses if a confirmed order is
       later cancelled. Tracked via orders.stock_deducted so this is safe
       to run through repeated/out-of-order status changes. */
    $sdStmt = $pdo->prepare("SELECT stock_deducted FROM orders WHERE id=?");
    $sdStmt->execute([$id]);
    $stockDeducted = (bool)$sdStmt->fetchColumn();

    if (!$stockDeducted && !in_array($newStatus, ['pending','cancelled'], true)) {
        $items = $pdo->prepare("SELECT product_id, quantity FROM order_items WHERE order_id=? AND is_preorder=0");
        $items->execute([$id]);
        foreach ($items->fetchAll(PDO::FETCH_ASSOC) as $it) {
            $pdo->prepare("UPDATE products SET stock=GREATEST(stock-?,0) WHERE id=?")->execute([$it['quantity'], $it['product_id']]);
        }
        $pdo->prepare("UPDATE orders SET stock_deducted=1 WHERE id=?")->execute([$id]);
    } elseif ($stockDeducted && in_array($newStatus, ['cancelled','returned'], true)) {
        $items = $pdo->prepare("SELECT product_id, quantity FROM order_items WHERE order_id=? AND is_preorder=0");
        $items->execute([$id]);
        foreach ($items->fetchAll(PDO::FETCH_ASSOC) as $it) {
            $pdo->prepare("UPDATE products SET stock=stock+? WHERE id=?")->execute([$it['quantity'], $it['product_id']]);
        }
        $pdo->prepare("UPDATE orders SET stock_deducted=0 WHERE id=?")->execute([$id]);
    }

    $pdo->prepare("UPDATE orders SET status=? WHERE id=?")->execute([$newStatus,$id]);
    echo json_encode(['success'=>true]);
}
?>
