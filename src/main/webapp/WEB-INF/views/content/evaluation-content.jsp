<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
/* ═══════════════════════════════════════════════════════════════
   EVALUATION DASHBOARD — Inline styles
   Mirrors training-content.jsp token system (ev-* prefix)
═══════════════════════════════════════════════════════════════ */

/* ── Theme tokens ─────────────────────────────────────────── */
[data-theme="dark"] {
  --ev-bg       : #0f1117;
  --ev-panel    : #161820;
  --ev-panel-2  : #1c1f2e;
  --ev-panel-3  : #222537;
  --ev-panel-4  : #282b3e;
  --ev-border   : rgba(255,255,255,0.07);
  --ev-border-hi: rgba(99,102,241,0.35);
  --ev-text     : #d8dae8;
  --ev-muted    : #6b7280;
  --ev-faint    : #252838;
  --ev-accent   : #6366f1;
  --ev-green    : #22c55e;
  --ev-red      : #ef4444;
  --ev-amber    : #f59e0b;
  --ev-cyan     : #06b6d4;
  --ev-purple   : #a855f7;
  --ev-orange   : #f97316;
  --ev-shadow   : 0 2px 12px rgba(0,0,0,0.4);
  --ev-shadow-lg: 0 8px 32px rgba(0,0,0,0.55);
}
[data-theme="light"] {
  --ev-bg       : #eef0f6;
  --ev-panel    : #ffffff;
  --ev-panel-2  : #f3f4f9;
  --ev-panel-3  : #eceef6;
  --ev-panel-4  : #e4e6f0;
  --ev-border   : rgba(0,0,0,0.08);
  --ev-border-hi: rgba(79,70,229,0.3);
  --ev-text     : #1a1d2e;
  --ev-muted    : #6b7280;
  --ev-faint    : #dde0ec;
  --ev-accent   : #4f46e5;
  --ev-green    : #16a34a;
  --ev-red      : #dc2626;
  --ev-amber    : #d97706;
  --ev-cyan     : #0891b2;
  --ev-purple   : #7c3aed;
  --ev-orange   : #ea580c;
  --ev-shadow   : 0 2px 8px rgba(0,0,0,0.07);
  --ev-shadow-lg: 0 8px 24px rgba(0,0,0,0.10);
}

/* ── Page wrapper ─────────────────────────────────────────── */
.ev-page { display:flex; flex-direction:column; gap:16px; padding-bottom:40px; }

/* ── Section label ────────────────────────────────────────── */
.ev-section-label {
  font-size:10px; font-weight:700; letter-spacing:0.14em;
  text-transform:uppercase; color:var(--ev-muted);
  display:flex; align-items:center; gap:10px; margin-bottom:4px;
}
.ev-section-label::after {
  content:''; flex:1; height:1px;
  background:linear-gradient(90deg, var(--ev-border), transparent);
}

/* ═══════════════════════════════════════════════════════════
   KPI STRIP
═══════════════════════════════════════════════════════════ */
.ev-kpi-grid {
  display:grid;
  grid-template-columns:repeat(5,1fr);
  gap:10px;
}
@media (max-width:1280px) { .ev-kpi-grid { grid-template-columns:repeat(3,1fr); } }
@media (max-width:640px)  { .ev-kpi-grid { grid-template-columns:repeat(2,1fr); } }

.ev-kpi {
  background:var(--ev-panel);
  border:1px solid var(--ev-border);
  border-radius:10px;
  padding:14px 16px 12px;
  position:relative; overflow:hidden;
  transition:border-color 160ms, box-shadow 160ms;
}
.ev-kpi::before {
  content:''; position:absolute; top:0; left:0; right:0; height:2px;
  background:var(--kpi-color, var(--ev-accent));
}
.ev-kpi::after {
  content:''; position:absolute; top:0; left:0; right:0; bottom:0;
  background:linear-gradient(135deg,
    color-mix(in srgb, var(--kpi-color, var(--ev-accent)) 5%, transparent) 0%,
    transparent 60%);
  pointer-events:none;
}
.ev-kpi:hover {
  border-color:color-mix(in srgb, var(--kpi-color, var(--ev-accent)) 40%, transparent);
  box-shadow:var(--ev-shadow);
}
.ev-kpi .kpi-label {
  font-size:10px; font-weight:700; text-transform:uppercase;
  letter-spacing:0.1em; color:var(--ev-muted); margin-bottom:8px;
}
.ev-kpi .kpi-value {
  font-size:28px; font-weight:300; color:var(--ev-text);
  line-height:1; margin-bottom:6px; font-variant-numeric:tabular-nums;
  display:flex; align-items:baseline; gap:4px;
}
.ev-kpi .kpi-unit  { font-size:13px; font-weight:400; color:var(--ev-muted); }
.ev-kpi .kpi-change { font-size:11px; color:var(--ev-muted); }
.ev-kpi .kpi-change.up   { color:var(--ev-green); }
.ev-kpi .kpi-change.down { color:var(--ev-red); }
.ev-kpi .kpi-icon {
  position:absolute; top:12px; right:14px;
  font-size:22px; opacity:0.13;
}

/* ═══════════════════════════════════════════════════════════
   CHART PANELS
═══════════════════════════════════════════════════════════ */
.ev-panel {
  background:var(--ev-panel);
  border:1px solid var(--ev-border);
  border-radius:10px;
  box-shadow:var(--ev-shadow);
  overflow:hidden;
}
.ev-panel-header {
  display:flex; align-items:flex-start; justify-content:space-between;
  padding:13px 18px 11px;
  border-bottom:1px solid var(--ev-border);
  background:linear-gradient(135deg, var(--ev-panel) 0%, var(--ev-panel-2) 100%);
}
.ev-panel-title  { font-size:13px; font-weight:700; color:var(--ev-text); margin-bottom:2px; }
.ev-panel-sub    { font-size:11px; color:var(--ev-muted); line-height:1.4; }
.ev-panel-badge  {
  font-size:9.5px; font-weight:700; text-transform:uppercase; letter-spacing:0.05em;
  padding:3px 9px; border-radius:20px; flex-shrink:0; margin-top:1px;
  background:color-mix(in srgb, var(--ev-accent) 12%, transparent);
  color:var(--ev-accent);
  border:1px solid color-mix(in srgb, var(--ev-accent) 25%, transparent);
}
.ev-panel-body   { padding:16px 18px; }

/* Canvas containers */
.ev-chart-wrap          { position:relative; height:260px; }
.ev-chart-wrap.tall     { height:310px; }
.ev-chart-wrap.short    { height:210px; }
.ev-chart-wrap canvas   { display:block; width:100% !important; }

/* Stat strip */
.ev-stat-strip { display:flex; border-top:1px solid var(--ev-border); background:var(--ev-panel-2); }
.ev-stat-item  { flex:1; padding:10px 16px; display:flex; flex-direction:column; gap:3px; border-right:1px solid var(--ev-border); }
.ev-stat-item:last-child { border-right:none; }
.ev-stat-label { font-size:9.5px; font-weight:700; text-transform:uppercase; letter-spacing:0.08em; color:var(--ev-muted); }
.ev-stat-val   { font-size:16px; font-weight:700; color:var(--ev-text); font-variant-numeric:tabular-nums; }
.ev-stat-sub   { font-size:10px; color:var(--ev-muted); }

/* Metric legend tags */
.ev-metric-tag {
  display:inline-flex; align-items:center; gap:5px;
  font-size:10px; font-weight:600; text-transform:uppercase; letter-spacing:0.05em;
  padding:3px 8px; border-radius:4px;
  background:var(--ev-panel-3); color:var(--ev-muted);
  border:1px solid var(--ev-border);
}
.ev-metric-tag .dot { width:6px; height:6px; border-radius:50%; display:inline-block; }

/* ── Grid layouts ─────────────────────────────────────────── */
.ev-grid-2   { display:grid; grid-template-columns:1fr 1fr; gap:12px; }
.ev-grid-3   { display:grid; grid-template-columns:1fr 1fr 1fr; gap:12px; }
.ev-grid-2-1 { display:grid; grid-template-columns:2fr 1fr; gap:12px; }

@media (max-width:1100px) {
  .ev-grid-3, .ev-grid-2, .ev-grid-2-1 { grid-template-columns:1fr; }
  .ev-chart-wrap { height:240px; }
}
@media (max-width:768px) {
  .ev-chart-wrap, .ev-chart-wrap.tall { height:220px; }
  .ev-chart-wrap.short { height:180px; }
}

/* ═══════════════════════════════════════════════════════════
   TABLE
═══════════════════════════════════════════════════════════ */
.ev-table-wrap {
  background:var(--ev-panel); border:1px solid var(--ev-border);
  border-radius:10px; box-shadow:var(--ev-shadow); overflow:hidden;
}
.ev-table-header {
  display:flex; align-items:center; justify-content:space-between;
  padding:13px 18px; border-bottom:1px solid var(--ev-border);
  background:linear-gradient(135deg, var(--ev-panel) 0%, var(--ev-panel-2) 100%);
}
.ev-table-title { font-size:13px; font-weight:700; color:var(--ev-text); }
.ev-table-sub   { font-size:11px; color:var(--ev-muted); margin-top:2px; }

#tblEval { font-size:12px; }
#tblEval thead th {
  font-size:10px; font-weight:700; text-transform:uppercase;
  letter-spacing:0.07em; color:var(--ev-muted) !important;
  background:var(--ev-panel-2) !important;
  border-bottom:1px solid var(--ev-border) !important;
  white-space:nowrap; padding:9px 12px !important;
}
#tblEval tbody td {
  padding:9px 12px !important;
  border-bottom:1px solid var(--ev-border) !important;
  vertical-align:middle; color:var(--ev-text);
}
#tblEval tbody tr:last-child td { border-bottom:none !important; }
#tblEval tbody tr:hover td { background:var(--ev-panel-2) !important; }
#tblEval.no-footer { border-bottom:1px solid var(--ev-border) !important; }

/* Job/Eval ID */
.ev-job-id {
  font-size:11px; font-weight:600; color:var(--ev-accent);
  font-family:'JetBrains Mono','Fira Code',ui-monospace,monospace; letter-spacing:0.01em;
}
.ev-model-cell { font-size:11.5px; color:var(--ev-muted); white-space:nowrap; }

/* Lang pill */
.ev-lang-pill {
  display:inline-block; font-size:10px; font-weight:800; letter-spacing:0.04em;
  padding:2px 8px; border-radius:4px;
  background:color-mix(in srgb, var(--ev-accent) 14%, transparent);
  color:var(--ev-accent);
  border:1px solid color-mix(in srgb, var(--ev-accent) 28%, transparent);
}

/* Status / grade badges */
.ev-tbl-badge {
  display:inline-flex; align-items:center; gap:4px;
  font-size:10px; font-weight:700; text-transform:uppercase;
  letter-spacing:0.05em; padding:3px 9px; border-radius:20px; border:1px solid;
  white-space:nowrap;
}
.ev-badge-a       { background:rgba(34,197,94,0.14);  color:#22c55e; border-color:rgba(34,197,94,0.3); }
.ev-badge-b       { background:rgba(245,158,11,0.14); color:#f59e0b; border-color:rgba(245,158,11,0.3); }
.ev-badge-c       { background:rgba(249,115,22,0.14); color:#f97316; border-color:rgba(249,115,22,0.3); }
.ev-badge-fail    { background:rgba(239,68,68,0.14);  color:#ef4444; border-color:rgba(239,68,68,0.3); }
.ev-badge-pass    { background:rgba(34,197,94,0.14);  color:#22c55e; border-color:rgba(34,197,94,0.3); }
.ev-badge-pending { background:rgba(99,102,241,0.14); color:#6366f1; border-color:rgba(99,102,241,0.3); }
.ev-badge-review  { background:rgba(245,158,11,0.12); color:#f59e0b; border-color:rgba(245,158,11,0.28); }

/* Score bar inside table cell */
.ev-score-cell  { display:flex; align-items:center; gap:7px; }
.ev-score-track { width:60px; height:5px; border-radius:3px; background:var(--ev-faint); overflow:hidden; flex-shrink:0; }
.ev-score-fill  { height:100%; border-radius:3px; transition:width 0.6s ease; }
.ev-score-label { font-size:10.5px; color:var(--ev-muted); white-space:nowrap; font-variant-numeric:tabular-nums; }

/* DataTables dark override */
.dataTables_wrapper { font-size:12px; color:var(--ev-text); }
.dataTables_wrapper .dataTables_length select,
.dataTables_wrapper .dataTables_filter input {
  background:var(--ev-panel-3); border:1px solid var(--ev-border);
  border-radius:6px; color:var(--ev-text); padding:4px 8px;
}
.dataTables_wrapper .dataTables_length select:focus,
.dataTables_wrapper .dataTables_filter input:focus { outline:none; border-color:var(--ev-accent); }
.dataTables_wrapper .dataTables_info { color:var(--ev-muted); font-size:11px; }
.dataTables_wrapper .dataTables_paginate .paginate_button {
  background:var(--ev-panel-3) !important; border:1px solid var(--ev-border) !important;
  color:var(--ev-muted) !important; border-radius:6px !important;
  padding:3px 8px !important; margin:0 2px !important; font-size:11px !important;
}
.dataTables_wrapper .dataTables_paginate .paginate_button:hover {
  background:var(--ev-panel-4) !important; color:var(--ev-text) !important;
  border-color:var(--ev-border-hi) !important;
}
.dataTables_wrapper .dataTables_paginate .paginate_button.current {
  background:color-mix(in srgb, var(--ev-accent) 18%, transparent) !important;
  color:var(--ev-accent) !important; border-color:var(--ev-accent) !important;
}

/* ── Fade-in ──────────────────────────────────────────────── */
@keyframes evFadeUp { from { opacity:0; transform:translateY(8px); } to { opacity:1; transform:translateY(0); } }
.ev-panel, .ev-kpi, .ev-table-wrap { animation:evFadeUp 220ms ease both; }
</style>

<!-- ══════════════════════════════════════════════════════════
     PAGE CONTENT
══════════════════════════════════════════════════════════ -->
<div class="ev-page">

  <!-- ── KPI STRIP ─────────────────────────────────────── -->
  <div class="ev-section-label">Live Metrics</div>
  <div class="ev-kpi-grid">

    <div class="ev-kpi" style="--kpi-color:#22c55e">
      <div class="kpi-icon">&#11088;</div>
      <div class="kpi-label">Avg MOS</div>
      <div class="kpi-value">4.12</div>
      <div class="kpi-change up">Target: &ge; 4.0 &#9989;</div>
    </div>

    <div class="ev-kpi" style="--kpi-color:#6366f1">
      <div class="kpi-icon">&#128202;</div>
      <div class="kpi-label">Avg WER</div>
      <div class="kpi-value">5.8<span class="kpi-unit">%</span></div>
      <div class="kpi-change up">Target: &lt; 8% &#9989;</div>
    </div>

    <div class="ev-kpi" style="--kpi-color:#06b6d4">
      <div class="kpi-icon">&#9889;</div>
      <div class="kpi-label">Avg Latency</div>
      <div class="kpi-value">428<span class="kpi-unit">ms</span></div>
      <div class="kpi-change up">Target: &lt; 800ms &#9989;</div>
    </div>

    <div class="ev-kpi" style="--kpi-color:#a855f7">
      <div class="kpi-icon">&#127908;</div>
      <div class="kpi-label">Avg Spk Similarity</div>
      <div class="kpi-value">0.75</div>
      <div class="kpi-change">Target: &ge; 0.80</div>
    </div>

    <div class="ev-kpi" style="--kpi-color:#22c55e">
      <div class="kpi-icon">&#127941;</div>
      <div class="kpi-label">Grade A Models</div>
      <div class="kpi-value">3</div>
      <div class="kpi-change">Out of 8 evaluations</div>
    </div>

  </div>

  <!-- ── ROW 1: MOS Bar (full width) ───────────────────── -->
  <div class="ev-section-label">MOS &amp; Quality</div>
  <div class="ev-panel">
    <div class="ev-panel-header">
      <div>
        <div class="ev-panel-title">MOS Score by Language</div>
        <div class="ev-panel-sub">Mean Opinion Score (1–5) &mdash; Green &ge; 4.0 passes quality gate</div>
      </div>
      <span class="ev-panel-badge">Bar</span>
    </div>
    <div class="ev-panel-body" style="padding-bottom:12px">
      <div class="ev-chart-wrap tall">
        <canvas id="chartMOSByLang"></canvas>
      </div>
    </div>
    <div class="ev-stat-strip">
      <div class="ev-stat-item">
        <span class="ev-stat-label">Best MOS</span>
        <span class="ev-stat-val" style="color:var(--ev-green)">4.51</span>
        <span class="ev-stat-sub">XTTS-EN-v3.0</span>
      </div>
      <div class="ev-stat-item">
        <span class="ev-stat-label">Target &ge; 4.0</span>
        <span class="ev-stat-val" style="color:var(--ev-accent)">3 / 8</span>
        <span class="ev-stat-sub">Passed threshold</span>
      </div>
      <div class="ev-stat-item">
        <span class="ev-stat-label">Worst MOS</span>
        <span class="ev-stat-val" style="color:var(--ev-red)">2.41</span>
        <span class="ev-stat-sub">XTTS-KN-v0.9</span>
      </div>
      <div class="ev-stat-item">
        <span class="ev-stat-label">Avg MOS</span>
        <span class="ev-stat-val" style="color:var(--ev-amber)">3.63</span>
        <span class="ev-stat-sub">All evaluations</span>
      </div>
    </div>
  </div>

  <!-- ── ROW 2: Radar + WER/CER ────────────────────────── -->
  <div class="ev-grid-2">

    <div class="ev-panel">
      <div class="ev-panel-header">
        <div>
          <div class="ev-panel-title">Multi-Metric Evaluation Radar</div>
          <div class="ev-panel-sub">Top 2 models &mdash; Naturalness · Intelligibility · Accuracy · Similarity · Speed · Responsiveness</div>
        </div>
        <span class="ev-panel-badge">Radar</span>
      </div>
      <div class="ev-panel-body">
        <div class="ev-chart-wrap tall">
          <canvas id="chartEvalRadar"></canvas>
        </div>
      </div>
    </div>

    <div class="ev-panel">
      <div class="ev-panel-header">
        <div>
          <div class="ev-panel-title">WER &amp; CER by Language</div>
          <div class="ev-panel-sub">Word &amp; Character Error Rate % &mdash; lower is better</div>
        </div>
        <span class="ev-panel-badge">Grouped Bar</span>
      </div>
      <div class="ev-panel-body">
        <div class="ev-chart-wrap tall">
          <canvas id="chartWERCER"></canvas>
        </div>
      </div>
    </div>

  </div>

  <!-- ── ROW 3: Latency + Grades ───────────────────────── -->
  <div class="ev-section-label">Latency &amp; Grading</div>
  <div class="ev-grid-2">

    <div class="ev-panel">
      <div class="ev-panel-header">
        <div>
          <div class="ev-panel-title">Latency Breakdown by Language</div>
          <div class="ev-panel-sub">Full latency vs First audio latency (ms) &mdash; red line = 800ms budget</div>
        </div>
        <span class="ev-panel-badge">Grouped Bar</span>
      </div>
      <div class="ev-panel-body">
        <div class="ev-chart-wrap">
          <canvas id="chartLatencyComp"></canvas>
        </div>
      </div>
    </div>

    <div class="ev-panel">
      <div class="ev-panel-header">
        <div>
          <div class="ev-panel-title">Model Grade Distribution</div>
          <div class="ev-panel-sub">A / B / C / Fail across all evaluations</div>
        </div>
        <span class="ev-panel-badge">Doughnut</span>
      </div>
      <div class="ev-panel-body">
        <div class="ev-chart-wrap">
          <canvas id="chartGrades"></canvas>
        </div>
      </div>
    </div>

  </div>

  <!-- ── ROW 4: MOS Version trend (full width) ─────────── -->
  <div class="ev-section-label">Version Progression</div>
  <div class="ev-panel">
    <div class="ev-panel-header">
      <div>
        <div class="ev-panel-title">MOS Improvement Over Versions</div>
        <div class="ev-panel-sub">Hindi &middot; English &middot; Tamil &mdash; all model versions (null = not released)</div>
      </div>
      <span class="ev-panel-badge">Line</span>
    </div>
    <div class="ev-panel-body" style="padding-bottom:12px">
      <div class="ev-chart-wrap tall">
        <canvas id="chartMOSVersions"></canvas>
      </div>
    </div>
    <div class="ev-stat-strip">
      <div class="ev-stat-item">
        <span class="ev-stat-label">EN best</span>
        <span class="ev-stat-val" style="color:var(--ev-green)">4.51</span>
        <span class="ev-stat-sub">v3.0 (+0.97 vs v1.0)</span>
      </div>
      <div class="ev-stat-item">
        <span class="ev-stat-label">HI best</span>
        <span class="ev-stat-val" style="color:var(--ev-accent)">4.32</span>
        <span class="ev-stat-sub">v2.1 (+1.41 vs v1.0)</span>
      </div>
      <div class="ev-stat-item">
        <span class="ev-stat-label">TA best</span>
        <span class="ev-stat-val" style="color:var(--ev-amber)">4.08</span>
        <span class="ev-stat-sub">v1.2 (+1.10 vs v1.0)</span>
      </div>
      <div class="ev-stat-item">
        <span class="ev-stat-label">Avg Improvement</span>
        <span class="ev-stat-val" style="color:var(--ev-muted)">+1.16</span>
        <span class="ev-stat-sub">MOS delta since v1.0</span>
      </div>
    </div>
  </div>

  <!-- ── EVALUATION TABLE ──────────────────────────────── -->
  <div class="ev-section-label">All Evaluations</div>
  <div class="ev-table-wrap">
    <div class="ev-table-header">
      <div>
        <div class="ev-table-title">Model Evaluation Records</div>
        <div class="ev-table-sub">All evaluations — MOS · WER · CER · Speaker Similarity · Latency · Pronunciation · Naturalness · Grade</div>
      </div>
    </div>
    <div style="padding:16px 18px">
      <div class="table-responsive">
        <table id="tblEval" class="table table-hover w-100">
          <thead>
            <tr>
              <th>Eval ID</th>
              <th>Model Version</th>
              <th>Lang</th>
              <th>MOS</th>
              <th>WER</th>
              <th>CER</th>
              <th>Spk Sim</th>
              <th>Latency</th>
              <th>1st Audio</th>
              <th>Pronunciation</th>
              <th>Naturalness</th>
              <th>Grade</th>
              <th>Status</th>
            </tr>
          </thead>
          <tbody id="evalTableBody"></tbody>
        </table>
      </div>
    </div>
  </div>

</div><!-- /ev-page -->

<script src="${pageContext.request.contextPath}/static/js/evaluation.js"></script>