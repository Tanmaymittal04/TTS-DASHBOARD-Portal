(function () {
  'use strict';

  function init() {
    const isDark = () =>
      (document.documentElement.getAttribute('data-theme') || 'dark') === 'dark';

    const C = {
      accent:'#6366f1', green:'#22c55e', red:'#ef4444',
      amber:'#f59e0b', cyan:'#06b6d4', purple:'#a855f7',
      pink:'#ec4899', orange:'#f97316',
      a: (hex, op) => hex + Math.round(op * 255).toString(16).padStart(2,'0')
    };

    Chart.defaults.font.family = "'Inter', system-ui, -apple-system, sans-serif";
    Chart.defaults.font.size   = 11;
    Chart.defaults.color       = '#6b7280';

    const gridColor  = () => isDark() ? 'rgba(255,255,255,0.06)' : 'rgba(0,0,0,0.07)';
    const tickColor  = () => isDark() ? '#6b7280' : '#9ca3af';
    const tooltipBg  = () => isDark() ? '#1c1f2e' : '#ffffff';
    const tooltipBdr = () => isDark() ? '#2e3150' : '#e5e7eb';

    const xScale = () => ({
      grid : { color: gridColor(), drawBorder: false },
      ticks: { color: tickColor(), maxRotation: 0, font: { size: 11 } }
    });
    const yScale = (label) => ({
      grid: { color: gridColor(), drawBorder: false },
      ticks: { color: tickColor(), font: { size: 11 } },
      beginAtZero: true,
      ...(label ? { title: { display:true, text:label, color:tickColor(), font:{size:10} } } : {})
    });
    const tooltip = () => ({
      backgroundColor: tooltipBg(), borderColor: tooltipBdr(), borderWidth:1,
      titleColor: isDark() ? '#d8dae8' : '#1a1d2e', bodyColor: tickColor(),
      padding:10, cornerRadius:6, titleFont:{size:12,weight:'600'}, bodyFont:{size:11}
    });
    const legend = (pos='top') => ({
      position: pos, align:'end',
      labels: { boxWidth:10, padding:14, color: tickColor() }
    });

    /* ── SEED DATA ─────────────────────────────────────────── */
    const LANGS = ['Hindi','Telugu','Tamil','Kannada','Malayalam','Marathi',
                   'Bengali','Gujarati','Punjabi','Odia','Urdu','Assamese'];
    const ACCENTS = {
      Hindi:['Delhi','UP','Bihar','Rajasthani'],
      Telugu:['Andhra','Telangana','Rayalaseema'],
      Tamil:['Chennai','Madurai','Coimbatore'],
      Kannada:['Bengaluru','Mysuru','Dharwad'],
      Malayalam:['Kochi','Trivandrum','Kozhikode'],
      Marathi:['Pune','Mumbai','Nagpur'],
      Bengali:['Kolkata','Dhaka','Sylhet'],
      Gujarati:['Ahmedabad','Surat','Vadodara'],
      Punjabi:['Amritsar','Ludhiana','Chandigarh'],
      Odia:['Bhubaneswar','Cuttack','Sambalpur'],
      Urdu:['Hyderabad','Lucknow','Delhi'],
      Assamese:['Guwahati','Dibrugarh','Silchar']
    };
    const SRCS   = ['open_source','recorded','vendor'];
    const LICS   = ['approved','approved','approved','approved','pending','rejected'];
    const STAGES = ['intake','qc','scored','training','approved','rejected'];
    const PERSONS= ['Ravi K.','Priya S.','Meena T.','Arjun R.','Divya M.',
                    'Sundar P.','Leela V.','Karan B.','Neha G.','Rohit J.'];

    function mkDS(i) {
      const lang   = LANGS[i % LANGS.length];
      const accent = ACCENTS[lang][i % ACCENTS[lang].length];
      const src    = SRCS[i % SRCS.length];
      const raw    = parseFloat((10 + ((i * 7.3) % 110)).toFixed(1));
      const clean  = parseFloat((raw * (0.70 + ((i * 0.013) % 0.26))).toFixed(1));
      const lic    = LICS[i % LICS.length];
      return {
        id         : `DS-${String(i + 1).padStart(3,'0')}`,
        name       : `${lang} ${accent} ${src === 'open_source' ? 'OSS' : src.charAt(0).toUpperCase() + src.slice(1)} v${(i % 4) + 1}`,
        language   : lang, accent, source: src,
        rawHours   : raw, cleanHours: clean,
        clips      : Math.round(raw * (420 + (i * 11) % 220)),
        speakers   : 20 + (i * 17) % 160,
        license    : lic,
        status     : lic === 'rejected' ? 'rejected' : STAGES[i % STAGES.length],
        assignedTo : PERSONS[i % PERSONS.length]
      };
    }
    const DS = Array.from({ length: 48 }, (_, i) => mkDS(i));

    /* ── CHART 1 — Source Type Doughnut ───────────────────── */
    const srcEl = document.getElementById('chartSourceType');
    if (srcEl) {
      const srcMap = DS.reduce((a, d) => {
        const k = d.source === 'open_source' ? 'Open Source'
                  : d.source.charAt(0).toUpperCase() + d.source.slice(1);
        a[k] = (a[k] || 0) + 1;
        return a;
      }, {});
      new Chart(srcEl, {
        type: 'doughnut',
        data: {
          labels: Object.keys(srcMap),
          datasets: [{
            data: Object.values(srcMap),
            backgroundColor: [C.a(C.accent,0.85), C.a(C.green,0.85), C.a(C.cyan,0.85)],
            borderWidth: 2,
            borderColor: isDark() ? '#161820' : '#ffffff',
            hoverOffset: 8
          }]
        },
        options: {
          responsive: true, maintainAspectRatio: false, cutout: '70%',
          plugins: { legend: legend('right'), tooltip: { ...tooltip() } }
        }
      });
    }

    /* ── CHART 2 — Raw vs Clean Grouped Bar ───────────────── */
    const rawCleanEl = document.getElementById('chartRawVsClean');
    if (rawCleanEl) {
      const langMap = {};
      DS.forEach(d => {
        if (!langMap[d.language]) langMap[d.language] = { raw: 0, clean: 0 };
        langMap[d.language].raw   += d.rawHours;
        langMap[d.language].clean += d.cleanHours;
      });
      const lKeys = Object.keys(langMap).sort();
      new Chart(rawCleanEl, {
        type: 'bar',
        data: {
          labels: lKeys,
          datasets: [
            {
              label: 'Raw Hours',
              data: lKeys.map(l => +langMap[l].raw.toFixed(1)),
              backgroundColor: C.a(C.cyan, 0.55), borderColor: C.cyan,
              borderWidth: 1, borderRadius: 4
            },
            {
              label: 'Clean Hours',
              data: lKeys.map(l => +langMap[l].clean.toFixed(1)),
              backgroundColor: C.a(C.green, 0.70), borderColor: C.green,
              borderWidth: 1, borderRadius: 4
            }
          ]
        },
        options: {
          responsive: true, maintainAspectRatio: false,
          interaction: { mode: 'index', intersect: false },
          plugins: { legend: legend('top'), tooltip: { ...tooltip() } },
          scales: { x: xScale(), y: yScale('Hours') }
        }
      });
      // store langMap for later charts
      window.__diLangMap  = langMap;
      window.__diLKeys    = lKeys;
    }

    /* ── CHART 3 — License Status Bar ─────────────────────── */
    const licEl = document.getElementById('chartLicenseStatus');
    if (licEl) {
      const licCounts = DS.reduce((a, d) => { a[d.license] = (a[d.license] || 0) + 1; return a; }, {});
      const licColor  = { approved: C.green, pending: C.amber, rejected: C.red };
      const licKeys   = ['approved', 'pending', 'rejected'];
      new Chart(licEl, {
        type: 'bar',
        data: {
          labels: licKeys.map(k => k.charAt(0).toUpperCase() + k.slice(1)),
          datasets: [{
            label: 'Datasets',
            data: licKeys.map(k => licCounts[k] || 0),
            backgroundColor: licKeys.map(k => C.a(licColor[k], 0.75)),
            borderColor    : licKeys.map(k => licColor[k]),
            borderWidth: 1, borderRadius: 5
          }]
        },
        options: {
          responsive: true, maintainAspectRatio: false,
          plugins: { legend: { display: false }, tooltip: { ...tooltip() } },
          scales: { x: xScale(), y: { ...yScale('Count'), ticks: { ...yScale('Count').ticks, stepSize: 1 } } }
        }
      });
    }

    /* ── CHART 4 — Speaker Count Bar ──────────────────────── */
    const spkEl = document.getElementById('chartSpeakerCount');
    if (spkEl) {
      const spkMap = {};
      DS.forEach(d => { spkMap[d.language] = (spkMap[d.language] || 0) + d.speakers; });
      const spkKeys   = Object.keys(spkMap).sort();
      const spkColors = [C.accent,C.green,C.cyan,C.amber,C.purple,C.pink,
                         C.orange,C.red,'#14b8a6','#3b82f6','#f43f5e','#84cc16'];
      new Chart(spkEl, {
        type: 'bar',
        data: {
          labels: spkKeys,
          datasets: [{
            label: 'Speakers',
            data: spkKeys.map(k => spkMap[k]),
            backgroundColor: spkKeys.map((_, i) => C.a(spkColors[i % spkColors.length], 0.75)),
            borderColor    : spkKeys.map((_, i) => spkColors[i % spkColors.length]),
            borderWidth: 1, borderRadius: 4
          }]
        },
        options: {
          responsive: true, maintainAspectRatio: false,
          plugins: { legend: { display: false }, tooltip: { ...tooltip() } },
          scales: { x: xScale(), y: yScale('Speakers') }
        }
      });
    }

    /* ── CHART 5 — Clean Yield % ───────────────────────────── */
    const yieldEl = document.getElementById('chartCleanYield');
    if (yieldEl) {
      const langMap = window.__diLangMap || (() => {
        const m = {};
        DS.forEach(d => {
          if (!m[d.language]) m[d.language] = { raw: 0, clean: 0 };
          m[d.language].raw   += d.rawHours;
          m[d.language].clean += d.cleanHours;
        });
        return m;
      })();
      const lKeys      = window.__diLKeys || Object.keys(langMap).sort();
      const yieldVals  = lKeys.map(l => +((langMap[l].clean / langMap[l].raw) * 100).toFixed(1));
      new Chart(yieldEl, {
        type: 'bar',
        data: {
          labels: lKeys,
          datasets: [{
            label: 'Clean Yield %',
            data: yieldVals,
            backgroundColor: yieldVals.map(v => v >= 85 ? C.a(C.green,0.75) : v >= 75 ? C.a(C.amber,0.75) : C.a(C.red,0.75)),
            borderColor    : yieldVals.map(v => v >= 85 ? C.green : v >= 75 ? C.amber : C.red),
            borderWidth: 1, borderRadius: 4
          }]
        },
        options: {
          responsive: true, maintainAspectRatio: false,
          plugins: {
            legend: { display: false },
            tooltip: { ...tooltip(), callbacks: { label: ctx => ` ${ctx.parsed.y}%` } }
          },
          scales: { x: xScale(), y: { ...yScale('%'), max: 100 } }
        }
      });
    }

    /* ── CHART 6 — Pipeline Stage Doughnut ────────────────── */
    const stageEl = document.getElementById('chartPipelineStage');
    if (stageEl) {
      const stageMap = DS.reduce((a, d) => {
        const k = d.status.charAt(0).toUpperCase() + d.status.slice(1);
        a[k] = (a[k] || 0) + 1;
        return a;
      }, {});
      const stageColorMap = {
        Intake:C.a(C.cyan,0.85), Qc:C.a(C.accent,0.85), Scored:C.a(C.purple,0.85),
        Training:C.a(C.amber,0.85), Approved:C.a(C.green,0.85), Rejected:C.a(C.red,0.85)
      };
      new Chart(stageEl, {
        type: 'doughnut',
        data: {
          labels: Object.keys(stageMap),
          datasets: [{
            data: Object.values(stageMap),
            backgroundColor: Object.keys(stageMap).map(k => stageColorMap[k] || C.a(C.accent,0.7)),
            borderWidth: 2,
            borderColor: isDark() ? '#161820' : '#ffffff',
            hoverOffset: 8
          }]
        },
        options: {
          responsive: true, maintainAspectRatio: false, cutout: '68%',
          plugins: { legend: legend('right'), tooltip: { ...tooltip() } }
        }
      });
    }

    /* ── TABLE ─────────────────────────────────────────────── */
    const licBadge = s => `<span class="di-tbl-badge di-badge-${s}">${s}</span>`;
    const stsBadge = s => `<span class="di-tbl-badge di-badge-${s}">${s}</span>`;
    const srcChip  = s => {
      const cls = { open_source:'di-src-open', recorded:'di-src-recorded', vendor:'di-src-vendor' };
      const lbl = s === 'open_source' ? 'Open Source' : s.charAt(0).toUpperCase() + s.slice(1);
      return `<span class="di-src-chip ${cls[s] || ''}">${lbl}</span>`;
    };
    const maxRaw   = Math.max(...DS.map(d => d.rawHours));
    const hoursCell = (v, max) => {
      const pct = Math.min(100, (v / max) * 100).toFixed(0);
      return `<div class="di-hours-cell">
        <span style="min-width:36px;text-align:right">${v.toFixed(1)}</span>
        <div class="di-hours-track">
          <div class="di-hours-fill" style="width:${pct}%;background:var(--di-cyan)"></div>
        </div></div>`;
    };
    const avCell = name => {
      const ini = name.split(' ').map(w => w[0]).join('').toUpperCase().slice(0, 2);
      return `<div class="di-assigned">
        <div class="di-av">${ini}</div>
        <span style="font-size:11px">${name}</span></div>`;
    };

    const tbody = document.getElementById('datasetTableBody');
    if (tbody) {
      tbody.innerHTML = DS.map(d => `
        <tr>
          <td><span class="di-ds-id">${d.id}</span></td>
          <td style="max-width:160px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis" title="${d.name}">
            <span style="font-size:12px;font-weight:600">${d.name}</span></td>
          <td><span class="di-lang-pill">${d.language.slice(0,3).toUpperCase()}</span></td>
          <td style="font-size:11px;color:var(--di-muted)">${d.accent}</td>
          <td>${srcChip(d.source)}</td>
          <td>${hoursCell(d.rawHours, maxRaw)}</td>
          <td>${hoursCell(d.cleanHours, maxRaw)}</td>
          <td style="text-align:right;font-variant-numeric:tabular-nums">${d.clips.toLocaleString()}</td>
          <td style="text-align:right;font-variant-numeric:tabular-nums">${d.speakers}</td>
          <td>${licBadge(d.license)}</td>
          <td>${stsBadge(d.status)}</td>
          <td>${avCell(d.assignedTo)}</td>
        </tr>`).join('');
    }

    if (typeof $ !== 'undefined' && $.fn && $.fn.DataTable) {
      $('#tblDatasets').DataTable({
        pageLength : 10,
        lengthMenu : [10, 25, 48],
        order      : [[5, 'desc']],
        language   : {
          search: '', searchPlaceholder: 'Search datasets…',
          lengthMenu: 'Show _MENU_',
          info: '_START_–_END_ of _TOTAL_ datasets',
          paginate: { previous: '‹', next: '›' }
        },
        columnDefs: [{ targets: [5, 6, 7, 8], className: 'dt-right' }]
      });
    }
  } // end init()

  /* ── SAFE EXECUTION: wait for DOM + Chart.js ─────────────── */
  function waitForChartJs(cb, attempts) {
    attempts = attempts || 0;
    if (typeof Chart !== 'undefined') {
      cb();
    } else if (attempts < 40) {
      setTimeout(function () { waitForChartJs(cb, attempts + 1); }, 100);
    } else {
      console.error('[dataset-intake] Chart.js did not load after 4 s');
    }
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', function () { waitForChartJs(init); });
  } else {
    waitForChartJs(init);
  }

})();