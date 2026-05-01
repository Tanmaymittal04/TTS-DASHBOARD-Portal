<%-- ═══════════════════════════════════════════════════════════════
     overview.jsp — Executive Overview / Main Dashboard Page
     Included via base.jsp as contentPage
════════════════════════════════════════════════════════════════ --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- ── PAGE HEADER ──────────────────────────────────────────── -->
<div class="page-header">
  <h1>Executive Overview</h1>
  <p>Full TTS pipeline health at a glance</p>
</div>

<!-- ── KPI CARDS ────────────────────────────────────────────── -->
<div class="kpi-grid">

  <div class="kpi-card blue">
    <div class="kpi-icon">🗄️</div>
    <div class="kpi-label">Total Datasets</div>
    <div class="kpi-value">48</div>
    <div class="kpi-delta up">↑ 3 this month</div>
  </div>

  <div class="kpi-card teal">
    <div class="kpi-icon">🕐</div>
    <div class="kpi-label">Clean Hours</div>
    <div class="kpi-value">1,250<span class="unit">hrs</span></div>
    <div class="kpi-delta up">↑ 84 hrs added</div>
  </div>

  <div class="kpi-card blue">
    <div class="kpi-icon">🌐</div>
    <div class="kpi-label">Languages</div>
    <div class="kpi-value">12</div>
    <div class="kpi-delta up">↑ 2 new languages</div>
  </div>

  <div class="kpi-card green">
    <div class="kpi-icon">🎙️</div>
    <div class="kpi-label">Voices in Prod</div>
    <div class="kpi-value">38</div>
    <div class="kpi-delta up">↑ 5 this week</div>
  </div>

  <div class="kpi-card purple">
    <div class="kpi-icon">🔬</div>
    <div class="kpi-label">Models Training</div>
    <div class="kpi-value">6</div>
    <div class="kpi-delta">2 running now</div>
  </div>

  <div class="kpi-card yellow">
    <div class="kpi-icon">⭐</div>
    <div class="kpi-label">Avg MOS</div>
    <div class="kpi-value">4.12</div>
    <div class="kpi-delta up">↑ 0.08 vs last batch</div>
  </div>

  <div class="kpi-card orange">
    <div class="kpi-icon">⚡</div>
    <div class="kpi-label">Avg Latency</div>
    <div class="kpi-value">340<span class="unit">ms</span></div>
    <div class="kpi-delta down">↓ 12ms improved</div>
  </div>

  <div class="kpi-card red">
    <div class="kpi-icon">🔍</div>
    <div class="kpi-label">Failed QC</div>
    <div class="kpi-value">8.4<span class="unit">%</span></div>
    <div class="kpi-delta up">↑ 0.2% vs last week</div>
  </div>

</div>

<!-- ── PIPELINE STATUS FLOW ──────────────────────────────────── -->
<div class="panel mb-12">
  <div class="panel-header">
    <div>
      <div class="panel-title">Pipeline Status Flow</div>
      <div class="panel-subtitle">Current dataset progression across stages</div>
    </div>
  </div>
  <div class="panel-body">
    <div class="pipeline-flow">
      <div class="pipeline-step">
        <span class="pipeline-step-label done">Dataset Found</span>
        <span class="pipeline-arrow">→</span>
      </div>
      <div class="pipeline-step">
        <span class="pipeline-step-label done">Ingested</span>
        <span class="pipeline-arrow">→</span>
      </div>
      <div class="pipeline-step">
        <span class="pipeline-step-label active">QC Running</span>
        <span class="pipeline-arrow">→</span>
      </div>
      <div class="pipeline-step">
        <span class="pipeline-step-label">QC Passed</span>
        <span class="pipeline-arrow">→</span>
      </div>
      <div class="pipeline-step">
        <span class="pipeline-step-label">Dataset Scored</span>
        <span class="pipeline-arrow">→</span>
      </div>
      <div class="pipeline-step">
        <span class="pipeline-step-label">Approved for Training</span>
        <span class="pipeline-arrow">→</span>
      </div>
      <div class="pipeline-step">
        <span class="pipeline-step-label active">Training Running</span>
        <span class="pipeline-arrow">→</span>
      </div>
      <div class="pipeline-step">
        <span class="pipeline-step-label">Evaluation</span>
        <span class="pipeline-arrow">→</span>
      </div>
      <div class="pipeline-step">
        <span class="pipeline-step-label">Voice Approved</span>
        <span class="pipeline-arrow">→</span>
      </div>
      <div class="pipeline-step">
        <span class="pipeline-step-label done">Production</span>
      </div>
    </div>
  </div>
  <!-- Mini counts per stage -->
  <div class="stat-row">
    <div class="stat-item">
      <span class="stat-item-label">In QC</span>
      <span class="stat-item-value text-orange">7</span>
    </div>
    <div class="stat-item">
      <span class="stat-item-label">In Training</span>
      <span class="stat-item-value text-blue">6</span>
    </div>
    <div class="stat-item">
      <span class="stat-item-label">In Evaluation</span>
      <span class="stat-item-value text-yellow">3</span>
    </div>
    <div class="stat-item">
      <span class="stat-item-label">Prod Ready</span>
      <span class="stat-item-value text-green">38</span>
    </div>
    <div class="stat-item">
      <span class="stat-item-label">Failed</span>
      <span class="stat-item-value text-red">2</span>
    </div>
  </div>
</div>

<!-- ── CHARTS ROW 1 ──────────────────────────────────────────── -->
<div class="panel-grid cols-2 mb-12">

  <!-- Datasets by Status — Doughnut -->
  <div class="panel">
    <div class="panel-header">
      <div>
        <div class="panel-title">Datasets by Status</div>
        <div class="panel-subtitle">All 48 datasets across pipeline stages</div>
      </div>
      <div class="panel-actions">
        <button class="panel-action-btn active" id="statusChartToggle">Doughnut</button>
      </div>
    </div>
    <div class="panel-body">
      <div class="chart-container" style="height:240px;">
        <canvas id="statusChart"></canvas>
      </div>
    </div>
  </div>

  <!-- Clean Hours by Language — Bar -->
  <div class="panel">
    <div class="panel-header">
      <div>
        <div class="panel-title">Clean Hours by Language</div>
        <div class="panel-subtitle">Usable audio hours per language</div>
      </div>
      <div class="panel-actions">
        <button class="panel-action-btn active">Bar</button>
      </div>
    </div>
    <div class="panel-body">
      <div class="chart-container" style="height:240px;">
        <canvas id="langChart"></canvas>
      </div>
    </div>
  </div>

</div>

<!-- ── CHARTS ROW 2 ──────────────────────────────────────────── -->
<div class="panel-grid cols-2 mb-12">

  <!-- MOS Score Trend — Line -->
  <div class="panel">
    <div class="panel-header">
      <div>
        <div class="panel-title">MOS Score Trend</div>
        <div class="panel-subtitle">Last 8 training batches</div>
      </div>
    </div>
    <div class="panel-body">
      <div class="chart-container" style="height:200px;">
        <canvas id="mosChart"></canvas>
      </div>
    </div>
  </div>

  <!-- QC Pass/Fail Rate — Line -->
  <div class="panel">
    <div class="panel-header">
      <div>
        <div class="panel-title">QC Pass / Fail Rate</div>
        <div class="panel-subtitle">Weekly trend over last 8 weeks</div>
      </div>
    </div>
    <div class="panel-body">
      <div class="chart-container" style="height:200px;">
        <canvas id="qcTrendChart"></canvas>
      </div>
    </div>
  </div>

</div>

<!-- ── ACTIVE TRAINING JOBS ──────────────────────────────────── -->
<div class="panel mb-12">
  <div class="panel-header">
    <div>
      <div class="panel-title">Active Training Jobs</div>
      <div class="panel-subtitle">Currently running or queued model training</div>
    </div>
    <div class="panel-actions">
      <a href="${pageContext.request.contextPath}/training" class="btn btn-secondary btn-sm">View All</a>
    </div>
  </div>
  <div class="panel-body no-pad">
    <table class="data-table">
      <thead>
        <tr>
          <th>Job ID</th>
          <th>Model</th>
          <th>Language</th>
          <th>Speaker</th>
          <th>Progress</th>
          <th>ETA</th>
          <th>Status</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td class="text-muted fs-11">TRN-0041</td>
          <td class="fw-500">XTTS-v2</td>
          <td>Hindi (hi-IN)</td>
          <td>Riya S.</td>
          <td>
            <div style="display:flex;align-items:center;gap:8px;">
              <div class="progress-bar-wrap" style="width:80px;">
                <div class="progress-bar-fill green" style="width:72%"></div>
              </div>
              <span class="fs-11">72%</span>
            </div>
          </td>
          <td class="text-muted fs-11">~18 min</td>
          <td><span class="badge badge-green">Running</span></td>
        </tr>
        <tr>
          <td class="text-muted fs-11">TRN-0042</td>
          <td class="fw-500">XTTS-v2</td>
          <td>Tamil (ta-IN)</td>
          <td>Arjun K.</td>
          <td>
            <div style="display:flex;align-items:center;gap:8px;">
              <div class="progress-bar-wrap" style="width:80px;">
                <div class="progress-bar-fill blue" style="width:38%"></div>
              </div>
              <span class="fs-11">38%</span>
            </div>
          </td>
          <td class="text-muted fs-11">~45 min</td>
          <td><span class="badge badge-green">Running</span></td>
        </tr>
        <tr>
          <td class="text-muted fs-11">TRN-0043</td>
          <td class="fw-500">XTTS-v2</td>
          <td>Bengali (bn-IN)</td>
          <td>Priya M.</td>
          <td>
            <div style="display:flex;align-items:center;gap:8px;">
              <div class="progress-bar-wrap" style="width:80px;">
                <div class="progress-bar-fill orange" style="width:5%"></div>
              </div>
              <span class="fs-11">5%</span>
            </div>
          </td>
          <td class="text-muted fs-11">~2.1 hrs</td>
          <td><span class="badge badge-orange">Queued</span></td>
        </tr>
        <tr>
          <td class="text-muted fs-11">TRN-0044</td>
          <td class="fw-500">XTTS-v2.1</td>
          <td>Telugu (te-IN)</td>
          <td>Suresh R.</td>
          <td>
            <div style="display:flex;align-items:center;gap:8px;">
              <div class="progress-bar-wrap" style="width:80px;">
                <div class="progress-bar-fill orange" style="width:0%"></div>
              </div>
              <span class="fs-11">0%</span>
            </div>
          </td>
          <td class="text-muted fs-11">—</td>
          <td><span class="badge badge-gray">Pending</span></td>
        </tr>
      </tbody>
    </table>
  </div>
</div>

<!-- ── RECENT DATASETS ───────────────────────────────────────── -->
<div class="panel mb-12">
  <div class="panel-header">
    <div>
      <div class="panel-title">Recent Datasets</div>
      <div class="panel-subtitle">Latest 5 ingested datasets</div>
    </div>
    <div class="panel-actions">
      <a href="${pageContext.request.contextPath}/datasets" class="btn btn-secondary btn-sm">View All</a>
    </div>
  </div>
  <div class="panel-body no-pad">
    <table class="data-table">
      <thead>
        <tr>
          <th>Dataset ID</th>
          <th>Language</th>
          <th>Speaker</th>
          <th>Hours</th>
          <th>QC Score</th>
          <th>MOS</th>
          <th>Status</th>
          <th>Ingested</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td class="fw-500">DS-0048</td>
          <td>Hindi</td>
          <td>Riya S.</td>
          <td>32.5</td>
          <td><span class="text-green">94.2%</span></td>
          <td>4.21</td>
          <td><span class="badge badge-green">QC Passed</span></td>
          <td class="text-muted fs-11">30 Apr 2026</td>
        </tr>
        <tr>
          <td class="fw-500">DS-0047</td>
          <td>Tamil</td>
          <td>Arjun K.</td>
          <td>28.0</td>
          <td><span class="text-orange">78.1%</span></td>
          <td>3.95</td>
          <td><span class="badge badge-orange">QC Running</span></td>
          <td class="text-muted fs-11">29 Apr 2026</td>
        </tr>
        <tr>
          <td class="fw-500">DS-0046</td>
          <td>Telugu</td>
          <td>Suresh R.</td>
          <td>41.0</td>
          <td><span class="text-green">91.7%</span></td>
          <td>4.08</td>
          <td><span class="badge badge-blue">In Training</span></td>
          <td class="text-muted fs-11">28 Apr 2026</td>
        </tr>
        <tr>
          <td class="fw-500">DS-0045</td>
          <td>Bengali</td>
          <td>Priya M.</td>
          <td>19.5</td>
          <td><span class="text-red">61.3%</span></td>
          <td>3.42</td>
          <td><span class="badge badge-red">QC Failed</span></td>
          <td class="text-muted fs-11">27 Apr 2026</td>
        </tr>
        <tr>
          <td class="fw-500">DS-0044</td>
          <td>Kannada</td>
          <td>Deepa V.</td>
          <td>55.2</td>
          <td><span class="text-green">96.0%</span></td>
          <td>4.35</td>
          <td><span class="badge badge-green">Production</span></td>
          <td class="text-muted fs-11">26 Apr 2026</td>
        </tr>
      </tbody>
    </table>
  </div>
</div>

<!-- ── OVERVIEW CHARTS JS ────────────────────────────────────── -->
<script>
(function () {

  // Global Chart.js dark theme
  Chart.defaults.color           = '#8e9199';
  Chart.defaults.borderColor     = '#23262b';
  Chart.defaults.font.family     = "'Inter', sans-serif";
  Chart.defaults.font.size       = 11;

  const COLORS = {
    blue:   '#3d71ab',
    green:  '#73bf69',
    orange: '#ff9830',
    red:    '#f2495c',
    yellow: '#fade2a',
    purple: '#9b59b6',
    teal:   '#4ecdc4',
    gray:   '#5a5f6a',
  };

  // ── Datasets by Status (Doughnut) ───────────────────────────
  const statusCtx = document.getElementById('statusChart');
  if (statusCtx) {
    new Chart(statusCtx, {
      type: 'doughnut',
      data: {
        labels: ['Production','In Training','QC Passed','QC Running','QC Failed','Ingested','Pending'],
        datasets: [{
          data: [16, 6, 9, 7, 2, 5, 3],
          backgroundColor: [
            COLORS.green, COLORS.blue, COLORS.teal,
            COLORS.orange, COLORS.red, COLORS.yellow, COLORS.gray
          ],
          borderColor: '#141619',
          borderWidth: 2,
          hoverBorderWidth: 0
        }]
      },
      options: {
        cutout: '68%',
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            position: 'right',
            labels: { boxWidth: 10, padding: 12, font: { size: 11 } }
          },
          tooltip: {
            callbacks: {
              label: ctx => ` ${ctx.label}: ${ctx.raw} datasets`
            }
          }
        }
      }
    });
  }

  // ── Clean Hours by Language (Bar) ────────────────────────────
  const langCtx = document.getElementById('langChart');
  if (langCtx) {
    new Chart(langCtx, {
      type: 'bar',
      data: {
        labels: ['Hindi','Tamil','Telugu','Bengali','Kannada','Marathi','Gujarati','Malayalam','Punjabi','Odia','Urdu','Assamese'],
        datasets: [{
          label: 'Clean Hours',
          data: [280, 195, 210, 140, 175, 90, 65, 80, 55, 40, 48, 22],
          backgroundColor: 'rgba(61,113,171,0.7)',
          borderColor: COLORS.blue,
          borderWidth: 1,
          borderRadius: 3,
          hoverBackgroundColor: COLORS.blue
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: { display: false },
          tooltip: { callbacks: { label: ctx => ` ${ctx.raw} hrs` } }
        },
        scales: {
          x: { grid: { display: false }, ticks: { font: { size: 10 } } },
          y: { grid: { color: '#23262b' }, ticks: { callback: v => v + 'h' } }
        }
      }
    });
  }

  // ── MOS Trend (Line) ────────────────────────────────────────
  const mosCtx = document.getElementById('mosChart');
  if (mosCtx) {
    new Chart(mosCtx, {
      type: 'line',
      data: {
        labels: ['Batch 1','Batch 2','Batch 3','Batch 4','Batch 5','Batch 6','Batch 7','Batch 8'],
        datasets: [{
          label: 'Avg MOS',
          data: [3.72, 3.85, 3.91, 3.88, 3.95, 4.01, 4.08, 4.12],
          borderColor: COLORS.yellow,
          backgroundColor: 'rgba(250,222,42,0.08)',
          borderWidth: 2,
          pointRadius: 4,
          pointBackgroundColor: COLORS.yellow,
          tension: 0.4,
          fill: true
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: { display: false },
          annotation: {
            annotations: {
              threshold: {
                type: 'line',
                yMin: 4.0, yMax: 4.0,
                borderColor: 'rgba(115,191,105,0.5)',
                borderWidth: 1,
                borderDash: [4, 4],
                label: {
                  content: 'Target 4.0',
                  display: true,
                  color: COLORS.green,
                  font: { size: 10 }
                }
              }
            }
          }
        },
        scales: {
          x: { grid: { display: false } },
          y: {
            min: 3.5, max: 4.5,
            grid: { color: '#23262b' },
            ticks: { stepSize: 0.25 }
          }
        }
      }
    });
  }

  // ── QC Pass/Fail Trend (Line) ────────────────────────────────
  const qcCtx = document.getElementById('qcTrendChart');
  if (qcCtx) {
    new Chart(qcCtx, {
      type: 'line',
      data: {
        labels: ['W1','W2','W3','W4','W5','W6','W7','W8'],
        datasets: [
          {
            label: 'Pass Rate %',
            data: [88, 90, 87, 92, 91, 93, 91, 92],
            borderColor: COLORS.green,
            backgroundColor: 'rgba(115,191,105,0.08)',
            borderWidth: 2,
            pointRadius: 3,
            tension: 0.4,
            fill: true
          },
          {
            label: 'Fail Rate %',
            data: [12, 10, 13, 8, 9, 7, 9, 8],
            borderColor: COLORS.red,
            backgroundColor: 'rgba(242,73,92,0.05)',
            borderWidth: 2,
            pointRadius: 3,
            tension: 0.4,
            fill: true
          }
        ]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            position: 'top',
            labels: { boxWidth: 10, padding: 10, font: { size: 11 } }
          }
        },
        scales: {
          x: { grid: { display: false } },
          y: {
            min: 0, max: 100,
            grid: { color: '#23262b' },
            ticks: { callback: v => v + '%' }
          }
        }
      }
    });
  }

})();
</script>
