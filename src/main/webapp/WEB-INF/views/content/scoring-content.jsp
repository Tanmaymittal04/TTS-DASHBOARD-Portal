<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!-- ── KPI STRIP ──────────────────────────────────────────────── -->
<div class="kpi-grid">

  <div class="kpi-card" style="--kpi-color:#22c55e">
    <div class="kpi-label">Approved for Training</div>
    <div class="kpi-value">6</div>
    <div class="kpi-change up">Final Score &ge; 80</div>
    <div class="kpi-icon">&#9989;</div>
  </div>

  <div class="kpi-card" style="--kpi-color:#f59e0b">
    <div class="kpi-label">Needs Rework</div>
    <div class="kpi-value">3</div>
    <div class="kpi-change">Score between 65–79</div>
    <div class="kpi-icon">&#128295;</div>
  </div>

  <div class="kpi-card" style="--kpi-color:#ef4444">
    <div class="kpi-label">Rejected</div>
    <div class="kpi-value">1</div>
    <div class="kpi-change down">Final Score &lt; 65</div>
    <div class="kpi-icon">&#10060;</div>
  </div>

  <div class="kpi-card" style="--kpi-color:#6366f1">
    <div class="kpi-label">Avg Final Score</div>
    <div class="kpi-value">81.2</div>
    <div class="kpi-change up">&#8593; 2.1 vs last batch</div>
    <div class="kpi-icon">&#11088;</div>
  </div>

</div>

<!-- ── SCORING FORMULA CARD ───────────────────────────────────── -->
<div class="formula-card">
  <div class="formula-title">&#9997; Scoring Formula</div>
  <div class="formula-body">
    <span>Final Score =</span>
    <span class="formula-part" style="color:#6366f1">
      Audio Clarity &times; 25%
    </span>
    <span>+</span>
    <span class="formula-part" style="color:#22c55e">
      Transcript Accuracy &times; 20%
    </span>
    <span>+</span>
    <span class="formula-part" style="color:#a855f7">
      Speaker Consistency &times; 25%
    </span>
    <span>+</span>
    <span class="formula-part" style="color:#f59e0b">
      Accent Purity &times; 10%
    </span>
    <span>+</span>
    <span class="formula-part" style="color:#06b6d4">
      Language Purity &times; 10%
    </span>
    <span>+</span>
    <span class="formula-part" style="color:#ec4899">
      Coverage &times; 10%
    </span>
  </div>
  <div class="formula-thresholds">
    <span class="threshold approved">&#9679; &ge; 80 → Approved for Training</span>
    <span class="threshold rework">&#9679; 65–79 → Needs Rework</span>
    <span class="threshold rejected">&#9679; &lt; 65 → Rejected</span>
  </div>
</div>

<!-- ── CHARTS ROW 1 ───────────────────────────────────────────── -->
<div class="chart-grid chart-grid-2">

  <div class="chart-card">
    <div class="chart-card-header">
      <div>
        <div class="chart-title">Score Radar — Hindi Dataset</div>
        <div class="chart-subtitle">All 6 component scores for ds_hi_001</div>
      </div>
      <span class="chart-badge">Radar</span>
    </div>
    <div class="chart-wrap">
      <canvas id="chartRadarHindi"></canvas>
    </div>
  </div>

  <div class="chart-card">
    <div class="chart-card-header">
      <div>
        <div class="chart-title">Final Scores — All Datasets</div>
        <div class="chart-subtitle">Green &ge; 80 approved, amber = rework</div>
      </div>
      <span class="chart-badge">Bar</span>
    </div>
    <div class="chart-wrap">
      <canvas id="chartFinalScores"></canvas>
    </div>
  </div>

</div>

<!-- ── CHARTS ROW 2 ───────────────────────────────────────────── -->
<div class="chart-grid chart-grid-2">

  <div class="chart-card">
    <div class="chart-card-header">
      <div>
        <div class="chart-title">Recommendation Breakdown</div>
        <div class="chart-subtitle">Approved / Rework / Rejected split</div>
      </div>
      <span class="chart-badge">Doughnut</span>
    </div>
    <div class="chart-wrap">
      <canvas id="chartRecommendation"></canvas>
    </div>
  </div>

  <div class="chart-card">
    <div class="chart-card-header">
      <div>
        <div class="chart-title">Score Components — All Datasets</div>
        <div class="chart-subtitle">Key metric comparison per dataset</div>
      </div>
      <span class="chart-badge">Grouped Bar</span>
    </div>
    <div class="chart-wrap">
      <canvas id="chartScoreHeatmap"></canvas>
    </div>
  </div>

</div>

<!-- ── SCORING TABLE ──────────────────────────────────────────── -->
<div class="table-card">
  <div class="table-card-header">
    <div class="table-title">Dataset Score Records</div>
  </div>
  <div class="table-responsive">
    <table id="tblScores" class="table table-hover w-100">
      <thead>
        <tr>
          <th>Score ID</th>
          <th>Dataset ID</th>
          <th>Audio Clarity</th>
          <th>Transcript</th>
          <th>Spk Consistency</th>
          <th>Accent Purity</th>
          <th>Lang Purity</th>
          <th>Coverage</th>
          <th>Final Score</th>
          <th>Recommendation</th>
        </tr>
      </thead>
      <tbody id="scoreTableBody"></tbody>
    </table>
  </div>
</div>

<!-- Page JS -->
<script src="${pageContext.request.contextPath}/static/js/scoring.js"></script>