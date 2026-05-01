window.addEventListener('load', function () {
  'use strict';

  if (typeof Chart === 'undefined') { console.error('[training.js] Chart.js missing'); return; }
  if (typeof $ === 'undefined')     { console.error('[training.js] jQuery missing');   return; }

  /* ── Resolve theme colours ───────────────────────────────── */
  function isDark() {
    return (document.documentElement.getAttribute('data-theme') || 'dark') === 'dark';
  }
  const MUTED = () => isDark() ? '#6b7280' : '#9ca3af';
  const GRID  = () => isDark() ? 'rgba(255,255,255,0.06)' : 'rgba(0,0,0,0.07)';
  const PANEL = () => isDark() ? '#181b22' : '#ffffff';

  const P = {
    primary: '#6366f1', success: '#22c55e', warning: '#f59e0b',
    danger:  '#ef4444', info:    '#06b6d4', purple:  '#a855f7',
    pink:    '#ec4899', teal:    '#14b8a6',
    alpha: (hex, a) => hex + Math.round(a * 255).toString(16).padStart(2, '0')
  };

  /* ── SEED DATA ──────────────────────────────────────────── */
  const SEED = {
    lossHistory: (function () {
      const epochs = Array.from({length: 50}, (_, i) => i + 1);
      const trainLoss = [
        2.74,2.51,2.31,2.14,1.99,1.86,1.74,1.64,1.55,1.47,
        1.40,1.34,1.28,1.23,1.18,1.14,1.10,1.06,1.03,1.00,
        0.97,0.95,0.92,0.90,0.88,0.86,0.84,0.83,0.81,0.80,
        0.79,0.77,0.76,0.75,0.74,0.73,0.72,0.71,0.70,0.70,
        0.69,0.68,0.68,0.67,0.67,0.66,0.65,0.65,0.64,0.63
      ];
      const valLoss = [
        2.80,2.58,2.39,2.23,2.09,1.96,1.85,1.75,1.67,1.59,
        1.52,1.46,1.41,1.36,1.32,1.28,1.25,1.22,1.20,1.18,
        1.16,1.15,1.14,1.13,1.12,1.12,1.11,1.11,1.11,1.11,
        1.12,1.12,1.13,1.13,1.14,1.14,1.15,1.15,1.16,1.17,
        1.17,1.18,1.19,1.19,1.20,1.21,1.21,1.22,1.23,1.24
      ];
      return { epochs, trainLoss, valLoss };
    })(),

    trainingJobs: [
      { id:'TJ-2024-001', datasetId:'DS-HI-XTTS-001', baseModel:'XTTS-v2',      langCode:'hi', type:'fine_tune',          gpu:'H100', epochs:50, currentEpoch:50, trainLoss:0.634, valLoss:1.235, status:'completed', startedAt:'2025-04-20 09:00', gpuHours:38 },
      { id:'TJ-2024-002', datasetId:'DS-TA-VC-002',   baseModel:'VoiceClone-v1', langCode:'ta', type:'voice_adaptation',   gpu:'A100', epochs:30, currentEpoch:30, trainLoss:0.712, valLoss:0.988, status:'completed', startedAt:'2025-04-22 14:00', gpuHours:24 },
      { id:'TJ-2024-003', datasetId:'DS-BN-TTS-003',  baseModel:'XTTS-v2',      langCode:'bn', type:'language_expansion',  gpu:'H100', epochs:40, currentEpoch:27, trainLoss:0.891, valLoss:1.102, status:'running',   startedAt:'2025-04-28 08:30', gpuHours:31 },
      { id:'TJ-2024-004', datasetId:'DS-TE-TTS-004',  baseModel:'FastSpeech-2', langCode:'te', type:'fine_tune',          gpu:'B200', epochs:60, currentEpoch:18, trainLoss:1.134, valLoss:1.421, status:'running',   startedAt:'2025-04-29 11:00', gpuHours:22 },
      { id:'TJ-2024-005', datasetId:'DS-MR-XTTS-005', baseModel:'XTTS-v2',      langCode:'mr', type:'fine_tune',          gpu:'A100', epochs:50, currentEpoch: 0, trainLoss:null,  valLoss:null,  status:'queued',    startedAt:null,               gpuHours: 0 },
      { id:'TJ-2024-006', datasetId:'DS-GU-TTS-006',  baseModel:'FastSpeech-2', langCode:'gu', type:'language_expansion',  gpu:'H100', epochs:35, currentEpoch:14, trainLoss:2.210, valLoss:2.640, status:'failed',    startedAt:'2025-04-27 16:45', gpuHours:12 }
    ]
  };

  /* ── Chart.js global defaults ───────────────────────────── */
  Chart.defaults.color                       = MUTED();
  Chart.defaults.font.family                 = "'Inter', sans-serif";
  Chart.defaults.font.size                   = 12;
  Chart.defaults.plugins.legend.labels.color = MUTED();

  function gridOpts() { return { color: GRID(), drawBorder: false }; }
  function tickOpts(extra) { return Object.assign({ color: MUTED(), maxRotation: 0 }, extra || {}); }

  /* ── 1. LOSS CURVE ──────────────────────────────────────── */
  const lh = SEED.lossHistory;

  const overfit = {
    id: 'overfitZone',
    beforeDraw(chart) {
      const { ctx, chartArea: { top, bottom, left, width }, scales: { x } } = chart;
      if (!x) return;
      const x30 = x.getPixelForValue(29);
      ctx.save();
      ctx.fillStyle = isDark() ? 'rgba(239,68,68,0.055)' : 'rgba(239,68,68,0.04)';
      ctx.fillRect(x30, top, (left + width) - x30, bottom - top);
      ctx.restore();
      ctx.save();
      ctx.font = '10px Inter, sans-serif';
      ctx.fillStyle = isDark() ? 'rgba(239,68,68,0.55)' : 'rgba(220,38,38,0.55)';
      ctx.fillText('Overfit zone', x30 + 6, top + 14);
      ctx.restore();
    }
  };

  const lossCurveEl = document.getElementById('chartLossCurve');
  if (lossCurveEl) {
    new Chart(lossCurveEl, {
      type: 'line',
      plugins: [overfit],
      data: {
        labels: lh.epochs.map(e => `E${e}`),
        datasets: [
          {
            label: 'Train Loss', data: lh.trainLoss,
            borderColor: P.primary, backgroundColor: P.alpha(P.primary, 0.09),
            borderWidth: 2.5, pointRadius: 3, pointHoverRadius: 6, fill: true, tension: 0.38
          },
          {
            label: 'Val Loss', data: lh.valLoss,
            borderColor: P.warning, backgroundColor: P.alpha(P.warning, 0.07),
            borderWidth: 2.5, pointRadius: 3, pointHoverRadius: 6,
            fill: true, tension: 0.38, borderDash: [5, 3]
          }
        ]
      },
      options: {
        responsive: true, maintainAspectRatio: false,
        interaction: { mode: 'index', intersect: false },
        plugins: {
          legend: { position: 'top', align: 'end', labels: { boxWidth: 12, padding: 14, color: MUTED() } },
          tooltip: { callbacks: { label: ctx => ` ${ctx.dataset.label}: ${ctx.parsed.y.toFixed(3)}` } }
        },
        scales: {
          x: { grid: gridOpts(), ticks: { ...tickOpts(), maxTicksLimit: 26 } },
          y: {
            grid: gridOpts(), ticks: tickOpts(), min: 0.3, max: 2.9,
            title: { display: true, text: 'Loss', color: MUTED(), font: { size: 11 } }
          }
        }
      }
    });
  }

  /* ── 2. JOB STATUS — Doughnut ───────────────────────────── */
  const statusColorMap = { completed: P.success, running: P.primary, queued: '#8888aa', failed: P.danger };
  const statusCounts   = SEED.trainingJobs.reduce((a, j) => { a[j.status] = (a[j.status] || 0) + 1; return a; }, {});

  const jobStatusEl = document.getElementById('chartJobStatus');
  if (jobStatusEl) {
    new Chart(jobStatusEl, {
      type: 'doughnut',
      data: {
        labels: Object.keys(statusCounts).map(s => s[0].toUpperCase() + s.slice(1)),
        datasets: [{
          data: Object.values(statusCounts),
          backgroundColor: Object.keys(statusCounts).map(s => statusColorMap[s] || P.info),
          borderWidth: 2, borderColor: PANEL(), hoverOffset: 8
        }]
      },
      options: {
        responsive: true, maintainAspectRatio: false, cutout: '68%',
        plugins: {
          legend: { position: 'bottom', labels: { padding: 10, font: { size: 11 }, color: MUTED() } },
          tooltip: { callbacks: { label: ctx => ` ${ctx.label}: ${ctx.raw} job${ctx.raw !== 1 ? 's' : ''}` } }
        }
      }
    });
  }

  /* ── 3. GPU DISTRIBUTION — Pie ──────────────────────────── */
  const gpuColors = { 'H100': P.info, 'A100': P.purple, 'B200': P.warning };
  const gpuCounts = SEED.trainingJobs.reduce((a, j) => { a[j.gpu] = (a[j.gpu] || 0) + 1; return a; }, {});

  const gpuDistEl = document.getElementById('chartGPUDist');
  if (gpuDistEl) {
    new Chart(gpuDistEl, {
      type: 'pie',
      data: {
        labels: Object.keys(gpuCounts),
        datasets: [{
          data: Object.values(gpuCounts),
          backgroundColor: Object.keys(gpuCounts).map(g => gpuColors[g] || P.pink),
          borderWidth: 2, borderColor: PANEL(), hoverOffset: 8
        }]
      },
      options: {
        responsive: true, maintainAspectRatio: false,
        plugins: { legend: { position: 'bottom', labels: { padding: 10, font: { size: 11 }, color: MUTED() } } }
      }
    });
  }

  /* ── 4. TRAINING TYPE — Bar ─────────────────────────────── */
  const typeColors = { 'fine_tune': P.primary, 'voice_adaptation': P.info, 'language_expansion': P.purple };
  const typeCounts = SEED.trainingJobs.reduce((a, j) => { a[j.type] = (a[j.type] || 0) + 1; return a; }, {});
  const typeLabels = Object.keys(typeCounts).map(t => t.replace(/_/g, ' ').replace(/\b\w/g, c => c.toUpperCase()));

  const trainTypeEl = document.getElementById('chartTrainType');
  if (trainTypeEl) {
    new Chart(trainTypeEl, {
      type: 'bar',
      data: {
        labels: typeLabels,
        datasets: [{
          label: 'Jobs',
          data: Object.values(typeCounts),
          backgroundColor: Object.keys(typeCounts).map(t => P.alpha(typeColors[t] || P.primary, 0.75)),
          borderColor:     Object.keys(typeCounts).map(t => typeColors[t] || P.primary),
          borderWidth: 1, borderRadius: 5, borderSkipped: false
        }]
      },
      options: {
        responsive: true, maintainAspectRatio: false,
        plugins: { legend: { display: false } },
        scales: {
          x: { grid: gridOpts(), ticks: { ...tickOpts(), font: { size: 10 } } },
          y: {
            grid: gridOpts(), ticks: { ...tickOpts(), stepSize: 1 }, beginAtZero: true,
            title: { display: true, text: 'Jobs', color: MUTED(), font: { size: 11 } }
          }
        }
      }
    });
  }

  /* ── 5. GPU HOURS — Horizontal Bar ─────────────────────── */
  const gpuHoursByJob = SEED.trainingJobs.filter(j => j.gpuHours > 0);

  const gpuHoursEl = document.getElementById('chartGpuHours');
  if (gpuHoursEl) {
    new Chart(gpuHoursEl, {
      type: 'bar',
      data: {
        labels: gpuHoursByJob.map(j => j.id.replace('TJ-2024-', 'TJ-')),
        datasets: [{
          label: 'GPU Hours',
          data: gpuHoursByJob.map(j => j.gpuHours),
          backgroundColor: gpuHoursByJob.map(j => P.alpha(statusColorMap[j.status] || P.primary, 0.72)),
          borderColor:     gpuHoursByJob.map(j => statusColorMap[j.status] || P.primary),
          borderWidth: 1, borderRadius: 4, borderSkipped: false
        }]
      },
      options: {
        indexAxis: 'y',
        responsive: true, maintainAspectRatio: false,
        plugins: {
          legend: { display: false },
          tooltip: { callbacks: { label: ctx => ` ${ctx.raw} hrs` } }
        },
        scales: {
          x: { grid: gridOpts(), ticks: tickOpts(), title: { display: true, text: 'Hours', color: MUTED(), font: { size: 11 } } },
          y: { grid: { display: false }, ticks: { ...tickOpts(), font: { size: 11 } } }
        }
      }
    });
  }

  /* ── 6. EPOCH PROGRESS — Stacked Bar ───────────────────── */
  const activeJobs = SEED.trainingJobs.filter(j => j.status === 'running' || j.status === 'completed' || j.status === 'failed');

  const epochProgressEl = document.getElementById('chartEpochProgress');
  if (epochProgressEl) {
    new Chart(epochProgressEl, {
      type: 'bar',
      data: {
        labels: activeJobs.map(j => j.id.replace('TJ-2024-', '')),
        datasets: [
          {
            label: 'Completed Epochs',
            data: activeJobs.map(j => j.currentEpoch),
            backgroundColor: activeJobs.map(j => P.alpha(statusColorMap[j.status] || P.primary, 0.75)),
            borderColor:     activeJobs.map(j => statusColorMap[j.status] || P.primary),
            borderWidth: 1, borderRadius: { topLeft: 4, topRight: 4 }, stack: 'ep'
          },
          {
            label: 'Remaining Epochs',
            data: activeJobs.map(j => j.epochs - j.currentEpoch),
            backgroundColor: isDark() ? 'rgba(255,255,255,0.06)' : 'rgba(0,0,0,0.07)',
            borderWidth: 0, borderRadius: { topLeft: 4, topRight: 4 }, stack: 'ep'
          }
        ]
      },
      options: {
        responsive: true, maintainAspectRatio: false,
        plugins: { legend: { position: 'top', align: 'end', labels: { boxWidth: 10, padding: 10, color: MUTED() } } },
        scales: {
          x: { grid: gridOpts(), ticks: { ...tickOpts(), font: { size: 10 } } },
          y: {
            grid: gridOpts(), ticks: tickOpts(), stacked: true,
            title: { display: true, text: 'Epochs', color: MUTED(), font: { size: 11 } }
          }
        }
      }
    });
  }

  /* ── 7. TABLE ───────────────────────────────────────────── */
  const statusBadge = s => {
    const map   = { completed: 'badge-pass', running: 'badge-running', queued: 'badge-review', failed: 'badge-fail' };
    const icons = { completed: '✓', running: '▶', queued: '⏳', failed: '✗' };
    return `<span class="tbl-badge ${map[s] || 'badge-review'}">${icons[s] || ''} ${s}</span>`;
  };

  function epochBar(cur, total) {
    if (!total) return '—';
    const pct = Math.round((cur / total) * 100);
    const col = pct === 100 ? '#22c55e' : pct > 50 ? '#6366f1' : '#f59e0b';
    return `<div class="epoch-cell">
      <div class="epoch-track"><div class="epoch-fill" style="width:${pct}%;background:${col}"></div></div>
      <span class="epoch-label">${cur}/${total}</span>
    </div>`;
  }

  function lossCell(val) {
    if (val === null || val === undefined) return '<span class="faint-val">—</span>';
    const col = val < 0.8 ? '#22c55e' : val < 1.2 ? '#f59e0b' : '#ef4444';
    return `<span style="color:${col};font-weight:700;font-variant-numeric:tabular-nums">${val.toFixed(3)}</span>`;
  }

  function gpuBadge(gpu) {
    const cols = { H100: '#06b6d4', A100: '#a855f7', B200: '#f59e0b' };
    const col = cols[gpu] || '#8888aa';
    return `<span class="gpu-chip" style="color:${col};border-color:${col}30;background:${col}14">${gpu}</span>`;
  }

  const tbody = document.getElementById('trainingTableBody');
  if (tbody) {
    tbody.innerHTML = SEED.trainingJobs.map(j => `
      <tr>
        <td><code class="job-id">${j.id}</code></td>
        <td class="ds-cell">${j.datasetId}</td>
        <td class="model-cell">${j.baseModel}</td>
        <td><span class="lang-pill">${j.langCode.toUpperCase()}</span></td>
        <td class="type-cell">${j.type.replace(/_/g, ' ')}</td>
        <td>${gpuBadge(j.gpu)}</td>
        <td>${epochBar(j.currentEpoch, j.epochs)}</td>
        <td>${lossCell(j.trainLoss)}</td>
        <td>${lossCell(j.valLoss)}</td>
        <td>${statusBadge(j.status)}</td>
        <td class="date-cell">${j.startedAt || '—'}</td>
        <td class="hrs-cell">${j.gpuHours ? j.gpuHours + 'h' : '—'}</td>
      </tr>
    `).join('');

    if ($.fn.DataTable) {
      $('#tblTraining').DataTable({
        pageLength: 6, lengthMenu: [6, 10, 25],
        order: [[9, 'asc']],
        language: {
          search: '', searchPlaceholder: 'Search jobs…',
          lengthMenu: 'Show _MENU_', info: '_START_–_END_ of _TOTAL_',
          paginate: { previous: '‹', next: '›' }
        },
        columnDefs: [{ targets: [6], orderable: false }]
      });
    }
  }

}); // end window.addEventListener('load', ...)