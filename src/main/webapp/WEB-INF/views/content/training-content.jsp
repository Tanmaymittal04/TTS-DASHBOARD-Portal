<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
/* ═══════════════════════════════════════════════════════════
   TRAINING JOBS — INLINE STYLES v1
   Matches dashboard dark/light theme tokens
═══════════════════════════════════════════════════════════ */

/* ── Theme tokens ────────────────────────────────────────── */
[data-theme="dark"] {
  --tr-bg        : #0f1117;
  --tr-panel     : #161820;
  --tr-panel-2   : #1c1f2e;
  --tr-panel-3   : #222537;
  --tr-panel-4   : #282b3e;
  --tr-border    : rgba(255,255,255,0.07);
  --tr-border-hi : rgba(99,102,241,0.35);
  --tr-text      : #d8dae8;
  --tr-muted     : #6b7280;
  --tr-faint     : #252838;
  --tr-accent    : #6366f1;
  --tr-green     : #22c55e;
  --tr-red       : #ef4444;
  --tr-amber     : #f59e0b;
  --tr-cyan      : #06b6d4;
  --tr-purple    : #a855f7;
  --tr-shadow    : 0 2px 12px rgba(0,0,0,0.4);
  --tr-shadow-lg : 0 8px 32px rgba(0,0,0,0.55);
}
[data-theme="light"] {
  --tr-bg        : #eef0f6;
  --tr-panel     : #ffffff;
  --tr-panel-2   : #f3f4f9;
  --tr-panel-3   : #eceef6;
  --tr-panel-4   : #e4e6f0;
  --tr-border    : rgba(0,0,0,0.08);
  --tr-border-hi : rgba(79,70,229,0.3);
  --tr-text      : #1a1d2e;
  --tr-muted     : #6b7280;
  --tr-faint     : #dde0ec;
  --tr-accent    : #4f46e5;
  --tr-green     : #16a34a;
  --tr-red       : #dc2626;
  --tr-amber     : #d97706;
  --tr-cyan      : #0891b2;
  --tr-purple    : #7c3aed;
  --tr-shadow    : 0 2px 8px rgba(0,0,0,0.07);
  --tr-shadow-lg : 0 8px 24px rgba(0,0,0,0.10);
}

/* ── Page wrapper ────────────────────────────────────────── */
.tr-page { display:flex; flex-direction:column; gap:16px; padding-bottom:40px; }

/* ── Section label ───────────────────────────────────────── */
.tr-section-label {
  font-size:10px; font-weight:700; letter-spacing:0.14em;
  text-transform:uppercase; color:var(--tr-muted);
  display:flex; align-items:center; gap:10px; margin-bottom:4px;
}
.tr-section-label::after { content:''; flex:1; height:1px; background:linear-gradient(90deg, var(--tr-border), transparent); }

/* ═══════════════════════════════════════════════════════════
   KPI STRIP
═══════════════════════════════════════════════════════════ */
.tr-kpi-grid {
  display:grid;
  grid-template-columns:repeat(6,1fr);
  gap:10px;
}
@media (max-width:1280px) { .tr-kpi-grid { grid-template-columns:repeat(3,1fr); } }
@media (max-width:640px)  { .tr-kpi-grid { grid-template-columns:repeat(2,1fr); } }

.tr-kpi {
  background:var(--tr-panel);
  border:1px solid var(--tr-border);
  border-radius:10px;
  padding:14px 16px 12px;
  position:relative; overflow:hidden;
  transition:border-color 160ms, box-shadow 160ms;
}
.tr-kpi::before {
  content:'';
  position:absolute; top:0; left:0; right:0; height:2px;
  background:var(--kpi-color, var(--tr-accent));
}
.tr-kpi::after {
  content:'';
  position:absolute; top:0; left:0; right:0; bottom:0;
  background:linear-gradient(135deg, color-mix(in srgb, var(--kpi-color,var(--tr-accent)) 5%, transparent) 0%, transparent 60%);
  pointer-events:none;
}
.tr-kpi:hover { border-color:color-mix(in srgb, var(--kpi-color,var(--tr-accent)) 40%, transparent); box-shadow:var(--tr-shadow); }

.kpi-label {
  font-size:10px; font-weight:700; text-transform:uppercase;
  letter-spacing:0.1em; color:var(--tr-muted); margin-bottom:8px;
}
.kpi-value {
  font-size:28px; font-weight:300; color:var(--tr-text);
  line-height:1; margin-bottom:6px; font-variant-numeric:tabular-nums;
  display:flex; align-items:baseline; gap:4px;
}
.kpi-unit { font-size:13px; font-weight:400; color:var(--tr-muted); }
.kpi-change { font-size:11px; color:var(--tr-muted); }
.kpi-change.up   { color:var(--tr-green); }
.kpi-change.down { color:var(--tr-red); }
.kpi-icon {
  position:absolute; top:12px; right:14px;
  font-size:22px; opacity:0.13;
}

/* ═══════════════════════════════════════════════════════════
   CHART PANELS
═══════════════════════════════════════════════════════════ */
.tr-panel {
  background:var(--tr-panel);
  border:1px solid var(--tr-border);
  border-radius:10px;
  box-shadow:var(--tr-shadow);
  overflow:hidden;
}
.tr-panel-header {
  display:flex; align-items:flex-start; justify-content:space-between;
  padding:13px 18px 11px;
  border-bottom:1px solid var(--tr-border);
  background:linear-gradient(135deg, var(--tr-panel) 0%, var(--tr-panel-2) 100%);
}
.tr-panel-title { font-size:13px; font-weight:700; color:var(--tr-text); margin-bottom:2px; }
.tr-panel-sub   { font-size:11px; color:var(--tr-muted); line-height:1.4; }
.tr-panel-badge {
  font-size:9.5px; font-weight:700; text-transform:uppercase; letter-spacing:0.05em;
  padding:3px 9px; border-radius:20px; flex-shrink:0; margin-top:1px;
  background:color-mix(in srgb, var(--tr-accent) 12%, transparent);
  color:var(--tr-accent);
  border:1px solid color-mix(in srgb, var(--tr-accent) 25%, transparent);
}
.tr-panel-body { padding:16px 18px; }

/* Chart canvas containers */
.tr-chart-wrap         { position:relative; height:260px; }
.tr-chart-wrap.tall    { height:300px; }
.tr-chart-wrap.short   { height:200px; }
.tr-chart-wrap.xl      { height:340px; }
.tr-chart-wrap canvas  { display:block; width:100% !important; }

/* ── Grid layouts ────────────────────────────────────────── */
.tr-grid-1   { display:grid; gap:12px; }
.tr-grid-2   { display:grid; grid-template-columns:1fr 1fr; gap:12px; }
.tr-grid-3   { display:grid; grid-template-columns:1fr 1fr 1fr; gap:12px; }
.tr-grid-2-1 { display:grid; grid-template-columns:2fr 1fr; gap:12px; }
.tr-grid-1-2 { display:grid; grid-template-columns:1fr 2fr; gap:12px; }

@media (max-width:1100px) {
  .tr-grid-3, .tr-grid-2, .tr-grid-2-1, .tr-grid-1-2 { grid-template-columns:1fr; }
  .tr-chart-wrap.xl { height:280px; }
}
@media (max-width:768px) {
  .tr-chart-wrap, .tr-chart-wrap.tall { height:220px; }
  .tr-chart-wrap.short { height:180px; }
}

/* ── Stats footer strip inside panel ─────────────────────── */
.tr-stat-strip {
  display:flex; gap:0;
  border-top:1px solid var(--tr-border);
  background:var(--tr-panel-2);
}
.tr-stat-item {
  flex:1; padding:10px 16px;
  display:flex; flex-direction:column; gap:3px;
  border-right:1px solid var(--tr-border);
}
.tr-stat-item:last-child { border-right:none; }
.tr-stat-label { font-size:9.5px; font-weight:700; text-transform:uppercase; letter-spacing:0.08em; color:var(--tr-muted); }
.tr-stat-val   { font-size:16px; font-weight:700; color:var(--tr-text); font-variant-numeric:tabular-nums; }
.tr-stat-sub   { font-size:10px; color:var(--tr-muted); }

/* ═══════════════════════════════════════════════════════════
   TABLE
═══════════════════════════════════════════════════════════ */
.tr-table-wrap {
  background:var(--tr-panel);
  border:1px solid var(--tr-border);
  border-radius:10px;
  box-shadow:var(--tr-shadow);
  overflow:hidden;
}
.tr-table-header {
  display:flex; align-items:center; justify-content:space-between;
  padding:13px 18px; border-bottom:1px solid var(--tr-border);
  background:linear-gradient(135deg, var(--tr-panel) 0%, var(--tr-panel-2) 100%);
}
.tr-table-title { font-size:13px; font-weight:700; color:var(--tr-text); }
.tr-table-sub   { font-size:11px; color:var(--tr-muted); margin-top:2px; }

/* Table overrides */
#tblTraining { font-size:12px; }
#tblTraining thead th {
  font-size:10px; font-weight:700; text-transform:uppercase;
  letter-spacing:0.07em; color:var(--tr-muted) !important;
  background:var(--tr-panel-2) !important;
  border-bottom:1px solid var(--tr-border) !important;
  white-space:nowrap; padding:9px 12px !important;
}
#tblTraining tbody td {
  padding:9px 12px !important;
  border-bottom:1px solid var(--tr-border) !important;
  vertical-align:middle; color:var(--tr-text);
}
#tblTraining tbody tr:last-child td { border-bottom:none !important; }
#tblTraining tbody tr:hover td { background:var(--tr-panel-2) !important; }
#tblTraining.no-footer { border-bottom:1px solid var(--tr-border) !important; }

/* Job ID */
.job-id {
  font-size:11px; font-weight:600; color:var(--tr-accent);
  font-family:'JetBrains Mono','Fira Code',ui-monospace,monospace;
  letter-spacing:0.01em;
}
/* Dataset / model cells */
.ds-cell, .model-cell, .type-cell, .date-cell {
  font-size:11.5px; color:var(--tr-muted); white-space:nowrap;
}
.type-cell { text-transform:capitalize; }
.hrs-cell  { font-size:11.5px; font-variant-numeric:tabular-nums; color:var(--tr-text); text-align:right; }

/* Lang pill */
.lang-pill {
  display:inline-block; font-size:10px; font-weight:800; letter-spacing:0.04em;
  padding:2px 8px; border-radius:4px;
  background:color-mix(in srgb, var(--tr-accent) 14%, transparent);
  color:var(--tr-accent);
  border:1px solid color-mix(in srgb, var(--tr-accent) 28%, transparent);
}

/* GPU chip */
.gpu-chip {
  display:inline-block; font-size:10px; font-weight:700; letter-spacing:0.04em;
  padding:2px 8px; border-radius:20px; border:1px solid;
  font-variant-numeric:tabular-nums;
}

/* Status badges */
.tbl-badge {
  display:inline-flex; align-items:center; gap:4px;
  font-size:10px; font-weight:700; text-transform:uppercase;
  letter-spacing:0.05em; padding:3px 9px; border-radius:20px; border:1px solid;
}
.badge-pass    { background:rgba(34,197,94,0.14);  color:var(--tr-green);  border-color:rgba(34,197,94,0.3); }
.badge-fail    { background:rgba(239,68,68,0.14);   color:var(--tr-red);    border-color:rgba(239,68,68,0.3); }
.badge-review  { background:rgba(107,114,128,0.12); color:var(--tr-muted);  border-color:rgba(107,114,128,0.25); }
.badge-running { background:rgba(99,102,241,0.14);  color:var(--tr-accent); border-color:rgba(99,102,241,0.3); }
.badge-info    { background:rgba(6,182,212,0.14);   color:var(--tr-cyan);   border-color:rgba(6,182,212,0.3); }
.faint-val     { color:var(--tr-muted); font-size:12px; }

/* Epoch progress bar */
.epoch-cell { display:flex; align-items:center; gap:7px; }
.epoch-track { width:64px; height:5px; border-radius:3px; background:var(--tr-faint); overflow:hidden; flex-shrink:0; }
.epoch-fill  { height:100%; border-radius:3px; transition:width 0.6s ease; }
.epoch-label { font-size:10.5px; color:var(--tr-muted); white-space:nowrap; font-variant-numeric:tabular-nums; }

/* DataTables dark overrides */
.dataTables_wrapper { font-size:12px; color:var(--tr-text); }
.dataTables_wrapper .dataTables_length select,
.dataTables_wrapper .dataTables_filter input {
  background:var(--tr-panel-3); border:1px solid var(--tr-border);
  border-radius:6px; color:var(--tr-text); padding:4px 8px;
}
.dataTables_wrapper .dataTables_length select:focus,
.dataTables_wrapper .dataTables_filter input:focus { outline:none; border-color:var(--tr-accent); }
.dataTables_wrapper .dataTables_info { color:var(--tr-muted); font-size:11px; }
.dataTables_wrapper .dataTables_paginate .paginate_button {
  background:var(--tr-panel-3) !important; border:1px solid var(--tr-border) !important;
  color:var(--tr-muted) !important; border-radius:6px !important;
  padding:3px 8px !important; margin:0 2px !important; font-size:11px !important;
}
.dataTables_wrapper .dataTables_paginate .paginate_button:hover {
  background:var(--tr-panel-4) !important; color:var(--tr-text) !important;
  border-color:var(--tr-border-hi) !important;
}
.dataTables_wrapper .dataTables_paginate .paginate_button.current {
  background:color-mix(in srgb, var(--tr-accent) 18%, transparent) !important;
  color:var(--tr-accent) !important; border-color:var(--tr-accent) !important;
}

/* ── Fade-in animation ───────────────────────────────────── */
@keyframes trFadeUp { from { opacity:0; transform:translateY(8px); } to { opacity:1; transform:translateY(0); } }
.tr-panel, .tr-kpi, .tr-table-wrap { animation:trFadeUp 220ms ease both; }
</style>

<!-- ══════════════════════════════════════════════════════════
     PAGE CONTENT
═══════════════════════════════════════════════════════════ -->
<div class="tr-page">

  <!-- ── KPI STRIP ──────────────────────────────────────── -->
  <div class="tr-section-label">Live Metrics</div>
  <div class="tr-kpi-grid">

    <div class="tr-kpi" style="--kpi-color:#6366f1">
      <div class="kpi-icon">&#128640;</div>
      <div class="kpi-label">Total Jobs</div>
      <div class="kpi-value">6</div>
      <div class="kpi-change">This sprint</div>
    </div>

    <div class="tr-kpi" style="--kpi-color:#f59e0b">
      <div class="kpi-icon">&#9654;</div>
      <div class="kpi-label">Running</div>
      <div class="kpi-value">2</div>
      <div class="kpi-change">Active now</div>
    </div>

    <div class="tr-kpi" style="--kpi-color:#8888aa">
      <div class="kpi-icon">&#9203;</div>
      <div class="kpi-label">Queued</div>
      <div class="kpi-value">1</div>
      <div class="kpi-change">Waiting for GPU</div>
    </div>

    <div class="tr-kpi" style="--kpi-color:#22c55e">
      <div class="kpi-icon">&#9989;</div>
      <div class="kpi-label">Completed</div>
      <div class="kpi-value">2</div>
      <div class="kpi-change up">&#9650; Done</div>
    </div>

    <div class="tr-kpi" style="--kpi-color:#ef4444">
      <div class="kpi-icon">&#10060;</div>
      <div class="kpi-label">Failed</div>
      <div class="kpi-value">1</div>
      <div class="kpi-change down">&#9660; Needs debug</div>
    </div>

    <div class="tr-kpi" style="--kpi-color:#06b6d4">
      <div class="kpi-icon">&#128187;</div>
      <div class="kpi-label">GPU Hours Used</div>
      <div class="kpi-value">142<span class="kpi-unit">hrs</span></div>
      <div class="kpi-change">H100 / A100 / B200</div>
    </div>

  </div>

  <!-- ── LOSS CURVE (full width) ────────────────────────── -->
  <div class="tr-section-label">Loss Curves</div>
  <div class="tr-panel">
    <div class="tr-panel-header">
      <div>
        <div class="tr-panel-title">Train vs Validation Loss Curve</div>
        <div class="tr-panel-sub">Hindi XTTS fine-tune &mdash; TJ-2024-001 &mdash; 50 epochs &mdash; H100</div>
      </div>
      <span class="tr-panel-badge">Line</span>
    </div>
    <div class="tr-panel-body" style="padding-bottom:12px">
      <div class="tr-chart-wrap xl">
        <canvas id="chartLossCurve"></canvas>
      </div>
    </div>
    <div class="tr-stat-strip">
      <div class="tr-stat-item">
        <span class="tr-stat-label">Best Train Loss</span>
        <span class="tr-stat-val" style="color:var(--tr-accent)">0.634</span>
        <span class="tr-stat-sub">Epoch 50</span>
      </div>
      <div class="tr-stat-item">
        <span class="tr-stat-label">Best Val Loss</span>
        <span class="tr-stat-val" style="color:var(--tr-amber)">1.112</span>
        <span class="tr-stat-sub">Epoch 26–29</span>
      </div>
      <div class="tr-stat-item">
        <span class="tr-stat-label">Overfit Onset</span>
        <span class="tr-stat-val" style="color:var(--tr-red)">Ep 30</span>
        <span class="tr-stat-sub">Val loss diverged</span>
      </div>
      <div class="tr-stat-item">
        <span class="tr-stat-label">Gap (final)</span>
        <span class="tr-stat-val" style="color:var(--tr-muted)">0.601</span>
        <span class="tr-stat-sub">Train–Val delta</span>
      </div>
    </div>
  </div>

  <!-- ── CHARTS ROW — 3 col ─────────────────────────────── -->
  <div class="tr-section-label">Job Analytics</div>
  <div class="tr-grid-3">

    <div class="tr-panel">
      <div class="tr-panel-header">
        <div>
          <div class="tr-panel-title">Job Status</div>
          <div class="tr-panel-sub">All training jobs</div>
        </div>
        <span class="tr-panel-badge">Doughnut</span>
      </div>
      <div class="tr-panel-body">
        <div class="tr-chart-wrap short"><canvas id="chartJobStatus"></canvas></div>
      </div>
    </div>

    <div class="tr-panel">
      <div class="tr-panel-header">
        <div>
          <div class="tr-panel-title">GPU Distribution</div>
          <div class="tr-panel-sub">GPU type per job</div>
        </div>
        <span class="tr-panel-badge">Pie</span>
      </div>
      <div class="tr-panel-body">
        <div class="tr-chart-wrap short"><canvas id="chartGPUDist"></canvas></div>
      </div>
    </div>

    <div class="tr-panel">
      <div class="tr-panel-header">
        <div>
          <div class="tr-panel-title">Training Type</div>
          <div class="tr-panel-sub">Fine-tune / adapt / language</div>
        </div>
        <span class="tr-panel-badge">Bar</span>
      </div>
      <div class="tr-panel-body">
        <div class="tr-chart-wrap short"><canvas id="chartTrainType"></canvas></div>
      </div>
    </div>

  </div>

  <!-- ── CHARTS ROW 2 — 2 col ───────────────────────────── -->
  <div class="tr-grid-2">

    <div class="tr-panel">
      <div class="tr-panel-header">
        <div>
          <div class="tr-panel-title">GPU Hours per Job</div>
          <div class="tr-panel-sub">Compute consumed, colour-coded by status</div>
        </div>
        <span class="tr-panel-badge">H-Bar</span>
      </div>
      <div class="tr-panel-body">
        <div class="tr-chart-wrap"><canvas id="chartGpuHours"></canvas></div>
      </div>
    </div>

    <div class="tr-panel">
      <div class="tr-panel-header">
        <div>
          <div class="tr-panel-title">Epoch Progress</div>
          <div class="tr-panel-sub">Completed vs remaining epochs per active job</div>
        </div>
        <span class="tr-panel-badge">Stacked Bar</span>
      </div>
      <div class="tr-panel-body">
        <div class="tr-chart-wrap"><canvas id="chartEpochProgress"></canvas></div>
      </div>
    </div>

  </div>

  <!-- ── TRAINING JOBS TABLE ────────────────────────────── -->
  <div class="tr-section-label">All Jobs</div>
  <div class="tr-table-wrap">
    <div class="tr-table-header">
      <div>
        <div class="tr-table-title">Training Jobs</div>
        <div class="tr-table-sub">All sprint jobs — click headers to sort</div>
      </div>
    </div>
    <div style="padding:16px 18px">
      <div class="table-responsive">
        <table id="tblTraining" class="table table-hover w-100">
          <thead>
            <tr>
              <th>Job ID</th>
              <th>Dataset</th>
              <th>Base Model</th>
              <th>Lang</th>
              <th>Type</th>
              <th>GPU</th>
              <th>Epoch Progress</th>
              <th>Train Loss</th>
              <th>Val Loss</th>
              <th>Status</th>
              <th>Started</th>
              <th>GPU Hrs</th>
            </tr>
          </thead>
          <tbody id="trainingTableBody"></tbody>
        </table>
      </div>
    </div>
  </div>

</div><!-- /tr-page -->

<script src="${pageContext.request.contextPath}/static/js/training.js"></script>