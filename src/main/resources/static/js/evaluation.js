/* ═══════════════════════════════════════════════════════════════
   evaluation.js — Model Evaluation Dashboard
   MOS · WER/CER · Latency · Speaker Similarity · Radar · Grades
   Fixed: wrapped in window.addEventListener('load', ...) so
   Chart.js / jQuery / DataTables are guaranteed to be present.
════════════════════════════════════════════════════════════════ */
window.addEventListener('load', function () {
  'use strict';

  if (typeof Chart === 'undefined') { console.error('[evaluation.js] Chart.js not loaded'); return; }
  if (typeof $     === 'undefined') { console.error('[evaluation.js] jQuery not loaded');   return; }

  /* ── Theme helpers ──────────────────────────────────────────── */
  function isDark() {
    return (document.documentElement.getAttribute('data-theme') || 'dark') === 'dark';
  }
  const MUTED  = () => isDark() ? '#6b7280' : '#9ca3af';
  const GRID   = () => isDark() ? 'rgba(255,255,255,0.06)' : 'rgba(0,0,0,0.07)';
  const PANEL  = () => isDark() ? '#161820' : '#ffffff';
  const RADAR_GRID = () => isDark() ? 'rgba(255,255,255,0.08)' : 'rgba(0,0,0,0.08)';

  /* ── Colour palette ─────────────────────────────────────────── */
  const P = {
    primary : '#6366f1',
    success : '#22c55e',
    warning : '#f59e0b',
    danger  : '#ef4444',
    info    : '#06b6d4',
    purple  : '#a855f7',
    pink    : '#ec4899',
    teal    : '#14b8a6',
    orange  : '#f97316',
    alpha   : (hex, a) => hex + Math.round(a * 255).toString(16).padStart(2, '0')
  };

  /* ── Chart.js global defaults ───────────────────────────────── */
  Chart.defaults.color                       = MUTED();
  Chart.defaults.font.family                 = "'Inter', sans-serif";
  Chart.defaults.font.size                   = 12;
  Chart.defaults.plugins.legend.labels.color = MUTED();

  function gridOpts()      { return { color: GRID(), drawBorder: false }; }
  function tickOpts(extra) { return Object.assign({ color: MUTED(), maxRotation: 0 }, extra || {}); }

  /* ══════════════════════════════════════════════════════════════
     SEED DATA — 8 evaluations across 7 languages
  ══════════════════════════════════════════════════════════════ */
  const SEED = {

    evaluations: [
      {
        id: 'EV-2025-001', modelVersion: 'XTTS-EN-v3.0', langCode: 'en',
        mos: 4.51, wer: 0.032, cer: 0.014, speakerSim: 0.92,
        latencyMs: 218, firstAudioMs: 98,
        pronunciation: 4.6, naturalness: 4.5,
        grade: 'A', status: 'approved',
        evaluatedBy: 'Auto+Human', evaluatedAt: '2025-04-26 10:00'
      },
      {
        id: 'EV-2025-002', modelVersion: 'XTTS-HI-v2.1', langCode: 'hi',
        mos: 4.32, wer: 0.048, cer: 0.021, speakerSim: 0.89,
        latencyMs: 295, firstAudioMs: 142,
        pronunciation: 4.4, naturalness: 4.3,
        grade: 'A', status: 'approved',
        evaluatedBy: 'Auto+Human', evaluatedAt: '2025-04-25 14:30'
      },
      {
        id: 'EV-2025-003', modelVersion: 'VC-TA-v1.2', langCode: 'ta',
        mos: 4.08, wer: 0.071, cer: 0.033, speakerSim: 0.83,
        latencyMs: 342, firstAudioMs: 165,
        pronunciation: 4.1, naturalness: 4.0,
        grade: 'A', status: 'approved',
        evaluatedBy: 'Auto', evaluatedAt: '2025-04-24 09:15'
      },
      {
        id: 'EV-2025-004', modelVersion: 'XTTS-BN-v1.0', langCode: 'bn',
        mos: 3.74, wer: 0.112, cer: 0.058, speakerSim: 0.77,
        latencyMs: 421, firstAudioMs: 198,
        pronunciation: 3.8, naturalness: 3.7,
        grade: 'B', status: 'pending',
        evaluatedBy: 'Auto', evaluatedAt: '2025-04-28 11:00'
      },
      {
        id: 'EV-2025-005', modelVersion: 'FS2-TE-v1.1', langCode: 'te',
        mos: 3.41, wer: 0.143, cer: 0.072, speakerSim: 0.71,
        latencyMs: 512, firstAudioMs: 241,
        pronunciation: 3.5, naturalness: 3.4,
        grade: 'B', status: 'pending',
        evaluatedBy: 'Auto', evaluatedAt: '2025-04-29 08:45'
      },
      {
        id: 'EV-2025-006', modelVersion: 'XTTS-MR-v1.0', langCode: 'mr',
        mos: 3.62, wer: 0.129, cer: 0.061, speakerSim: 0.74,
        latencyMs: 388, firstAudioMs: 182,
        pronunciation: 3.7, naturalness: 3.6,
        grade: 'B', status: 'pending',
        evaluatedBy: 'Auto', evaluatedAt: '2025-04-28 16:00'
      },
      {
        id: 'EV-2025-007', modelVersion: 'FS2-GU-v1.0', langCode: 'gu',
        mos: 2.89, wer: 0.218, cer: 0.124, speakerSim: 0.61,
        latencyMs: 734, firstAudioMs: 312,
        pronunciation: 2.9, naturalness: 2.8,
        grade: 'C', status: 'needs_review',
        evaluatedBy: 'Auto', evaluatedAt: '2025-04-27 13:30'
      },
      {
        id: 'EV-2025-008', modelVersion: 'XTTS-KN-v0.9', langCode: 'kn',
        mos: 2.41, wer: 0.312, cer: 0.178, speakerSim: 0.52,
        latencyMs: 921, firstAudioMs: 445,
        pronunciation: 2.4, naturalness: 2.3,
        grade: 'Fail', status: 'rejected',
        evaluatedBy: 'Auto', evaluatedAt: '2025-04-26 17:00'
      }
    ],

    /* MOS version history for 3 key languages */
    mosVersions: {
      labels  : ['v0.9', 'v1.0', 'v1.1', 'v1.2', 'v2.0', 'v2.1', 'v3.0'],
      hindi   : [2.91, 3.28, 3.52, 3.74, 3.94, 4.32, null],
      english : [3.11, 3.48, 3.72, 3.95, 4.12, 4.31, 4.51],
      tamil   : [null, 2.98, 3.15, 4.08, null, null, null]
    }
  };

  const evals = SEED.evaluations;

  /* ══════════════════════════════════════════════════════════════
     1. MOS BY LANGUAGE — Vertical Bar, threshold-coloured
  ══════════════════════════════════════════════════════════════ */
  const mosEl = document.getElementById('chartMOSByLang');
  if (mosEl) {
    const mosColors = evals.map(e =>
      e.mos >= 4.0 ? P.success : e.mos >= 3.3 ? P.warning : P.danger
    );

    /* annotate threshold line */
    const thresholdPlugin = {
      id: 'mosThreshold',
      afterDraw(chart) {
        const { ctx, chartArea: { left, right }, scales: { y } } = chart;
        const yPos = y.getPixelForValue(4.0);
        ctx.save();
        ctx.setLineDash([6, 4]);
        ctx.strokeStyle = isDark() ? 'rgba(99,102,241,0.55)' : 'rgba(79,70,229,0.45)';
        ctx.lineWidth = 1.5;
        ctx.beginPath();
        ctx.moveTo(left, yPos);
        ctx.lineTo(right, yPos);
        ctx.stroke();
        ctx.setLineDash([]);
        ctx.font = '10px Inter, sans-serif';
        ctx.fillStyle = isDark() ? 'rgba(99,102,241,0.7)' : 'rgba(79,70,229,0.7)';
        ctx.fillText('Target ≥ 4.0', right - 72, yPos - 5);
        ctx.restore();
      }
    };

    new Chart(mosEl, {
      type: 'bar',
      plugins: [thresholdPlugin],
      data: {
        labels: evals.map(e => e.langCode.toUpperCase()),
        datasets: [{
          label: 'MOS Score',
          data: evals.map(e => e.mos),
          backgroundColor: mosColors.map(c => P.alpha(c, 0.72)),
          borderColor: mosColors,
          borderWidth: 1,
          borderRadius: 5,
          borderSkipped: false
        }]
      },
      options: {
        responsive: true, maintainAspectRatio: false,
        plugins: {
          legend: { display: false },
          tooltip: {
            callbacks: {
              title: (items) => evals[items[0].dataIndex].modelVersion,
              label: ctx => ` MOS: ${ctx.parsed.y.toFixed(2)} / 5.0`
            }
          }
        },
        scales: {
          x: { grid: { display: false }, ticks: tickOpts({ font: { size: 11 } }) },
          y: {
            grid: gridOpts(), ticks: tickOpts(),
            min: 2.0, max: 5.0,
            title: { display: true, text: 'MOS (1–5)', color: MUTED(), font: { size: 11 } }
          }
        }
      }
    });
  }

  /* ══════════════════════════════════════════════════════════════
     2. EVALUATION RADAR — Top 2 models, multi-metric
  ══════════════════════════════════════════════════════════════ */
  const radarEl = document.getElementById('chartEvalRadar');
  if (radarEl) {
    const sorted   = [...evals].sort((a, b) => b.mos - a.mos);
    const best     = sorted[0];
    const second   = sorted[1];

    function toRadar(e) {
      return [
        +(e.mos / 5 * 100).toFixed(1),                              // naturalness
        +(100 - e.wer * 100).toFixed(1),                             // intelligibility
        +(100 - e.cer * 100).toFixed(1),                             // char accuracy
        +(e.speakerSim * 100).toFixed(1),                            // speaker similarity
        +(100 - Math.min(e.latencyMs / 1000, 1) * 100).toFixed(1),  // speed (full)
        +(100 - Math.min(e.firstAudioMs / 500, 1) * 100).toFixed(1) // responsiveness (TTFA)
      ];
    }

    new Chart(radarEl, {
      type: 'radar',
      data: {
        labels: ['Naturalness', 'Intelligibility', 'Char Accuracy', 'Spk Similarity', 'Speed', 'Responsiveness'],
        datasets: [
          {
            label: best.modelVersion,
            data: toRadar(best),
            borderColor: P.success,
            backgroundColor: P.alpha(P.success, 0.15),
            borderWidth: 2,
            pointBackgroundColor: P.success,
            pointRadius: 4, pointHoverRadius: 6
          },
          {
            label: second.modelVersion,
            data: toRadar(second),
            borderColor: P.primary,
            backgroundColor: P.alpha(P.primary, 0.12),
            borderWidth: 2, borderDash: [4, 3],
            pointBackgroundColor: P.primary,
            pointRadius: 4, pointHoverRadius: 6
          }
        ]
      },
      options: {
        responsive: true, maintainAspectRatio: false,
        plugins: {
          legend: { position: 'top', labels: { boxWidth: 10, padding: 12, font: { size: 11 }, color: MUTED() } }
        },
        scales: {
          r: {
            min: 50, max: 100,
            ticks: { stepSize: 10, color: MUTED(), backdropColor: 'transparent', font: { size: 9 } },
            grid: { color: RADAR_GRID() },
            pointLabels: { color: MUTED(), font: { size: 10.5 } },
            angleLines: { color: RADAR_GRID() }
          }
        }
      }
    });
  }

  /* ══════════════════════════════════════════════════════════════
     3. WER & CER GROUPED BAR
  ══════════════════════════════════════════════════════════════ */
  const werEl = document.getElementById('chartWERCER');
  if (werEl) {
    new Chart(werEl, {
      type: 'bar',
      data: {
        labels: evals.map(e => e.langCode.toUpperCase()),
        datasets: [
          {
            label: 'WER %',
            data: evals.map(e => +(e.wer * 100).toFixed(1)),
            backgroundColor: P.alpha(P.danger, 0.65),
            borderColor: P.danger,
            borderWidth: 1, borderRadius: 4, borderSkipped: false
          },
          {
            label: 'CER %',
            data: evals.map(e => +(e.cer * 100).toFixed(1)),
            backgroundColor: P.alpha(P.warning, 0.65),
            borderColor: P.warning,
            borderWidth: 1, borderRadius: 4, borderSkipped: false
          }
        ]
      },
      options: {
        responsive: true, maintainAspectRatio: false,
        interaction: { mode: 'index', intersect: false },
        plugins: {
          legend: { position: 'top', align: 'end', labels: { boxWidth: 10, padding: 10, font: { size: 11 }, color: MUTED() } }
        },
        scales: {
          x: { grid: { display: false }, ticks: tickOpts({ font: { size: 11 } }) },
          y: {
            grid: gridOpts(), ticks: tickOpts(), beginAtZero: true,
            title: { display: true, text: 'Error Rate %', color: MUTED(), font: { size: 11 } }
          }
        }
      }
    });
  }

  /* ══════════════════════════════════════════════════════════════
     4. LATENCY BREAKDOWN — Full latency vs First audio latency
  ══════════════════════════════════════════════════════════════ */
  const latEl = document.getElementById('chartLatencyComp');
  if (latEl) {
    const latTarget = {
      id: 'latTarget',
      afterDraw(chart) {
        const { ctx, chartArea: { left, right }, scales: { y } } = chart;
        const yPos = y.getPixelForValue(800);
        ctx.save();
        ctx.setLineDash([5, 4]);
        ctx.strokeStyle = isDark() ? 'rgba(239,68,68,0.5)' : 'rgba(220,38,38,0.4)';
        ctx.lineWidth = 1.5;
        ctx.beginPath(); ctx.moveTo(left, yPos); ctx.lineTo(right, yPos); ctx.stroke();
        ctx.setLineDash([]);
        ctx.font = '10px Inter, sans-serif';
        ctx.fillStyle = isDark() ? 'rgba(239,68,68,0.65)' : 'rgba(220,38,38,0.65)';
        ctx.fillText('Max latency 800ms', right - 110, yPos - 5);
        ctx.restore();
      }
    };

    new Chart(latEl, {
      type: 'bar',
      plugins: [latTarget],
      data: {
        labels: evals.map(e => e.langCode.toUpperCase()),
        datasets: [
          {
            label: 'Full Latency (ms)',
            data: evals.map(e => e.latencyMs),
            backgroundColor: evals.map(e =>
              P.alpha(e.latencyMs < 400 ? P.success : e.latencyMs < 700 ? P.warning : P.danger, 0.7)
            ),
            borderColor: evals.map(e =>
              e.latencyMs < 400 ? P.success : e.latencyMs < 700 ? P.warning : P.danger
            ),
            borderWidth: 1, borderRadius: 4, borderSkipped: false
          },
          {
            label: 'First Audio (ms)',
            data: evals.map(e => e.firstAudioMs),
            backgroundColor: P.alpha(P.info, 0.55),
            borderColor: P.info,
            borderWidth: 1, borderRadius: 4, borderSkipped: false
          }
        ]
      },
      options: {
        responsive: true, maintainAspectRatio: false,
        interaction: { mode: 'index', intersect: false },
        plugins: {
          legend: { position: 'top', align: 'end', labels: { boxWidth: 10, padding: 10, font: { size: 11 }, color: MUTED() } }
        },
        scales: {
          x: { grid: { display: false }, ticks: tickOpts({ font: { size: 11 } }) },
          y: {
            grid: gridOpts(), ticks: tickOpts(), beginAtZero: true,
            title: { display: true, text: 'Latency (ms)', color: MUTED(), font: { size: 11 } }
          }
        }
      }
    });
  }

  /* ══════════════════════════════════════════════════════════════
     5. GRADE DISTRIBUTION — Doughnut
  ══════════════════════════════════════════════════════════════ */
  const gradesEl = document.getElementById('chartGrades');
  if (gradesEl) {
    const gradeColors = { 'A': P.success, 'B': P.warning, 'C': P.orange, 'Fail': P.danger };
    const gradeCounts = evals.reduce((acc, e) => { acc[e.grade] = (acc[e.grade] || 0) + 1; return acc; }, {});

    new Chart(gradesEl, {
      type: 'doughnut',
      data: {
        labels: Object.keys(gradeCounts),
        datasets: [{
          data: Object.values(gradeCounts),
          backgroundColor: Object.keys(gradeCounts).map(g => gradeColors[g] || P.info),
          borderWidth: 2, borderColor: PANEL(), hoverOffset: 10
        }]
      },
      options: {
        responsive: true, maintainAspectRatio: false, cutout: '65%',
        plugins: {
          legend: { position: 'bottom', labels: { padding: 12, font: { size: 11 }, color: MUTED() } },
          tooltip: { callbacks: { label: ctx => ` Grade ${ctx.label}: ${ctx.raw} model${ctx.raw !== 1 ? 's' : ''}` } }
        }
      }
    });
  }

  /* ══════════════════════════════════════════════════════════════
     6. MOS IMPROVEMENT OVER VERSIONS — Multi-series Line
  ══════════════════════════════════════════════════════════════ */
  const mosVerEl = document.getElementById('chartMOSVersions');
  if (mosVerEl) {
    const mv = SEED.mosVersions;

    new Chart(mosVerEl, {
      type: 'line',
      data: {
        labels: mv.labels,
        datasets: [
          {
            label: 'English',
            data: mv.english,
            borderColor: P.success, backgroundColor: P.alpha(P.success, 0.09),
            borderWidth: 2.5, pointRadius: 4, pointHoverRadius: 6,
            fill: true, tension: 0.35, spanGaps: true
          },
          {
            label: 'Hindi',
            data: mv.hindi,
            borderColor: P.primary, backgroundColor: P.alpha(P.primary, 0.07),
            borderWidth: 2.5, pointRadius: 4, pointHoverRadius: 6,
            fill: true, tension: 0.35, spanGaps: true, borderDash: [5, 3]
          },
          {
            label: 'Tamil',
            data: mv.tamil,
            borderColor: P.warning, backgroundColor: P.alpha(P.warning, 0.07),
            borderWidth: 2.5, pointRadius: 4, pointHoverRadius: 6,
            fill: true, tension: 0.35, spanGaps: true, borderDash: [3, 3]
          }
        ]
      },
      options: {
        responsive: true, maintainAspectRatio: false,
        interaction: { mode: 'index', intersect: false },
        plugins: {
          legend: { position: 'top', align: 'end', labels: { boxWidth: 12, padding: 12, font: { size: 11 }, color: MUTED() } },
          tooltip: { callbacks: { label: ctx => ctx.parsed.y != null ? ` ${ctx.dataset.label}: ${ctx.parsed.y.toFixed(2)}` : null } }
        },
        scales: {
          x: { grid: gridOpts(), ticks: tickOpts({ font: { size: 11 } }) },
          y: {
            grid: gridOpts(), ticks: tickOpts(),
            min: 2.5, max: 5.0,
            title: { display: true, text: 'MOS', color: MUTED(), font: { size: 11 } }
          }
        }
      }
    });
  }

  /* ══════════════════════════════════════════════════════════════
     7. DATATABLES — EVALUATIONS TABLE
  ══════════════════════════════════════════════════════════════ */
  function gradeBadge(g) {
    const map = { 'A': 'ev-badge-a', 'B': 'ev-badge-b', 'C': 'ev-badge-c', 'Fail': 'ev-badge-fail' };
    return `<span class="ev-tbl-badge ${map[g] || 'ev-badge-b'}">${g}</span>`;
  }

  function statusBadge(s) {
    const map   = { approved: 'ev-badge-pass', pending: 'ev-badge-pending', needs_review: 'ev-badge-review', rejected: 'ev-badge-fail' };
    const icons = { approved: '✓', pending: '⏳', needs_review: '⚠', rejected: '✗' };
    const label = s.replace(/_/g, ' ');
    return `<span class="ev-tbl-badge ${map[s] || 'ev-badge-pending'}">${icons[s] || ''} ${label}</span>`;
  }

  function mosCell(v) {
    const col = v >= 4.0 ? '#22c55e' : v >= 3.3 ? '#f59e0b' : '#ef4444';
    return `<span style="color:${col};font-weight:700;font-variant-numeric:tabular-nums">${v.toFixed(2)}</span>`;
  }

  function pctCell(v, goodMax, warnMax) {
    const pct = +(v * 100).toFixed(1);
    const col = pct <= goodMax ? '#22c55e' : pct <= warnMax ? '#f59e0b' : '#ef4444';
    return `<span style="color:${col};font-weight:600;font-variant-numeric:tabular-nums">${pct}%</span>`;
  }

  function simCell(v) {
    const col = v >= 0.85 ? '#22c55e' : v >= 0.75 ? '#f59e0b' : '#ef4444';
    return `<span style="color:${col};font-weight:600;font-variant-numeric:tabular-nums">${v.toFixed(2)}</span>`;
  }

  function latCell(v, goodMax, warnMax) {
    const col = v <= goodMax ? '#22c55e' : v <= warnMax ? '#f59e0b' : '#ef4444';
    return `<span style="color:${col};font-weight:600;font-variant-numeric:tabular-nums">${v}</span>`;
  }

  function scoreBar(v, max) {
    const pct = Math.round((v / max) * 100);
    const col = pct >= 80 ? '#22c55e' : pct >= 65 ? '#f59e0b' : '#ef4444';
    return `<div class="ev-score-cell">
      <div class="ev-score-track"><div class="ev-score-fill" style="width:${pct}%;background:${col}"></div></div>
      <span class="ev-score-label">${v.toFixed(1)}</span>
    </div>`;
  }

  const tbody = document.getElementById('evalTableBody');
  if (tbody) {
    tbody.innerHTML = evals.map(e => `
      <tr>
        <td><code class="ev-job-id">${e.id}</code></td>
        <td class="ev-model-cell">${e.modelVersion}</td>
        <td><span class="ev-lang-pill">${e.langCode.toUpperCase()}</span></td>
        <td style="text-align:right">${mosCell(e.mos)}</td>
        <td style="text-align:right">${pctCell(e.wer, 6, 10)}</td>
        <td style="text-align:right">${pctCell(e.cer, 3, 6)}</td>
        <td style="text-align:right">${simCell(e.speakerSim)}</td>
        <td style="text-align:right">${latCell(e.latencyMs, 400, 700)} ms</td>
        <td style="text-align:right">${latCell(e.firstAudioMs, 150, 250)} ms</td>
        <td>${scoreBar(e.pronunciation, 5)}</td>
        <td>${scoreBar(e.naturalness, 5)}</td>
        <td>${gradeBadge(e.grade)}</td>
        <td>${statusBadge(e.status)}</td>
      </tr>
    `).join('');
  }

  if ($.fn.DataTable) {
    $('#tblEval').DataTable({
      pageLength : 8,
      lengthMenu : [8, 10, 25],
      order      : [[3, 'desc']],
      language   : {
        search: '', searchPlaceholder: 'Search evaluations…',
        lengthMenu: 'Show _MENU_', info: '_START_–_END_ of _TOTAL_',
        paginate: { previous: '‹', next: '›' }
      },
      columnDefs: [
        { targets: [3, 4, 5, 6, 7, 8], className: 'dt-right' },
        { targets: [9, 10, 11, 12], orderable: false }
      ]
    });
  }

}); // end window.addEventListener('load', ...)