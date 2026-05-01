/* ═══════════════════════════════════════════════════════════════
   datasets.js — Datasets Page: charts + DataTable
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

  /* ── 1. STATUS DOUGHNUT ─────────────────────────────────────── */
  const dsStatus = SEED.datasets.reduce((acc, d) => {
    acc[d.status] = (acc[d.status] || 0) + 1;
    return acc;
  }, {});

  const statusColorMap = {
    approved  : P.success,
    in_review : P.warning,
    draft     : P.info,
    rejected  : P.danger
  };

  new Chart(document.getElementById('chartDSStatus'), {
    type: 'doughnut',
    data: {
      labels: Object.keys(dsStatus).map(s =>
        s.replace(/_/g, ' ').replace(/\b\w/g, c => c.toUpperCase())
      ),
      datasets: [{
        data           : Object.values(dsStatus),
        backgroundColor: Object.keys(dsStatus).map(
          s => statusColorMap[s] || P.purple
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
        legend: { position: 'bottom', labels: { padding: 10, font: { size: 11 } } }
      }
    }
  });

  /* ── 2. CLIPS BY LANGUAGE BAR ───────────────────────────────── */
  const clipsMap = {};
  SEED.datasets.forEach(d => {
    clipsMap[d.langCode] = (clipsMap[d.langCode] || 0) + d.totalClips;
  });
  const clipsSorted = Object.entries(clipsMap).sort((a, b) => b[1] - a[1]);
  const langPalette = [P.primary, P.info, P.success, P.purple, P.warning, P.danger, '#ec4899', '#14b8a6'];

  new Chart(document.getElementById('chartDSClipsByLang'), {
    type: 'bar',
    data: {
      labels: clipsSorted.map(([l]) => l.toUpperCase()),
      datasets: [{
        label          : 'Clips',
        data           : clipsSorted.map(([, v]) => v),
        backgroundColor: clipsSorted.map((_, i) =>
          P.alpha(langPalette[i % langPalette.length], 0.75)
        ),
        borderColor: clipsSorted.map((_, i) => langPalette[i % langPalette.length]),
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
          title: { display: true, text: 'Clips', color: MUTED, font: { size: 11 } }
        }
      }
    }
  });

  /* ── 3. HOURS BY CATEGORY GROUPED BAR ──────────────────────── */
  const catLangMap = {};
  SEED.datasets.forEach(d => {
    if (!catLangMap[d.category]) catLangMap[d.category] = {};
    catLangMap[d.category][d.langCode] =
      (catLangMap[d.category][d.langCode] || 0) + d.totalHours;
  });

  const allLangs = [...new Set(SEED.datasets.map(d => d.langCode))];
  const catKeys  = Object.keys(catLangMap);
  const catColors = [P.primary, P.info, P.purple];

  new Chart(document.getElementById('chartDSHoursByCategory'), {
    type: 'bar',
    data: {
      labels: allLangs.map(l => l.toUpperCase()),
      datasets: catKeys.map((cat, i) => ({
        label          : cat.charAt(0).toUpperCase() + cat.slice(1),
        data           : allLangs.map(l => catLangMap[cat][l] || 0),
        backgroundColor: P.alpha(catColors[i % catColors.length], 0.75),
        borderColor    : catColors[i % catColors.length],
        borderWidth    : 1,
        borderRadius   : 3
      }))
    },
    options: {
      responsive         : true,
      maintainAspectRatio: false,
      interaction        : { mode: 'index', intersect: false },
      plugins: {
        legend: {
          position: 'top',
          align   : 'end',
          labels  : { boxWidth: 10, padding: 8, font: { size: 10 } }
        }
      },
      scales: {
        x: { grid: gridOpts(), ticks: tickOpts() },
        y: {
          grid: gridOpts(), ticks: tickOpts(),
          beginAtZero: true,
          title: { display: true, text: 'Hours', color: MUTED, font: { size: 11 } }
        }
      }
    }
  });

  /* ── 4. DATATABLE — DATASETS ────────────────────────────────── */
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

  const tbody = document.getElementById('datasetTableBody');
  if (tbody) {
    tbody.innerHTML = SEED.datasets.map(d => `
      <tr>
        <td><code style="font-size:11px;color:var(--primary)">${d.id}</code></td>
        <td style="font-weight:500">${d.name}</td>
        <td>${d.langCode.toUpperCase()}</td>
        <td>
          <span class="badge-status badge-info">${d.category}</span>
        </td>
        <td style="text-align:right;color:var(--text-muted)">
          ${d.totalClips.toLocaleString()}
        </td>
        <td style="text-align:right;color:var(--text-muted)">
          ${d.totalHours.toFixed(1)}h
        </td>
        <td style="text-align:right;color:var(--text-muted)">${d.speakers}</td>
        <td>${dsBadge(d.status)}</td>
        <td style="color:var(--text-muted)">${d.createdBy}</td>
        <td style="color:var(--text-muted)">${d.createdAt}</td>
      </tr>
    `).join('');
  }

  if (typeof $ !== 'undefined' && $.fn.DataTable) {
    $('#tblDatasets').DataTable({
      pageLength : 7,
      lengthMenu : [7, 10, 25],
      order      : [[9, 'desc']],
      language   : {
        search           : '',
        searchPlaceholder: 'Search datasets…',
        lengthMenu       : 'Show _MENU_',
        info             : '_START_–_END_ of _TOTAL_',
        paginate         : { previous: '‹', next: '›' }
      },
      columnDefs: [
        { targets: [4, 5, 6], className: 'dt-right' }
      ]
    });
  }

})();