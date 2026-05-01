/* ═══════════════════════════════════════════════════════════════
   deployment.js — Model Deployment Dashboard
   Status, uptime, latency heatmap, region distribution + DataTable
════════════════════════════════════════════════════════════════ */

(function () {
  'use strict';

  const MUTED  = '#8888aa';
  const BORDER = 'rgba(255,255,255,0.07)';

  const P = {
    primary : '#6366f1',
    success : '#22c55e',
    warning : '#f59e0b',
    danger  : '#ef4444',
    info    : '#06b6d4',
    purple  : '#a855f7',
    alpha   : (hex, a) => hex + Math.round(a * 255).toString(16).padStart(2, '0')
  };

  function gridOpts() { return { color: BORDER, drawBorder: false }; }
  function tickOpts() { return { color: MUTED, maxRotation: 0 }; }

  /* ── 1. DEPLOYMENT STATUS DOUGHNUT ─────────────────────────── */
  const depStatus = SEED.deployments.reduce((acc, d) => {
    acc[d.status] = (acc[d.status] || 0) + 1;
    return acc;
  }, {});

  const depStatusColors = {
    live      : P.success,
    staging   : P.info,
    deprecated: P.warning,
    offline   : P.danger
  };

  new Chart(document.getElementById('chartDepStatus'), {
    type: 'doughnut',
    data: {
      labels: Object.keys(depStatus).map(s =>
        s.charAt(0).toUpperCase() + s.slice(1)
      ),
      datasets: [{
        data           : Object.values(depStatus),
        backgroundColor: Object.keys(depStatus).map(
          s => depStatusColors[s] || P.primary
        ),
        borderWidth : 2,
        borderColor : '#16161d',
        hoverOffset : 6
      }]
    },
    options: {
      responsive         : true,
      maintainAspectRatio: false,
      cutout             : '68%',
      plugins            : {
        legend: {
          position: 'right',
          labels  : { padding: 12, font: { size: 11 } }
        }
      }
    }
  });

  /* ── 2. UPTIME % BAR ────────────────────────────────────────── */
  const liveDeployments = SEED.deployments.filter(d => d.status === 'live');

  new Chart(document.getElementById('chartUptime'), {
    type: 'bar',
    data: {
      labels: liveDeployments.map(d => d.modelVersion),
      datasets: [{
        label          : 'Uptime %',
        data           : liveDeployments.map(d => d.uptimePct),
        backgroundColor: liveDeployments.map(d =>
          P.alpha(d.uptimePct >= 99.5 ? P.success : d.uptimePct >= 98 ? P.warning : P.danger, 0.72)
        ),
        borderColor: liveDeployments.map(d =>
          d.uptimePct >= 99.5 ? P.success : d.uptimePct >= 98 ? P.warning : P.danger
        ),
        borderWidth : 1,
        borderRadius: 4
      }]
    },
    options: {
      indexAxis          : 'y',
      responsive         : true,
      maintainAspectRatio: false,
      plugins: {
        legend: { display: false },
        tooltip: {
          callbacks: {
            label: ctx => ` Uptime: ${ctx.parsed.x.toFixed(2)}%`
          }
        }
      },
      scales: {
        x: {
          grid: gridOpts(), ticks: tickOpts(),
          min  : 96, max: 100,
          title: { display: true, text: 'Uptime %', color: MUTED, font: { size: 11 } }
        },
        y: { grid: { display: false }, ticks: { ...tickOpts(), font: { size: 10 } } }
      }
    }
  });

  /* ── 3. REGION DISTRIBUTION PIE ────────────────────────────── */
  const regionCounts = SEED.deployments.reduce((acc, d) => {
    acc[d.region] = (acc[d.region] || 0) + 1;
    return acc;
  }, {});

  const regionPalette = [P.primary, P.info, P.success, P.purple, P.warning, P.danger];

  new Chart(document.getElementById('chartRegionDist'), {
    type: 'pie',
    data: {
      labels: Object.keys(regionCounts),
      datasets: [{
        data           : Object.values(regionCounts),
        backgroundColor: regionPalette.slice(0, Object.keys(regionCounts).length),
        borderWidth    : 2,
        borderColor    : '#16161d',
        hoverOffset    : 6
      }]
    },
    options: {
      responsive         : true,
      maintainAspectRatio: false,
      plugins            : {
        legend: {
          position: 'right',
          labels  : { padding: 10, font: { size: 11 } }
        }
      }
    }
  });

  /* ── 4. P50 / P95 / P99 LATENCY GROUPED BAR ────────────────── */
  const liveLabels = liveDeployments.map(d => d.modelVersion);

  new Chart(document.getElementById('chartLatencyPercentiles'), {
    type: 'bar',
    data: {
      labels: liveLabels,
      datasets: [
        {
          label          : 'P50 (ms)',
          data           : liveDeployments.map(d => d.latencyP50),
          backgroundColor: P.alpha(P.success, 0.72),
          borderColor    : P.success,
          borderWidth    : 1,
          borderRadius   : 3
        },
        {
          label          : 'P95 (ms)',
          data           : liveDeployments.map(d => d.latencyP95),
          backgroundColor: P.alpha(P.warning, 0.72),
          borderColor    : P.warning,
          borderWidth    : 1,
          borderRadius   : 3
        },
        {
          label          : 'P99 (ms)',
          data           : liveDeployments.map(d => d.latencyP99),
          backgroundColor: P.alpha(P.danger, 0.72),
          borderColor    : P.danger,
          borderWidth    : 1,
          borderRadius   : 3
        }
      ]
    },
    options: {
      responsive         : true,
      maintainAspectRatio: false,
      interaction        : { mode: 'index', intersect: false },
      plugins: {
        legend: {
          position: 'top',
          align   : 'end',
          labels  : { boxWidth: 10, padding: 10, font: { size: 11 } }
        }
      },
      scales: {
        x: { grid: gridOpts(), ticks: { ...tickOpts(), font: { size: 10 } } },
        y: {
          grid: gridOpts(), ticks: tickOpts(),
          beginAtZero: true,
          title: { display: true, text: 'Latency (ms)', color: MUTED, font: { size: 11 } }
        }
      }
    }
  });

  /* ── 5. REQUESTS/DAY TREND LINE ─────────────────────────────── */
  /* Use the first live deployment's weekly traffic if available */
  const trendDep = liveDeployments[0];
  if (trendDep && trendDep.dailyRequests) {
    new Chart(document.getElementById('chartReqTrend'), {
      type: 'line',
      data: {
        labels: trendDep.dailyRequests.map((_, i) => `Day ${i + 1}`),
        datasets: [{
          label          : `${trendDep.modelVersion} — Req/Day`,
          data           : trendDep.dailyRequests,
          borderColor    : P.info,
          backgroundColor: P.alpha(P.info, 0.10),
          borderWidth    : 2,
          pointRadius    : 4,
          pointHoverRadius: 6,
          fill           : true,
          tension        : 0.4
        }]
      },
      options: {
        responsive         : true,
        maintainAspectRatio: false,
        plugins: {
          legend: { display: false },
          tooltip: {
            callbacks: {
              label: ctx =>
                ` Requests: ${ctx.parsed.y.toLocaleString()}`
            }
          }
        },
        scales: {
          x: { grid: gridOpts(), ticks: tickOpts() },
          y: {
            grid: gridOpts(), ticks: tickOpts(),
            beginAtZero: false,
            title: { display: true, text: 'Requests', color: MUTED, font: { size: 11 } }
          }
        }
      }
    });
  }

  /* ── 6. DATATABLES — DEPLOYMENTS ────────────────────────────── */
  function statusBadge(s) {
    const map = {
      live      : 'approved',
      staging   : 'running',
      deprecated: 'pending',
      offline   : 'rejected'
    };
    return `<span class="badge-status badge-${map[s] || 'draft'}">${s}</span>`;
  }

  function latCell(v, warnAt, dangerAt) {
    const color = v <= warnAt ? 'var(--success)' :
                  v <= dangerAt ? 'var(--warning)' : 'var(--danger)';
    return `<span style="color:${color};font-weight:600">${v} ms</span>`;
  }

  const tbody = document.getElementById('deployTableBody');
  if (tbody) {
    tbody.innerHTML = SEED.deployments.map(d => `
      <tr>
        <td><code style="font-size:11px;color:var(--primary)">${d.id}</code></td>
        <td style="color:var(--text-muted)">${d.modelVersion}</td>
        <td>${d.langCode.toUpperCase()}</td>
        <td>
          <span class="badge-status badge-info">${d.region}</span>
        </td>
        <td>${statusBadge(d.status)}</td>
        <td style="text-align:right;font-weight:600;color:${
          d.uptimePct >= 99.5 ? 'var(--success)' :
          d.uptimePct >= 98   ? 'var(--warning)' : 'var(--danger)'
        }">${d.uptimePct.toFixed(2)}%</td>
        <td style="text-align:right">${latCell(d.latencyP50, 150, 250)}</td>
        <td style="text-align:right">${latCell(d.latencyP95, 300, 450)}</td>
        <td style="text-align:right">${latCell(d.latencyP99, 500, 700)}</td>
        <td style="text-align:right;color:var(--text-muted)">
          ${d.requestsToday ? d.requestsToday.toLocaleString() : '—'}
        </td>
        <td style="color:var(--text-muted);white-space:nowrap">${d.deployedAt}</td>
        <td style="color:var(--text-muted)">${d.deployedBy}</td>
      </tr>
    `).join('');
  }

  if (typeof $ !== 'undefined' && $.fn.DataTable) {
    $('#tblDeployments').DataTable({
      pageLength : 7,
      lengthMenu : [7, 10, 25],
      order      : [[4, 'asc']],
      language   : {
        search           : '',
        searchPlaceholder: 'Search deployments…',
        lengthMenu       : 'Show _MENU_',
        info             : '_START_–_END_ of _TOTAL_',
        paginate         : { previous: '‹', next: '›' }
      },
      columnDefs: [
        { targets: [5,6,7,8,9], className: 'dt-right' }
      ]
    });
  }

})();