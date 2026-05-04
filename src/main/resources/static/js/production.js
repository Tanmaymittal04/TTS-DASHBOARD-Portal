/* ═══════════════════════════════════════════════════════════════
   production.js — TTS Production Monitor
   Fix: wrapped in window 'load' event so Chart.js is guaranteed
   to be available before any chart initialisation runs.
═══════════════════════════════════════════════════════════════ */
window.addEventListener('load', function () {
  'use strict';

  /* ── CHART.JS DARK DEFAULTS ─────────────────────────────── */
  Chart.defaults.color        = '#6e7681';
  Chart.defaults.borderColor  = '#21262d';
  Chart.defaults.font.family  = "'Inter',-apple-system,sans-serif";
  Chart.defaults.font.size    = 11;

  const C = {
    purple : '#6366f1',
    green  : '#3fb950',
    red    : '#f85149',
    blue   : '#58a6ff',
    violet : '#bc8cff',
    orange : '#f0883e',
    yellow : '#d29922',
    pink   : '#db61a2',
    gray   : '#484f58',
  };

  /* ── SEED DATA ───────────────────────────────────────────── */
  const HOURS = Array.from({ length: 24 }, (_, i) =>
    `${String(i).padStart(2, '0')}:00`
  );

  const success = [2800,2400,1900,1600,1400,1800,2600,3400,4200,4800,
                   5100,5400,5600,5300,5100,5400,5700,5900,5500,5000,
                   4600,4100,3500,2950];
  const failed  = [82,66,55,48,38,52,76,95,118,130,142,148,
                   155,145,140,150,162,168,155,140,128,115,98,82];
  const latency = [310,295,280,270,265,285,312,335,348,362,371,365,
                   358,370,360,355,368,375,362,345,338,328,315,305];
  const p95     = latency.map(v => Math.round(v * 1.55 + 10));
  const p99     = latency.map(v => Math.round(v * 2.10 + 20));

  /* ── HELPERS ─────────────────────────────────────────────── */
  const $ = id => document.getElementById(id);
  const qsa = sel => document.querySelectorAll(sel);

  function fmtK(n)    { return n >= 1000 ? (n / 1000).toFixed(1) + 'k' : String(n); }
  function rateClr(r) { return r >= 98 ? C.green : r >= 95 ? C.yellow : C.red; }

  function hexRgba(hex, alpha) {
    const r = parseInt(hex.slice(1,3),16);
    const g = parseInt(hex.slice(3,5),16);
    const b = parseInt(hex.slice(5,7),16);
    return `rgba(${r},${g},${b},${alpha})`;
  }

  /* ── SAFETY CHECKS ───────────────────────────────────────── */
  const requiredCanvasIds = [
    'sparkTotalReqs',
    'sparkFailed',
    'chartRequestVolume',
    'chartProdLatency',
    'chartVoiceUsage',
    'chartSuccessRate',
    'chartReqByLang',
    'chartErrorBreakdown',
    'chartPercentileLatency'
  ];

  const missing = requiredCanvasIds.filter(id => !$(id));
  if (missing.length) {
    console.error('Missing chart canvas elements:', missing);
    return;
  }

  /* ── SPARKLINES ──────────────────────────────────────────── */
  function sparkline(id, data, color) {
    const el = $(id);
    if (!el) return;

    new Chart(el, {
      type : 'line',
      data : {
        labels   : data.map((_, i) => i),
        datasets : [{
          data            : data,
          borderColor     : color,
          borderWidth     : 1.5,
          pointRadius     : 0,
          tension         : 0.4,
          fill            : true,
          backgroundColor : hexRgba(color, 0.10)
        }]
      },
      options : {
        responsive           : true,
        maintainAspectRatio  : false,
        animation            : false,
        plugins : {
          legend: { display: false },
          tooltip: { enabled: false }
        },
        scales  : {
          x: { display: false },
          y: { display: false }
        }
      }
    });
  }

  sparkline(
    'sparkTotalReqs',
    success.slice(12).map((v, i) => v + failed[i + 12]),
    C.purple
  );
  sparkline('sparkFailed', failed.slice(12), C.red);

  /* ── 1. REQUEST VOLUME ───────────────────────────────────── */
  new Chart($('chartRequestVolume'), {
    type : 'bar',
    data : {
      labels   : HOURS,
      datasets : [
        {
          label           : 'Success',
          data            : success,
          backgroundColor : 'rgba(63,185,80,0.75)',
          borderRadius    : 2,
          stack           : 'v'
        },
        {
          label           : 'Failed',
          data            : failed,
          backgroundColor : 'rgba(248,81,73,0.75)',
          borderRadius    : 2,
          stack           : 'v'
        }
      ]
    },
    options : {
      responsive          : true,
      maintainAspectRatio : false,
      plugins : {
        legend  : {
          position: 'top',
          labels: { boxWidth: 10, padding: 10 }
        },
        tooltip : {
          mode: 'index',
          callbacks: {
            afterBody: items => {
              const i = items[0].dataIndex;
              const t = success[i] + failed[i];
              return [`  Rate: ${((success[i] / t) * 100).toFixed(1)}%`];
            }
          }
        }
      },
      scales : {
        x : {
          grid: { display: false },
          ticks: { maxTicksLimit: 12 }
        },
        y : {
          grid: { color: '#161b22' },
          stacked: true,
          ticks: { callback: v => fmtK(v) }
        }
      }
    }
  });

  /* ── 2. AVG LATENCY TREND ────────────────────────────────── */
  const latencyChartOptions = {
    responsive          : true,
    maintainAspectRatio : false,
    plugins : {
      legend : { display: false }
    },
    scales : {
      x : {
        grid: { display: false },
        ticks: { maxTicksLimit: 12 }
      },
      y : {
        min: 200,
        grid: { color: '#161b22' },
        ticks: { callback: v => v + 'ms' }
      }
    }
  };

  if (window.ChartAnnotation || (window['chartjs-plugin-annotation'])) {
    latencyChartOptions.plugins.annotation = {
      annotations : {
        sla : {
          type        : 'line',
          yMin        : 800,
          yMax        : 800,
          borderColor : 'rgba(248,81,73,0.50)',
          borderWidth : 1,
          borderDash  : [5, 4],
          label       : {
            content  : 'SLA 800ms',
            display  : true,
            color    : C.red,
            font     : { size: 10 },
            position : 'end',
            padding  : 4
          }
        }
      }
    };
  }

  new Chart($('chartProdLatency'), {
    type : 'line',
    data : {
      labels   : HOURS,
      datasets : [{
        label            : 'Avg Latency',
        data             : latency,
        borderColor      : C.blue,
        backgroundColor  : hexRgba(C.blue, 0.07),
        borderWidth      : 2,
        pointRadius      : 2,
        pointHoverRadius : 5,
        tension          : 0.4,
        fill             : true
      }]
    },
    options : latencyChartOptions
  });

  /* ── 3. TOP VOICES ───────────────────────────────────────── */
  new Chart($('chartVoiceUsage'), {
    type : 'bar',
    data : {
      labels   : [
        'Riya (hi-IN)',
        'Arjun (ta-IN)',
        'Priya (te-IN)',
        'Suresh (kn-IN)',
        'Deepa (bn-IN)',
        'Meera (mr-IN)'
      ],
      datasets : [{
        label           : 'Requests',
        data            : [18400, 14200, 11800, 9600, 7300, 5200],
        backgroundColor : [C.purple, C.blue, C.green, C.orange, C.violet, C.pink],
        borderRadius    : 3,
        borderWidth     : 0
      }]
    },
    options : {
      indexAxis           : 'y',
      responsive          : true,
      maintainAspectRatio : false,
      plugins : {
        legend : { display: false },
        tooltip : {
          callbacks: {
            label: ctx => ` ${ctx.raw.toLocaleString()} req`
          }
        }
      },
      scales : {
        x : {
          grid: { color: '#161b22' },
          ticks: { callback: v => fmtK(v) }
        },
        y : {
          grid: { display: false },
          ticks: { font: { size: 11 } }
        }
      }
    }
  });

  /* ── 4. SUCCESS vs FAILED ────────────────────────────────── */
  new Chart($('chartSuccessRate'), {
    type : 'doughnut',
    data : {
      labels   : ['Success (97.3%)', 'Failed (2.7%)'],
      datasets : [{
        data             : [97.3, 2.7],
        backgroundColor  : ['rgba(63,185,80,0.80)', 'rgba(248,81,73,0.80)'],
        borderColor      : '#0d1117',
        borderWidth      : 3,
        hoverBorderWidth : 0
      }]
    },
    options : {
      cutout              : '70%',
      responsive          : true,
      maintainAspectRatio : false,
      plugins : {
        legend : {
          position: 'bottom',
          labels: { boxWidth: 10, padding: 10 }
        },
        tooltip : {
          callbacks: {
            label: ctx => ` ${ctx.raw}%`
          }
        }
      }
    }
  });

  /* ── 5. REQUESTS BY LANGUAGE ─────────────────────────────── */
  new Chart($('chartReqByLang'), {
    type : 'pie',
    data : {
      labels   : ['Hindi', 'Tamil', 'Telugu', 'Kannada', 'Bengali', 'Marathi', 'Others'],
      datasets : [{
        data            : [31, 23, 18, 11, 8, 5, 4],
        backgroundColor : [C.purple, C.blue, C.green, C.orange, C.violet, C.pink, C.gray],
        borderColor     : '#0d1117',
        borderWidth     : 2
      }]
    },
    options : {
      responsive          : true,
      maintainAspectRatio : false,
      plugins : {
        legend : {
          position: 'bottom',
          labels: { boxWidth: 10, padding: 8, font: { size: 10 } }
        },
        tooltip : {
          callbacks: {
            label: ctx => ` ${ctx.label}: ${ctx.raw}%`
          }
        }
      }
    }
  });

  /* ── 6. ERROR BREAKDOWN ──────────────────────────────────── */
  new Chart($('chartErrorBreakdown'), {
    type : 'bar',
    data : {
      labels   : ['Timeout', 'Model Error', 'Invalid Input', 'Rate Limit', 'Network', 'Auth Fail'],
      datasets : [{
        label           : 'Count',
        data            : [820, 542, 398, 287, 165, 62],
        backgroundColor : hexRgba(C.red, 0.70),
        borderColor     : C.red,
        borderWidth     : 1,
        borderRadius    : 3
      }]
    },
    options : {
      responsive          : true,
      maintainAspectRatio : false,
      plugins : {
        legend: { display: false }
      },
      scales  : {
        x : { grid: { display: false } },
        y : { grid: { color: '#161b22' } }
      }
    }
  });

  /* ── 7. P95 / P99 LATENCY ────────────────────────────────── */
  new Chart($('chartPercentileLatency'), {
    type : 'line',
    data : {
      labels   : HOURS,
      datasets : [
        {
          label: 'Avg',
          data: latency,
          borderColor: C.blue,
          borderWidth: 1.5,
          pointRadius: 0,
          tension: 0.4
        },
        {
          label: 'P95',
          data: p95,
          borderColor: C.orange,
          borderWidth: 1.5,
          pointRadius: 0,
          tension: 0.4,
          borderDash: [4, 3]
        },
        {
          label: 'P99',
          data: p99,
          borderColor: C.red,
          borderWidth: 1.5,
          pointRadius: 0,
          tension: 0.4,
          borderDash: [2, 3]
        }
      ]
    },
    options : {
      responsive          : true,
      maintainAspectRatio : false,
      plugins : {
        legend : {
          position: 'top',
          labels: { boxWidth: 10, padding: 10 }
        }
      },
      scales : {
        x : {
          grid: { display: false },
          ticks: { maxTicksLimit: 12 }
        },
        y : {
          grid: { color: '#161b22' },
          ticks: { callback: v => v + 'ms' }
        }
      }
    }
  });

  /* ── TABLE DATA ──────────────────────────────────────────── */
  const tableData = HOURS.map((h, i) => {
    const s = success[i], f = failed[i], t = s + f;
    return {
      hour    : h,
      total   : t,
      success : s,
      failed  : f,
      rate    : parseFloat(((s / t) * 100).toFixed(1)),
      lat     : latency[i]
    };
  });

  let sortCol = -1, sortDir = 1, filterText = '', page = 0;
  const PAGE_SIZE = 12;

  function renderPagination(pages) {
    const el = $('tblPagination');
    if (!el) return;

    el.innerHTML = Array.from({ length: pages }, (_, i) =>
      `<button class="prod-pg-btn${i === page ? ' active' : ''}" data-page="${i}">${i + 1}</button>`
    ).join('');

    el.querySelectorAll('.prod-pg-btn').forEach(btn =>
      btn.addEventListener('click', () => {
        page = +btn.dataset.page;
        renderTable();
      })
    );
  }

  function renderTable() {
    const ft = filterText.toLowerCase();
    let rows = tableData.filter(r =>
      r.hour.includes(ft) ||
      String(r.total).includes(ft) ||
      String(r.rate).includes(ft)
    );

    if (sortCol >= 0) {
      const keys = ['hour', 'total', 'success', 'failed', 'rate', 'lat'];
      const k = keys[sortCol];
      rows.sort((a, b) => sortDir * (a[k] > b[k] ? 1 : a[k] < b[k] ? -1 : 0));
    }

    const total = rows.length;
    const pageRows = rows.slice(page * PAGE_SIZE, (page + 1) * PAGE_SIZE);

    $('productionTableBody').innerHTML = pageRows.map(r => {
      const rc = rateClr(r.rate);
      const latClass = r.lat < 350 ? 't-grn' : r.lat < 600 ? 't-yel' : 't-red';
      const badge = r.rate >= 97
        ? '<span class="tbl-badge tbl-badge-g">Healthy</span>'
        : r.rate >= 90
          ? '<span class="tbl-badge tbl-badge-y">Degraded</span>'
          : '<span class="tbl-badge tbl-badge-r">Critical</span>';

      return `<tr>
        <td class="prod-td-mono t-mut">${r.hour}</td>
        <td>${r.total.toLocaleString('en-IN')}</td>
        <td class="prod-td-grn">${r.success.toLocaleString('en-IN')}</td>
        <td class="prod-td-red">${r.failed.toLocaleString('en-IN')}</td>
        <td>
          <div class="prod-rate-cell">
            <span style="color:${rc};font-weight:600;font-size:12px">${r.rate}%</span>
            <div class="prod-mini-bar">
              <div class="prod-mini-bar-fill" style="width:${r.rate}%;background:${rc}"></div>
            </div>
          </div>
        </td>
        <td class="${latClass} prod-td-mono">${r.lat}&thinsp;ms</td>
        <td>${badge}</td>
      </tr>`;
    }).join('');

    $('tblInfo').textContent = `Showing ${pageRows.length} of ${total} rows`;
    renderPagination(Math.ceil(total / PAGE_SIZE));
  }

  qsa('#tblProduction .sortable').forEach(th => {
    th.addEventListener('click', () => {
      const col = +th.dataset.col;
      sortDir = sortCol === col ? -sortDir : 1;
      sortCol = col;
      page = 0;

      qsa('#tblProduction .sortable').forEach(t =>
        t.classList.remove('sort-asc', 'sort-desc')
      );

      th.classList.add(sortDir === 1 ? 'sort-asc' : 'sort-desc');
      renderTable();
    });
  });

  const searchEl = $('tblSearchInput');
  if (searchEl) {
    searchEl.addEventListener('input', () => {
      filterText = searchEl.value.trim();
      page = 0;
      renderTable();
    });
  }

  renderTable();

  /* ── LIVE CLOCK ──────────────────────────────────────────── */
  function updateClock() {
    const el = $('lastUpdated');
    if (!el) return;

    const now = new Date();
    const d = now.toLocaleDateString('en-IN', {
      day: '2-digit',
      month: 'short',
      year: 'numeric'
    });
    const t = now.toLocaleTimeString('en-IN', { hour12: false });

    el.textContent = `Updated: ${d}, ${t}`;
  }

  updateClock();
  setInterval(updateClock, 1000);

  /* ── AUTO REFRESH ────────────────────────────────────────── */
  let refreshTimer = null;
  const refreshSel = $('refreshInterval');

  function setupRefresh() {
    clearInterval(refreshTimer);
    if (!refreshSel) return;

    const secs = +refreshSel.value;
    if (secs > 0) {
      refreshTimer = setInterval(() => location.reload(), secs * 1000);
    }
  }

  if (refreshSel) {
    refreshSel.addEventListener('change', setupRefresh);
    setupRefresh();
  }

  /* ── CSV EXPORT ──────────────────────────────────────────── */
  function exportCSV(data, filename) {
    const hdr = 'Hour,Total,Success,Failed,Success Rate,Avg Latency\n';
    const body = data.map(r =>
      `${r.hour},${r.total},${r.success},${r.failed},${r.rate}%,${r.lat}ms`
    ).join('\n');

    const blob = new Blob([hdr + body], { type: 'text/csv' });
    const a = Object.assign(document.createElement('a'), {
      href: URL.createObjectURL(blob),
      download: filename
    });

    a.click();
    URL.revokeObjectURL(a.href);
  }

  const btnExport = $('btnExport');
  const btnDownload = $('btnDownloadTable');

  if (btnExport) {
    btnExport.addEventListener('click', () => exportCSV(tableData, 'production_24h.csv'));
  }

  if (btnDownload) {
    btnDownload.addEventListener('click', () => exportCSV(tableData, 'production_table.csv'));
  }
});