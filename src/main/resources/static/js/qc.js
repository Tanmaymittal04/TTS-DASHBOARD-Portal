// =============================================================
//  qc.js — QC & Data Quality  |  hardcoded seed data
//  Uses window 'load' so Chart.js + jQuery (loaded in base.jsp
//  AFTER <main>) are guaranteed available before any code runs.
// =============================================================

window.addEventListener('load', function () {
  'use strict';

  /* ── Guard: bail out if Chart.js didn't load ─────────────── */
  if (typeof Chart === 'undefined') {
    console.error('[qc.js] Chart.js is not loaded. Check base.jsp script order.');
    return;
  }

  /* ── Theme helpers ─────────────────────────────────────────── */
  function theme() {
    return (document.documentElement.getAttribute('data-theme') || 'dark') === 'dark'
      ? {
          grid   : 'rgba(255,255,255,0.055)',
          tick   : '#6b7280',
          ttBg   : '#1a1d27',
          ttBorder: 'rgba(255,255,255,0.10)',
          ttText : '#d8dae0',
        }
      : {
          grid   : 'rgba(0,0,0,0.06)',
          tick   : '#6b7280',
          ttBg   : '#ffffff',
          ttBorder: 'rgba(0,0,0,0.10)',
          ttText : '#1a1d2e',
        };
  }

  function ttDefaults() {
    const th = theme();
    return {
      backgroundColor : th.ttBg,
      borderColor     : th.ttBorder,
      borderWidth     : 1,
      titleColor      : th.ttText,
      bodyColor       : th.ttText,
      padding         : 10,
      cornerRadius    : 6,
    };
  }

  function scaleDefaults() {
    const th = theme();
    return {
      x: { grid: { color: th.grid, drawBorder: false }, ticks: { color: th.tick, font: { size: 11 } } },
      y: { grid: { color: th.grid, drawBorder: false }, ticks: { color: th.tick, font: { size: 11 } } },
    };
  }

  /* ── Colour palette ─────────────────────────────────────── */
  const C = {
    indigo: '#6366f1', green: '#22c55e', red: '#ef4444', amber: '#f59e0b',
    cyan: '#06b6d4', violet: '#a855f7', orange: '#f97316',
    teal: '#14b8a6', pink: '#ec4899', lime: '#84cc16',
  };

  /* ── Chart.js globals ───────────────────────────────────── */
  Chart.defaults.font.family = "'Inter', system-ui, sans-serif";
  Chart.defaults.font.size   = 12;
  Chart.defaults.animation   = { duration: 600, easing: 'easeOutQuart' };

  /* ══════════════════════════════════════════════════════════
     1. QC STATUS — DOUGHNUT
  ═══════════════════════════════════════════════════════════ */
  new Chart(document.getElementById('chartQCStatus'), {
    type: 'doughnut',
    data: {
      labels: ['QC Pass', 'QC Fail', 'Under Review'],
      datasets: [{
        data            : [61400, 5821, 1240],
        backgroundColor : [C.green, C.red, C.amber],
        hoverBackgroundColor: ['#4ade80', '#f87171', '#fbbf24'],
        borderWidth     : 0,
        hoverOffset     : 10,
      }]
    },
    options: {
      responsive: true, maintainAspectRatio: false, cutout: '70%',
      plugins: {
        legend: {
          position: 'bottom',
          labels: { color: theme().tick, padding: 18, boxWidth: 11, boxHeight: 11,
                    usePointStyle: true, pointStyle: 'rectRounded', font: { size: 11.5 } }
        },
        tooltip: {
          ...ttDefaults(),
          callbacks: {
            label(ctx) {
              const total = ctx.dataset.data.reduce((a, b) => a + b, 0);
              return `  ${ctx.label}: ${ctx.parsed.toLocaleString()} (${((ctx.parsed/total)*100).toFixed(1)}%)`;
            }
          }
        }
      }
    }
  });

  /* ══════════════════════════════════════════════════════════
     2. QUALITY SCORE DISTRIBUTION — BAR
  ═══════════════════════════════════════════════════════════ */
  new Chart(document.getElementById('chartQualityDist'), {
    type: 'bar',
    data: {
      labels: ['0–10','10–20','20–30','30–40','40–50','50–60','60–70','70–80','80–90','90–100'],
      datasets: [{
        label: 'Clips',
        data : [120, 210, 380, 720, 1850, 4100, 9800, 22400, 19600, 9280],
        backgroundColor: [
          'rgba(239,68,68,0.82)','rgba(239,68,68,0.72)','rgba(239,68,68,0.62)',
          'rgba(245,158,11,0.72)','rgba(245,158,11,0.82)',
          'rgba(6,182,212,0.68)','rgba(6,182,212,0.78)',
          'rgba(34,197,94,0.72)','rgba(34,197,94,0.84)','rgba(34,197,94,0.96)',
        ],
        borderRadius: 5, borderSkipped: false,
        hoverBackgroundColor: 'rgba(255,255,255,0.15)',
      }]
    },
    options: {
      responsive: true, maintainAspectRatio: false,
      plugins: {
        legend: { display: false },
        tooltip: { ...ttDefaults(), callbacks: { label: ctx => `  Clips: ${ctx.parsed.y.toLocaleString()}` } }
      },
      scales: {
        ...scaleDefaults(),
        y: { ...scaleDefaults().y, beginAtZero: true,
             ticks: { ...scaleDefaults().y.ticks, callback: v => v >= 1000 ? (v/1000).toFixed(0)+'k' : v } }
      }
    }
  });

  /* ══════════════════════════════════════════════════════════
     3. AVG NOISE SCORE BY LANGUAGE — BAR
  ═══════════════════════════════════════════════════════════ */
  const noiseLangs = ['Hindi','English','Tamil','Telugu','Bengali','Marathi','Gujarati','Kannada','Malayalam','Punjabi'];
  const noiseVals  = [0.18, 0.12, 0.22, 0.25, 0.31, 0.19, 0.28, 0.21, 0.17, 0.33];

  new Chart(document.getElementById('chartNoiseByLang'), {
    type: 'bar',
    data: {
      labels: noiseLangs,
      datasets: [{
        label: 'Noise Score',
        data : noiseVals,
        backgroundColor: noiseVals.map(v =>
          v < 0.20 ? 'rgba(34,197,94,0.80)'
          : v < 0.27 ? 'rgba(245,158,11,0.80)'
          : 'rgba(239,68,68,0.80)'),
        borderRadius: 5, borderSkipped: false,
      }]
    },
    options: {
      responsive: true, maintainAspectRatio: false,
      plugins: {
        legend: { display: false },
        tooltip: { ...ttDefaults(), callbacks: { label: ctx => `  Noise: ${ctx.parsed.y.toFixed(2)}` } }
      },
      scales: {
        ...scaleDefaults(),
        y: { ...scaleDefaults().y, min: 0, max: 0.40, beginAtZero: true,
             ticks: { ...scaleDefaults().y.ticks, callback: v => v.toFixed(2) } }
      }
    }
  });

  /* ══════════════════════════════════════════════════════════
     4. TOP REJECTION REASONS — HORIZONTAL BAR
  ═══════════════════════════════════════════════════════════ */
  new Chart(document.getElementById('chartRejectionReasons'), {
    type: 'bar',
    data: {
      labels: ['High Background Noise','Clipping / Distortion','Too Much Silence',
               'Incorrect Transcript','Low SNR','Speaker Mismatch','Short Duration','Reverb Detected'],
      datasets: [{
        label: 'Clips Rejected',
        data : [1820, 1340, 890, 640, 510, 330, 210, 81],
        backgroundColor: [C.red, C.orange, C.amber, C.violet, C.cyan, C.indigo, C.teal, C.pink],
        borderRadius: 5, borderSkipped: false,
      }]
    },
    options: {
      indexAxis: 'y', responsive: true, maintainAspectRatio: false,
      plugins: {
        legend: { display: false },
        tooltip: { ...ttDefaults(), callbacks: { label: ctx => `  ${ctx.parsed.x.toLocaleString()} rejected` } }
      },
      scales: {
        ...scaleDefaults(),
        x: { ...scaleDefaults().x, beginAtZero: true,
             ticks: { ...scaleDefaults().x.ticks, callback: v => v >= 1000 ? (v/1000)+'k' : v } },
        y: { ...scaleDefaults().y, grid: { display: false } }
      }
    }
  });

  /* ══════════════════════════════════════════════════════════
     5. ASR WER % BY LANGUAGE — BAR
  ═══════════════════════════════════════════════════════════ */
  const werLangs = ['Hindi','English','Tamil','Telugu','Bengali','Marathi','Gujarati','Kannada','Malayalam','Punjabi'];
  const werVals  = [8.2, 5.1, 12.4, 14.1, 11.3, 9.8, 13.5, 11.9, 10.4, 15.2];

  new Chart(document.getElementById('chartWERByLang'), {
    type: 'bar',
    data: {
      labels: werLangs,
      datasets: [{
        label: 'WER %',
        data : werVals,
        backgroundColor: werVals.map(v =>
          v < 9 ? 'rgba(34,197,94,0.82)'
          : v < 13 ? 'rgba(245,158,11,0.82)'
          : 'rgba(239,68,68,0.82)'),
        borderRadius: 5, borderSkipped: false,
      }]
    },
    options: {
      responsive: true, maintainAspectRatio: false,
      plugins: {
        legend: { display: false },
        tooltip: { ...ttDefaults(), callbacks: { label: ctx => `  WER: ${ctx.parsed.y}%` } }
      },
      scales: {
        ...scaleDefaults(),
        y: { ...scaleDefaults().y, beginAtZero: true, max: 20,
             ticks: { ...scaleDefaults().y.ticks, callback: v => v + '%' } }
      }
    }
  });

  /* ══════════════════════════════════════════════════════════
     6. QC PASS RATE TREND — LINE
  ═══════════════════════════════════════════════════════════ */
  new Chart(document.getElementById('chartQCWeeklyTrend'), {
    type: 'line',
    data: {
      labels: ['Wk 1','Wk 2','Wk 3','Wk 4','Wk 5','Wk 6','Wk 7','Wk 8'],
      datasets: [
        {
          label: 'Pass Rate %',
          data : [79.2, 80.6, 81.1, 80.8, 82.0, 83.4, 84.1, 87.4],
          borderColor: C.green, backgroundColor: 'rgba(34,197,94,0.10)',
          borderWidth: 2.5, pointBackgroundColor: C.green,
          pointRadius: 4, pointHoverRadius: 7, fill: true, tension: 0.4,
        },
        {
          label: 'Fail Rate %',
          data : [14.1, 12.8, 12.4, 12.9, 11.6, 10.2, 9.6, 8.4],
          borderColor: C.red, backgroundColor: 'rgba(239,68,68,0.06)',
          borderWidth: 2, pointBackgroundColor: C.red,
          pointRadius: 3, pointHoverRadius: 6,
          fill: true, tension: 0.4, borderDash: [6, 3],
        }
      ]
    },
    options: {
      responsive: true, maintainAspectRatio: false,
      interaction: { mode: 'index', intersect: false },
      plugins: {
        legend: {
          labels: { color: theme().tick, boxWidth: 11, usePointStyle: true,
                    pointStyle: 'circle', font: { size: 11.5 }, padding: 16 }
        },
        tooltip: { ...ttDefaults(), callbacks: { label: ctx => `  ${ctx.dataset.label}: ${ctx.parsed.y}%` } }
      },
      scales: {
        ...scaleDefaults(),
        y: { ...scaleDefaults().y, min: 0, max: 100,
             ticks: { ...scaleDefaults().y.ticks, callback: v => v + '%' } }
      }
    }
  });

  /* ══════════════════════════════════════════════════════════
     7. DATATABLE — Clip Records
  ═══════════════════════════════════════════════════════════ */
  const DATASETS  = ['Hindi-Studio-v2','English-Field-v1','Tamil-Noise-v3','Telugu-Web-v2','Bengali-Clean-v1'];
  const LANGS     = ['Hindi','English','Tamil','Telugu','Bengali'];
  const SPEAKERS  = ['SPK_001','SPK_002','SPK_003','SPK_004','SPK_005','SPK_006'];
  const REVIEWERS = ['Priya M.','Amit S.','Kavitha R.','Rohan D.','Neha T.'];
  const REASONS   = ['High Noise','Clipping','Too Quiet','Transcript Error','Short Clip',''];

  function rnd(a, b, dec) {
    const v = a + Math.random() * (b - a);
    return dec !== undefined ? +v.toFixed(dec) : Math.floor(v);
  }

  const rows = [];
  for (let i = 1; i <= 100; i++) {
    const quality = rnd(20, 100);
    const di = rnd(0, 5);
    let status, reason;
    if      (quality >= 75) { status = 'Pass';   reason = '—'; }
    else if (quality >= 60) { status = 'Review'; reason = '—'; }
    else                    { status = 'Fail';   reason = REASONS[rnd(0,5)]; }
    rows.push({
      id: 'CLIP_' + String(i).padStart(5, '0'),
      dataset: DATASETS[di], lang: LANGS[di],
      speaker: SPEAKERS[rnd(0,6)],
      duration: rnd(1.0, 12.0, 1), noise: rnd(0.05, 0.45, 2),
      silence: rnd(0.0, 0.30, 2), wer: rnd(2.0, 20.0, 1),
      quality, status, reason, reviewer: REVIEWERS[rnd(0,5)],
    });
  }

  const statusBadge = s => {
    const cls = { Pass:'badge-pass', Fail:'badge-fail', Review:'badge-review' }[s];
    return `<span class="qc-badge ${cls}">${s}</span>`;
  };

  const qualityBar = q => {
    const col = q >= 75 ? '#22c55e' : q >= 60 ? '#f59e0b' : '#ef4444';
    return `<div class="qbar-wrap">
      <div class="qbar-track"><div class="qbar-fill" style="width:${q}%;background:${col}"></div></div>
      <span class="qbar-label">${q}</span>
    </div>`;
  };

  const tbody = document.getElementById('clipTableBody');
  if (tbody) {
    rows.forEach(r => {
      const tr = document.createElement('tr');
      tr.innerHTML = `
        <td><code class="clip-id">${r.id}</code></td>
        <td>${r.dataset}</td>
        <td><span class="lang-pill">${r.lang}</span></td>
        <td>${r.speaker}</td>
        <td>${r.duration}s</td>
        <td>${r.noise}</td>
        <td>${r.silence}</td>
        <td>${r.wer}%</td>
        <td>${qualityBar(r.quality)}</td>
        <td>${statusBadge(r.status)}</td>
        <td>${r.reason}</td>
        <td>${r.reviewer}</td>`;
      tbody.appendChild(tr);
    });
  }

  if (typeof $ !== 'undefined' && $.fn && $.fn.DataTable) {
    $('#tblClips').DataTable({
      pageLength : 15,
      lengthMenu : [10, 15, 25, 50],
      order      : [[8, 'desc']],
      scrollX    : true,
      autoWidth  : false,
      language   : { search: 'Filter:', paginate: { next: '›', previous: '‹' } },
    });
  }

}); // end window.addEventListener('load')