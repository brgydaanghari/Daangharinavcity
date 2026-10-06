<?php
require_once __DIR__ . '/includes/auth.php';
require_login();
$pdo = db();
$stats = [
  'residents' => (int)$pdo->query('SELECT COUNT(*) FROM residents')->fetchColumn(),
  'households' => (int)$pdo->query('SELECT COUNT(DISTINCT household) FROM residents')->fetchColumn(),
  'documents' => (int)$pdo->query("SELECT COUNT(*) FROM document_requests WHERE status IN ('Pending','For review')")->fetchColumn(),
  'blotters' => (int)$pdo->query("SELECT COUNT(*) FROM blotters WHERE status <> 'Resolved'")->fetchColumn(),
];
$recentResidents = $pdo->query('SELECT * FROM residents ORDER BY created_at DESC LIMIT 4')->fetchAll();
$pageTitle = 'Dashboard'; $activePage = 'dashboard'; require __DIR__ . '/partials/header.php';
?>
<section class="section-heading"><div><div class="eyebrow">Wednesday · October 08, 2026</div><h1>Good morning, Captain Reyes.</h1><p>Keep the barangay moving, one resolved concern at a time.</p></div><a class="primary-button" href="residents.php?action=new">＋ Add new resident</a></section>
<div class="stats-grid"><div class="stat-card"><div class="stat-icon blue">♙</div><span class="stat-label">Total residents</span><strong><?= number_format($stats['residents']) ?></strong><small>Registered profiles</small></div><div class="stat-card"><div class="stat-icon mint">⌂</div><span class="stat-label">Active households</span><strong><?= number_format($stats['households']) ?></strong><small>Unique households</small></div><div class="stat-card"><div class="stat-icon amber">▤</div><span class="stat-label">Open documents</span><strong><?= number_format($stats['documents']) ?></strong><small>Needs processing</small></div><div class="stat-card"><div class="stat-icon violet">▣</div><span class="stat-label">Open blotters</span><strong><?= number_format($stats['blotters']) ?></strong><small>Needs follow-up</small></div></div>
<div class="priority-banner"><span class="priority-icon">!</span><div><strong>Keep records current</strong><small>Review pending document requests and unresolved blotter cases from the workspace.</small></div><a href="documents.php">Open document desk →</a></div>
<div class="dashboard-grid"><section class="panel"><div class="card-header"><div><div class="eyebrow">Quick actions</div><h2>Keep work moving</h2></div></div><div class="quick-grid"><a href="residents.php?action=new"><b class="shortcut blue">♙</b><strong>Add resident</strong><small>Create a profile</small></a><a href="documents.php?action=new"><b class="shortcut mint">▤</b><strong>Issue document</strong><small>Process a request</small></a><a href="blotters.php?action=new"><b class="shortcut amber">▣</b><strong>Record blotter</strong><small>Log an incident</small></a><a href="residents.php"><b class="shortcut violet">▥</b><strong>View residents</strong><small>Search records</small></a></div></section><section class="panel activity-panel"><div class="card-header"><div><div class="eyebrow">Latest residents</div><h2>Recently registered</h2></div><a class="text-button" href="residents.php">View all →</a></div><div class="activity-list"><?php foreach ($recentResidents as $resident): ?><div class="activity-row"><span class="avatar"><?= h(strtoupper(substr($resident['full_name'], 0, 2))) ?></span><div><strong><?= h($resident['full_name']) ?></strong><small><?= h($resident['barangay_id']) ?> · <?= h($resident['sector']) ?></small></div><span class="muted"><?= h(date('M d', strtotime($resident['created_at']))) ?></span></div><?php endforeach; ?></div></section></div>
<?php require __DIR__ . '/partials/footer.php'; ?>
