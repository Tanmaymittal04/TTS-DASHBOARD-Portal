<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!-- Three.js Particle Canvas — fixed behind content -->
<div style="position:fixed;top:0;left:0;width:100%;height:100%;z-index:-1;pointer-events:none;opacity:0.15;">
  <canvas id="three-canvas" style="width:100%;height:100%;display:block;"></canvas>
</div>

<!-- ── KPI STRIP ──────────────────────────────────────────────── -->
<div class="kpi-grid">

  <div class="kpi-card" style="--kpi-color:#6366f1">
    <div class="kpi-label">Total Datasets</div>
    <div class="kpi-value">48</div>
    <div class="kpi-change up">&#8593; 3 this month</div>
    <div class="kpi-icon">&#128230;</div>
  </div>

  <div class="kpi-card" style="--kpi-color:#22c55e">
    <div class="kpi-label">Clean Hours</div>
    <div class="kpi-value">1,250<span class="kpi-unit">hrs</span></div>
    <div class="kpi-change up">&#8593; 84 hrs added</div>
    <div class="kpi-icon">&#128336;</div>
  </div>

  <div class="kpi-card" style="--kpi-color:#06b6d4">
    <div class="kpi-label">Languages</div>
    <div class="kpi-value">12</div>
    <div class="kpi-change up">&#8593; 2 new languages</div>
    <div class="kpi-icon">&#127758;</div>
  </div>

  <div class="kpi-card" style="--kpi-color:#a855f7">
    <div class="kpi-label">Voices in Prod</div>
    <div class="kpi-value">38</div>
    <div class="kpi-change up">&#8593; 5 this week</div>
    <div class="kpi-icon">&#127908;</div>
  </div>

  <div class="kpi-card" style="--kpi-color:#f59e0b">
    <div class="kpi-label">Models Training</div>
    <div class="kpi-value">6</div>
    <div class="kpi-change">2 running now</div>
    <div class="kpi-icon">&#128640;</div>
  </div>

  <div class="kpi-card" style="--kpi-color:#22c55e">
    <div class="kpi-label">Avg MOS</div>
    <div class="kpi-value">4.12</div>
    <div class="kpi-change up">&#8593; 0.08 vs last batch</div>
    <div class="kpi-icon">&#11088;</div>
  </div>

  <div class="kpi-card" style="--kpi-color:#06b6d4">
    <div class="kpi-label">Avg Latency</div>
    <div class="kpi-value">340<span class="kpi-unit">ms</span></div>
    <div class="kpi-change up">&#8595; 12ms improved</div>
    <div class="kpi-icon">&#9889;</div>
  </div>

  <div class="kpi-card" style="--kpi-color:#ef4444">
    <div class="kpi-label">Failed QC</div>
    <div class="kpi-value">8.4<span class="kpi-unit">%</span></div>
    <div class="kpi-change down">&#8593; 0.2% vs last week</div>
    <div class="kpi-icon">&#128269;</div>
  </div>

</div>

<!-- ── PIPELINE FLOW ──────────────────────────────────────────── -->
<div class="section-title">PIPELINE STATUS FLOW</div>
<div class="flow-steps">
  <span class="flow-step active">Dataset Found</span>
  <span class="flow-arrow">&#8594;</span>
  <span class="flow-step active">Ingested</span>
  <span class="flow-arrow">&#8594;</span>
  <span class="flow-step active">QC Running</span>
  <span class="flow-arrow">&#8594;</span>
  <span class="flow-step active">QC Passed</span>
  <span class="flow-arrow">&#8594;</span>
  <span class="flow-step active">Dataset Scored</span>
  <span class="flow-arrow">&#8594;</span>
  <span class="flow-step active">Approved for Training</span>
  <span class="flow-arrow">&#8594;</span>
  <span class="flow-step">Training Running</span>
  <span class="flow-arrow">&#8594;</span>
  <span class="flow-step">Evaluation</span>
  <span class="flow-arrow">&#8594;</span>
  <span class="flow-step">Voice Approved</span>
  <span class="flow-arrow">&#8594;</span>
  <span class="flow-step">Production</span>
</div>

<!-- ── CHARTS ROW 1 ───────────────────────────────────────────── -->
<div class="chart-grid chart-grid-2">

  <div class="chart-card">
    <div class="chart-card-header">
      <div>
        <div class="chart-title">Datasets by Status</div>
        <div class="chart-subtitle">All 48 datasets across pipeline stages</div>
      </div>
      <span class="chart-badge">Doughnut</span>
    </div>
    <div class="chart-wrap">
      <canvas id="chartDatasetStatus"></canvas>
    </div>
  </div>

  <div class="chart-card">
    <div class="chart-card-header">
      <div>
        <div class="chart-title">Clean Hours by Language</div>
        <div class="chart-subtitle">Usable audio hours per language</div>
      </div>
      <span class="chart-badge">Bar</span>
    </div>
    <div class="chart-wrap">
      <canvas id="chartCleanHours"></canvas>
    </div>
  </div>

</div>

<!-- ── CHARTS ROW 2 ───────────────────────────────────────────── -->
<div class="chart-grid chart-grid-2">

  <div class="chart-card">
    <div class="chart-card-header">
      <div>
        <div class="chart-title">Avg MOS Trend</div>
        <div class="chart-subtitle">Last 6 model versions per language</div>
      </div>
      <span class="chart-badge">Line</span>
    </div>
    <div class="chart-wrap">
      <canvas id="chartMOSTrend"></canvas>
    </div>
  </div>

  <div class="chart-card">
    <div class="chart-card-header">
      <div>
        <div class="chart-title">Training Jobs by Status</div>
        <div class="chart-subtitle">Current sprint breakdown</div>
      </div>
      <span class="chart-badge">Doughnut</span>
    </div>
    <div class="chart-wrap">
      <canvas id="chartTrainingStatus"></canvas>
    </div>
  </div>

</div>

<!-- ── CHARTS ROW 3 ───────────────────────────────────────────── -->
<div class="chart-grid chart-grid-2">

  <div class="chart-card">
    <div class="chart-card-header">
      <div>
        <div class="chart-title">Voices by Use Case</div>
        <div class="chart-subtitle">Support / Sales / Collections split</div>
      </div>
      <span class="chart-badge">Pie</span>
    </div>
    <div class="chart-wrap">
      <canvas id="chartVoiceUseCase"></canvas>
    </div>
  </div>

  <div class="chart-card">
    <div class="chart-card-header">
      <div>
        <div class="chart-title">Avg Latency by Model Version</div>
        <div class="chart-subtitle">Response time trend (ms) — lower is better</div>
      </div>
      <span class="chart-badge">Line</span>
    </div>
    <div class="chart-wrap">
      <canvas id="chartLatencyTrend"></canvas>
    </div>
  </div>

</div>

<!-- Page JS -->
<script src="${pageContext.request.contextPath}/static/js/three-bg.js"></script>
<script src="${pageContext.request.contextPath}/static/js/overview.js"></script>