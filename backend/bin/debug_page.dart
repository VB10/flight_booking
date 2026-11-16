/// Single-file demo panel served at `GET /debug` (v14). No packages, no build:
/// it polls `/debug/state` and drives the switches over plain `fetch`.
const debugPageHtml = r'''<!doctype html>
<html lang="en"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Flight Booking Server · Debug</title>
<style>
  :root { --bg:#0f1623; --card:#182235; --line:#26334d; --text:#e8eef9;
          --mut:#8a9bb8; --ok:#34d399; --warn:#f59e0b; --bad:#f87171; --acc:#60a5fa; }
  @media (prefers-color-scheme: light) {
    :root { --bg:#f4f6fb; --card:#fff; --line:#dde3ef; --text:#142036; --mut:#5d6b85; }
  }
  * { box-sizing:border-box }
  body { margin:0; padding:20px 16px 40px; background:var(--bg); color:var(--text);
         font:15px/1.45 -apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,sans-serif }
  main { max-width:760px; margin:0 auto; display:grid; gap:14px }
  h1 { font-size:18px; margin:0 0 2px }
  h2 { font-size:12px; letter-spacing:.08em; text-transform:uppercase; color:var(--mut); margin:0 0 10px }
  .card { background:var(--card); border:1px solid var(--line); border-radius:14px; padding:16px }
  .row { display:flex; align-items:center; justify-content:space-between; gap:12px; flex-wrap:wrap }
  button { font:inherit; font-weight:600; color:var(--text); background:transparent; cursor:pointer;
           border:1px solid var(--line); border-radius:10px; padding:8px 14px }
  button:hover { border-color:var(--acc) }
  .sw { display:inline-flex; border:1px solid var(--line); border-radius:10px; overflow:hidden }
  .sw button { border:0; border-radius:0; color:var(--mut) }
  .sw button.on-active { background:var(--ok); color:#06281c }
  .sw button.off-active { background:var(--bad); color:#2b0a0a }
  .pill { border-radius:999px; padding:3px 10px; font-size:13px; font-weight:600 }
  .armed { background:rgba(245,158,11,.18); color:var(--warn) }
  .idle { background:rgba(138,155,184,.15); color:var(--mut) }
  table { width:100%; border-collapse:collapse; font-size:14px }
  th { text-align:left; color:var(--mut); font-weight:600; font-size:12px; padding:0 8px 6px 0 }
  td { padding:7px 8px 7px 0; border-top:1px solid var(--line); vertical-align:top }
  td.num { font-variant-numeric:tabular-nums }
  tr.dup td { color:var(--bad) }
  .tag { font-size:12px; font-weight:700; color:var(--bad) }
  .s200 { color:var(--ok) } .s503 { color:var(--bad) }
  .empty { color:var(--mut); padding:6px 0 }
  code { font-family:ui-monospace,Menlo,monospace; font-size:13px }
</style></head>
<body><main>
  <div><h1>Flight Booking Server · Debug</h1>
  <div style="color:var(--mut)">v14 · checkout idempotency demo</div></div>

  <section class="card"><div class="row">
    <div><h2 style="margin:0">Idempotency (server side)</h2>
      <div id="idemHint" style="color:var(--mut)"></div></div>
    <div class="sw" role="group" aria-label="Idempotency">
      <button id="off">OFF</button><button id="on">ON</button></div>
  </div></section>

  <section class="card"><div class="row">
    <div><h2 style="margin:0">Connection drop</h2>
      <div style="color:var(--mut)">Next checkout commits the order, then answers 503.</div></div>
    <div class="row"><span id="armed" class="pill idle">idle</span>
      <button id="drop">Drop next payment</button></div>
  </div></section>

  <section class="card">
    <div class="row"><h2>Orders (live)</h2><button id="reset">Reset</button></div>
    <table><thead><tr><th>#</th><th>Reference</th><th>Total</th><th>Key</th><th>Time</th></tr></thead>
    <tbody id="orders"></tbody></table><div id="noOrders" class="empty">No orders yet.</div>
  </section>

  <section class="card"><h2>Recent requests</h2>
    <table><thead><tr><th>Time</th><th>Request</th><th>Status</th><th>Note</th></tr></thead>
    <tbody id="events"></tbody></table><div id="noEvents" class="empty">Nothing yet.</div>
  </section>
</main>
<script>
  const $ = (id) => document.getElementById(id);
  const post = (path, body) => fetch(path, { method: 'POST',
    headers: { 'Content-Type': 'application/json' }, body: body ? JSON.stringify(body) : '' }).then(refresh);
  $('on').onclick = () => post('/debug/idempotency', { enabled: true });
  $('off').onclick = () => post('/debug/idempotency', { enabled: false });
  $('drop').onclick = () => post('/debug/drop-next');
  $('reset').onclick = () => post('/debug/reset');

  function cell(tr, text, cls) {
    const td = document.createElement('td'); td.textContent = text;
    if (cls) td.className = cls; tr.appendChild(td); return td;
  }
  function fill(body, rows, build) {
    body.replaceChildren(); rows.forEach((r) => body.appendChild(build(r)));
  }
  async function refresh() {
    let s; try { s = await (await fetch('/debug/state')).json(); } catch (_) { return; }
    $('on').className = s.idempotencyEnabled ? 'on-active' : '';
    $('off').className = s.idempotencyEnabled ? '' : 'off-active';
    $('idemHint').textContent = s.idempotencyEnabled
      ? 'ON: a retry with the same key replays the first order.'
      : 'OFF: the key is ignored, so a retry books twice.';
    $('armed').textContent = s.dropArmed ? 'armed' : 'idle';
    $('armed').className = 'pill ' + (s.dropArmed ? 'armed' : 'idle');
    $('noOrders').hidden = s.orders.length > 0;
    fill($('orders'), s.orders, (o) => {
      const tr = document.createElement('tr'); if (o.duplicate) tr.className = 'dup';
      cell(tr, '#' + o.id, 'num'); const ref = cell(tr, o.bookingReference);
      if (o.duplicate) { const t = document.createElement('span');
        t.className = 'tag'; t.textContent = '  DOUBLE BOOKING'; ref.appendChild(t); }
      cell(tr, '₺' + o.totalPrice, 'num');
      cell(tr, o.idempotencyKey ? o.idempotencyKey.slice(0, 8) + '…' : '—');
      cell(tr, o.time, 'num'); return tr;
    });
    $('noEvents').hidden = s.events.length > 0;
    fill($('events'), s.events, (e) => {
      const tr = document.createElement('tr');
      cell(tr, e.time, 'num'); cell(tr, e.method + ' ' + e.path);
      cell(tr, String(e.status), 's' + e.status);
      cell(tr, e.replayed ? '♻ replayed (Idempotent-Replayed: true)' : e.note); return tr;
    });
  }
  refresh(); setInterval(refresh, 1000);
</script></body></html>''';
