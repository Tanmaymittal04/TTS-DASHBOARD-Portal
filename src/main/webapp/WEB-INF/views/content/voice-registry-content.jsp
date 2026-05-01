<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
/* ═══════════════════════════════════════════════════════════════
   VOICE REGISTRY DASHBOARD — Inline styles
   Mirrors training / evaluation token system (vr-* prefix)
═══════════════════════════════════════════════════════════════ */

/* ── Theme tokens ─────────────────────────────────────────── */
[data-theme="dark"] {
  --vr-bg       : #0f1117;
  --vr-panel    : #161820;
  --vr-panel-2  : #1c1f2e;
  --vr-panel-3  : #222537;
  --vr-panel-4  : #282b3e;
  --vr-border   : rgba(255,255,255,0.07);
  --vr-border-hi: rgba(99,102,241,0.35);
  --vr-text     : #d8dae8;
  --vr-muted    : #6b7280;
  --vr-faint    : #252838;
  --vr-accent   : #6366f1;
  --vr-green    : #22c55e;
  --vr-red      : #ef4444;
  --vr-amber    : #f59e0b;
  --vr-cyan     : #06b6d4;
  --vr-purple   : #a855f7;
  --vr-pink     : #ec4899;
  --vr-orange   : #f97316;
  --vr-shadow   : 0 2px 12px rgba(0,0,0,0.4);
  --vr-shadow-lg: 0 8px 32px rgba(0,0,0,0.55);
}
[data-theme="light"] {
  --vr-bg       : #eef0f6;
  --vr-panel    : #ffffff;
  --vr-panel-2  : #f3f4f9;
  --vr-panel-3  : #eceef6;
  --vr-panel-4  : #e4e6f0;
  --vr-border   : rgba(0,0,0,0.08);
  --vr-border-hi: rgba(79,70,229,0.3);
  --vr-text     : #1a1d2e;
  --vr-muted    : #6b7280;
  --vr-faint    : #dde0ec;
  --vr-accent   : #4f46e5;
  --vr-green    : #16a34a;
  --vr-red      : #dc2626;
  --vr-amber    : #d97706;
  --vr-cyan     : #0891b2;
  --vr-purple   : #7c3aed;
  --vr-pink     : #be185d;
  --vr-orange   : #ea580c;
  --vr-shadow   : 0 2px 8px rgba(0,0,0,0.07);
  --vr-shadow-lg: 0 8px 24px rgba(0,0,0,0.10);
}

/* ── Page wrapper ─────────────────────────────────────────── */
.vr-page { display:flex; flex-direction:column; gap:16px; padding-bottom:40px; }

/* ── Section label ────────────────────────────────────────── */
.vr-section-label {
  font-size:10px; font-weight:700; letter-spacing:0.14em;
  text-transform:uppercase; color:var(--vr-muted);
  display:flex; align-items:center; gap:10px; margin-bottom:4px;
}
.vr-section-label::after {
  content:''; flex:1; height:1px;
  background:linear-gradient(90deg, var(--vr-border), transparent);
}

/* ═══════════════════════════════════════════════════════════
   KPI STRIP
═══════════════════════════════════════════════════════════ */
.vr-kpi-grid {
  display:grid;
  grid-template-columns:repeat(5,1fr);
  gap:10px;
}
@media (max-width:1280px) { .vr-kpi-grid { grid-template-columns:repeat(3,1fr); } }
@media (max-width:640px)  { .vr-kpi-grid { grid-template-columns:repeat(2,1fr); } }

.vr-kpi {
  background:var(--vr-panel);
  border:1px solid var(--vr-border);
  border-radius:10px;
  padding:14px 16px 12px;
  position:relative; overflow:hidden;
  transition:border-color 160ms, box-shadow 160ms;
}
.vr-kpi::before {
  content:''; position:absolute; top:0; left:0; right:0; height:2px;
  background:var(--kpi-color, var(--vr-accent));
}
.vr-kpi::after {
  content:''; position:absolute; inset:0;
  background:linear-gradient(135deg,
    color-mix(in srgb, var(--kpi-color,var(--vr-accent)) 5%, transparent) 0%,
    transparent 60%);
  pointer-events:none;
}
.vr-kpi:hover {
  border-color:color-mix(in srgb, var(--kpi-color,var(--vr-accent)) 40%, transparent);
  box-shadow:var(--vr-shadow);
}
.vr-kpi .kpi-label {
  font-size:10px; font-weight:700; text-transform:uppercase;
  letter-spacing:0.1em; color:var(--vr-muted); margin-bottom:8px;
}
.vr-kpi .kpi-value {
  font-size:28px; font-weight:300; color:var(--vr-text);
  line-height:1; margin-bottom:6px; font-variant-numeric:tabular-nums;
  display:flex; align-items:baseline; gap:4px;
}
.vr-kpi .kpi-unit  { font-size:13px; font-weight:400; color:var(--vr-muted); }
.vr-kpi .kpi-change{ font-size:11px; color:var(--vr-muted); }
.vr-kpi .kpi-change.up   { color:var(--vr-green); }
.vr-kpi .kpi-change.down { color:var(--vr-red); }
.vr-kpi .kpi-icon {
  position:absolute; top:12px; right:14px;
  font-size:22px; opacity:0.13;
}

/* ═══════════════════════════════════════════════════════════
   CHART PANELS
═══════════════════════════════════════════════════════════ */
.vr-panel {
  background:var(--vr-panel);
  border:1px solid var(--vr-border);
  border-radius:10px;
  box-shadow:var(--vr-shadow);
  overflow:hidden;
}
.vr-panel-header {
  display:flex; align-items:flex-start; justify-content:space-between;
  padding:13px 18px 11px;
  border-bottom:1px solid var(--vr-border);
  background:linear-gradient(135deg, var(--vr-panel) 0%, var(--vr-panel-2) 100%);
}
.vr-panel-title { font-size:13px; font-weight:700; color:var(--vr-text); margin-bottom:2px; }
.vr-panel-sub   { font-size:11px; color:var(--vr-muted); line-height:1.4; }
.vr-panel-badge {
  font-size:9.5px; font-weight:700; text-transform:uppercase; letter-spacing:0.05em;
  padding:3px 9px; border-radius:20px; flex-shrink:0; margin-top:1px;
  background:color-mix(in srgb, var(--vr-accent) 12%, transparent);
  color:var(--vr-accent);
  border:1px solid color-mix(in srgb, var(--vr-accent) 25%, transparent);
}
.vr-panel-body  { padding:16px 18px; }

/* Canvas containers */
.vr-chart-wrap         { position:relative; height:260px; }
.vr-chart-wrap.tall    { height:310px; }
.vr-chart-wrap.xl      { height:380px; }
.vr-chart-wrap.short   { height:210px; }
.vr-chart-wrap canvas  { display:block; width:100% !important; height:100% !important; }

/* Stat strip */
.vr-stat-strip { display:flex; border-top:1px solid var(--vr-border); background:var(--vr-panel-2); }
.vr-stat-item  { flex:1; padding:10px 16px; display:flex; flex-direction:column; gap:3px; border-right:1px solid var(--vr-border); }
.vr-stat-item:last-child { border-right:none; }
.vr-stat-label { font-size:9.5px; font-weight:700; text-transform:uppercase; letter-spacing:0.08em; color:var(--vr-muted); }
.vr-stat-val   { font-size:16px; font-weight:700; color:var(--vr-text); font-variant-numeric:tabular-nums; }
.vr-stat-sub   { font-size:10px; color:var(--vr-muted); }

/* ── Grid layouts ─────────────────────────────────────────── */
.vr-grid-2   { display:grid; grid-template-columns:1fr 1fr; gap:12px; }
.vr-grid-3   { display:grid; grid-template-columns:1fr 1fr 1fr; gap:12px; }
.vr-grid-2-1 { display:grid; grid-template-columns:2fr 1fr; gap:12px; }
.vr-grid-1-2 { display:grid; grid-template-columns:1fr 2fr; gap:12px; }

@media (max-width:1100px) {
  .vr-grid-3, .vr-grid-2, .vr-grid-2-1, .vr-grid-1-2 { grid-template-columns:1fr; }
  .vr-chart-wrap { height:240px; }
  .vr-chart-wrap.xl { height:300px; }
}
@media (max-width:768px) {
  .vr-chart-wrap, .vr-chart-wrap.tall { height:220px; }
  .vr-chart-wrap.short { height:180px; }
}

/* ═══════════════════════════════════════════════════════════
   TABLE
═══════════════════════════════════════════════════════════ */
.vr-table-wrap {
  background:var(--vr-panel); border:1px solid var(--vr-border);
  border-radius:10px; box-shadow:var(--vr-shadow); overflow:hidden;
}
.vr-table-header {
  display:flex; align-items:center; justify-content:space-between;
  padding:13px 18px; border-bottom:1px solid var(--vr-border);
  background:linear-gradient(135deg, var(--vr-panel) 0%, var(--vr-panel-2) 100%);
}
.vr-table-title { font-size:13px; font-weight:700; color:var(--vr-text); }
.vr-table-sub   { font-size:11px; color:var(--vr-muted); margin-top:2px; }

#tblVoices { font-size:12px; }
#tblVoices thead th {
  font-size:10px; font-weight:700; text-transform:uppercase;
  letter-spacing:0.07em; color:var(--vr-muted) !important;
  background:var(--vr-panel-2) !important;
  border-bottom:1px solid var(--vr-border) !important;
  white-space:nowrap; padding:9px 12px !important;
}
#tblVoices tbody td {
  padding:9px 12px !important;
  border-bottom:1px solid var(--vr-border) !important;
  vertical-align:middle; color:var(--vr-text);
}
#tblVoices tbody tr:last-child td { border-bottom:none !important; }
#tblVoices tbody tr:hover td { background:var(--vr-panel-2) !important; }
#tblVoices.no-footer { border-bottom:1px solid var(--vr-border) !important; }

/* Voice ID code */
.vr-voice-id {
  font-size:11px; font-weight:600; color:var(--vr-accent);
  font-family:'JetBrains Mono','Fira Code',ui-monospace,monospace;
}

/* Name cell with avatar */
.vr-name-wrap   { display:flex; align-items:center; gap:10px; }
.vr-avatar      {
  width:30px; height:30px; border-radius:50%; flex-shrink:0;
  background:color-mix(in srgb, var(--vr-accent) 18%, transparent);
  color:var(--vr-accent); font-size:12px; font-weight:700;
  display:flex; align-items:center; justify-content:center;
  border:1px solid color-mix(in srgb, var(--vr-accent) 30%, transparent);
}
.vr-voice-name   { font-size:12px; font-weight:600; color:var(--vr-text); }
.vr-voice-accent { font-size:10px; color:var(--vr-muted); margin-top:1px; }
.vr-accent-cell  { display:none; } /* shown in name cell already */

/* Lang pill */
.vr-lang-pill {
  display:inline-block; font-size:10px; font-weight:800; letter-spacing:0.04em;
  padding:2px 8px; border-radius:4px;
  background:color-mix(in srgb, var(--vr-accent) 14%, transparent);
  color:var(--vr-accent);
  border:1px solid color-mix(in srgb, var(--vr-accent) 28%, transparent);
}

/* Gender */
.vr-gender-f { color:var(--vr-pink);   font-size:11.5px; font-weight:600; }
.vr-gender-m { color:var(--vr-cyan);   font-size:11.5px; font-weight:600; }
.vr-gender-n { color:var(--vr-purple); font-size:11.5px; font-weight:600; }

/* Use case chip */
.vr-uc-chip {
  display:inline-flex; align-items:center;
  font-size:10px; font-weight:700; text-transform:capitalize; letter-spacing:0.04em;
  padding:2px 9px; border-radius:20px; border:1px solid;
}
.vr-uc-support    { background:rgba(6,182,212,0.12);  color:#06b6d4; border-color:rgba(6,182,212,0.28); }
.vr-uc-sales      { background:rgba(99,102,241,0.12); color:#6366f1; border-color:rgba(99,102,241,0.28); }
.vr-uc-col        { background:rgba(245,158,11,0.12); color:#f59e0b; border-color:rgba(245,158,11,0.28); }

/* Tone */
.vr-tone-cell { font-size:11.5px; color:var(--vr-muted); }

/* Status badges */
.vr-tbl-badge {
  display:inline-flex; align-items:center; gap:5px;
  font-size:10px; font-weight:700; text-transform:uppercase;
  letter-spacing:0.05em; padding:3px 9px; border-radius:20px; border:1px solid;
  white-space:nowrap;
}
.vr-badge-prod    { background:rgba(34,197,94,0.14);  color:#22c55e; border-color:rgba(34,197,94,0.3); }
.vr-badge-staging { background:rgba(245,158,11,0.14); color:#f59e0b; border-color:rgba(245,158,11,0.3); }
.vr-badge-draft   { background:rgba(99,102,241,0.14); color:#6366f1; border-color:rgba(99,102,241,0.3); }
.vr-badge-retired { background:rgba(107,114,128,0.12);color:#6b7280; border-color:rgba(107,114,128,0.25); }

/* Customer cell */
.vr-customer-cell { font-size:11.5px; color:var(--vr-muted); white-space:nowrap; }

/* Similarity mini bar */
.vr-sim-cell  { display:flex; align-items:center; gap:7px; }
.vr-sim-track { width:56px; height:5px; border-radius:3px; background:var(--vr-faint); overflow:hidden; flex-shrink:0; }
.vr-sim-fill  { height:100%; border-radius:3px; transition:width 0.6s ease; }

/* DataTables dark override */
.dataTables_wrapper { font-size:12px; color:var(--vr-text); }
.dataTables_wrapper .dataTables_length select,
.dataTables_wrapper .dataTables_filter input {
  background:var(--vr-panel-3); border:1px solid var(--vr-border);
  border-radius:6px; color:var(--vr-text); padding:4px 8px;
}
.dataTables_wrapper .dataTables_length select:focus,
.dataTables_wrapper .dataTables_filter input:focus { outline:none; border-color:var(--vr-accent); }
.dataTables_wrapper .dataTables_info { color:var(--vr-muted); font-size:11px; }
.dataTables_wrapper .dataTables_paginate .paginate_button {
  background:var(--vr-panel-3) !important; border:1px solid var(--vr-border) !important;
  color:var(--vr-muted) !important; border-radius:6px !important;
  padding:3px 8px !important; margin:0 2px !important; font-size:11px !important;
}
.dataTables_wrapper .dataTables_paginate .paginate_button:hover {
  background:var(--vr-panel-4) !important; color:var(--vr-text) !important;
  border-color:var(--vr-border-hi) !important;
}
.dataTables_wrapper .dataTables_paginate .paginate_button.current {
  background:color-mix(in srgb, var(--vr-accent) 18%, transparent) !important;
  color:var(--vr-accent) !important; border-color:var(--vr-accent) !important;
}

/* ── Fade-in ──────────────────────────────────────────────── */
@keyframes vrFadeUp { from { opacity:0; transform:translateY(8px); } to { opacity:1; transform:translateY(0); } }
.vr-panel, .vr-kpi, .vr-table-wrap { animation:vrFadeUp 220ms ease both; }
</style>

<!-- ══════════════════════════════════════════════════════════
     PAGE CONTENT
══════════════════════════════════════════════════════════ -->
<div class="vr-page">

  <!-- ── KPI STRIP ──────────────────────────────────────── -->
  <div class="vr-section-label">Registry Overview</div>
  <div class="vr-kpi-grid">

    <div class="vr-kpi" style="--kpi-color:#22c55e">
      <div class="kpi-icon">&#9989;</div>
      <div class="kpi-label">In Production</div>
      <div class="kpi-value">7</div>
      <div class="kpi-change up">&#8593; 3 this sprint</div>
    </div>

    <div class="vr-kpi" style="--kpi-color:#f59e0b">
      <div class="kpi-icon">&#9203;</div>
      <div class="kpi-label">Staging</div>
      <div class="kpi-value">3</div>
      <div class="kpi-change">Ready for sign-off</div>
    </div>

    <div class="vr-kpi" style="--kpi-color:#6366f1">
      <div class="kpi-icon">&#128196;</div>
      <div class="kpi-label">Draft</div>
      <div class="kpi-value">2</div>
      <div class="kpi-change">In evaluation</div>
    </div>

    <div class="vr-kpi" style="--kpi-color:#6b7280">
      <div class="kpi-icon">&#128466;</div>
      <div class="kpi-label">Retired</div>
      <div class="kpi-value">2</div>
      <div class="kpi-change">Deprecated voices</div>
    </div>

    <div class="vr-kpi" style="--kpi-color:#22c55e">
      <div class="kpi-icon">&#11088;</div>
      <div class="kpi-label">Avg MOS (Prod)</div>
      <div class="kpi-value">4.37</div>
      <div class="kpi-change up">Above 4.0 target &#9989;</div>
    </div>

  </div>

  <!-- ── ROW 1: Status + MOS per Voice ─────────────────── -->
  <div class="vr-section-label">Quality &amp; Coverage</div>
  <div class="vr-grid-2">

    <div class="vr-panel">
      <div class="vr-panel-header">
        <div>
          <div class="vr-panel-title">Voice Status Distribution</div>
          <div class="vr-panel-sub">Production &middot; Staging &middot; Draft &middot; Retired</div>
        </div>
        <span class="vr-panel-badge">Doughnut</span>
      </div>
      <div class="vr-panel-body">
        <div class="vr-chart-wrap">
          <canvas id="chartVoiceStatus"></canvas>
        </div>
      </div>
    </div>

    <div class="vr-panel">
      <div class="vr-panel-header">
        <div>
          <div class="vr-panel-title">MOS Score per Voice</div>
          <div class="vr-panel-sub">Green &ge; 4.0 passes quality gate &mdash; amber &ge; 3.3 &mdash; red below threshold</div>
        </div>
        <span class="vr-panel-badge">Bar</span>
      </div>
      <div class="vr-panel-body">
        <div class="vr-chart-wrap">
          <canvas id="chartVoiceMOS"></canvas>
        </div>
      </div>
    </div>

  </div>

  <!-- ── ROW 2: Use Case + Gender + Language ───────────── -->
  <div class="vr-section-label">Composition</div>
  <div class="vr-grid-3">

    <div class="vr-panel">
      <div class="vr-panel-header">
        <div>
          <div class="vr-panel-title">Use Case Split</div>
          <div class="vr-panel-sub">Support &middot; Sales &middot; Collections</div>
        </div>
        <span class="vr-panel-badge">Pie</span>
      </div>
      <div class="vr-panel-body">
        <div class="vr-chart-wrap short">
          <canvas id="chartVoiceUseCase2"></canvas>
        </div>
      </div>
    </div>

    <div class="vr-panel">
      <div class="vr-panel-header">
        <div>
          <div class="vr-panel-title">Gender Distribution</div>
          <div class="vr-panel-sub">Male &middot; Female &middot; Neutral voices</div>
        </div>
        <span class="vr-panel-badge">Doughnut</span>
      </div>
      <div class="vr-panel-body">
        <div class="vr-chart-wrap short">
          <canvas id="chartVoiceGender"></canvas>
        </div>
      </div>
    </div>

    <div class="vr-panel">
      <div class="vr-panel-header">
        <div>
          <div class="vr-panel-title">Voices by Language</div>
          <div class="vr-panel-sub">Registered voice count per language</div>
        </div>
        <span class="vr-panel-badge">Bar</span>
      </div>
      <div class="vr-panel-body">
        <div class="vr-chart-wrap short">
          <canvas id="chartVoiceLang"></canvas>
        </div>
      </div>
    </div>

  </div>

  <!-- ── Speaker Similarity full width ─────────────────── -->
  <div class="vr-section-label">Speaker Fidelity</div>
  <div class="vr-panel">
    <div class="vr-panel-header">
      <div>
        <div class="vr-panel-title">Speaker Similarity per Voice</div>
        <div class="vr-panel-sub">Green &ge; 0.85 &middot; Amber &ge; 0.75 &middot; Red below 0.75 &mdash; dashed line = 0.80 production threshold</div>
      </div>
      <span class="vr-panel-badge">H-Bar</span>
    </div>
    <div class="vr-panel-body" style="padding-bottom:12px">
      <div class="vr-chart-wrap xl">
        <canvas id="chartSpeakerSim"></canvas>
      </div>
    </div>
    <div class="vr-stat-strip">
      <div class="vr-stat-item">
        <span class="vr-stat-label">Best Similarity</span>
        <span class="vr-stat-val" style="color:var(--vr-green)">0.93</span>
        <span class="vr-stat-sub">Alex (EN)</span>
      </div>
      <div class="vr-stat-item">
        <span class="vr-stat-label">Above 0.80</span>
        <span class="vr-stat-val" style="color:var(--vr-accent)">7 / 14</span>
        <span class="vr-stat-sub">Pass threshold</span>
      </div>
      <div class="vr-stat-item">
        <span class="vr-stat-label">Needs Retraining</span>
        <span class="vr-stat-val" style="color:var(--vr-red)">4</span>
        <span class="vr-stat-sub">Below 0.70</span>
      </div>
      <div class="vr-stat-item">
        <span class="vr-stat-label">Avg Similarity</span>
        <span class="vr-stat-val" style="color:var(--vr-amber)">0.76</span>
        <span class="vr-stat-sub">All 14 voices</span>
      </div>
    </div>
  </div>

  <!-- ── VOICE REGISTRY TABLE ──────────────────────────── -->
  <div class="vr-section-label">All Voices</div>
  <div class="vr-table-wrap">
    <div class="vr-table-header">
      <div>
        <div class="vr-table-title">Voice Registry</div>
        <div class="vr-table-sub">All registered voices &mdash; Name &middot; Language &middot; Gender &middot; Use Case &middot; Tone &middot; MOS &middot; Similarity &middot; Latency &middot; Status &middot; Customer</div>
      </div>
    </div>
    <div style="padding:16px 18px">
      <div class="table-responsive">
        <table id="tblVoices" class="table table-hover w-100">
          <thead>
            <tr>
              <th>Voice ID</th>
              <th>Name</th>
              <th>Lang</th>
              <th>Accent</th>
              <th>Gender</th>
              <th>Use Case</th>
              <th>Tone</th>
              <th>MOS</th>
              <th>Similarity</th>
              <th>Latency</th>
              <th>Status</th>
              <th>Customer</th>
            </tr>
          </thead>
          <tbody id="voiceTableBody"></tbody>
        </table>
      </div>
    </div>
  </div>

</div><!-- /vr-page -->

<script src="${pageContext.request.contextPath}/static/js/voice-registry.js"></script>