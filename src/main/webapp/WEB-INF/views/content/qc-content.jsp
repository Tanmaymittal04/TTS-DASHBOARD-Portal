<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
/* ═══════════════════════════════════════════════════════════
   QC PAGE — INLINE STYLES
   Grafana-style dark panels, fully responsive
═══════════════════════════════════════════════════════════ */

/* ── Variables ────────────────────────────────────────────── */
[data-theme="dark"] {
  --qc-panel      : #181b1f;
  --qc-panel-2    : #1e2228;
  --qc-panel-hover: #1e2330;
  --qc-border     : rgba(255,255,255,0.07);
  --qc-border-hover: rgba(99,102,241,0.35);
  --qc-text       : #d8dae0;
  --qc-muted      : #6b7280;
  --qc-faint      : #3d4250;
  --qc-accent     : #6366f1;
  --qc-green      : #22c55e;
  --qc-red        : #ef4444;
  --qc-amber      : #f59e0b;
  --qc-cyan       : #06b6d4;
  --qc-shadow     : 0 1px 3px rgba(0,0,0,0.4), 0 4px 16px rgba(0,0,0,0.3);
}
[data-theme="light"] {
  --qc-panel      : #ffffff;
  --qc-panel-2    : #f4f6f9;
  --qc-panel-hover: #f0f4ff;
  --qc-border     : rgba(0,0,0,0.08);
  --qc-border-hover: rgba(79,70,229,0.3);
  --qc-text       : #1a1d2e;
  --qc-muted      : #6b7280;
  --qc-faint      : #d1d5db;
  --qc-accent     : #4f46e5;
  --qc-green      : #16a34a;
  --qc-red        : #dc2626;
  --qc-amber      : #d97706;
  --qc-cyan       : #0891b2;
  --qc-shadow     : 0 1px 3px rgba(0,0,0,0.07), 0 4px 12px rgba(0,0,0,0.05);
}

/* ── Page wrapper ─────────────────────────────────────────── */
.qc-page {
  display        : flex;
  flex-direction : column;
  gap            : 16px;
  padding        : 4px 0 24px;
  width          : 100%;
}

/* ══════════════════════════════════════════════════════════
   KPI STRIP
═══════════════════════════════════════════════════════════ */
.kpi-grid {
  display              : grid;
  grid-template-columns: repeat(5, 1fr);
  gap                  : 12px;
}
@media (max-width: 1200px) { .kpi-grid { grid-template-columns: repeat(3, 1fr); } }
@media (max-width: 768px)  { .kpi-grid { grid-template-columns: repeat(2, 1fr); } }
@media (max-width: 480px)  { .kpi-grid { grid-template-columns: 1fr; } }

.kpi-card {
  position     : relative;
  overflow     : hidden;
  background   : var(--qc-panel);
  border       : 1px solid var(--qc-border);
  border-radius: 10px;
  padding      : 16px 18px 14px 20px;
  box-shadow   : var(--qc-shadow);
  transition   : transform 150ms ease, box-shadow 150ms ease, border-color 150ms ease;
  cursor       : default;
}
.kpi-card:hover {
  transform    : translateY(-2px);
  box-shadow   : 0 4px 24px rgba(0,0,0,0.25), 0 1px 4px rgba(0,0,0,0.2);
  border-color : var(--qc-border-hover);
}
.kpi-card::before {
  content      : '';
  position     : absolute;
  left         : 0; top: 0; bottom: 0;
  width        : 3px;
  background   : var(--kpi-color, #6366f1);
  border-radius: 3px 0 0 3px;
}
.kpi-card::after {
  content      : '';
  position     : absolute;
  top: 0; left: 0; right: 0;
  height       : 50%;
  background   : linear-gradient(180deg, color-mix(in srgb, var(--kpi-color,#6366f1) 8%, transparent) 0%, transparent 100%);
  pointer-events: none;
}
.kpi-label {
  font-size    : 10.5px;
  font-weight  : 600;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color        : var(--qc-muted);
  margin-bottom: 8px;
}
.kpi-value {
  font-size    : clamp(20px, 2vw, 28px);
  font-weight  : 700;
  color        : var(--qc-text);
  line-height  : 1;
  font-variant-numeric: tabular-nums;
  letter-spacing: -0.02em;
  margin-bottom: 7px;
}
.kpi-change     { font-size: 11px; color: var(--qc-muted); }
.kpi-change.up  { color: var(--qc-green); font-weight: 500; }
.kpi-change.down{ color: var(--qc-red);   font-weight: 500; }
.kpi-icon {
  position  : absolute;
  right     : 14px; top: 14px;
  font-size : 20px;
  opacity   : 0.14;
  user-select: none;
}

/* ══════════════════════════════════════════════════════════
   SECTION LABELS
═══════════════════════════════════════════════════════════ */
.section-label {
  display      : flex;
  align-items  : center;
  gap          : 8px;
  font-size    : 10.5px;
  font-weight  : 700;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color        : var(--qc-muted);
  padding-left : 2px;
  margin-top   : 4px;
}
.section-label::after {
  content    : '';
  flex       : 1;
  height     : 1px;
  background : var(--qc-border);
}

/* ══════════════════════════════════════════════════════════
   CHART GRID — fills full available width
═══════════════════════════════════════════════════════════ */
.chart-grid {
  display: grid;
  gap    : 12px;
  width  : 100%;
}
.chart-grid-2 { grid-template-columns: 1fr 1fr; }
.chart-grid-3 { grid-template-columns: 1fr 1fr 1fr; }

@media (max-width: 960px) {
  .chart-grid-2,
  .chart-grid-3 { grid-template-columns: 1fr; }
}

/* ── Chart card ───────────────────────────────────────────── */
.chart-card {
  background     : var(--qc-panel);
  border         : 1px solid var(--qc-border);
  border-radius  : 10px;
  overflow       : hidden;
  box-shadow     : var(--qc-shadow);
  display        : flex;
  flex-direction : column;
  transition     : border-color 150ms ease, box-shadow 150ms ease;
  min-width      : 0; /* prevent grid blowout */
}
.chart-card:hover {
  border-color   : var(--qc-border-hover);
  box-shadow     : 0 4px 24px rgba(0,0,0,0.22), 0 1px 4px rgba(0,0,0,0.18);
}
.chart-card-header {
  display        : flex;
  align-items    : flex-start;
  justify-content: space-between;
  padding        : 13px 16px 10px;
  border-bottom  : 1px solid var(--qc-border);
  gap            : 10px;
  flex-shrink    : 0;
}
.chart-title    { font-size: 13px; font-weight: 600; color: var(--qc-text); line-height: 1.3; }
.chart-subtitle { font-size: 11px; color: var(--qc-muted); margin-top: 2px; }
.chart-badge {
  font-size    : 9.5px;
  font-weight  : 700;
  letter-spacing: 0.06em;
  text-transform: uppercase;
  color        : var(--qc-accent);
  background   : color-mix(in srgb, var(--qc-accent) 12%, transparent);
  border       : 1px solid color-mix(in srgb, var(--qc-accent) 22%, transparent);
  padding      : 2px 9px;
  border-radius: 20px;
  white-space  : nowrap;
  flex-shrink  : 0;
  margin-top   : 1px;
}

/* chart canvas container — flex:1 makes it fill remaining card height */
.chart-wrap {
  position  : relative;
  padding   : 14px 12px 8px;
  flex      : 1;
  min-height: 240px;
}
.chart-wrap.h-sm  { min-height: 200px; max-height: 230px; }
.chart-wrap.h-md  { min-height: 260px; }
.chart-wrap.h-lg  { min-height: 300px; }
.chart-wrap canvas { position: absolute; inset: 14px 12px 8px; }

/* ── Stat footer strip ────────────────────────────────────── */
.stat-row {
  display     : flex;
  border-top  : 1px solid var(--qc-border);
  flex-shrink : 0;
}
.stat-item {
  flex        : 1;
  padding     : 9px 12px;
  border-right: 1px solid var(--qc-border);
  text-align  : center;
}
.stat-item:last-child { border-right: none; }
.stat-val { font-size: 14px; font-weight: 700; font-variant-numeric: tabular-nums; }
.stat-lbl { font-size: 9.5px; color: var(--qc-muted); text-transform: uppercase; letter-spacing: 0.06em; margin-top: 2px; }

/* ── Threshold legend ─────────────────────────────────────── */
.threshold-legend {
  display    : flex;
  gap        : 14px;
  flex-wrap  : wrap;
  padding    : 6px 16px 11px;
  flex-shrink: 0;
}
.thr-item {
  display    : flex;
  align-items: center;
  gap        : 5px;
  font-size  : 10.5px;
  color      : var(--qc-muted);
}
.thr-dot { width: 8px; height: 8px; border-radius: 50%; flex-shrink: 0; }

/* ══════════════════════════════════════════════════════════
   TABLE CARD
═══════════════════════════════════════════════════════════ */
.table-card {
  background   : var(--qc-panel);
  border       : 1px solid var(--qc-border);
  border-radius: 10px;
  overflow     : hidden;
  box-shadow   : var(--qc-shadow);
}
.table-card-header {
  display        : flex;
  align-items    : center;
  justify-content: space-between;
  padding        : 12px 16px;
  border-bottom  : 1px solid var(--qc-border);
}
.table-title { font-size: 13px; font-weight: 600; color: var(--qc-text); }
.table-responsive { overflow-x: auto; padding: 0; }

/* DataTables dark overrides */
[data-theme="dark"] .dataTables_wrapper { color: var(--qc-muted); }
[data-theme="dark"] .dataTables_wrapper .dataTables_length,
[data-theme="dark"] .dataTables_wrapper .dataTables_filter { padding: 10px 14px 0; }
[data-theme="dark"] .dataTables_wrapper .dataTables_info,
[data-theme="dark"] .dataTables_wrapper .dataTables_paginate { padding: 8px 14px 12px; }
[data-theme="dark"] .dataTables_wrapper .dataTables_length select,
[data-theme="dark"] .dataTables_wrapper .dataTables_filter input {
  background: var(--qc-panel-2); border: 1px solid var(--qc-border);
  color: var(--qc-text); border-radius: 5px; padding: 4px 8px; outline: none;
}
[data-theme="dark"] .dataTables_wrapper .dataTables_filter input:focus {
  border-color: var(--qc-accent);
  box-shadow: 0 0 0 3px color-mix(in srgb, var(--qc-accent) 18%, transparent);
}
[data-theme="dark"] table.dataTable thead th {
  background: var(--qc-panel-2) !important;
  border-bottom: 1px solid var(--qc-faint) !important;
  color: var(--qc-muted); font-size: 10.5px; font-weight: 700;
  text-transform: uppercase; letter-spacing: 0.07em; padding: 10px 12px;
}
[data-theme="dark"] table.dataTable tbody tr {
  background: var(--qc-panel) !important;
  color: var(--qc-text); font-size: 12.5px; transition: background 100ms;
}
[data-theme="dark"] table.dataTable tbody tr:nth-child(even) { background: var(--qc-panel-2) !important; }
[data-theme="dark"] table.dataTable tbody tr:hover td { background: rgba(99,102,241,0.07) !important; }
[data-theme="dark"] table.dataTable tbody td {
  border-top: 1px solid var(--qc-faint) !important;
  padding: 8px 12px; vertical-align: middle;
}
[data-theme="dark"] .dataTables_wrapper .dataTables_paginate .paginate_button {
  color: var(--qc-muted) !important; border-radius: 5px !important; border: none !important;
}
[data-theme="dark"] .dataTables_wrapper .dataTables_paginate .paginate_button:hover {
  background: rgba(99,102,241,0.15) !important; color: var(--qc-text) !important;
}
[data-theme="dark"] .dataTables_wrapper .dataTables_paginate .paginate_button.current,
[data-theme="dark"] .dataTables_wrapper .dataTables_paginate .paginate_button.current:hover {
  background: var(--qc-accent) !important; border-color: transparent !important;
  color: #fff !important;
}

/* ── Badges, pills, bars ─────────────────────────────────── */
.qc-badge {
  display: inline-block; padding: 2px 9px; border-radius: 20px;
  font-size: 10.5px; font-weight: 600; letter-spacing: 0.03em;
}
.badge-pass   { background:rgba(34,197,94,0.14);  color:#22c55e; border:1px solid rgba(34,197,94,0.28); }
.badge-fail   { background:rgba(239,68,68,0.14);  color:#ef4444; border:1px solid rgba(239,68,68,0.28); }
.badge-review { background:rgba(245,158,11,0.14); color:#f59e0b; border:1px solid rgba(245,158,11,0.28); }

.lang-pill {
  background:rgba(6,182,212,0.12); color:#06b6d4;
  border:1px solid rgba(6,182,212,0.24); border-radius:20px;
  padding:1px 8px; font-size:10.5px; font-weight:600;
}
.clip-id {
  font-family: 'JetBrains Mono','Fira Code',monospace;
  font-size: 11px; color: var(--qc-accent);
  background: color-mix(in srgb, var(--qc-accent) 10%, transparent);
  padding: 1px 6px; border-radius: 4px;
}
.qbar-wrap  { display:flex; align-items:center; gap:7px; min-width:100px; }
.qbar-track { flex:1; height:5px; border-radius:3px; background:var(--qc-faint); overflow:hidden; }
.qbar-fill  { height:100%; border-radius:3px; transition:width 0.3s ease; }
.qbar-label { font-size:11.5px; font-weight:600; color:var(--qc-text); min-width:24px; text-align:right; font-variant-numeric:tabular-nums; }
</style>

<!-- ══════════════════════════════════════════════════════════
     PAGE CONTENT
═══════════════════════════════════════════════════════════ -->
<div class="qc-page">

  <!-- KPI STRIP -->
  <div class="kpi-grid">
    <div class="kpi-card" style="--kpi-color:#6366f1">
      <div class="kpi-icon">&#127925;</div>
      <div class="kpi-label">Total Clips</div>
      <div class="kpi-value">68,461</div>
      <div class="kpi-change">Across all datasets</div>
    </div>
    <div class="kpi-card" style="--kpi-color:#22c55e">
      <div class="kpi-icon">&#9989;</div>
      <div class="kpi-label">QC Pass</div>
      <div class="kpi-value">61,400</div>
      <div class="kpi-change up">&#8593; 87.4% pass rate</div>
    </div>
    <div class="kpi-card" style="--kpi-color:#ef4444">
      <div class="kpi-icon">&#10060;</div>
      <div class="kpi-label">QC Fail</div>
      <div class="kpi-value">5,821</div>
      <div class="kpi-change down">&#8595; 8.4% failure rate</div>
    </div>
    <div class="kpi-card" style="--kpi-color:#f59e0b">
      <div class="kpi-icon">&#128269;</div>
      <div class="kpi-label">Under Review</div>
      <div class="kpi-value">1,240</div>
      <div class="kpi-change">1.8% in review queue</div>
    </div>
    <div class="kpi-card" style="--kpi-color:#06b6d4">
      <div class="kpi-icon">&#11088;</div>
      <div class="kpi-label">Avg Quality Score</div>
      <div class="kpi-value">82.4</div>
      <div class="kpi-change up">&#8593; 1.2 vs last week</div>
    </div>
  </div>

  <!-- ROW 1 -->
  <div class="section-label">Status &amp; Score Overview</div>
  <div class="chart-grid chart-grid-2">

    <div class="chart-card">
      <div class="chart-card-header">
        <div><div class="chart-title">QC Status Distribution</div><div class="chart-subtitle">Pass / Fail / Review — 68,461 total clips</div></div>
        <span class="chart-badge">Doughnut</span>
      </div>
      <div class="chart-wrap h-md"><canvas id="chartQCStatus"></canvas></div>
      <div class="stat-row">
        <div class="stat-item"><div class="stat-val" style="color:#22c55e">61,400</div><div class="stat-lbl">Pass</div></div>
        <div class="stat-item"><div class="stat-val" style="color:#ef4444">5,821</div><div class="stat-lbl">Fail</div></div>
        <div class="stat-item"><div class="stat-val" style="color:#f59e0b">1,240</div><div class="stat-lbl">Review</div></div>
      </div>
    </div>

    <div class="chart-card">
      <div class="chart-card-header">
        <div><div class="chart-title">Quality Score Distribution</div><div class="chart-subtitle">Clip count by quality score band (0–100)</div></div>
        <span class="chart-badge">Bar</span>
      </div>
      <div class="chart-wrap h-md"><canvas id="chartQualityDist"></canvas></div>
      <div class="threshold-legend">
        <span class="thr-item"><span class="thr-dot" style="background:#ef4444"></span>Poor (0–40)</span>
        <span class="thr-item"><span class="thr-dot" style="background:#f59e0b"></span>Fair (40–60)</span>
        <span class="thr-item"><span class="thr-dot" style="background:#06b6d4"></span>Good (60–70)</span>
        <span class="thr-item"><span class="thr-dot" style="background:#22c55e"></span>Excellent (70–100)</span>
      </div>
    </div>

  </div>

  <!-- ROW 2 -->
  <div class="section-label">Audio Quality Metrics</div>
  <div class="chart-grid chart-grid-2">

    <div class="chart-card">
      <div class="chart-card-header">
        <div><div class="chart-title">Avg Noise Score by Language</div><div class="chart-subtitle">Lower is better — 0.0 is perfectly clean</div></div>
        <span class="chart-badge">Bar</span>
      </div>
      <div class="chart-wrap h-md"><canvas id="chartNoiseByLang"></canvas></div>
      <div class="threshold-legend">
        <span class="thr-item"><span class="thr-dot" style="background:#22c55e"></span>&lt; 0.20 Clean</span>
        <span class="thr-item"><span class="thr-dot" style="background:#f59e0b"></span>0.20–0.27 Moderate</span>
        <span class="thr-item"><span class="thr-dot" style="background:#ef4444"></span>&gt; 0.27 Noisy</span>
      </div>
    </div>

    <div class="chart-card">
      <div class="chart-card-header">
        <div><div class="chart-title">Top Rejection Reasons</div><div class="chart-subtitle">Why clips failed QC — 5,821 total rejections</div></div>
        <span class="chart-badge">Horizontal Bar</span>
      </div>
      <div class="chart-wrap h-lg"><canvas id="chartRejectionReasons"></canvas></div>
    </div>

  </div>

  <!-- ROW 3 -->
  <div class="section-label">ASR Performance &amp; Trend</div>
  <div class="chart-grid chart-grid-2">

    <div class="chart-card">
      <div class="chart-card-header">
        <div><div class="chart-title">ASR WER % by Language</div><div class="chart-subtitle">Word Error Rate — lower is better</div></div>
        <span class="chart-badge">Bar</span>
      </div>
      <div class="chart-wrap h-md"><canvas id="chartWERByLang"></canvas></div>
      <div class="threshold-legend">
        <span class="thr-item"><span class="thr-dot" style="background:#22c55e"></span>&lt; 9% Excellent</span>
        <span class="thr-item"><span class="thr-dot" style="background:#f59e0b"></span>9–13% Acceptable</span>
        <span class="thr-item"><span class="thr-dot" style="background:#ef4444"></span>&gt; 13% High Error</span>
      </div>
    </div>

    <div class="chart-card">
      <div class="chart-card-header">
        <div><div class="chart-title">QC Pass Rate Trend</div><div class="chart-subtitle">Weekly pass &amp; fail rate — last 8 weeks</div></div>
        <span class="chart-badge">Line</span>
      </div>
      <div class="chart-wrap h-md"><canvas id="chartQCWeeklyTrend"></canvas></div>
    </div>

  </div>

  <!-- TABLE -->
  <div class="section-label">Clip Records</div>
  <div class="table-card">
    <div class="table-card-header">
      <div class="table-title">Audio Clip QC Records</div>
      <span class="chart-badge" style="font-size:9.5px">100 sample rows &mdash; hardcoded</span>
    </div>
    <div class="table-responsive">
      <table id="tblClips" class="table table-hover w-100" style="font-size:12.5px; margin:0;">
        <thead>
          <tr>
            <th>Clip ID</th><th>Dataset</th><th>Lang</th><th>Speaker</th>
            <th>Duration</th><th>Noise</th><th>Silence</th><th>WER</th>
            <th>Quality</th><th>Status</th><th>Reject Reason</th><th>Reviewed By</th>
          </tr>
        </thead>
        <tbody id="clipTableBody"></tbody>
      </table>
    </div>
  </div>

</div>

<script src="${pageContext.request.contextPath}/static/js/qc.js"></script>