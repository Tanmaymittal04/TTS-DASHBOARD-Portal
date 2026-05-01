<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!-- ── KPI STRIP ──────────────────────────────────────────────── -->
<div class="kpi-grid">

  <div class="kpi-card" style="--kpi-color:#6366f1">
    <div class="kpi-label">Total Requests (24h)</div>
    <div class="kpi-value">84,200</div>
    <div class="kpi-change up">&#8593; 6.2% vs yesterday</div>
    <div class="kpi-icon">&#9889;</div>
  </div>

  <div class="kpi-card" style="--kpi-color:#22c55e">
    <div class="kpi-label">Success Rate</div>
    <div class="kpi-value">97.3<span class="kpi-unit">%</span></div>
    <div class="kpi-change up">Target: &ge; 97% &#9989;</div>
    <div class="kpi-icon">&#9989;</div>
  </div>

  <div class="kpi-card" style="--kpi-color:#ef4444">
    <div class="kpi-label">Failed Requests</div>
    <div class="kpi-value">2,274</div>
    <div class="kpi-change down">2.7% error rate</div>
    <div class="kpi-icon">&#10060;</div>
  </div>

  <div class="kpi-card" style="--kpi-color:#06b6d4">
    <div class="kpi-label">Avg Latency</div>
    <div class="kpi-value">340<span class="kpi-unit">ms</span></div>
    <div class="kpi-change up">Target: &lt; 800ms &#9989;</div>
    <div class="kpi-icon">&#128336;</div>
  </div>

  <div class="kpi-card" style="--kpi-color:#a855f7">
    <div class="kpi-label">1st Audio Latency</div>
    <div class="kpi-value">188<span class="kpi-unit">ms</span></div>
    <div class="kpi-change up">Target: &lt; 300ms &#9989;</div>
    <div class="kpi-icon">&#127911;</div>
  </div>

</div>

<!-- ── CHARTS ROW 1 ───────────────────────────────────────────── -->
<div class="chart-grid chart-grid-2">

  <div class="chart-card">
    <div class="chart-card-header">
      <div>
        <div class="chart-title">Request Volume (24h)</div>
        <div class="chart-subtitle">Hourly success vs failed requests</div>
      </div>
      <span class="chart-badge">Stacked Bar</span>
    </div>
    <div class="chart-wrap">
      <canvas id="chartRequestVolume"></canvas>
    </div>
  </div>

  <div class="chart-card">
    <div class="chart-card-header">
      <div>
        <div class="chart-title">Avg Latency Trend (24h)</div>
        <div class="chart-subtitle">Response time per hour in ms</div>
      </div>
      <span class="chart-badge">Line</span>
    </div>
    <div class="chart-wrap">
      <canvas id="chartProdLatency"></canvas>
    </div>
  </div>

</div>

<!-- ── CHARTS ROW 2 ───────────────────────────────────────────── -->
<div class="chart-grid chart-grid-3">

  <div class="chart-card">
    <div class="chart-card-header">
      <div>
        <div class="chart-title">Top Voices by Usage</div>
        <div class="chart-subtitle">Most called voices (24h)</div>
      </div>
      <span class="chart-badge">Horizontal Bar</span>
    </div>
    <div class="chart-wrap short">
      <canvas id="chartVoiceUsage"></canvas>
    </div>
  </div>

  <div class="chart-card">
    <div class="chart-card-header">
      <div>
        <div class="chart-title">Success vs Failed</div>
        <div class="chart-subtitle">24h overall split</div>
      </div>
      <span class="chart-badge">Doughnut</span>
    </div>
    <div class="chart-wrap short">
      <canvas id="chartSuccessRate"></canvas>
    </div>
  </div>

  <div class="chart-card">
    <div class="chart-card-header">
      <div>
        <div class="chart-title">Requests by Language</div>
        <div class="chart-subtitle">Volume breakdown per language</div>
      </div>
      <span class="chart-badge">Pie</span>
    </div>
    <div class="chart-wrap short">
      <canvas id="chartReqByLang"></canvas>
    </div>
  </div>

</div>

<!-- ── HOURLY BREAKDOWN TABLE ─────────────────────────────────── -->
<div class="table-card">
  <div class="table-card-header">
    <div class="table-title">Hourly Request Breakdown (24h)</div>
  </div>
  <div class="table-responsive">
    <table id="tblProduction" class="table table-hover w-100">
      <thead>
        <tr>
          <th>Hour</th>
          <th>Total Requests</th>
          <th>Success</th>
          <th>Failed</th>
          <th>Success Rate</th>
          <th>Avg Latency</th>
        </tr>
      </thead>
      <tbody id="productionTableBody"></tbody>
    </table>
  </div>
</div>

<!-- Page JS -->
<script src="${pageContext.request.contextPath}/static/js/production.js"></script>