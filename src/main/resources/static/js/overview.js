/* ═══════════════════════════════════════════════════════════════
   overview.js  —  TTS Dashboard · Overview Page Charts
   Charts: Dataset Status (doughnut), Clean Hours (bar),
           MOS Trend (line), Training Status (doughnut),
           Voice Use Case (pie), Latency Trend (line)
   Table : Recent datasets
   FIX   : All init wrapped in waitForChartJs + DOMContentLoaded
           so charts never run before Chart.js or DOM is ready
════════════════════════════════════════════════════════════════ */

(function () {
  'use strict';

  /* ── Theme helpers ──────────────────────────────────────────── */
  const isDark = () =>
    (document.documentElement.getAttribute('data-theme') || 'dark') === 'dark';

  const C = {
    accent : '#6366f1', green  : '#22c55e', red    : '#ef4444',
    amber  : '#f59e0b', cyan   : '#06b6d4', purple : '#a855f7',
    pink   : '#ec4899', orange : '#f97316', teal   : '#14b8a6',
    blue   : '#3b82f6',
    a: (hex, op) => hex + Math.round(op * 255).toString(16).padStart(2, '0')
  };

  const gridColor  = () => isDark() ? 'rgba(255,255,255,0.06)' : 'rgba(0,0,0,0.07)';
  const tickColor  = () => isDark() ? '#6b7280' : '#9ca3af';
  const tooltipBg  = () => isDark() ? '#1c1f2e' : '#ffffff';
  const tooltipBdr = () => isDark() ? '#2e3150' : '#e5e7eb';
  const borderBg   = () => isDark() ? '#161820' : '#ffffff';

  const xScale = () => ({
    grid : { color: gridColor(), drawBorder: false },
    ticks: { color: tickColor(), maxRotation: 0, font: { size: 11 } }
  });
  const yScale = (label) => ({
    grid       : { color: gridColor(), drawBorder: false },
    ticks      : { color: tickColor(), font: { size: 11 } },
    beginAtZero: true,
    ...(label ? { title: { display: true, text: label,
                            color: tickColor(), font: { size: 10 } } } : {})
  });
  const tooltip = () => ({
    backgroundColor: tooltipBg(), borderColor: tooltipBdr(), borderWidth: 1,
    titleColor     : isDark() ? '#d8dae8' : '#1a1d2e',
    bodyColor      : tickColor(),
    padding        : 10,
    cornerRadius   : 6,
    titleFont      : { size: 12, weight: '600' },
    bodyFont       : { size: 11 }
  });
  const legend = (pos = 'top') => ({
    position: pos, align: 'end',
    labels  : { boxWidth: 10, padding: 14, color: tickColor() }
  });

  /* ══════════════════════════════════════════════════════════════
     SEED DATA — fully self-contained, no external SEED global
  ═══════════════════════════════════════════════════════════════ */
  const LANG_CODES = ['hi','te','ta','kn','ml','mr','bn','gu','pa','ur','or','as'];
  const LANG_NAMES = {
    hi:'Hindi',  te:'Telugu',   ta:'Tamil',   kn:'Kannada', ml:'Malayalam',
    mr:'Marathi',bn:'Bengali',  gu:'Gujarati',pa:'Punjabi', ur:'Urdu',
    or:'Odia',   as:'Assamese'
  };
  const DS_STATUSES  = ['approved','approved','approved','in_review','draft','rejected'];
  const JOB_STATUSES = ['completed','completed','completed','running','queued','failed'];
  const USE_CASES    = ['Support','Sales','Collections','IVR','Notifications'];
  const MOS_VERSIONS = ['v1','v2','v3','v4','v5','v6'];
  const LAT_VERSIONS = ['v1.0','v1.1','v1.2','v2.0','v2.1','v2.2'];

  function seeded(s) {
    let x = s;
    return () => { x = (x * 1664525 + 1013904223) & 0xffffffff; return (x >>> 0) / 0xffffffff; };
  }

  const datasets = Array.from({ length: 48 }, (_, i) => {
    const rng        = seeded(i * 1777 + 31);
    const lang       = LANG_CODES[i % LANG_CODES.length];
    const totalHours = +(20 + rng() * 130).toFixed(1);
    return {
      name      : `${LANG_NAMES[lang]} Dataset v${(i % 4) + 1}`,
      langCode  : lang,
      totalHours,
      totalClips: Math.round(totalHours * (400 + rng() * 200)),
      status    : DS_STATUSES[i % DS_STATUSES.length],
      mos       : +(3.0 + rng() * 2.0).toFixed(2),
      createdAt : `2025-0${(i % 9) + 1}-${String((i % 28) + 1).padStart(2, '0')}`
    };
  });

  const trainingJobs = Array.from({ length: 30 }, (_, i) => ({
    langCode: LANG_CODES[i % LANG_CODES.length],
    status  : JOB_STATUSES[i % JOB_STATUSES.length]
  }));

  const mosTrendData = {};
  LANG_CODES.slice(0, 5).forEach((l, li) => {
    const rng = seeded(li * 999 + 7);
    let val   = 3.2 + rng() * 0.5;
    mosTrendData[l] = MOS_VERSIONS.map(() => {
      val = Math.min(5, +(val + (rng() * 0.25 - 0.05)).toFixed(2));
      return val;
    });
  });

  const latencyData        = [480, 440, 410, 385, 360, 340];
  const voiceUseCaseCounts = [14, 10, 8, 4, 2];

  /* ══════════════════════════════════════════════════════════════
     INIT — only called after Chart.js is loaded AND DOM is ready
  ═══════════════════════════════════════════════════════════════ */
  function init() {

    /* Set Chart.js global defaults INSIDE init, never at top level */
    Chart.defaults.font.family = "'Inter', system-ui, -apple-system, sans-serif";
    Chart.defaults.font.size   = 11;
    Chart.defaults.color       = '#6b7280';

    /* ── CHART 1 · Dataset Status Doughnut ────────────────────── */
    (function () {
      const el = document.getElementById('chartDatasetStatus');
      if (!el) return;

      const map = datasets.reduce((a, d) => {
        a[d.status] = (a[d.status] || 0) + 1;
        return a;
      }, {});
      const colorMap = {
        approved : C.green, in_review: C.amber,
        draft    : C.cyan,  rejected : C.red
      };

      new Chart(el, {
        type: 'doughnut',
        data: {
          labels: Object.keys(map).map(s =>
            s.replace(/_/g, ' ').replace(/\b\w/g, c => c.toUpperCase())
          ),
          datasets: [{
            data           : Object.values(map),
            backgroundColor: Object.keys(map).map(s => C.a(colorMap[s] || C.purple, 0.85)),
            borderColor    : borderBg(),
            borderWidth    : 2,
            hoverOffset    : 8
          }]
        },
        options: {
          responsive: true, maintainAspectRatio: false, cutout: '68%',
          plugins: {
            legend : legend('right'),
            tooltip: { ...tooltip(), callbacks: {
              label: ctx => ` ${ctx.label}: ${ctx.parsed} dataset(s)`
            }}
          }
        }
      });
    })();

    /* ── CHART 2 · Clean Hours by Language (Bar) ──────────────── */
    (function () {
      const el = document.getElementById('chartCleanHours');
      if (!el) return;

      const map = {};
      datasets.forEach(d => { map[d.langCode] = (map[d.langCode] || 0) + d.totalHours; });
      const sorted  = Object.entries(map).sort((a, b) => b[1] - a[1]);
      const palette = [
        C.accent, C.cyan,   C.green, C.purple,
        C.amber,  C.red,    C.pink,  C.teal,
        C.orange, C.blue, '#84cc16','#f43f5e'
      ];

      new Chart(el, {
        type: 'bar',
        data: {
          labels: sorted.map(([l]) => (LANG_NAMES[l] || l).slice(0, 3).toUpperCase()),
          datasets: [{
            label          : 'Clean Hours',
            data           : sorted.map(([, h]) => +h.toFixed(1)),
            backgroundColor: sorted.map((_, i) => C.a(palette[i % palette.length], 0.75)),
            borderColor    : sorted.map((_, i) => palette[i % palette.length]),
            borderWidth    : 1,
            borderRadius   : 4
          }]
        },
        options: {
          responsive: true, maintainAspectRatio: false,
          plugins: {
            legend : { display: false },
            tooltip: { ...tooltip(), callbacks: {
              label: ctx => ` ${ctx.parsed.y.toFixed(1)} hrs`
            }}
          },
          scales: { x: xScale(), y: yScale('Hours') }
        }
      });
    })();

    /* ── CHART 3 · MOS Trend — Multi-line ────────────────────── */
    (function () {
      const el = document.getElementById('chartMOSTrend');
      if (!el) return;

      const palette  = [C.accent, C.green, C.cyan, C.amber, C.purple];
      const dsCfg    = Object.entries(mosTrendData).map(([lang, vals], i) => ({
        label            : (LANG_NAMES[lang] || lang).slice(0, 3).toUpperCase(),
        data             : vals,
        borderColor      : palette[i % palette.length],
        backgroundColor  : C.a(palette[i % palette.length], 0.12),
        borderWidth      : 2,
        pointRadius      : 3,
        pointHoverRadius : 5,
        tension          : 0.35,
        fill             : false
      }));

      new Chart(el, {
        type: 'line',
        data: { labels: MOS_VERSIONS, datasets: dsCfg },
        options: {
          responsive: true, maintainAspectRatio: false,
          interaction: { mode: 'index', intersect: false },
          plugins : { legend: legend('top'), tooltip: tooltip() },
          scales  : {
            x: xScale(),
            y: {
              ...yScale('MOS Score'),
              min: 3.0, max: 5.0,
              ticks: { color: tickColor(), font: { size: 11 }, stepSize: 0.5 }
            }
          }
        }
      });
    })();

    /* ── CHART 4 · Training Job Status Doughnut ──────────────── */
    (function () {
      const el = document.getElementById('chartTrainingStatus');
      if (!el) return;

      const map = trainingJobs.reduce((a, j) => {
        a[j.status] = (a[j.status] || 0) + 1;
        return a;
      }, {});
      const colorMap = {
        completed: C.green, running : C.accent,
        queued   : '#6b7280', failed: C.red
      };

      new Chart(el, {
        type: 'doughnut',
        data: {
          labels: Object.keys(map).map(s => s.charAt(0).toUpperCase() + s.slice(1)),
          datasets: [{
            data           : Object.values(map),
            backgroundColor: Object.keys(map).map(s => C.a(colorMap[s] || C.cyan, 0.85)),
            borderColor    : borderBg(),
            borderWidth    : 2,
            hoverOffset    : 8
          }]
        },
        options: {
          responsive: true, maintainAspectRatio: false, cutout: '68%',
          plugins: {
            legend : legend('right'),
            tooltip: { ...tooltip(), callbacks: {
              label: ctx => ` ${ctx.label}: ${ctx.parsed} job(s)`
            }}
          }
        }
      });
    })();

    /* ── CHART 5 · Voice Use Case (Pie) ──────────────────────── */
    (function () {
      const el = document.getElementById('chartVoiceUseCase');
      if (!el) return;

      const palette = [C.accent, C.cyan, C.green, C.amber, C.purple];

      new Chart(el, {
        type: 'pie',
        data: {
          labels  : USE_CASES,
          datasets: [{
            data           : voiceUseCaseCounts,
            backgroundColor: palette.map(c => C.a(c, 0.80)),
            borderColor    : borderBg(),
            borderWidth    : 2,
            hoverOffset    : 8
          }]
        },
        options: {
          responsive: true, maintainAspectRatio: false,
          plugins: {
            legend : legend('right'),
            tooltip: { ...tooltip(), callbacks: {
              label: ctx => ` ${ctx.label}: ${ctx.parsed} voice(s)`
            }}
          }
        }
      });
    })();

    /* ── CHART 6 · Avg Latency Trend (Line with fill) ─────────── */
    (function () {
      const el = document.getElementById('chartLatencyTrend');
      if (!el) return;

      new Chart(el, {
        type: 'line',
        data: {
          labels  : LAT_VERSIONS,
          datasets: [{
            label               : 'Avg Latency (ms)',
            data                : latencyData,
            borderColor         : C.cyan,
            backgroundColor     : C.a(C.cyan, 0.12),
            borderWidth         : 2,
            pointRadius         : 4,
            pointHoverRadius    : 6,
            pointBackgroundColor: C.cyan,
            tension             : 0.4,
            fill                : true
          }]
        },
        options: {
          responsive: true, maintainAspectRatio: false,
          plugins: {
            legend : { display: false },
            tooltip: { ...tooltip(), callbacks: {
              label: ctx => ` ${ctx.parsed.y} ms`
            }}
          },
          scales: {
            x: xScale(),
            y: {
              ...yScale('Latency (ms)'),
              ticks: { color: tickColor(), font: { size: 11 }, callback: v => v + ' ms' }
            }
          }
        }
      });
    })();

    /* ── TABLE · Recent Datasets ──────────────────────────────── */
    (function () {
      const tbody = document.getElementById('ovTableBody');
      if (!tbody) return;

      const sorted = [...datasets].sort(
        (a, b) => new Date(b.createdAt) - new Date(a.createdAt)
      );

      const licBadge = status => {
        const cls = {
          approved : 'ov-badge-approved',
          in_review: 'ov-badge-pending',
          draft    : 'ov-badge-draft',
          rejected : 'ov-badge-rejected'
        };
        const lbl = status.replace(/_/g, ' ').replace(/\b\w/g, c => c.toUpperCase());
        return `<span class="ov-badge ${cls[status] || 'ov-badge-draft'}">${lbl}</span>`;
      };

      const mosBar = mos => {
        const pct   = Math.min(100, ((mos - 1) / 4) * 100).toFixed(0);
        const color = mos >= 4.0 ? 'var(--ov-green)'
                    : mos >= 3.3 ? 'var(--ov-amber)' : 'var(--ov-red)';
        return `<div class="ov-mos-wrap">
          <span style="min-width:30px;text-align:right;font-variant-numeric:tabular-nums">${mos}</span>
          <div class="ov-mos-track">
            <div class="ov-mos-fill" style="width:${pct}%;background:${color}"></div>
          </div>
        </div>`;
      };

      tbody.innerHTML = sorted.map(d => `
        <tr>
          <td style="font-size:12px;font-weight:600">${d.name}</td>
          <td><span class="ov-lang-pill">${d.langCode.toUpperCase()}</span></td>
          <td style="text-align:right;font-variant-numeric:tabular-nums;color:var(--ov-muted)">
            ${d.totalClips.toLocaleString()}</td>
          <td style="text-align:right;font-variant-numeric:tabular-nums;color:var(--ov-muted)">
            ${d.totalHours.toFixed(1)}h</td>
          <td>${mosBar(d.mos)}</td>
          <td>${licBadge(d.status)}</td>
          <td style="color:var(--ov-muted);font-size:11px">${d.createdAt}</td>
        </tr>`).join('');

      if (typeof $ !== 'undefined' && $.fn && $.fn.DataTable) {
        $('#tblOverview').DataTable({
          pageLength : 7,
          lengthMenu : [7, 10, 20],
          order      : [[6, 'desc']],
          language   : {
            search           : '',
            searchPlaceholder: 'Search datasets…',
            lengthMenu       : 'Show _MENU_',
            info             : '_START_–_END_ of _TOTAL_',
            paginate         : { previous: '‹', next: '›' }
          },
          columnDefs: [{ targets: [2, 3], className: 'dt-right' }]
        });
      }
    })();

    /* ── PARTICLE CANVAS · pure Canvas 2D, no Three.js needed ─── */
    (function () {
      const canvas = document.getElementById('ovParticleCanvas');
      if (!canvas) return;

      const ctx  = canvas.getContext('2d');
      let W, H, particles;

      function resize() {
        W = canvas.width  = window.innerWidth;
        H = canvas.height = window.innerHeight;
      }
      function mkDot() {
        return {
          x : Math.random() * W,
          y : Math.random() * H,
          r : 1 + Math.random() * 1.5,
          vx: (Math.random() - .5) * 0.3,
          vy: (Math.random() - .5) * 0.3,
          op: 0.3 + Math.random() * 0.5
        };
      }

      resize();
      particles = Array.from({ length: 60 }, mkDot);
      window.addEventListener('resize', resize);

      (function draw() {
        ctx.clearRect(0, 0, W, H);
        const col = isDark() ? '99,102,241' : '79,70,229';

        for (let i = 0; i < particles.length; i++) {
          for (let j = i + 1; j < particles.length; j++) {
            const dx = particles[i].x - particles[j].x;
            const dy = particles[i].y - particles[j].y;
            const d  = Math.sqrt(dx * dx + dy * dy);
            if (d < 120) {
              ctx.beginPath();
              ctx.strokeStyle = `rgba(${col},${(1 - d / 120) * 0.15})`;
              ctx.lineWidth   = 0.6;
              ctx.moveTo(particles[i].x, particles[i].y);
              ctx.lineTo(particles[j].x, particles[j].y);
              ctx.stroke();
            }
          }
        }

        particles.forEach(p => {
          ctx.beginPath();
          ctx.arc(p.x, p.y, p.r, 0, Math.PI * 2);
          ctx.fillStyle = `rgba(${col},${p.op})`;
          ctx.fill();
          p.x += p.vx; p.y += p.vy;
          if (p.x < 0 || p.x > W) p.vx *= -1;
          if (p.y < 0 || p.y > H) p.vy *= -1;
        });

        requestAnimationFrame(draw);
      })();
    })();

  } /* ── end init() ─────────────────────────────────────────── */

  /* ══════════════════════════════════════════════════════════════
     SAFE BOOT
     Guarantees:
       1. DOM is fully parsed before touching getElementById
       2. Chart.js global exists before calling new Chart()
     Polls every 100ms for up to 5 seconds for Chart.js.
  ═══════════════════════════════════════════════════════════════ */
  function waitForChartJs(cb, attempts) {
    attempts = attempts || 0;
    if (typeof Chart !== 'undefined') {
      cb();
    } else if (attempts < 50) {
      setTimeout(function () { waitForChartJs(cb, attempts + 1); }, 100);
    } else {
      console.error('[overview.js] Chart.js not available after 5s — charts skipped.');
    }
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', function () {
      waitForChartJs(init);
    });
  } else {
    /* DOM already ready (script loaded with defer or at bottom of body) */
    waitForChartJs(init);
  }

})();