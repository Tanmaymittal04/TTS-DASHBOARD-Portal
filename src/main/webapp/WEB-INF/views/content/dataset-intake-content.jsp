<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="user-stats-section.jsp" %>
<style>
[data-theme="dark"] {
  --di-bg:#0f1117;--di-panel:#161820;--di-panel-2:#1c1f2e;
  --di-panel-3:#222537;--di-panel-4:#282b3e;
  --di-border:rgba(255,255,255,0.07);--di-border-hi:rgba(99,102,241,0.35);
  --di-text:#d8dae8;--di-muted:#6b7280;--di-faint:#252838;
  --di-accent:#6366f1;--di-green:#22c55e;--di-red:#ef4444;
  --di-amber:#f59e0b;--di-cyan:#06b6d4;--di-purple:#a855f7;
  --di-shadow:0 2px 12px rgba(0,0,0,.4);
}
[data-theme="light"] {
  --di-bg:#eef0f6;--di-panel:#ffffff;--di-panel-2:#f3f4f9;
  --di-panel-3:#eceef6;--di-panel-4:#e4e6f0;
  --di-border:rgba(0,0,0,.08);--di-border-hi:rgba(79,70,229,.3);
  --di-text:#1a1d2e;--di-muted:#6b7280;--di-faint:#dde0ec;
  --di-accent:#4f46e5;--di-green:#16a34a;--di-red:#dc2626;
  --di-amber:#d97706;--di-cyan:#0891b2;--di-purple:#7c3aed;
  --di-shadow:0 2px 8px rgba(0,0,0,.07);
}
.di-page{display:flex;flex-direction:column;gap:16px;padding-bottom:40px}
.di-section-label{font-size:10px;font-weight:700;letter-spacing:.14em;text-transform:uppercase;color:var(--di-muted);display:flex;align-items:center;gap:10px;margin-bottom:2px}
.di-section-label::after{content:'';flex:1;height:1px;background:linear-gradient(90deg,var(--di-border),transparent)}
.di-kpi-grid{display:grid;grid-template-columns:repeat(5,1fr);gap:10px}
@media(max-width:1280px){.di-kpi-grid{grid-template-columns:repeat(3,1fr)}}
@media(max-width:640px){.di-kpi-grid{grid-template-columns:repeat(2,1fr)}}
.di-kpi{background:var(--di-panel);border:1px solid var(--di-border);border-radius:10px;padding:14px 16px 12px;position:relative;overflow:hidden;transition:border-color 160ms,box-shadow 160ms}
.di-kpi::before{content:'';position:absolute;top:0;left:0;right:0;height:2px;background:var(--kpi-color,var(--di-accent))}
.di-kpi::after{content:'';position:absolute;inset:0;pointer-events:none;background:linear-gradient(135deg,color-mix(in srgb,var(--kpi-color,var(--di-accent)) 6%,transparent) 0%,transparent 55%)}
.di-kpi:hover{border-color:color-mix(in srgb,var(--kpi-color,var(--di-accent)) 45%,transparent);box-shadow:var(--di-shadow)}
.di-kpi .kpi-label{font-size:10px;font-weight:700;text-transform:uppercase;letter-spacing:.10em;color:var(--di-muted);margin-bottom:8px}
.di-kpi .kpi-value{font-size:28px;font-weight:300;color:var(--di-text);line-height:1;margin-bottom:6px;font-variant-numeric:tabular-nums;display:flex;align-items:baseline;gap:4px}
.di-kpi .kpi-unit{font-size:13px;font-weight:400;color:var(--di-muted)}
.di-kpi .kpi-change{font-size:11px;color:var(--di-muted)}
.di-kpi .kpi-change.up{color:var(--di-green)}
.di-kpi .kpi-change.down{color:var(--di-red)}
.di-kpi .kpi-icon{position:absolute;top:12px;right:14px;font-size:22px;opacity:.13;pointer-events:none}
.di-panel{background:var(--di-panel);border:1px solid var(--di-border);border-radius:10px;box-shadow:var(--di-shadow);overflow:hidden}
.di-panel-header{display:flex;align-items:flex-start;justify-content:space-between;padding:13px 18px 11px;border-bottom:1px solid var(--di-border);background:linear-gradient(135deg,var(--di-panel) 0%,var(--di-panel-2) 100%)}
.di-panel-title{font-size:13px;font-weight:700;color:var(--di-text);margin-bottom:2px}
.di-panel-sub{font-size:11px;color:var(--di-muted)}
.di-panel-badge{font-size:9.5px;font-weight:700;text-transform:uppercase;letter-spacing:.05em;padding:3px 9px;border-radius:20px;flex-shrink:0;margin-top:1px;background:color-mix(in srgb,var(--di-accent) 12%,transparent);color:var(--di-accent);border:1px solid color-mix(in srgb,var(--di-accent) 25%,transparent)}
.di-panel-body{padding:16px 18px}
.di-chart-wrap{position:relative;height:260px}
.di-chart-wrap.short{height:210px}
.di-chart-wrap canvas{display:block;width:100%!important;height:100%!important}
.di-stat-strip{display:flex;border-top:1px solid var(--di-border);background:var(--di-panel-2)}
.di-stat-item{flex:1;padding:10px 16px;display:flex;flex-direction:column;gap:3px;border-right:1px solid var(--di-border)}
.di-stat-item:last-child{border-right:none}
.di-stat-label{font-size:9.5px;font-weight:700;text-transform:uppercase;letter-spacing:.08em;color:var(--di-muted)}
.di-stat-val{font-size:17px;font-weight:700;color:var(--di-text);font-variant-numeric:tabular-nums}
.di-stat-sub{font-size:10px;color:var(--di-muted)}
.di-grid-2{display:grid;grid-template-columns:1fr 1fr;gap:12px}
@media(max-width:1100px){.di-grid-2{grid-template-columns:1fr}.di-chart-wrap{height:240px}}
@media(max-width:768px){.di-chart-wrap,.di-chart-wrap.short{height:200px}}
.di-table-wrap{background:var(--di-panel);border:1px solid var(--di-border);border-radius:10px;box-shadow:var(--di-shadow);overflow:hidden}
.di-table-header{display:flex;align-items:center;justify-content:space-between;padding:13px 18px;border-bottom:1px solid var(--di-border);background:linear-gradient(135deg,var(--di-panel) 0%,var(--di-panel-2) 100%)}
.di-table-title{font-size:13px;font-weight:700;color:var(--di-text)}
.di-table-sub{font-size:11px;color:var(--di-muted);margin-top:2px}
#tblDatasets{font-size:12px}
#tblDatasets thead th{font-size:10px!important;font-weight:700!important;text-transform:uppercase!important;letter-spacing:.07em!important;color:var(--di-muted)!important;background:var(--di-panel-2)!important;border-bottom:1px solid var(--di-border)!important;white-space:nowrap;padding:9px 12px!important}
#tblDatasets tbody td{padding:9px 12px!important;border-bottom:1px solid var(--di-border)!important;vertical-align:middle;color:var(--di-text)}
#tblDatasets tbody tr:last-child td{border-bottom:none!important}
#tblDatasets tbody tr:hover td{background:var(--di-panel-2)!important}
.di-ds-id{font-size:11px;font-weight:600;color:var(--di-accent);font-family:'JetBrains Mono','Fira Code',ui-monospace,monospace}
.di-lang-pill{display:inline-block;font-size:10px;font-weight:800;letter-spacing:.04em;padding:2px 8px;border-radius:4px;background:color-mix(in srgb,var(--di-accent) 14%,transparent);color:var(--di-accent);border:1px solid color-mix(in srgb,var(--di-accent) 28%,transparent)}
.di-src-chip{display:inline-flex;align-items:center;font-size:10px;font-weight:700;text-transform:capitalize;letter-spacing:.04em;padding:2px 9px;border-radius:20px;border:1px solid}
.di-src-open{background:rgba(6,182,212,.12);color:#06b6d4;border-color:rgba(6,182,212,.28)}
.di-src-recorded{background:rgba(99,102,241,.12);color:#6366f1;border-color:rgba(99,102,241,.28)}
.di-src-vendor{background:rgba(245,158,11,.12);color:#f59e0b;border-color:rgba(245,158,11,.28)}
.di-tbl-badge{display:inline-flex;align-items:center;gap:5px;font-size:10px;font-weight:700;text-transform:uppercase;letter-spacing:.05em;padding:3px 9px;border-radius:20px;border:1px solid;white-space:nowrap}
.di-badge-approved{background:rgba(34,197,94,.14);color:#22c55e;border-color:rgba(34,197,94,.3)}
.di-badge-pending{background:rgba(245,158,11,.14);color:#f59e0b;border-color:rgba(245,158,11,.3)}
.di-badge-rejected{background:rgba(239,68,68,.14);color:#ef4444;border-color:rgba(239,68,68,.3)}
.di-badge-training{background:rgba(99,102,241,.14);color:#6366f1;border-color:rgba(99,102,241,.3)}
.di-badge-qc{background:rgba(6,182,212,.14);color:#06b6d4;border-color:rgba(6,182,212,.3)}
.di-badge-intake{background:rgba(107,114,128,.12);color:#9ca3af;border-color:rgba(107,114,128,.25)}
.di-badge-scored{background:rgba(168,85,247,.14);color:#a855f7;border-color:rgba(168,85,247,.3)}
.di-hours-cell{display:flex;align-items:center;gap:7px}
.di-hours-track{width:52px;height:5px;border-radius:3px;background:var(--di-faint);overflow:hidden;flex-shrink:0}
.di-hours-fill{height:100%;border-radius:3px}
.di-assigned{display:flex;align-items:center;gap:6px}
.di-av{width:24px;height:24px;border-radius:50%;flex-shrink:0;background:color-mix(in srgb,var(--di-accent) 18%,transparent);color:var(--di-accent);font-size:10px;font-weight:700;display:flex;align-items:center;justify-content:center;border:1px solid color-mix(in srgb,var(--di-accent) 30%,transparent)}
.dataTables_wrapper{font-size:12px;color:var(--di-text)}
.dataTables_wrapper .dataTables_length select,.dataTables_wrapper .dataTables_filter input{background:var(--di-panel-3);border:1px solid var(--di-border);border-radius:6px;color:var(--di-text);padding:4px 8px}
.dataTables_wrapper .dataTables_length select:focus,.dataTables_wrapper .dataTables_filter input:focus{outline:none;border-color:var(--di-accent)}
.dataTables_wrapper .dataTables_info{color:var(--di-muted);font-size:11px}
.dataTables_wrapper .dataTables_paginate .paginate_button{background:var(--di-panel-3)!important;border:1px solid var(--di-border)!important;color:var(--di-muted)!important;border-radius:6px!important;padding:3px 8px!important;margin:0 2px!important;font-size:11px!important}
.dataTables_wrapper .dataTables_paginate .paginate_button:hover{background:var(--di-panel-4)!important;color:var(--di-text)!important;border-color:var(--di-border-hi)!important}
.dataTables_wrapper .dataTables_paginate .paginate_button.current{background:color-mix(in srgb,var(--di-accent) 18%,transparent)!important;color:var(--di-accent)!important;border-color:var(--di-accent)!important}
@keyframes diFadeUp{from{opacity:0;transform:translateY(8px)}to{opacity:1;transform:translateY(0)}}
.di-panel,.di-kpi,.di-table-wrap{animation:diFadeUp 220ms ease both}
</style>

<div class="di-page">

  <div class="di-section-label">Intake Overview</div>
  <div class="di-kpi-grid">
    <div class="di-kpi" style="--kpi-color:#6366f1">
      <div class="kpi-icon">&#128230;</div>
      <div class="kpi-label">Total Datasets</div>
      <div class="kpi-value">48</div>
      <div class="kpi-change">Across 12 languages</div>
    </div>
    <div class="di-kpi" style="--kpi-color:#22c55e">
      <div class="kpi-icon">&#127925;</div>
      <div class="kpi-label">Total Raw Hours</div>
      <div class="kpi-value">935<span class="kpi-unit">hrs</span></div>
      <div class="kpi-change up">&#8593; 12% this month</div>
    </div>
    <div class="di-kpi" style="--kpi-color:#06b6d4">
      <div class="kpi-icon">&#9989;</div>
      <div class="kpi-label">License Approved</div>
      <div class="kpi-value">38</div>
      <div class="kpi-change">79.2% approval rate</div>
    </div>
    <div class="di-kpi" style="--kpi-color:#f59e0b">
      <div class="kpi-icon">&#9203;</div>
      <div class="kpi-label">License Pending</div>
      <div class="kpi-value">7</div>
      <div class="kpi-change">Awaiting review</div>
    </div>
    <div class="di-kpi" style="--kpi-color:#ef4444">
      <div class="kpi-icon">&#10060;</div>
      <div class="kpi-label">Rejected</div>
      <div class="kpi-value">3</div>
      <div class="kpi-change down">License violations</div>
    </div>
  </div>

  <div class="di-section-label">Data Coverage</div>
  <div class="di-grid-2">
    <div class="di-panel">
      <div class="di-panel-header">
        <div><div class="di-panel-title">Source Type Distribution</div><div class="di-panel-sub">Open-Source &middot; Recorded &middot; Vendor</div></div>
        <span class="di-panel-badge">Doughnut</span>
      </div>
      <div class="di-panel-body"><div class="di-chart-wrap"><canvas id="chartSourceType"></canvas></div></div>
    </div>
    <div class="di-panel">
      <div class="di-panel-header">
        <div><div class="di-panel-title">Raw vs Clean Hours by Language</div><div class="di-panel-sub">Data quality yield per language</div></div>
        <span class="di-panel-badge">Grouped Bar</span>
      </div>
      <div class="di-panel-body"><div class="di-chart-wrap"><canvas id="chartRawVsClean"></canvas></div></div>
    </div>
  </div>

  <div class="di-section-label">Licensing &amp; Speakers</div>
  <div class="di-grid-2">
    <div class="di-panel">
      <div class="di-panel-header">
        <div><div class="di-panel-title">License Status Breakdown</div><div class="di-panel-sub">Approved &middot; Pending &middot; Rejected</div></div>
        <span class="di-panel-badge">Bar</span>
      </div>
      <div class="di-panel-body"><div class="di-chart-wrap short"><canvas id="chartLicenseStatus"></canvas></div></div>
      <div class="di-stat-strip">
        <div class="di-stat-item"><span class="di-stat-label">Approved</span><span class="di-stat-val" style="color:var(--di-green)">38</span><span class="di-stat-sub">79.2%</span></div>
        <div class="di-stat-item"><span class="di-stat-label">Pending</span><span class="di-stat-val" style="color:var(--di-amber)">7</span><span class="di-stat-sub">14.6%</span></div>
        <div class="di-stat-item"><span class="di-stat-label">Rejected</span><span class="di-stat-val" style="color:var(--di-red)">3</span><span class="di-stat-sub">6.3%</span></div>
      </div>
    </div>
    <div class="di-panel">
      <div class="di-panel-header">
        <div><div class="di-panel-title">Speaker Count by Language</div><div class="di-panel-sub">Unique speakers registered per language</div></div>
        <span class="di-panel-badge">Bar</span>
      </div>
      <div class="di-panel-body"><div class="di-chart-wrap short"><canvas id="chartSpeakerCount"></canvas></div></div>
    </div>
  </div>

  <div class="di-section-label">Quality &amp; Pipeline</div>
  <div class="di-grid-2">
    <div class="di-panel">
      <div class="di-panel-header">
        <div><div class="di-panel-title">Clean Yield % by Language</div><div class="di-panel-sub">cleanHours / rawHours — higher is better</div></div>
        <span class="di-panel-badge">Bar</span>
      </div>
      <div class="di-panel-body"><div class="di-chart-wrap short"><canvas id="chartCleanYield"></canvas></div></div>
    </div>
    <div class="di-panel">
      <div class="di-panel-header">
        <div><div class="di-panel-title">Pipeline Stage Distribution</div><div class="di-panel-sub">How many datasets are in each stage</div></div>
        <span class="di-panel-badge">Doughnut</span>
      </div>
      <div class="di-panel-body"><div class="di-chart-wrap short"><canvas id="chartPipelineStage"></canvas></div></div>
    </div>
  </div>

  <div class="di-section-label">All Datasets</div>
  <div class="di-table-wrap">
    <div class="di-table-header">
      <div>
        <div class="di-table-title">Dataset Registry</div>
        <div class="di-table-sub">All 48 datasets — Language &middot; Source &middot; Hours &middot; License &middot; Pipeline Stage</div>
      </div>
    </div>
    <div style="padding:16px 18px">
      <div class="table-responsive">
        <table id="tblDatasets" class="table table-hover w-100">
          <thead>
            <tr>
              <th>ID</th><th>Name</th><th>Lang</th><th>Accent</th><th>Source</th>
              <th>Raw Hrs</th><th>Clean Hrs</th><th>Clips</th><th>Speakers</th>
              <th>License</th><th>Status</th><th>Assigned To</th>
            </tr>
          </thead>
          <tbody id="datasetTableBody"></tbody>
        </table>
      </div>
    </div>
  </div>

</div>
<script src="${pageContext.request.contextPath}/static/js/dataset-intake.js"></script>
<script src="${pageContext.request.contextPath}/static/js/user-stats.js"></script>