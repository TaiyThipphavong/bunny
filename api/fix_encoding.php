<?php
/* ONE-TIME DIAGNOSTIC/FIX — DELETE THIS FILE AFTER USE */
require 'config.php';
header('Content-Type: text/html; charset=UTF-8');

$tables = ['orders', 'order_items', 'members'];
$result = null;

if ($_SERVER['REQUEST_METHOD'] === 'POST' && ($_POST['action'] ?? '') === 'fix') {
    $result = [];
    foreach ($tables as $t) {
        try {
            $pdo->exec("ALTER TABLE `$t` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");
            $result[$t] = 'ok';
        } catch (Exception $e) {
            $result[$t] = 'error: ' . $e->getMessage();
        }
    }
}

function tableCharsets($pdo, $table) {
    try {
        $stmt = $pdo->prepare(
            "SELECT COLUMN_NAME, CHARACTER_SET_NAME, COLLATION_NAME
             FROM information_schema.COLUMNS
             WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ? AND CHARACTER_SET_NAME IS NOT NULL"
        );
        $stmt->execute([$table]);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
        return [];
    }
}
?>
<!DOCTYPE html>
<html lang="lo">
<head>
<meta charset="UTF-8">
<title>Fix Encoding</title>
<style>
  body{font-family:'Noto Sans Lao',sans-serif;background:#f4f4f2;padding:40px 20px;margin:0}
  .box{background:#fff;border-radius:16px;padding:32px;max-width:700px;margin:0 auto;box-shadow:0 8px 32px rgba(0,0,0,.1)}
  h2{margin:0 0 6px;font-size:1.1rem;color:#111}
  .warn{background:#fff8e1;border:1px solid #ffd54f;border-radius:8px;padding:10px 14px;font-size:.8rem;color:#7a5c00;margin-bottom:24px}
  table{width:100%;border-collapse:collapse;margin-bottom:20px;font-size:.82rem}
  th,td{text-align:left;padding:6px 10px;border-bottom:1px solid #eee}
  th{color:#888;text-transform:uppercase;font-size:.7rem;letter-spacing:.5px}
  .bad{color:#c62828;font-weight:700}
  .good{color:#2e7d32;font-weight:700}
  button{padding:13px 24px;background:#111;color:#fff;border:none;border-radius:10px;font-family:inherit;font-size:.9rem;font-weight:700;cursor:pointer}
  button:hover{background:#333}
  .ok-msg{background:#e8f5e9;border:1px solid #a5d6a7;border-radius:10px;padding:16px;color:#1b5e20;margin-bottom:20px}
  .note{font-size:.8rem;color:#999;margin-top:20px;line-height:1.6}
</style>
</head>
<body>
<div class="box">
  <h2>ກວດ ແລະ ແກ້ໄຂ character encoding</h2>
  <div class="warn">⚠️ ໃຊ້ຄັ້ງດຽວແລ້ວລຶບໄຟລ໌ນີ້ທັນທີ</div>

  <?php if ($result): ?>
    <div class="ok-msg">
      <?php foreach ($result as $t => $r): ?>
        <div><?= htmlspecialchars($t) ?>: <?= htmlspecialchars($r) ?></div>
      <?php endforeach; ?>
    </div>
  <?php endif; ?>

  <?php foreach ($tables as $t): ?>
    <h3 style="font-size:.9rem;margin-bottom:6px"><?= htmlspecialchars($t) ?></h3>
    <table>
      <tr><th>Column</th><th>Charset</th><th>Collation</th></tr>
      <?php foreach (tableCharsets($pdo, $t) as $col): ?>
        <?php $ok = stripos($col['CHARACTER_SET_NAME'], 'utf8mb4') === 0; ?>
        <tr>
          <td><?= htmlspecialchars($col['COLUMN_NAME']) ?></td>
          <td class="<?= $ok ? 'good' : 'bad' ?>"><?= htmlspecialchars($col['CHARACTER_SET_NAME']) ?></td>
          <td><?= htmlspecialchars($col['COLLATION_NAME']) ?></td>
        </tr>
      <?php endforeach; ?>
    </table>
  <?php endforeach; ?>

  <form method="POST">
    <input type="hidden" name="action" value="fix">
    <button type="submit">ແປງທຸກຕາຕະລາງເປັນ utf8mb4</button>
  </form>

  <div class="note">
    ໝາຍເຫດ: ການແປງນີ້ຈະປ້ອງກັນບໍ່ໃຫ້ຂໍ້ຄວາມພາສາລາວໃໝ່ຖືກແທນທີ່ດ້ວຍ "?" ອີກຕໍ່ໄປ.
    ຂໍ້ມູນທີ່ຖືກແທນທີ່ດ້ວຍ "?" ໄປແລ້ວກ່ອນໜ້ານີ້ (ເຊັ່ນ ທີ່ຢູ່ເກົ່າ) ບໍ່ສາມາດກູ້ຄືນໄດ້ —
    ລູກຄ້າ/admin ຈະຕ້ອງແກ້ໄຂຂໍ້ມູນນັ້ນຄືນໃໝ່ຫຼັງຈາກແປງແລ້ວ.
  </div>
</div>
</body>
</html>
