'use strict';

const BASE = (window._ctx || '');
let batchDT = null, chunkDT = null, failChart = null, qcChart = null;
let activeCard = null;

/* ── Live clock ─────────────────────────────────────────────── */
(function tick() {
  const el = document.getElementById('liveClock');
  if (el) el.textContent = new Date().toLocaleString('en-IN', { timeZone: 'Asia/Kolkata' });
  setTimeout(tick, 1000);
})();

/* ================================================================
   LEVEL-2: Load batches for clicked user
   ================================================================ */
function diLoadBatches(userName, cardIdx) {
  const card     = document.getElementById('uc-' + cardIdx);
  const safeUser = card.getAttribute('data-username');
  const section  = document.getElementById('diBatchSection');

  console.log('[di] cardIdx:', cardIdx);
  console.log('[di] safeUser from DOM attr:', JSON.stringify(safeUser));
  console.log('[di] userName from arg:', JSON.stringify(userName));

  if (!safeUser) {
    console.error('[di] safeUser is empty! Check data-username attribute in JSP.');
    return;
  }

  if (activeCard === cardIdx && !section.classList.contains('di-hidden')) {
    diCloseBatchSection();
    return;
  }

  document.querySelectorAll('.di-user-card').forEach(c => c.classList.remove('di-active'));
  document.querySelectorAll('[id^=uca-]').forEach(a => a.textContent = '›');

  card.classList.add('di-active');
  document.getElementById('uca-' + cardIdx).textContent = '⌄';
  activeCard = cardIdx;
  document.getElementById('diBatchUserLabel').textContent = safeUser;

  const url = BASE + '/datasets/batches?userName=' + encodeURIComponent(safeUser);
  console.log('[di] Fetching:', url);

  $.getJSON(url, function (rows) {
    console.log('[di] Rows received:', rows.length);
    const tbody = document.getElementById('diBatchTbody');
    tbody.innerHTML = '';

    rows.forEach(r => {
      const barCls = r.passRate >= 80 ? 'di-fill-green'
                   : r.passRate >= 50 ? 'di-fill-orange'
                                      : 'di-fill-red';
      const tr = document.createElement('tr');
      tr.style.cursor = 'pointer';
      tr.title = 'Click to open detail drawer';
      tr.onclick = () => diOpenDrawer(r.batchId, r.sourceName);
      tr.innerHTML = `
        <td><code class="di-code">${r.batchId}</code></td>
        <td>${esc(r.sourceName)}</td>
        <td><span class="di-badge di-badge-muted">${esc(r.sourceType)}</span></td>
        <td>${esc(r.language)}</td>
        <td>${esc(r.speakerName)} <span class="di-muted">${r.speakerGender ? '(' + r.speakerGender + ')' : ''}</span></td>
        <td><span class="di-badge ${stageClass(r.currentStage)}">${r.currentStage}</span></td>
        <td><span class="di-badge ${licClass(r.licenseStatus)}">${r.licenseStatus}</span></td>
        <td class="di-num">${r.rawHours}</td>
        <td class="di-num">${r.cleanHours}</td>
        <td class="di-num">${r.totalFiles}</td>
        <td class="di-num di-green">${r.passedFiles}</td>
        <td class="di-num di-red">${r.failedFiles}</td>
        <td>
          <div class="di-mini-bar">
            <div class="di-mini-fill ${barCls}" style="width:${r.passRate}%"></div>
          </div>
          <span class="di-num">${r.passRate}%</span>
        </td>
        <td class="di-muted">${r.createdAt}</td>
      `;
      tbody.appendChild(tr);
    });

    if (batchDT) { batchDT.destroy(); batchDT = null; }
    batchDT = $('#diBatchTable').DataTable({
      pageLength: 10,
      order: [],
      scrollX: true,
      dom: '<"di-dt-top"lf>rt<"di-dt-bot"ip>',
      language: { search: '', searchPlaceholder: 'Search batches…' }
    });

    section.classList.remove('di-hidden');
    section.scrollIntoView({ behavior: 'smooth', block: 'start' });

  }).fail(function (xhr, status, err) {
    console.error('[di] AJAX failed:', status, err, xhr.responseText);
  });
}

function diCloseBatchSection() {
  document.getElementById('diBatchSection').classList.add('di-hidden');
  document.querySelectorAll('.di-user-card').forEach(c => c.classList.remove('di-active'));
  document.querySelectorAll('[id^=uca-]').forEach(a => a.textContent = '›');
  activeCard = null;
}

/* ================================================================
   LEVEL-3: Open drawer for a batch
   ================================================================ */
function diOpenDrawer(batchId, sourceName) {
  const drawer = document.getElementById('diDrawer');
  drawer.classList.add('di-open');
  document.body.style.overflow = 'hidden';

  document.getElementById('diDrawerTitle').textContent = sourceName || batchId;
  document.getElementById('diDrawerSub').textContent   = batchId;
  document.getElementById('diChunkCount').textContent  = '…';
  document.getElementById('diBatchInfoGrid').innerHTML = skelGrid(10);
  document.getElementById('diMetricsRow').innerHTML    = skelRow(7);
  destroyCharts();

  Promise.all([
    fetchJ('/datasets/batch-detail?batchId=' + enc(batchId)),
    fetchJ('/datasets/failures?batchId='     + enc(batchId)),
    fetchJ('/datasets/qc-score?batchId='     + enc(batchId))
  ]).then(([detail, failures, qcScore]) => {
    renderBatchInfo(detail);
    renderMetrics(detail);
    renderFailChart(failures);
    renderQcChart(qcScore);
  }).catch(console.error);

  initChunkTable(batchId);
}

function diCloseDrawer() {
  document.getElementById('diDrawer').classList.remove('di-open');
  document.body.style.overflow = '';
  destroyCharts();
}

/* ── Renderers ─────────────────────────────────────────────── */
function renderBatchInfo(d) {
  document.getElementById('diBatchInfoGrid').innerHTML = `
    ${ii('Batch ID',           `<code class="di-code">${d.batch_id || '–'}</code>`)}
    ${ii('Source',             esc(d.source_name))}
    ${ii('Type',               `<span class="di-badge di-badge-muted">${d.source_type || '–'}</span>`)}
    ${ii('Speaker',            `${esc(d.speaker_name)} <span class="di-muted">(${esc(d.speaker_gender)})</span>`)}
    ${ii('Stage',              `<span class="di-badge ${stageClass(d.current_stage)}">${d.current_stage || '–'}</span>`)}
    ${ii('License',            `<span class="di-badge ${licClass(d.status)}">${d.status || '–'}</span>`)}
    ${ii('Created',            `<span class="di-muted">${d.createdAt || '–'}</span>`)}
    ${ii('Updated',            `<span class="di-muted">${d.updatedAt || '–'}</span>`)}
    ${ii('S3 Path',            `<span class="di-muted di-small">${d.s3_prefix_path || '–'}</span>`)}
    ${ii('Source URL',         `<span class="di-muted di-small">${d.source_url || '–'}</span>`)}
    <div class="di-info-divider" style="grid-column:1/-1">⚙️ Init Config — QC Thresholds</div>
    ${ii('Min SNR (dB)',       `<span class="di-cfg-val">${d.cfgSnr              ?? '–'}</span>`)}
    ${ii('Max Silence Ratio',  `<span class="di-cfg-val">${d.cfgSilenceRatio     ?? '–'}</span>`)}
    ${ii('Max Clipping',       `<span class="di-cfg-val">${d.cfgClipping         ?? '–'}</span>`)}
    ${ii('Min Speaker Sim',    `<span class="di-cfg-val">${d.cfgSpeakerSimilarity ?? '–'}</span>`)}
    ${ii('Sampling Rate (Hz)', `<span class="di-cfg-val">${d.cfgSamplingRate      ?? '–'}</span>`)}
    ${ii('Dedup Check',        `<span class="di-cfg-val">${d.cfgDuplication != null ? (d.cfgDuplication ? 'Yes' : 'No') : '–'}</span>`)}
  `;
}

function renderMetrics(d) {
  const pr = d.totalFiles > 0 ? ((d.passedFiles / d.totalFiles) * 100).toFixed(1) : 0;
  const yr = d.totalHours > 0 ? ((d.passedHours / d.totalHours) * 100).toFixed(1) : 0;
  document.getElementById('diMetricsRow').innerHTML = `
    ${mc('blue',   d.totalFiles,        'Total Files')}
    ${mc('green',  d.passedFiles,       'Passed')}
    ${mc('red',    d.failedFiles,       'Failed')}
    ${mc('teal',   d.totalHours  + 'h', 'Raw Hours')}
    ${mc('cyan',   d.passedHours + 'h', 'Clean Hours')}
    ${mc('lime',   pr + '%',            'Pass Rate')}
    ${mc('orange', yr + '%',            'Clean Yield')}
  `;
}

function initChunkTable(batchId) {
  if (chunkDT) { chunkDT.destroy(); chunkDT = null; }

  chunkDT = $('#diChunkTable').DataTable({
    processing: true,
    serverSide: true,
    pageLength: 25,
    lengthMenu: [10, 25, 50, 100],
    scrollX: true,
    dom: '<"di-dt-top"lf>rt<"di-dt-bot"ip>',
    language: {
      search: '',
      searchPlaceholder: 'Search chunks…',
      processing: '<div class="di-spinner">Loading…</div>'
    },
    ajax: {
      url:  BASE + '/datasets/chunks',
      type: 'GET',
      data: function (d) { d.batchId = batchId; return d; },
      dataSrc: function (json) {
        document.getElementById('diChunkCount').textContent = json.recordsTotal;
        return json.data;
      },
      error: function (xhr, err) {
        console.error('[di] Chunks AJAX error:', err, xhr.responseText);
      }
    },
    columns: [
      { data: 'chunk_id',          render: v => `<code class="di-code di-small">${v}</code>` },
      { data: 'video_id',          render: v => `<span class="di-muted di-small">${v || '–'}</span>` },
      { data: 'startSec',          className: 'di-num' },
      { data: 'endSec',            className: 'di-num' },
      { data: 'duration',          className: 'di-num' },
      { data: 'language',          render: v => v || '–' },
      { data: 'snrDb',             className: 'di-num' },
      { data: 'silenceRatio',      className: 'di-num' },
      { data: 'clippingRatio',     className: 'di-num' },
      { data: 'speakerSimilarity', className: 'di-num' },
      {
        data: 'duplicate', orderable: false,
        render: v => v
          ? '<span class="di-badge di-badge-warn">DUP</span>'
          : '<span class="di-badge di-badge-ok">—</span>'
      },
      {
        data: 'passed', orderable: false,
        render: v => `<span class="${v ? 'di-green' : 'di-red'} di-num">${v ? '✓' : '✗'}</span>`
      },
      {
        data: 'qcPassed', orderable: false,
        render: v => `<span class="${v ? 'di-green' : 'di-red'} di-num">${v ? '✓' : '✗'}</span>`
      },
      {
        data: 'failureReasons', orderable: false,
        render: v => `<span class="di-small di-muted">${v === '-' ? '' : esc(v)}</span>`
      },
      {
        data: 'transcript', orderable: false,
        render: (v) => `<span class="di-small di-transcript" title="${esc(v)}">${trunc(v, 45)}</span>`
      }
    ],
    order: [[2, 'asc']]
  });
}

function renderFailChart(data) {
  const ctx = document.getElementById('diFailChart').getContext('2d');
  if (failChart) failChart.destroy();
  failChart = new Chart(ctx, {
    type: 'bar',
    data: {
      labels: data.map(d => d.reason),
      datasets: [{
        label: 'Failures',
        data: data.map(d => d.failCount),
        backgroundColor: ['#f2495c', '#ff9830', '#fade2a', '#73bf69', '#b877d9'],
        borderRadius: 4,
        barPercentage: 0.55
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: { legend: { display: false } },
      scales: {
        x: { ticks: { color: '#8e9199', font: { size: 11 } }, grid: { color: '#23262b' } },
        y: { ticks: { color: '#8e9199' }, grid: { color: '#23262b' }, beginAtZero: true }
      }
    }
  });
}

function renderQcChart(qc) {
  const ctx = document.getElementById('diQcChart').getContext('2d');
  if (qcChart) qcChart.destroy();
  if (!qc || qc.q1_score == null) {
    document.querySelector('#diQcPanel .di-panel-body').innerHTML =
      '<div class="di-empty-sm">No QC scoring data for this batch</div>';
    return;
  }
  qcChart = new Chart(ctx, {
    type: 'radar',
    data: {
      labels: ['Naturalness', 'Clarity', 'Accent', 'Pace', 'Pronunciation', 'Overall'],
      datasets: [{
        label: 'Score',
        data: [qc.q1_score, qc.q2_score, qc.q3_score, qc.q4_score, qc.q5_score, qc.q6_score],
        borderColor: '#5794f2',
        backgroundColor: 'rgba(87,148,242,0.15)',
        pointBackgroundColor: '#5794f2',
        pointRadius: 4,
        borderWidth: 2
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: { legend: { display: false } },
      scales: {
        r: {
          min: 0, max: 5,
          ticks: { stepSize: 1, color: '#8e9199', backdropColor: 'transparent' },
          grid: { color: '#2c3235' },
          pointLabels: { color: '#ccccdc', font: { size: 11 } }
        }
      }
    }
  });
}

/* ── Helpers ───────────────────────────────────────────────── */
function stageClass(s) {
  s = (s || '').toLowerCase();
  return s === 'approved' ? 'di-badge-success'
       : s === 'training' ? 'di-badge-info'
       : s === 'qc'       ? 'di-badge-warn'
       : s === 'scored'   ? 'di-badge-purple'
                          : 'di-badge-muted';
}

function licClass(s) {
  s = (s || '').toLowerCase();
  return s === 'approved' ? 'di-badge-success'
       : s === 'pending'  ? 'di-badge-warn'
       : s === 'rejected' ? 'di-badge-danger'
                          : 'di-badge-muted';
}

function ii(k, v)    { return `<div class="di-info-item"><div class="di-info-key">${k}</div><div class="di-info-val">${v}</div></div>`; }
function mc(c, v, l) { return `<div class="di-m-card di-m-${c}"><div class="di-m-val">${v}</div><div class="di-m-lbl">${l}</div></div>`; }
function skelGrid(n) { return Array.from({length: n}, () => `<div class="di-info-item"><div class="di-skel-line"></div><div class="di-skel-line di-skel-short"></div></div>`).join(''); }
function skelRow(n)  { return Array.from({length: n}, () => `<div class="di-m-card di-m-blue"><div class="di-skel-line"></div><div class="di-skel-line di-skel-short"></div></div>`).join(''); }
function fetchJ(p)   { return fetch(BASE + p).then(r => r.json()); }
function enc(s)      { return encodeURIComponent(s); }
function esc(s)      { if (!s) return '–'; return String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;'); }
function trunc(s, n) { if (!s) return '–'; return s.length > n ? s.substring(0, n) + '…' : s; }

function destroyCharts() {
  if (failChart) { failChart.destroy(); failChart = null; }
  if (qcChart)   { qcChart.destroy();   qcChart   = null; }
}