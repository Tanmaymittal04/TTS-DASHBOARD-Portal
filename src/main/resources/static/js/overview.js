/* ═══════════════════════════════════════════════════════════════
   overview.js — Main Dashboard Overview Charts + DataTable
   Wires: dataset status doughnut, hours-by-lang bar,
          job status doughnut, MOS bar, recent activity table
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

  /* ── 1. DATASET STATUS DOUGHNUT ─────────────────────────────── */
  const dsStatus = SEED.datasets.reduce((acc, d) => {
    acc[d.status] = (acc[d.status] || 0) + 1;
    return acc;
  }, {});

  const dsStatusColorMap = {
    approved  : P.success,
    in_review : P.warning,
    draft     : P.info,
    rejected  : P.danger
  };

  new Chart(document.getElementById('chartOverviewDatasetStatus'), {
    type: 'doughnut',
    data: {
      labels: Object.keys(dsStatus).map(s =>
        s.replace(/_/g, ' ').replace(/\b\w/g, c => c.toUpperCase())
      ),
      datasets: [{
        data           : Object.values(dsStatus),
        backgroundColor: Object.keys(dsStatus).map(
          s => dsStatusColorMap[s] || P.purple
        ),
        borderWidth : 2,
        borderColor : '#16161d',
        hoverOffset : 6
      }]
    },
    options: {
      responsive         : true,
      maintainAspectRatio: false,
      cutout             : '65%',
      plugins: {
        legend: {
          position: 'right',
          labels  : { padding: 10, font: { size: 11 } }
        },
        tooltip: {
          callbacks: {
            label: ctx => ` ${ctx.label}: ${ctx.parsed} dataset(s)`
          }
        }
      }
    }
  });

  /* ── 2. AUDIO HOURS BY LANGUAGE ─────────────────────────────── */
  const hoursMap = {};
  SEED.datasets.forEach(d => {
    hoursMap[d.langCode] = (hoursMap[d.langCode] || 0) + d.totalHours;
  });
  const hoursSorted = Object.entries(hoursMap)
    .sort((a, b) => b[1] - a[1]);

  const langPalette = [
    P.primary, P.info, P.success, P.purple,
    P.warning, P.danger, '#ec4899', '#14b8a6'
  ];

  new Chart(document.getElementById('chartOverviewHoursByLang'), {
    type: 'bar',
    data: {
      labels: hoursSorted.map(([l]) => l.toUpperCase()),
      datasets: [{
        label          : 'Hours',
        data           : hoursSorted.map(([, h]) => +h.toFixed(1)),
        backgroundColor: hoursSorted.map((_, i) =>
          P.alpha(langPalette[i % langPalette.length], 0.75)
        ),
        borderColor    : hoursSorted.map((_, i) =>
          langPalette[i % langPalette.length]
        ),
        borderWidth : 1,
        borderRadius: 4
      }]
    },
    options: {
      responsive         : true,
      maintainAspectRatio: false,
      plugins            : { legend: { display: false } },
      scales: {
        x: { grid: gridOpts(), ticks: tickOpts() },
        y: {
          grid: gridOpts(), ticks: tickOpts(),
          beginAtZero: true,
          title: {
            display: true, text: 'Hours',
            color: MUTED, font: { size: 11 }
          }
        }
      }
    }
  });

  /* ── 3. TRAINING JOB STATUS DOUGHNUT ────────────────────────── */
  const jobStatus = SEED.trainingJobs.reduce((acc, j) => {
    acc[j.status] = (acc[j.status] || 0) + 1;
    return acc;
  }, {});

  const jobStatusColorMap = {
    completed : P.success,
    running   : P.primary,
    queued    : MUTED,
    failed    : P.danger
  };

  new Chart(document.getElementById('chartOverviewJobStatus'), {
    type: 'doughnut',
    data: {
      labels: Object.keys(jobStatus).map(s =>
        s.charAt(0).toUpperCase() + s.slice(1)
      ),
      datasets: [{
        data           : Object.values(jobStatus),
        backgroundColor: Object.keys(jobStatus).map(
          s => jobStatusColorMap[s] || P.info
        ),
        borderWidth : 2,
        borderColor : '#16161d',
        hoverOffset : 6
      }]
    },
    options: {
      responsive         : true,
      maintainAspectRatio: false,
      cutout             : '65%',
      plugins: {
        legend: {
          position: 'right',
          labels  : { padding: 10, font: { size: 11 } }
        }
      }
    }
  });

  /* ── 4. BEST MODEL MOS BY LANGUAGE ──────────────────────────── */
  /* Pick highest MOS per language */
  const bestMOS = {};
  SEED.evaluations.forEach(e => {
    if (!bestMOS[e.langCode] || e.mos > bestMOS[e.langCode].mos) {
      bestMOS[e.langCode] = e;
    }
  });
  const mosEntries = Object.entries(bestMOS)
    .sort((a, b) => b[1].mos - a[1].mos);

  const mosColors = mosEntries.map(([, e]) =>
    e.mos >= 4.0 ? P.success : e.mos >= 3.3 ? P.warning : P.danger
  );

  new Chart(document.getElementById('chartOverviewMOS'), {
    type: 'bar',
    data: {
      labels: mosEntries.map(([l]) => l.toUpperCase()),
      datasets: [{
        label          : 'Best MOS',
        data           : mosEntries.map(([, e]) => e.mos),
        backgroundColor: mosColors.map(c => P.alpha(c, 0.75)),
        borderColor    : mosColors,
        borderWidth    : 1,
        borderRadius   : 4
      }]
    },
    options: {
      responsive         : true,
      maintainAspectRatio: false,
      plugins: {
        legend: { display: false },
        tooltip: {
          callbacks: {
            label: ctx => ` MOS: ${ctx.parsed.y.toFixed(2)} / 5.0`
          }
        }
      },
      scales: {
        x: { grid: gridOpts(), ticks: tickOpts() },
        y: {
          grid: gridOpts(), ticks: tickOpts(),
          min  : 3.0, max: 5.0,
          title: {
            display: true, text: 'MOS',
            color: MUTED, font: { size: 11 }
          }
        }
      }
    }
  });

  /* ── 5. RECENT ACTIVITY DATATABLE ───────────────────────────── */
  function dsBadge(status) {
    const map = {
      approved  : 'approved',
      in_review : 'pending',
      draft     : 'draft',
      rejected  : 'rejected'
    };
    const label = status.replace(/_/g, ' ')
      .replace(/\b\w/g, c => c.toUpperCase());
    return `<span class="badge-status badge-${map[status] || 'draft'}">${label}</span>`;
  }

  const tbody = document.getElementById('recentActivityBody');
  if (tbody) {
    /* Show all 10 datasets sorted by createdAt desc */
    const sorted = [...SEED.datasets].sort(
      (a, b) => new Date(b.createdAt) - new Date(a.createdAt)
    );
    tbody.innerHTML = sorted.map(d => `
      <tr>
        <td>
          <a href="${d.id}" style="color:var(--primary);font-weight:500">
            ${d.name}
          </a>
        </td>
        <td>${d.langCode.toUpperCase()}</td>
        <td style="text-align:right;color:var(--text-muted)">
          ${d.totalClips.toLocaleString()}
        </td>
        <td style="text-align:right;color:var(--text-muted)">
          ${d.totalHours.toFixed(1)}h
        </td>
        <td>${dsBadge(d.status)}</td>
        <td style="color:var(--text-muted)">${d.createdAt}</td>
      </tr>
    `).join('');
  }

  if (typeof $ !== 'undefined' && $.fn.DataTable) {
    $('#tblRecentActivity').DataTable({
      pageLength : 7,
      lengthMenu : [7, 10],
      order      : [[5, 'desc']],
      language   : {
        search           : '',
        searchPlaceholder: 'Search…',
        lengthMenu       : 'Show _MENU_',
        info             : '_START_–_END_ of _TOTAL_',
        paginate         : { previous: '‹', next: '›' }
      },
      columnDefs: [
        { targets: [2, 3], className: 'dt-right' }
      ]
    });
  }

})();