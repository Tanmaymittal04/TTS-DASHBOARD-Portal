<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- ═══════════════════════════════════════════════════════════════
     production-content.jsp — TTS Production Monitor
     All styles are inline <style> — no external CSS dependency
═══════════════════════════════════════════════════════════════ -->

<style>
/* ── RESET / BASE ───────────────────────────────────────────── */
.prod-page *{box-sizing:border-box;margin:0;padding:0}

/* ── PAGE WRAPPER ───────────────────────────────────────────── */
.prod-page{font-family:'Inter',-apple-system,BlinkMacSystemFont,'Segoe UI',sans-serif;font-size:13px;color:#c9d1d9;line-height:1.5}

/* ── PAGE HEADER ────────────────────────────────────────────── */
.prod-header{display:flex;align-items:flex-start;justify-content:space-between;flex-wrap:wrap;gap:12px;margin-bottom:14px}
.prod-header-left{}
.prod-title{font-size:18px;font-weight:600;color:#e6edf3;display:flex;align-items:center;gap:9px;letter-spacing:-.3px}
.prod-subtitle{font-size:11px;color:#6e7681;margin-top:3px}
.prod-header-right{display:flex;align-items:center;gap:8px;flex-wrap:wrap}

/* Live pulse dot */
.prod-live{display:inline-block;width:8px;height:8px;border-radius:50%;background:#3fb950;box-shadow:0 0 0 0 rgba(63,185,80,.6);animation:prodPulse 2s infinite;flex-shrink:0}
@keyframes prodPulse{0%{box-shadow:0 0 0 0 rgba(63,185,80,.6)}70%{box-shadow:0 0 0 8px rgba(63,185,80,0)}100%{box-shadow:0 0 0 0 rgba(63,185,80,0)}}

/* Buttons */
.prod-btn{display:inline-flex;align-items:center;gap:5px;font-size:12px;font-weight:500;padding:5px 11px;border-radius:6px;border:1px solid #30363d;background:#161b22;color:#8b949e;cursor:pointer;transition:all .15s;white-space:nowrap;font-family:inherit}
.prod-btn:hover{background:#21262d;color:#c9d1d9;border-color:#444c56}
.prod-btn-sm{font-size:11px;padding:3px 8px}

/* Time badge */
.prod-time{font-size:11px;color:#6e7681;background:#161b22;border:1px solid #30363d;border-radius:6px;padding:4px 10px;white-space:nowrap;font-variant-numeric:tabular-nums}

/* Select / Input */
.prod-select,.prod-input{background:#161b22;color:#8b949e;border:1px solid #30363d;border-radius:6px;padding:4px 8px;font-size:12px;font-family:inherit;outline:none;transition:border .15s}
.prod-select:focus,.prod-input:focus{border-color:#388bfd;color:#c9d1d9}
.prod-refresh-group{display:flex;align-items:center;gap:6px}
.prod-refresh-lbl{font-size:11px;color:#6e7681}

/* ── SLA STATUS BAR ─────────────────────────────────────────── */
.prod-sla{display:flex;align-items:center;flex-wrap:wrap;gap:0;background:#0d1117;border:1px solid #21262d;border-radius:8px;padding:9px 16px;margin-bottom:14px;row-gap:8px}
.prod-sla-item{display:flex;align-items:center;gap:6px;font-size:12px;white-space:nowrap}
.prod-sla-dot{width:7px;height:7px;border-radius:50%;flex-shrink:0}
.prod-sla-dot.g{background:#3fb950;box-shadow:0 0 5px rgba(63,185,80,.5)}
.prod-sla-dot.y{background:#d29922;box-shadow:0 0 5px rgba(210,153,34,.5)}
.prod-sla-dot.r{background:#f85149;box-shadow:0 0 5px rgba(248,81,73,.5)}
.prod-sla-lbl{color:#6e7681}
.prod-sla-val{color:#c9d1d9;font-weight:500}
.prod-sla-val.ok{color:#3fb950}
.prod-sla-val.warn{color:#d29922}
.prod-sla-divider{width:1px;height:16px;background:#30363d;margin:0 12px;flex-shrink:0}
.prod-sla-uptime{margin-left:auto;display:flex;align-items:center;gap:6px;font-size:12px}

/* ── KPI GRID ───────────────────────────────────────────────── */
.prod-kpi-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(185px,1fr));gap:10px;margin-bottom:14px}
.prod-kpi{background:#0d1117;border:1px solid #21262d;border-top:2px solid var(--kc,#388bfd);border-radius:8px;padding:13px 15px 10px;position:relative;overflow:hidden;transition:border-color .2s,box-shadow .2s}
.prod-kpi:hover{box-shadow:0 4px 16px rgba(0,0,0,.4);border-color:#30363d}
.prod-kpi-top{display:flex;justify-content:space-between;align-items:flex-start;margin-bottom:2px}
.prod-kpi-lbl{font-size:10px;color:#6e7681;font-weight:500;text-transform:uppercase;letter-spacing:.6px;line-height:1.3}
.prod-kpi-ico{width:22px;height:22px;border-radius:5px;display:flex;align-items:center;justify-content:center;flex-shrink:0}
.prod-kpi-val{font-size:24px;font-weight:700;color:#e6edf3;letter-spacing:-1px;line-height:1.1;margin:5px 0 3px}
.prod-kpi-unit{font-size:13px;font-weight:400;color:#6e7681;margin-left:1px}
.prod-kpi-delta{font-size:11px;font-weight:500;margin-bottom:6px}
.prod-kpi-delta.up{color:#3fb950}
.prod-kpi-delta.dn{color:#f85149}
.prod-kpi-delta.muted{color:#6e7681}
/* progress bar */
.prod-kpi-bar-wrap{height:3px;background:#21262d;border-radius:99px;overflow:hidden;margin-top:5px}
.prod-kpi-bar{height:100%;border-radius:99px;transition:width 1.2s ease}
/* sparkline */
.prod-kpi-spark{height:32px;margin-top:6px}

/* ── PANELS ─────────────────────────────────────────────────── */
.prod-panel{background:#0d1117;border:1px solid #21262d;border-radius:8px;overflow:hidden;margin-bottom:12px}
.prod-panel-hdr{display:flex;align-items:center;justify-content:space-between;padding:11px 15px;border-bottom:1px solid #21262d;gap:10px}
.prod-panel-hdr-left{}
.prod-panel-title{font-size:13px;font-weight:600;color:#c9d1d9}
.prod-panel-sub{font-size:11px;color:#6e7681;margin-top:2px}
.prod-panel-hdr-right{display:flex;align-items:center;gap:6px;flex-shrink:0}
.prod-panel-body{padding:13px 15px}
.prod-panel-nop{padding:0}
.prod-badge-chip{font-size:10px;font-weight:600;text-transform:uppercase;letter-spacing:.4px;padding:2px 7px;background:#161b22;color:#6e7681;border:1px solid #30363d;border-radius:4px;white-space:nowrap}

/* ── CHART GRIDS ────────────────────────────────────────────── */
.prod-grid{display:grid;gap:10px;margin-bottom:12px}
.prod-grid-2{grid-template-columns:repeat(2,1fr)}
.prod-grid-3{grid-template-columns:repeat(3,1fr)}
.prod-chart-wrap{position:relative}
@media(max-width:1100px){.prod-grid-3{grid-template-columns:repeat(2,1fr)}}
@media(max-width:720px){.prod-grid-2,.prod-grid-3{grid-template-columns:1fr}}

/* ── TABLE ──────────────────────────────────────────────────── */
.prod-tbl{width:100%;border-collapse:collapse;font-size:12px}
.prod-tbl thead th{padding:9px 13px;text-align:left;font-size:10.5px;font-weight:600;color:#6e7681;text-transform:uppercase;letter-spacing:.5px;background:#090d13;border-bottom:1px solid #21262d;white-space:nowrap;cursor:default}
.prod-tbl thead th.sortable{cursor:pointer;user-select:none}
.prod-tbl thead th.sortable:hover{color:#c9d1d9}
.prod-tbl thead th.sort-asc .s-ico:after{content:' ▲';color:#388bfd}
.prod-tbl thead th.sort-desc .s-ico:after{content:' ▼';color:#388bfd}
.prod-tbl tbody tr{border-bottom:1px solid #161b22;transition:background .12s}
.prod-tbl tbody tr:hover{background:#161b22}
.prod-tbl td{padding:9px 13px;color:#c9d1d9;vertical-align:middle}
.prod-td-mono{font-family:'JetBrains Mono','SFMono-Regular','Cascadia Code',monospace;font-size:11.5px}
.prod-td-grn{color:#56d364}
.prod-td-red{color:#f85149}
.t-grn{color:#56d364}
.t-yel{color:#d29922}
.t-red{color:#f85149}
.t-mut{color:#6e7681}
/* rate cell */
.prod-rate-cell{display:flex;flex-direction:column;gap:3px}
.prod-mini-bar{width:56px;height:3px;background:#21262d;border-radius:99px;overflow:hidden}
.prod-mini-bar-fill{height:100%;border-radius:99px}
/* table badges */
.tbl-badge{font-size:10px;font-weight:600;padding:2px 8px;border-radius:4px;text-transform:uppercase;letter-spacing:.4px;white-space:nowrap}
.tbl-badge-g{background:rgba(63,185,80,.15);color:#56d364}
.tbl-badge-y{background:rgba(210,153,34,.15);color:#d29922}
.tbl-badge-r{background:rgba(248,81,73,.15);color:#f85149}
/* table footer */
.prod-tbl-foot{display:flex;align-items:center;justify-content:space-between;padding:9px 15px;border-top:1px solid #21262d;flex-wrap:wrap;gap:8px}
.prod-tbl-info{font-size:11px;color:#6e7681}
.prod-pagination{display:flex;gap:3px}
.prod-pg-btn{width:26px;height:26px;background:#161b22;color:#6e7681;border:1px solid #30363d;border-radius:5px;font-size:11px;cursor:pointer;transition:all .15s;font-family:inherit}
.prod-pg-btn:hover,.prod-pg-btn.active{background:#388bfd;color:#fff;border-color:#388bfd}
</style>

<div class="prod-page">

<!-- ── PAGE HEADER ──────────────────────────────────────────── -->
<div class="prod-header">
  <div class="prod-header-left">
    <div class="prod-title">
      <span class="prod-live"></span>
      Production Monitor
    </div>
    <div class="prod-subtitle">Live TTS deployment health &amp; request analytics — Last 24h</div>
  </div>
  <div class="prod-header-right">
    <div class="prod-time" id="lastUpdated">Updating...</div>
    <div class="prod-refresh-group">
      <label class="prod-refresh-lbl">Auto‑refresh</label>
      <select id="refreshInterval" class="prod-select">
        <option value="0">Off</option>
        <option value="30" selected>30s</option>
        <option value="60">1m</option>
        <option value="300">5m</option>
      </select>
    </div>
    <button class="prod-btn" id="btnExport">
      <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
      Export CSV
    </button>
  </div>
</div>

<!-- ── SLA STATUS BAR ────────────────────────────────────────── -->
<div class="prod-sla">
  <div class="prod-sla-item">
    <span class="prod-sla-dot g"></span>
    <span class="prod-sla-lbl">API Gateway</span>
    <span class="prod-sla-val ok">Operational</span>
  </div>
  <div class="prod-sla-divider"></div>
  <div class="prod-sla-item">
    <span class="prod-sla-dot g"></span>
    <span class="prod-sla-lbl">TTS Engine</span>
    <span class="prod-sla-val ok">Operational</span>
  </div>
  <div class="prod-sla-divider"></div>
  <div class="prod-sla-item">
    <span class="prod-sla-dot y"></span>
    <span class="prod-sla-lbl">Hindi Cluster</span>
    <span class="prod-sla-val warn">Degraded</span>
  </div>
  <div class="prod-sla-divider"></div>
  <div class="prod-sla-item">
    <span class="prod-sla-dot g"></span>
    <span class="prod-sla-lbl">Tamil Cluster</span>
    <span class="prod-sla-val ok">Operational</span>
  </div>
  <div class="prod-sla-divider"></div>
  <div class="prod-sla-item">
    <span class="prod-sla-dot g"></span>
    <span class="prod-sla-lbl">Storage</span>
    <span class="prod-sla-val ok">Operational</span>
  </div>
  <div class="prod-sla-divider"></div>
  <div class="prod-sla-uptime">
    <span class="prod-sla-lbl">30d Uptime</span>
    <span class="prod-sla-val ok" style="font-size:13px;font-weight:600">99.94%</span>
  </div>
</div>

<!-- ── KPI STRIP ─────────────────────────────────────────────── -->
<div class="prod-kpi-grid">

  <div class="prod-kpi" style="--kc:#6366f1">
    <div class="prod-kpi-top">
      <div class="prod-kpi-lbl">Total Requests (24h)</div>
      <div class="prod-kpi-ico" style="background:rgba(99,102,241,.15);color:#6366f1">
        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
      </div>
    </div>
    <div class="prod-kpi-val">84,200</div>
    <div class="prod-kpi-delta up">↑ 6.2% vs yesterday</div>
    <div class="prod-kpi-spark"><canvas id="sparkTotalReqs" height="32"></canvas></div>
  </div>

  <div class="prod-kpi" style="--kc:#3fb950">
    <div class="prod-kpi-top">
      <div class="prod-kpi-lbl">Success Rate</div>
      <div class="prod-kpi-ico" style="background:rgba(63,185,80,.15);color:#3fb950">
        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="20 6 9 17 4 12"/></svg>
      </div>
    </div>
    <div class="prod-kpi-val">97.3<span class="prod-kpi-unit">%</span></div>
    <div class="prod-kpi-delta up">Target ≥ 97% ✓</div>
    <div class="prod-kpi-bar-wrap"><div class="prod-kpi-bar" style="width:97.3%;background:#3fb950"></div></div>
  </div>

  <div class="prod-kpi" style="--kc:#f85149">
    <div class="prod-kpi-top">
      <div class="prod-kpi-lbl">Failed Requests</div>
      <div class="prod-kpi-ico" style="background:rgba(248,81,73,.15);color:#f85149">
        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg>
      </div>
    </div>
    <div class="prod-kpi-val">2,274</div>
    <div class="prod-kpi-delta dn">2.7% error rate</div>
    <div class="prod-kpi-spark"><canvas id="sparkFailed" height="32"></canvas></div>
  </div>

  <div class="prod-kpi" style="--kc:#58a6ff">
    <div class="prod-kpi-top">
      <div class="prod-kpi-lbl">Avg Latency</div>
      <div class="prod-kpi-ico" style="background:rgba(88,166,255,.15);color:#58a6ff">
        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
      </div>
    </div>
    <div class="prod-kpi-val">340<span class="prod-kpi-unit">ms</span></div>
    <div class="prod-kpi-delta up">Target &lt; 800ms ✓</div>
    <div class="prod-kpi-bar-wrap"><div class="prod-kpi-bar" style="width:42.5%;background:#58a6ff"></div></div>
  </div>

  <div class="prod-kpi" style="--kc:#bc8cff">
    <div class="prod-kpi-top">
      <div class="prod-kpi-lbl">1st Audio Latency</div>
      <div class="prod-kpi-ico" style="background:rgba(188,140,255,.15);color:#bc8cff">
        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 18V5l12-2v13"/><circle cx="6" cy="18" r="3"/><circle cx="18" cy="16" r="3"/></svg>
      </div>
    </div>
    <div class="prod-kpi-val">188<span class="prod-kpi-unit">ms</span></div>
    <div class="prod-kpi-delta up">Target &lt; 300ms ✓</div>
    <div class="prod-kpi-bar-wrap"><div class="prod-kpi-bar" style="width:62.7%;background:#bc8cff"></div></div>
  </div>

</div>

<!-- ── CHARTS ROW 1 ──────────────────────────────────────────── -->
<div class="prod-grid prod-grid-2">

  <div class="prod-panel">
    <div class="prod-panel-hdr">
      <div class="prod-panel-hdr-left">
        <div class="prod-panel-title">Request Volume (24h)</div>
        <div class="prod-panel-sub">Hourly success vs failed — stacked</div>
      </div>
      <span class="prod-badge-chip">Stacked Bar</span>
    </div>
    <div class="prod-panel-body">
      <div class="prod-chart-wrap" style="height:220px"><canvas id="chartRequestVolume"></canvas></div>
    </div>
  </div>

  <div class="prod-panel">
    <div class="prod-panel-hdr">
      <div class="prod-panel-hdr-left">
        <div class="prod-panel-title">Avg Latency Trend (24h)</div>
        <div class="prod-panel-sub">Response time per hour — SLA 800ms</div>
      </div>
      <span class="prod-badge-chip">Line</span>
    </div>
    <div class="prod-panel-body">
      <div class="prod-chart-wrap" style="height:220px"><canvas id="chartProdLatency"></canvas></div>
    </div>
  </div>

</div>

<!-- ── CHARTS ROW 2 ──────────────────────────────────────────── -->
<div class="prod-grid prod-grid-3">

  <div class="prod-panel">
    <div class="prod-panel-hdr">
      <div class="prod-panel-hdr-left">
        <div class="prod-panel-title">Top Voices by Usage</div>
        <div class="prod-panel-sub">Most called voices — 24h</div>
      </div>
      <span class="prod-badge-chip">H-Bar</span>
    </div>
    <div class="prod-panel-body">
      <div class="prod-chart-wrap" style="height:200px"><canvas id="chartVoiceUsage"></canvas></div>
    </div>
  </div>

  <div class="prod-panel">
    <div class="prod-panel-hdr">
      <div class="prod-panel-hdr-left">
        <div class="prod-panel-title">Success vs Failed</div>
        <div class="prod-panel-sub">24h overall split</div>
      </div>
      <span class="prod-badge-chip">Doughnut</span>
    </div>
    <div class="prod-panel-body">
      <div class="prod-chart-wrap" style="height:200px"><canvas id="chartSuccessRate"></canvas></div>
    </div>
  </div>

  <div class="prod-panel">
    <div class="prod-panel-hdr">
      <div class="prod-panel-hdr-left">
        <div class="prod-panel-title">Requests by Language</div>
        <div class="prod-panel-sub">Volume share per language</div>
      </div>
      <span class="prod-badge-chip">Pie</span>
    </div>
    <div class="prod-panel-body">
      <div class="prod-chart-wrap" style="height:200px"><canvas id="chartReqByLang"></canvas></div>
    </div>
  </div>

</div>

<!-- ── CHARTS ROW 3 ──────────────────────────────────────────── -->
<div class="prod-grid prod-grid-2">

  <div class="prod-panel">
    <div class="prod-panel-hdr">
      <div class="prod-panel-hdr-left">
        <div class="prod-panel-title">Error Type Breakdown</div>
        <div class="prod-panel-sub">Categorised failure reasons — 24h</div>
      </div>
      <span class="prod-badge-chip">Bar</span>
    </div>
    <div class="prod-panel-body">
      <div class="prod-chart-wrap" style="height:180px"><canvas id="chartErrorBreakdown"></canvas></div>
    </div>
  </div>

  <div class="prod-panel">
    <div class="prod-panel-hdr">
      <div class="prod-panel-hdr-left">
        <div class="prod-panel-title">P95 / P99 Latency (24h)</div>
        <div class="prod-panel-sub">Percentile response time per hour</div>
      </div>
      <span class="prod-badge-chip">Multi‑Line</span>
    </div>
    <div class="prod-panel-body">
      <div class="prod-chart-wrap" style="height:180px"><canvas id="chartPercentileLatency"></canvas></div>
    </div>
  </div>

</div>

<!-- ── HOURLY BREAKDOWN TABLE ────────────────────────────────── -->
<div class="prod-panel" style="margin-bottom:0">
  <div class="prod-panel-hdr">
    <div class="prod-panel-hdr-left">
      <div class="prod-panel-title">Hourly Request Breakdown (24h)</div>
      <div class="prod-panel-sub">Detailed per-hour production statistics</div>
    </div>
    <div class="prod-panel-hdr-right">
      <input type="text" id="tblSearchInput" class="prod-input" placeholder="Filter…" style="width:140px"/>
      <button class="prod-btn prod-btn-sm" id="btnDownloadTable">
        <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
        CSV
      </button>
    </div>
  </div>
  <div class="prod-panel-nop" style="overflow-x:auto">
    <table class="prod-tbl" id="tblProduction">
      <thead>
        <tr>
          <th>Hour</th>
          <th class="sortable" data-col="1">Total&nbsp;Req <span class="s-ico">⇅</span></th>
          <th class="sortable" data-col="2">Success <span class="s-ico">⇅</span></th>
          <th class="sortable" data-col="3">Failed <span class="s-ico">⇅</span></th>
          <th class="sortable" data-col="4">Success&nbsp;Rate <span class="s-ico">⇅</span></th>
          <th class="sortable" data-col="5">Avg&nbsp;Latency <span class="s-ico">⇅</span></th>
          <th>Status</th>
        </tr>
      </thead>
      <tbody id="productionTableBody"></tbody>
    </table>
  </div>
  <div class="prod-tbl-foot">
    <span id="tblInfo" class="prod-tbl-info">—</span>
    <div class="prod-pagination" id="tblPagination"></div>
  </div>
</div>

</div><!-- /.prod-page -->

<script src="${pageContext.request.contextPath}/static/js/production.js"></script>