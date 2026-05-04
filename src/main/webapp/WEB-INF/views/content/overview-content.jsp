<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!-- ═══════════════════════════════════════════════════════════════
     OVERVIEW PAGE — STYLES
════════════════════════════════════════════════════════════════ -->
<style>
/* ── Theme tokens (mirrors your existing di-* system) ─────────── */
[data-theme="dark"] {
  --ov-bg          : #0f1117;
  --ov-panel       : #161820;
  --ov-panel-2     : #1c1f2e;
  --ov-panel-3     : #222537;
  --ov-panel-4     : #282b3e;
  --ov-border      : rgba(255,255,255,0.07);
  --ov-border-hi   : rgba(99,102,241,0.35);
  --ov-text        : #d8dae8;
  --ov-muted       : #6b7280;
  --ov-faint       : #252838;
  --ov-accent      : #6366f1;
  --ov-green       : #22c55e;
  --ov-red         : #ef4444;
  --ov-amber       : #f59e0b;
  --ov-cyan        : #06b6d4;
  --ov-purple      : #a855f7;
  --ov-shadow      : 0 2px 12px rgba(0,0,0,.4);
  --ov-particle-op : 0.18;
}
[data-theme="light"] {
  --ov-bg          : #eef0f6;
  --ov-panel       : #ffffff;
  --ov-panel-2     : #f3f4f9;
  --ov-panel-3     : #eceef6;
  --ov-panel-4     : #e4e6f0;
  --ov-border      : rgba(0,0,0,0.08);
  --ov-border-hi   : rgba(79,70,229,0.3);
  --ov-text        : #1a1d2e;
  --ov-muted       : #6b7280;
  --ov-faint       : #dde0ec;
  --ov-accent      : #4f46e5;
  --ov-green       : #16a34a;
  --ov-red         : #dc2626;
  --ov-amber       : #d97706;
  --ov-cyan        : #0891b2;
  --ov-purple      : #7c3aed;
  --ov-shadow      : 0 2px 8px rgba(0,0,0,0.07);
  --ov-particle-op : 0.07;
}

/* ── Layout ───────────────────────────────────────────────────── */
.ov-page {
  display       : flex;
  flex-direction: column;
  gap           : 18px;
  padding-bottom: 48px;
  position      : relative;
}

/* ── Particle canvas ──────────────────────────────────────────── */
.ov-particle-wrap {
  position      : fixed;
  inset         : 0;
  z-index       : -1;
  pointer-events: none;
  opacity       : var(--ov-particle-op);
}
.ov-particle-wrap canvas { width:100%; height:100%; display:block; }

/* ── Section label ────────────────────────────────────────────── */
.ov-section-label {
  font-size      : 10px;
  font-weight    : 700;
  letter-spacing : .14em;
  text-transform : uppercase;
  color          : var(--ov-muted);
  display        : flex;
  align-items    : center;
  gap            : 10px;
  margin-bottom  : 2px;
}
.ov-section-label::after {
  content   : '';
  flex      : 1;
  height    : 1px;
  background: linear-gradient(90deg,var(--ov-border),transparent);
}

/* ── KPI Grid ─────────────────────────────────────────────────── */
.ov-kpi-grid {
  display              : grid;
  grid-template-columns: repeat(4,1fr);
  gap                  : 10px;
}
@media(max-width:1280px){ .ov-kpi-grid{ grid-template-columns:repeat(4,1fr) } }
@media(max-width:900px) { .ov-kpi-grid{ grid-template-columns:repeat(2,1fr) } }
@media(max-width:480px) { .ov-kpi-grid{ grid-template-columns:1fr } }

.ov-kpi {
  background : var(--ov-panel);
  border     : 1px solid var(--ov-border);
  border-radius: 10px;
  padding    : 14px 16px 12px;
  position   : relative;
  overflow   : hidden;
  transition : border-color 160ms, box-shadow 160ms;
  animation  : ovFadeUp 220ms ease both;
}
.ov-kpi::before {
  content   : '';
  position  : absolute;
  top: 0; left: 0; right: 0;
  height    : 2px;
  background: var(--kpi-c, var(--ov-accent));
}
.ov-kpi::after {
  content   : '';
  position  : absolute;
  inset     : 0;
  pointer-events: none;
  background: linear-gradient(135deg,
    color-mix(in srgb,var(--kpi-c,var(--ov-accent)) 6%,transparent) 0%,
    transparent 55%);
}
.ov-kpi:hover {
  border-color: color-mix(in srgb,var(--kpi-c,var(--ov-accent)) 45%,transparent);
  box-shadow  : var(--ov-shadow);
}
.ov-kpi-icon {
  position  : absolute;
  top: 12px; right: 14px;
  font-size : 22px;
  opacity   : .12;
  pointer-events: none;
  user-select: none;
}
.ov-kpi-label {
  font-size     : 9.5px;
  font-weight   : 700;
  text-transform: uppercase;
  letter-spacing: .10em;
  color         : var(--ov-muted);
  margin-bottom : 8px;
}
.ov-kpi-value {
  font-size    : 28px;
  font-weight  : 300;
  color        : var(--ov-text);
  line-height  : 1;
  margin-bottom: 6px;
  font-variant-numeric: tabular-nums;
  display      : flex;
  align-items  : baseline;
  gap          : 4px;
}
.ov-kpi-unit   { font-size:13px; font-weight:400; color:var(--ov-muted) }
.ov-kpi-change { font-size:11px; color:var(--ov-muted) }
.ov-kpi-change.up   { color:var(--ov-green) }
.ov-kpi-change.down { color:var(--ov-red) }

/* ── Pipeline Flow ────────────────────────────────────────────── */
.ov-flow-wrap {
  background   : var(--ov-panel);
  border       : 1px solid var(--ov-border);
  border-radius: 10px;
  padding      : 14px 18px;
  box-shadow   : var(--ov-shadow);
  overflow-x   : auto;
  animation    : ovFadeUp 240ms ease both;
}
.ov-flow {
  display    : flex;
  align-items: center;
  gap        : 4px;
  min-width  : max-content;
}
.ov-flow-step {
  display      : flex;
  align-items  : center;
  gap          : 6px;
  font-size    : 11px;
  font-weight  : 600;
  color        : var(--ov-muted);
  padding      : 6px 12px;
  border-radius: 20px;
  border       : 1px solid var(--ov-border);
  background   : var(--ov-panel-2);
  white-space  : nowrap;
  transition   : all 160ms;
  position     : relative;
}
.ov-flow-step .step-dot {
  width        : 6px;
  height       : 6px;
  border-radius: 50%;
  background   : var(--ov-muted);
  flex-shrink  : 0;
}
.ov-flow-step.active {
  color       : var(--ov-text);
  border-color: color-mix(in srgb,var(--ov-accent) 40%,transparent);
  background  : color-mix(in srgb,var(--ov-accent) 10%,transparent);
}
.ov-flow-step.active .step-dot {
  background: var(--ov-green);
  box-shadow: 0 0 6px var(--ov-green);
}
.ov-flow-step.running {
  color       : var(--ov-amber);
  border-color: color-mix(in srgb,var(--ov-amber) 40%,transparent);
  background  : color-mix(in srgb,var(--ov-amber) 10%,transparent);
}
.ov-flow-step.running .step-dot {
  background  : var(--ov-amber);
  box-shadow  : 0 0 6px var(--ov-amber);
  animation   : ovPulse 1.4s ease-in-out infinite;
}
.ov-flow-arrow {
  color    : var(--ov-muted);
  font-size: 13px;
  flex-shrink: 0;
  opacity  : .5;
}

@keyframes ovPulse {
  0%,100%{ opacity:1; transform:scale(1) }
  50%    { opacity:.4; transform:scale(1.5) }
}

/* ── Chart card ───────────────────────────────────────────────── */
.ov-grid-2 {
  display              : grid;
  grid-template-columns: 1fr 1fr;
  gap                  : 12px;
}
@media(max-width:1100px){ .ov-grid-2{ grid-template-columns:1fr } }

.ov-chart-card {
  background   : var(--ov-panel);
  border       : 1px solid var(--ov-border);
  border-radius: 10px;
  box-shadow   : var(--ov-shadow);
  overflow     : hidden;
  animation    : ovFadeUp 260ms ease both;
}
.ov-chart-head {
  display        : flex;
  align-items    : flex-start;
  justify-content: space-between;
  padding        : 13px 18px 11px;
  border-bottom  : 1px solid var(--ov-border);
  background     : linear-gradient(135deg,var(--ov-panel) 0%,var(--ov-panel-2) 100%);
}
.ov-chart-title  { font-size:13px; font-weight:700; color:var(--ov-text); margin-bottom:2px }
.ov-chart-sub    { font-size:11px; color:var(--ov-muted) }
.ov-chart-badge  {
  font-size     : 9.5px;
  font-weight   : 700;
  text-transform: uppercase;
  letter-spacing: .05em;
  padding       : 3px 9px;
  border-radius : 20px;
  flex-shrink   : 0;
  margin-top    : 1px;
  background    : color-mix(in srgb,var(--ov-accent) 12%,transparent);
  color         : var(--ov-accent);
  border        : 1px solid color-mix(in srgb,var(--ov-accent) 25%,transparent);
}
.ov-chart-body   { padding:16px 18px }
.ov-chart-wrap   { position:relative; height:260px }
.ov-chart-wrap.short { height:210px }
.ov-chart-wrap canvas { display:block; width:100%!important; height:100%!important }

/* ── Stat strip below chart ───────────────────────────────────── */
.ov-stat-strip {
  display   : flex;
  border-top: 1px solid var(--ov-border);
  background: var(--ov-panel-2);
}
.ov-stat-item {
  flex     : 1;
  padding  : 10px 16px;
  display  : flex;
  flex-direction: column;
  gap      : 3px;
  border-right: 1px solid var(--ov-border);
}
.ov-stat-item:last-child { border-right:none }
.ov-stat-label {
  font-size     : 9.5px;
  font-weight   : 700;
  text-transform: uppercase;
  letter-spacing: .08em;
  color         : var(--ov-muted);
}
.ov-stat-val {
  font-size    : 17px;
  font-weight  : 700;
  color        : var(--ov-text);
  font-variant-numeric: tabular-nums;
}
.ov-stat-sub { font-size:10px; color:var(--ov-muted) }

/* ── Table ────────────────────────────────────────────────────── */
.ov-table-wrap {
  background   : var(--ov-panel);
  border       : 1px solid var(--ov-border);
  border-radius: 10px;
  box-shadow   : var(--ov-shadow);
  overflow     : hidden;
  animation    : ovFadeUp 280ms ease both;
}
.ov-table-head {
  display        : flex;
  align-items    : center;
  justify-content: space-between;
  padding        : 13px 18px;
  border-bottom  : 1px solid var(--ov-border);
  background     : linear-gradient(135deg,var(--ov-panel) 0%,var(--ov-panel-2) 100%);
}
.ov-table-title { font-size:13px; font-weight:700; color:var(--ov-text) }
.ov-table-sub   { font-size:11px; color:var(--ov-muted); margin-top:2px }

#tblOverview { font-size:12px }
#tblOverview thead th {
  font-size:10px!important; font-weight:700!important;
  text-transform:uppercase!important; letter-spacing:.07em!important;
  color:var(--ov-muted)!important;
  background:var(--ov-panel-2)!important;
  border-bottom:1px solid var(--ov-border)!important;
  white-space:nowrap; padding:9px 12px!important;
}
#tblOverview tbody td {
  padding:9px 12px!important;
  border-bottom:1px solid var(--ov-border)!important;
  vertical-align:middle; color:var(--ov-text);
}
#tblOverview tbody tr:last-child td { border-bottom:none!important }
#tblOverview tbody tr:hover td { background:var(--ov-panel-2)!important }

/* Badges */
.ov-badge {
  display       : inline-flex;
  align-items   : center;
  gap           : 5px;
  font-size     : 9.5px;
  font-weight   : 700;
  text-transform: uppercase;
  letter-spacing: .05em;
  padding       : 3px 9px;
  border-radius : 20px;
  border        : 1px solid;
  white-space   : nowrap;
}
.ov-badge-approved  { background:rgba(34,197,94,.14);  color:#22c55e; border-color:rgba(34,197,94,.3)  }
.ov-badge-pending   { background:rgba(245,158,11,.14); color:#f59e0b; border-color:rgba(245,158,11,.3) }
.ov-badge-draft     { background:rgba(6,182,212,.14);  color:#06b6d4; border-color:rgba(6,182,212,.3)  }
.ov-badge-rejected  { background:rgba(239,68,68,.14);  color:#ef4444; border-color:rgba(239,68,68,.3)  }
.ov-badge-training  { background:rgba(99,102,241,.14); color:#6366f1; border-color:rgba(99,102,241,.3) }
.ov-badge-running   { background:rgba(245,158,11,.14); color:#f59e0b; border-color:rgba(245,158,11,.3) }

/* MOS inline bar */
.ov-mos-wrap { display:flex; align-items:center; gap:7px }
.ov-mos-track {
  width:52px; height:5px; border-radius:3px;
  background:var(--ov-faint); overflow:hidden; flex-shrink:0;
}
.ov-mos-fill { height:100%; border-radius:3px }

/* Lang pill */
.ov-lang-pill {
  display       : inline-block;
  font-size     : 10px;
  font-weight   : 800;
  letter-spacing: .04em;
  padding       : 2px 8px;
  border-radius : 4px;
  background    : color-mix(in srgb,var(--ov-accent) 14%,transparent);
  color         : var(--ov-accent);
  border        : 1px solid color-mix(in srgb,var(--ov-accent) 28%,transparent);
}

/* DataTables override */
.dataTables_wrapper { font-size:12px; color:var(--ov-text) }
.dataTables_wrapper .dataTables_length select,
.dataTables_wrapper .dataTables_filter input {
  background:var(--ov-panel-3); border:1px solid var(--ov-border);
  border-radius:6px; color:var(--ov-text); padding:4px 8px;
}
.dataTables_wrapper .dataTables_length select:focus,
.dataTables_wrapper .dataTables_filter input:focus {
  outline:none; border-color:var(--ov-accent);
}
.dataTables_wrapper .dataTables_info { color:var(--ov-muted); font-size:11px }
.dataTables_wrapper .dataTables_paginate .paginate_button {
  background:var(--ov-panel-3)!important;
  border:1px solid var(--ov-border)!important;
  color:var(--ov-muted)!important; border-radius:6px!important;
  padding:3px 8px!important; margin:0 2px!important; font-size:11px!important;
}
.dataTables_wrapper .dataTables_paginate .paginate_button:hover {
  background:var(--ov-panel-4)!important; color:var(--ov-text)!important;
  border-color:var(--ov-border-hi)!important;
}
.dataTables_wrapper .dataTables_paginate .paginate_button.current {
  background:color-mix(in srgb,var(--ov-accent) 18%,transparent)!important;
  color:var(--ov-accent)!important; border-color:var(--ov-accent)!important;
}

/* ── Animation ────────────────────────────────────────────────── */
@keyframes ovFadeUp {
  from{ opacity:0; transform:translateY(8px) }
  to  { opacity:1; transform:translateY(0)   }
}
.ov-chart-card:nth-child(1){ animation-delay: 40ms }
.ov-chart-card:nth-child(2){ animation-delay: 80ms }
.ov-chart-card:nth-child(3){ animation-delay:120ms }
.ov-chart-card:nth-child(4){ animation-delay:160ms }
</style>

<!-- ═══════════════════════════════════════════════════════════════
     PARTICLE BG
════════════════════════════════════════════════════════════════ -->
<div class="ov-particle-wrap">
  <canvas id="ovParticleCanvas"></canvas>
</div>

<!-- ═══════════════════════════════════════════════════════════════
     PAGE BODY
════════════════════════════════════════════════════════════════ -->
<div class="ov-page">

  <!-- ── KPI STRIP ─────────────────────────────────────────────── -->
  <div class="ov-section-label">Live Metrics</div>
  <div class="ov-kpi-grid">

    <div class="ov-kpi" style="--kpi-c:#6366f1">
      <div class="ov-kpi-icon">&#128230;</div>
      <div class="ov-kpi-label">Total Datasets</div>
      <div class="ov-kpi-value">48</div>
      <div class="ov-kpi-change up">&#8593; 3 this month</div>
    </div>

    <div class="ov-kpi" style="--kpi-c:#22c55e">
      <div class="ov-kpi-icon">&#128336;</div>
      <div class="ov-kpi-label">Clean Hours</div>
      <div class="ov-kpi-value">1,250<span class="ov-kpi-unit">hrs</span></div>
      <div class="ov-kpi-change up">&#8593; 84 hrs added</div>
    </div>

    <div class="ov-kpi" style="--kpi-c:#06b6d4">
      <div class="ov-kpi-icon">&#127758;</div>
      <div class="ov-kpi-label">Languages</div>
      <div class="ov-kpi-value">12</div>
      <div class="ov-kpi-change up">&#8593; 2 new</div>
    </div>

    <div class="ov-kpi" style="--kpi-c:#a855f7">
      <div class="ov-kpi-icon">&#127908;</div>
      <div class="ov-kpi-label">Voices in Prod</div>
      <div class="ov-kpi-value">38</div>
      <div class="ov-kpi-change up">&#8593; 5 this week</div>
    </div>

    <div class="ov-kpi" style="--kpi-c:#f59e0b">
      <div class="ov-kpi-icon">&#128640;</div>
      <div class="ov-kpi-label">Models Training</div>
      <div class="ov-kpi-value">6</div>
      <div class="ov-kpi-change">2 running now</div>
    </div>

    <div class="ov-kpi" style="--kpi-c:#22c55e">
      <div class="ov-kpi-icon">&#11088;</div>
      <div class="ov-kpi-label">Avg MOS</div>
      <div class="ov-kpi-value">4.12</div>
      <div class="ov-kpi-change up">&#8593; 0.08 vs last batch</div>
    </div>

    <div class="ov-kpi" style="--kpi-c:#06b6d4">
      <div class="ov-kpi-icon">&#9889;</div>
      <div class="ov-kpi-label">Avg Latency</div>
      <div class="ov-kpi-value">340<span class="ov-kpi-unit">ms</span></div>
      <div class="ov-kpi-change up">&#8595; 12 ms improved</div>
    </div>

    <div class="ov-kpi" style="--kpi-c:#ef4444">
      <div class="ov-kpi-icon">&#128269;</div>
      <div class="ov-kpi-label">Failed QC</div>
      <div class="ov-kpi-value">8.4<span class="ov-kpi-unit">%</span></div>
      <div class="ov-kpi-change down">&#8593; 0.2 % vs last week</div>
    </div>

  </div><!-- /kpi-grid -->

  <!-- ── PIPELINE FLOW ──────────────────────────────────────────── -->
  <div class="ov-section-label">Pipeline Status</div>
  <div class="ov-flow-wrap">
    <div class="ov-flow">
      <span class="ov-flow-step active"><span class="step-dot"></span>Dataset Found</span>
      <span class="ov-flow-arrow">&#8594;</span>
      <span class="ov-flow-step active"><span class="step-dot"></span>Ingested</span>
      <span class="ov-flow-arrow">&#8594;</span>
      <span class="ov-flow-step active"><span class="step-dot"></span>QC Running</span>
      <span class="ov-flow-arrow">&#8594;</span>
      <span class="ov-flow-step active"><span class="step-dot"></span>QC Passed</span>
      <span class="ov-flow-arrow">&#8594;</span>
      <span class="ov-flow-step active"><span class="step-dot"></span>Dataset Scored</span>
      <span class="ov-flow-arrow">&#8594;</span>
      <span class="ov-flow-step active"><span class="step-dot"></span>Approved for Training</span>
      <span class="ov-flow-arrow">&#8594;</span>
      <span class="ov-flow-step running"><span class="step-dot"></span>Training Running</span>
      <span class="ov-flow-arrow">&#8594;</span>
      <span class="ov-flow-step"><span class="step-dot"></span>Evaluation</span>
      <span class="ov-flow-arrow">&#8594;</span>
      <span class="ov-flow-step"><span class="step-dot"></span>Voice Approved</span>
      <span class="ov-flow-arrow">&#8594;</span>
      <span class="ov-flow-step"><span class="step-dot"></span>Production</span>
    </div>
  </div>

  <!-- ── ROW 1 : Dataset Status + Clean Hours ───────────────────── -->
  <div class="ov-section-label">Data Coverage</div>
  <div class="ov-grid-2">

    <div class="ov-chart-card">
      <div class="ov-chart-head">
        <div>
          <div class="ov-chart-title">Datasets by Status</div>
          <div class="ov-chart-sub">All 48 datasets across pipeline stages</div>
        </div>
        <span class="ov-chart-badge">Doughnut</span>
      </div>
      <div class="ov-chart-body">
        <div class="ov-chart-wrap"><canvas id="chartDatasetStatus"></canvas></div>
      </div>
      <div class="ov-stat-strip">
        <div class="ov-stat-item">
          <span class="ov-stat-label">Approved</span>
          <span class="ov-stat-val" style="color:var(--ov-green)">32</span>
          <span class="ov-stat-sub">66.7 %</span>
        </div>
        <div class="ov-stat-item">
          <span class="ov-stat-label">In Review</span>
          <span class="ov-stat-val" style="color:var(--ov-amber)">10</span>
          <span class="ov-stat-sub">20.8 %</span>
        </div>
        <div class="ov-stat-item">
          <span class="ov-stat-label">Draft</span>
          <span class="ov-stat-val" style="color:var(--ov-cyan)">4</span>
          <span class="ov-stat-sub">8.3 %</span>
        </div>
        <div class="ov-stat-item">
          <span class="ov-stat-label">Rejected</span>
          <span class="ov-stat-val" style="color:var(--ov-red)">2</span>
          <span class="ov-stat-sub">4.2 %</span>
        </div>
      </div>
    </div>

    <div class="ov-chart-card">
      <div class="ov-chart-head">
        <div>
          <div class="ov-chart-title">Clean Hours by Language</div>
          <div class="ov-chart-sub">Usable audio hours per language</div>
        </div>
        <span class="ov-chart-badge">Bar</span>
      </div>
      <div class="ov-chart-body">
        <div class="ov-chart-wrap"><canvas id="chartCleanHours"></canvas></div>
      </div>
    </div>

  </div>

  <!-- ── ROW 2 : MOS Trend + Training Status ────────────────────── -->
  <div class="ov-section-label">Model Quality &amp; Training</div>
  <div class="ov-grid-2">

    <div class="ov-chart-card">
      <div class="ov-chart-head">
        <div>
          <div class="ov-chart-title">Avg MOS Trend</div>
          <div class="ov-chart-sub">Last 6 model versions per language</div>
        </div>
        <span class="ov-chart-badge">Line</span>
      </div>
      <div class="ov-chart-body">
        <div class="ov-chart-wrap"><canvas id="chartMOSTrend"></canvas></div>
      </div>
    </div>

    <div class="ov-chart-card">
      <div class="ov-chart-head">
        <div>
          <div class="ov-chart-title">Training Jobs by Status</div>
          <div class="ov-chart-sub">Current sprint breakdown</div>
        </div>
        <span class="ov-chart-badge">Doughnut</span>
      </div>
      <div class="ov-chart-body">
        <div class="ov-chart-wrap short"><canvas id="chartTrainingStatus"></canvas></div>
      </div>
      <div class="ov-stat-strip">
        <div class="ov-stat-item">
          <span class="ov-stat-label">Completed</span>
          <span class="ov-stat-val" style="color:var(--ov-green)">18</span>
          <span class="ov-stat-sub">60 %</span>
        </div>
        <div class="ov-stat-item">
          <span class="ov-stat-label">Running</span>
          <span class="ov-stat-val" style="color:var(--ov-accent)">6</span>
          <span class="ov-stat-sub">20 %</span>
        </div>
        <div class="ov-stat-item">
          <span class="ov-stat-label">Queued</span>
          <span class="ov-stat-val" style="color:var(--ov-muted)">4</span>
          <span class="ov-stat-sub">13.3 %</span>
        </div>
        <div class="ov-stat-item">
          <span class="ov-stat-label">Failed</span>
          <span class="ov-stat-val" style="color:var(--ov-red)">2</span>
          <span class="ov-stat-sub">6.7 %</span>
        </div>
      </div>
    </div>

  </div>

  <!-- ── ROW 3 : Voice Use Case + Latency Trend ─────────────────── -->
  <div class="ov-section-label">Voice Production</div>
  <div class="ov-grid-2">

    <div class="ov-chart-card">
      <div class="ov-chart-head">
        <div>
          <div class="ov-chart-title">Voices by Use Case</div>
          <div class="ov-chart-sub">Support / Sales / Collections split</div>
        </div>
        <span class="ov-chart-badge">Pie</span>
      </div>
      <div class="ov-chart-body">
        <div class="ov-chart-wrap short"><canvas id="chartVoiceUseCase"></canvas></div>
      </div>
    </div>

    <div class="ov-chart-card">
      <div class="ov-chart-head">
        <div>
          <div class="ov-chart-title">Avg Latency by Model Version</div>
          <div class="ov-chart-sub">Response time trend (ms) — lower is better</div>
        </div>
        <span class="ov-chart-badge">Line</span>
      </div>
      <div class="ov-chart-body">
        <div class="ov-chart-wrap short"><canvas id="chartLatencyTrend"></canvas></div>
      </div>
    </div>

  </div>

  <!-- ── RECENT DATASETS TABLE ──────────────────────────────────── -->
  <div class="ov-section-label">Recent Datasets</div>
  <div class="ov-table-wrap">
    <div class="ov-table-head">
      <div>
        <div class="ov-table-title">Dataset Registry — Latest Activity</div>
        <div class="ov-table-sub">Most recently updated datasets across all languages</div>
      </div>
    </div>
    <div style="padding:16px 18px">
      <div class="table-responsive">
        <table id="tblOverview" class="table table-hover w-100">
          <thead>
            <tr>
              <th>Dataset</th>
              <th>Lang</th>
              <th>Clips</th>
              <th>Hours</th>
              <th>Best MOS</th>
              <th>License</th>
              <th>Created</th>
            </tr>
          </thead>
          <tbody id="ovTableBody"></tbody>
        </table>
      </div>
    </div>
  </div>

</div><!-- /ov-page -->

<!-- Page JS -->
<script src="${pageContext.request.contextPath}/static/js/three-bg.js"></script>
<script src="${pageContext.request.contextPath}/static/js/overview.js"></script>