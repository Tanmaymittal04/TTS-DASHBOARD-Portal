/* ═══════════════════════════════════════════════════════════════
   speakers.js — Speakers Page: charts + DataTable
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
    pink    : '#ec4899',
    alpha   : (hex, a) => hex + Math.round(a * 255).toString(16).padStart(2, '0')
  };

  function gridOpts() { return { color: BORDER, drawBorder: false }; }
  function tickOpts() { return { color: MUTED, maxRotation: 0 }; }

  /* ── 1. GENDER DOUGHNUT ─────────────────────────────────────── */
  const genderCount = SEED.speakers.reduce((acc, s) => {
    const label = s.gender === 'F' ? 'Female' : 'Male';
    acc[label] = (acc[label] || 0) + 1;
    return acc;
  }, {});

  new Chart(document.getElementById('chartSpeakerGender'), {
    type: 'doughnut',
    data: {
      labels: Object.keys(genderCount),
      datasets: [{
        data           : Object.values(genderCount),
        backgroundColor: [P.pink, P.info],
        borderWidth    : 2,
        borderColor    : '#16161d',
        hoverOffset    : 6
      }]
    },
    options: {
      responsive         : true,
      maintainAspectRatio: false,
      cutout             : '65%',
      plugins            : {
        legend: { position: 'bottom', labels: { padding: 10, font: { size: 11 } } }
      }
    }
  });

  /* ── 2. RECORDING ENVIRONMENT PIE ───────────────────────────── */
  const envCount = SEED.speakers.reduce((acc, s) => {
    acc[s.recordingEnv] = (acc[s.recordingEnv] || 0) + 1;
    return acc;
  }, {});

  new Chart(document.getElementById('chartSpeakerEnv'), {
    type: 'pie',
    data: {
      labels: Object.keys(envCount).map(e =>
        e.charAt(0).toUpperCase() + e.slice(1)
      ),
      datasets: [{
        data           : Object.values(envCount),
        backgroundColor: [P.primary, P.success, P.warning],
        borderWidth    : 2,
        borderColor    : '#16161d',
        hoverOffset    : 6
      }]
    },
    options: {
      responsive         : true,
      maintainAspectRatio: false,
      plugins            : {
        legend: { position: 'bottom', labels: { padding: 10, font: { size: 11 } } }
      }
    }
  });

  /* ── 3. CLIPS BY LANGUAGE BAR ───────────────────────────────── */
  const clipsMap = {};
  SEED.speakers.forEach(s => {
    clipsMap[s.langCode] = (clipsMap[s.langCode] || 0) + s.totalClips;
  });
  const clipsSorted = Object.entries(clipsMap).sort((a, b) => b[1] - a[1]);
  const langPalette = [P.primary, P.info, P.success, P.purple, P.warning, P.danger, P.pink, '#14b8a6'];

  new Chart(document.getElementById('chartSpeakerClipsByLang'), {
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

  /* ── 4. DATATABLE — SPEAKERS ────────────────────────────────── */
  function statusBadge(s) {
    return `<span class="badge-status badge-${s === 'active' ? 'approved' : 'draft'}">${s}</span>`;
  }

  const tbody = document.getElementById('speakerTableBody');
  if (tbody) {
    tbody.innerHTML = SEED.speakers.map(s => `
      <tr>
        <td><code style="font-size:11px;color:var(--primary)">${s.id}</code></td>
        <td style="font-weight:500">${s.name}</td>
        <td>${s.langCode.toUpperCase()}</td>
        <td>${s.gender === 'F' ? '♀ Female' : '♂ Male'}</td>
        <td style="text-align:right;color:var(--text-muted)">${s.age}</td>
        <td style="color:var(--text-muted)">${s.accent}</td>
        <td>
          <span class="badge-status badge-info">${s.recordingEnv}</span>
        </td>
        <td style="text-align:right;color:var(--text-muted)">
          ${s.totalClips.toLocaleString()}
        </td>
        <td style="text-align:right;color:var(--text-muted)">
          ${s.totalHours.toFixed(1)}h
        </td>
        <td>${statusBadge(s.status)}</td>
      </tr>
    `).join('');
  }

  if (typeof $ !== 'undefined' && $.fn.DataTable) {
    $('#tblSpeakers').DataTable({
      pageLength : 8,
      lengthMenu : [8, 12, 25],
      order      : [[7, 'desc']],
      language   : {
        search           : '',
        searchPlaceholder: 'Search speakers…',
        lengthMenu       : 'Show _MENU_',
        info             : '_START_–_END_ of _TOTAL_',
        paginate         : { previous: '‹', next: '›' }
      },
      columnDefs: [
        { targets: [4, 7, 8], className: 'dt-right' }
      ]
    });
  }

})();