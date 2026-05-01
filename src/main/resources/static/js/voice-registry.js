/* ═══════════════════════════════════════════════════════════════
   voice-registry.js — Hardcoded seed + Chart.js 4 charts
   + DataTables  |  TTS Portal — Cyfuture AI
   FIX: DOMContentLoaded guard, no annotation plugin dependency,
        threshold lines drawn as extra dataset, canvas sized correctly
═══════════════════════════════════════════════════════════════ */

/* ── Theme helpers ──────────────────────────────────────── */
const VR = (() => {
  const dark = () => document.documentElement.getAttribute('data-theme') !== 'light';

  const C = {
    green   : '#22c55e',  greenA  : 'rgba(34,197,94,0.55)',
    amber   : '#f59e0b',  amberA  : 'rgba(245,158,11,0.55)',
    red     : '#ef4444',  redA    : 'rgba(239,68,68,0.55)',
    accent  : '#6366f1',  accentA : 'rgba(99,102,241,0.55)',
    cyan    : '#06b6d4',  cyanA   : 'rgba(6,182,212,0.55)',
    purple  : '#a855f7',
    pink    : '#ec4899',
    orange  : '#f97316',
    teal    : '#14b8a6',
    slate   : '#64748b',
  };

  const axisColor  = () => dark() ? 'rgba(255,255,255,0.09)' : 'rgba(0,0,0,0.07)';
  const textColor  = () => dark() ? '#9ca3af' : '#6b7280';
  const tooltipBg  = () => dark() ? '#1e2130' : '#ffffff';
  const tooltipBdr = () => dark() ? 'rgba(255,255,255,0.10)' : 'rgba(0,0,0,0.10)';

  const font  = (sz = 11) => ({ family: 'Inter, system-ui, sans-serif', size: sz });

  const tooltip = () => ({
    backgroundColor : tooltipBg(),
    borderColor     : tooltipBdr(),
    borderWidth     : 1,
    titleColor      : dark() ? '#e2e8f0' : '#1e293b',
    bodyColor       : dark() ? '#94a3b8' : '#475569',
    padding         : 10,
    cornerRadius    : 8,
    displayColors   : true,
    boxPadding      : 4,
  });

  const scaleX = (extra = {}) => ({
    grid  : { color: axisColor(), drawBorder: false },
    ticks : { color: textColor(), font: font() },
    border: { dash: [4, 4] },
    ...extra,
  });
  const scaleY = (extra = {}) => ({
    grid  : { color: axisColor(), drawBorder: false },
    ticks : { color: textColor(), font: font() },
    border: { dash: [4, 4] },
    ...extra,
  });
  const legend = (extra = {}) => ({
    labels: {
      color: dark() ? '#d1d5db' : '#374151',
      font : font(11),
      padding: 14,
      usePointStyle: true,
      pointStyleWidth: 10,
    },
    ...extra,
  });

  return { dark, C, axisColor, textColor, tooltip, scaleX, scaleY, legend, font };
})();

/* ══════════════════════════════════════════════════════════════
   SEED DATA — 16 voices
══════════════════════════════════════════════════════════════ */
const VOICE_SEED = [
  { id:'VCR-0001', name:'Ananya',  lang:'Hindi',     accent:'Delhi',     gender:'F', useCase:'Support',     tone:'Warm',         mos:4.51, sim:0.91, latency:320, status:'production', customer:'Airtel' },
  { id:'VCR-0002', name:'Rohan',   lang:'Hindi',     accent:'Mumbai',    gender:'M', useCase:'Sales',       tone:'Confident',    mos:4.38, sim:0.87, latency:295, status:'production', customer:'Jio' },
  { id:'VCR-0003', name:'Priya',   lang:'Tamil',     accent:'Chennai',   gender:'F', useCase:'Support',     tone:'Professional', mos:4.45, sim:0.89, latency:310, status:'production', customer:'TN Govt' },
  { id:'VCR-0004', name:'Vikram',  lang:'Tamil',     accent:'Madurai',   gender:'M', useCase:'Collections', tone:'Assertive',    mos:3.87, sim:0.73, latency:340, status:'staging',    customer:'ICICI Bank' },
  { id:'VCR-0005', name:'Meera',   lang:'Telugu',    accent:'Hyderabad', gender:'F', useCase:'Support',     tone:'Empathetic',   mos:4.29, sim:0.86, latency:285, status:'production', customer:'TSRTC' },
  { id:'VCR-0006', name:'Arjun',   lang:'Telugu',    accent:'Vizag',     gender:'M', useCase:'Sales',       tone:'Energetic',    mos:3.71, sim:0.68, latency:360, status:'draft',      customer:'—' },
  { id:'VCR-0007', name:'Lakshmi', lang:'Kannada',   accent:'Bangalore', gender:'F', useCase:'Support',     tone:'Calm',         mos:4.62, sim:0.93, latency:270, status:'production', customer:'BigBasket' },
  { id:'VCR-0008', name:'Suresh',  lang:'Kannada',   accent:'Mysore',    gender:'M', useCase:'Collections', tone:'Firm',         mos:3.54, sim:0.67, latency:390, status:'retired',    customer:'Bajaj Finance' },
  { id:'VCR-0009', name:'Divya',   lang:'Malayalam', accent:'Kochi',     gender:'F', useCase:'Support',     tone:'Friendly',     mos:4.17, sim:0.82, latency:300, status:'production', customer:'Kerala PWD' },
  { id:'VCR-0010', name:'Ashok',   lang:'Marathi',   accent:'Pune',      gender:'M', useCase:'Sales',       tone:'Persuasive',   mos:4.33, sim:0.85, latency:305, status:'production', customer:'MahaDB' },
  { id:'VCR-0011', name:'Sneha',   lang:'Bengali',   accent:'Kolkata',   gender:'F', useCase:'Support',     tone:'Warm',         mos:4.08, sim:0.79, latency:315, status:'staging',    customer:'WB Govt' },
  { id:'VCR-0012', name:'Ravi',    lang:'Gujarati',  accent:'Ahmedabad', gender:'M', useCase:'Collections', tone:'Neutral',      mos:3.65, sim:0.64, latency:380, status:'retired',    customer:'—' },
  { id:'VCR-0013', name:'Pooja',   lang:'English',   accent:'Neutral',   gender:'F', useCase:'Support',     tone:'Professional', mos:4.71, sim:0.92, latency:265, status:'production', customer:'HDFC Bank' },
  { id:'VCR-0014', name:'Alex',    lang:'English',   accent:'IndE',      gender:'N', useCase:'Sales',       tone:'Confident',    mos:4.58, sim:0.93, latency:278, status:'production', customer:'Razorpay' },
  { id:'VCR-0015', name:'Kavya',   lang:'Hindi',     accent:'Lucknow',   gender:'F', useCase:'Support',     tone:'Empathetic',   mos:3.92, sim:0.76, latency:330, status:'staging',    customer:'UP Govt' },
  { id:'VCR-0016', name:'Kiran',   lang:'Telugu',    accent:'Tirupati',  gender:'N', useCase:'Collections', tone:'Assertive',    mos:3.48, sim:0.61, latency:415, status:'draft',      customer:'—' },
];

/* ══════════════════════════════════════════════════════════════
   HELPERS
══════════════════════════════════════════════════════════════ */
function mkChart(id, config) {
  const el = document.getElementById(id);
  if (!el) { console.warn('voice-registry: canvas not found —', id); return null; }
  // Destroy any previous instance on the same canvas
  const existing = Chart.getChart(el);
  if (existing) existing.destroy();
  return new Chart(el, config);
}

function mosColor(v)  { return v >= 4.0 ? VR.C.green  : v >= 3.3 ? VR.C.amber  : VR.C.red; }
function mosColorA(v) { return v >= 4.0 ? VR.C.greenA : v >= 3.3 ? VR.C.amberA : VR.C.redA; }
function simColor(v)  { return v >= 0.85 ? VR.C.green : v >= 0.75 ? VR.C.amber : VR.C.red; }
function simColorA(v) { return v >= 0.85 ? VR.C.greenA : v >= 0.75 ? VR.C.amberA : VR.C.redA; }

/* ══════════════════════════════════════════════════════════════
   CHART 1 — Voice Status Doughnut
══════════════════════════════════════════════════════════════ */
function buildChartVoiceStatus() {
  const c = { production:0, staging:0, draft:0, retired:0 };
  VOICE_SEED.forEach(v => c[v.status]++);

  mkChart('chartVoiceStatus', {
    type: 'doughnut',
    data: {
      labels: ['Production','Staging','Draft','Retired'],
      datasets: [{
        data: [c.production, c.staging, c.draft, c.retired],
        backgroundColor: ['rgba(34,197,94,0.80)','rgba(245,158,11,0.80)','rgba(99,102,241,0.80)','rgba(107,114,128,0.55)'],
        borderColor    : ['rgba(34,197,94,0.2)','rgba(245,158,11,0.2)','rgba(99,102,241,0.2)','rgba(107,114,128,0.2)'],
        borderWidth: 1, hoverOffset: 8,
      }],
    },
    options: {
      responsive: true, maintainAspectRatio: false,
      cutout: '66%',
      plugins: {
        legend : { ...VR.legend(), position: 'bottom' },
        tooltip: { ...VR.tooltip(), callbacks: { label: ctx => ` ${ctx.label}: ${ctx.parsed} voices` } },
      },
    },
  });
}

/* ══════════════════════════════════════════════════════════════
   CHART 2 — MOS per Voice (threshold as extra dataset line)
══════════════════════════════════════════════════════════════ */
function buildChartVoiceMOS() {
  const sorted = [...VOICE_SEED].sort((a, b) => b.mos - a.mos);
  const n = sorted.length;

  mkChart('chartVoiceMOS', {
    type: 'bar',
    data: {
      labels: sorted.map(v => v.name),
      datasets: [
        {
          type: 'bar',
          label: 'MOS Score',
          data : sorted.map(v => v.mos),
          backgroundColor: sorted.map(v => mosColorA(v.mos)),
          borderColor    : sorted.map(v => mosColor(v.mos)),
          borderWidth: 1.5, borderRadius: 5, borderSkipped: false,
          order: 2,
        },
        {
          type: 'line',
          label: 'Target 4.0',
          data : Array(n).fill(4.0),
          borderColor: 'rgba(34,197,94,0.6)',
          borderWidth: 1.5,
          borderDash: [6, 4],
          pointRadius: 0,
          fill: false,
          tension: 0,
          order: 1,
        },
      ],
    },
    options: {
      responsive: true, maintainAspectRatio: false,
      plugins: {
        legend: { ...VR.legend(), labels: { ...VR.legend().labels,
          filter: item => item.text !== undefined
        }},
        tooltip: { ...VR.tooltip(),
          callbacks: {
            label     : ctx => ctx.dataset.type === 'line' ? ` Threshold: 4.0` : ` MOS: ${ctx.parsed.y.toFixed(2)}`,
            afterLabel : ctx => {
              if (ctx.dataset.type === 'line') return '';
              const v = sorted[ctx.dataIndex];
              return `  ${v.lang} · ${v.status} · ${v.customer}`;
            },
          }
        },
      },
      scales: {
        x: VR.scaleX(),
        y: VR.scaleY({ min: 2.5, max: 5.0,
          ticks: { color: VR.textColor(), font: VR.font(), callback: v => v.toFixed(1) },
        }),
      },
    },
  });
}

/* ══════════════════════════════════════════════════════════════
   CHART 3 — Use Case Pie
══════════════════════════════════════════════════════════════ */
function buildChartUseCase() {
  const c = {};
  VOICE_SEED.forEach(v => { c[v.useCase] = (c[v.useCase] || 0) + 1; });
  const keys = Object.keys(c);

  mkChart('chartVoiceUseCase2', {
    type: 'pie',
    data: {
      labels: keys,
      datasets: [{
        data: keys.map(k => c[k]),
        backgroundColor: ['rgba(6,182,212,0.75)','rgba(99,102,241,0.75)','rgba(245,158,11,0.75)'],
        borderColor    : ['rgba(6,182,212,0.2)','rgba(99,102,241,0.2)','rgba(245,158,11,0.2)'],
        borderWidth: 1, hoverOffset: 6,
      }],
    },
    options: {
      responsive: true, maintainAspectRatio: false,
      plugins: {
        legend : { ...VR.legend(), position: 'bottom' },
        tooltip: { ...VR.tooltip(),
          callbacks: { label: ctx => ` ${ctx.label}: ${ctx.parsed} (${Math.round(ctx.parsed/VOICE_SEED.length*100)}%)` }
        },
      },
    },
  });
}

/* ══════════════════════════════════════════════════════════════
   CHART 4 — Gender Doughnut
══════════════════════════════════════════════════════════════ */
function buildChartGender() {
  const c = { F:0, M:0, N:0 };
  VOICE_SEED.forEach(v => c[v.gender]++);

  mkChart('chartVoiceGender', {
    type: 'doughnut',
    data: {
      labels: ['Female','Male','Neutral'],
      datasets: [{
        data: [c.F, c.M, c.N],
        backgroundColor: ['rgba(236,72,153,0.75)','rgba(6,182,212,0.75)','rgba(168,85,247,0.75)'],
        borderColor    : ['rgba(236,72,153,0.2)','rgba(6,182,212,0.2)','rgba(168,85,247,0.2)'],
        borderWidth: 1, hoverOffset: 6,
      }],
    },
    options: {
      responsive: true, maintainAspectRatio: false,
      cutout: '60%',
      plugins: {
        legend : { ...VR.legend(), position: 'bottom' },
        tooltip: { ...VR.tooltip() },
      },
    },
  });
}

/* ══════════════════════════════════════════════════════════════
   CHART 5 — Voices by Language Bar
══════════════════════════════════════════════════════════════ */
function buildChartLang() {
  const c = {};
  VOICE_SEED.forEach(v => { c[v.lang] = (c[v.lang] || 0) + 1; });
  const labels = Object.keys(c).sort((a, b) => c[b] - c[a]);
  const palette = [
    VR.C.accent, VR.C.cyan, VR.C.green, VR.C.amber,
    VR.C.pink, VR.C.purple, VR.C.orange, VR.C.teal,
  ];

  mkChart('chartVoiceLang', {
    type: 'bar',
    data: {
      labels,
      datasets: [{
        label: 'Voices',
        data : labels.map(l => c[l]),
        backgroundColor: labels.map((_, i) => palette[i % palette.length] + '99'),
        borderColor    : labels.map((_, i) => palette[i % palette.length]),
        borderWidth: 1.5, borderRadius: 5, borderSkipped: false,
      }],
    },
    options: {
      responsive: true, maintainAspectRatio: false,
      plugins: {
        legend : { display: false },
        tooltip: { ...VR.tooltip() },
      },
      scales: {
        x: VR.scaleX(),
        y: VR.scaleY({ ticks: { color: VR.textColor(), font: VR.font(), stepSize: 1 } }),
      },
    },
  });
}

/* ══════════════════════════════════════════════════════════════
   CHART 6 — Speaker Similarity Horizontal Bar
   threshold drawn as extra line dataset (no plugin needed)
══════════════════════════════════════════════════════════════ */
function buildChartSpeakerSim() {
  const sorted = [...VOICE_SEED].sort((a, b) => b.sim - a.sim);
  const n = sorted.length;

  mkChart('chartSpeakerSim', {
    type: 'bar',
    data: {
      labels: sorted.map(v => `${v.name} (${v.lang})`),
      datasets: [
        {
          type: 'bar',
          label: 'Speaker Similarity',
          data : sorted.map(v => v.sim),
          backgroundColor: sorted.map(v => simColorA(v.sim)),
          borderColor    : sorted.map(v => simColor(v.sim)),
          borderWidth: 1.5, borderRadius: 4, borderSkipped: false,
          indexAxis: 'y',
          order: 2,
        },
        {
          type: 'line',
          label: '0.80 Threshold',
          data : Array(n).fill(0.80),
          borderColor: 'rgba(99,102,241,0.65)',
          borderWidth: 1.5,
          borderDash: [5, 4],
          pointRadius: 0,
          fill: false,
          tension: 0,
          indexAxis: 'y',
          xAxisID: 'x',
          order: 1,
        },
      ],
    },
    options: {
      indexAxis: 'y',
      responsive: true, maintainAspectRatio: false,
      plugins: {
        legend: { ...VR.legend() },
        tooltip: { ...VR.tooltip(),
          callbacks: {
            label: ctx => ctx.dataset.type === 'line'
              ? ` Threshold: 0.80`
              : ` Similarity: ${ctx.parsed.x.toFixed(2)}`,
            afterLabel: ctx => {
              if (ctx.dataset.type === 'line') return '';
              const v = sorted[ctx.dataIndex];
              return `  Status: ${v.status}  ·  Customer: ${v.customer}`;
            },
          }
        },
      },
      scales: {
        x: VR.scaleX({ min: 0.40, max: 1.0,
          ticks: { color: VR.textColor(), font: VR.font(), callback: v => v.toFixed(2) },
        }),
        y: VR.scaleY(),
      },
    },
  });
}

/* ══════════════════════════════════════════════════════════════
   DATATABLE RENDER
══════════════════════════════════════════════════════════════ */
function statusBadge(s) {
  const map = {
    production: ['vr-badge-prod',    '● Production'],
    staging    : ['vr-badge-staging', '◐ Staging'],
    draft      : ['vr-badge-draft',   '○ Draft'],
    retired    : ['vr-badge-retired', '✕ Retired'],
  };
  const [cls, label] = map[s] || ['vr-badge-retired', s];
  return `<span class="vr-tbl-badge ${cls}">${label}</span>`;
}
function genderCell(g) {
  return g === 'F' ? `<span class="vr-gender-f">♀ Female</span>`
       : g === 'M' ? `<span class="vr-gender-m">♂ Male</span>`
       :              `<span class="vr-gender-n">⚥ Neutral</span>`;
}
function ucChip(u) {
  const cls = u === 'Support' ? 'vr-uc-support' : u === 'Sales' ? 'vr-uc-sales' : 'vr-uc-col';
  return `<span class="vr-uc-chip ${cls}">${u}</span>`;
}
function mosCell(v) {
  const c = v >= 4.0 ? '#22c55e' : v >= 3.3 ? '#f59e0b' : '#ef4444';
  return `<span style="color:${c};font-weight:700;font-variant-numeric:tabular-nums">${v.toFixed(2)}</span>`;
}
function simCell(v) {
  const c = v >= 0.85 ? '#22c55e' : v >= 0.75 ? '#f59e0b' : '#ef4444';
  return `<div class="vr-sim-cell">
    <div class="vr-sim-track"><div class="vr-sim-fill" style="width:${Math.round(v*100)}%;background:${c}"></div></div>
    <span style="color:${c};font-weight:700;font-variant-numeric:tabular-nums">${v.toFixed(2)}</span>
  </div>`;
}

function buildTable() {
  const tbody = document.getElementById('voiceTableBody');
  if (!tbody) return;
  VOICE_SEED.forEach(v => {
    const tr = document.createElement('tr');
    tr.innerHTML = `
      <td><span class="vr-voice-id">${v.id}</span></td>
      <td>
        <div class="vr-name-wrap">
          <div class="vr-avatar">${v.name.charAt(0)}</div>
          <div>
            <div class="vr-voice-name">${v.name}</div>
            <div class="vr-voice-accent">${v.accent}</div>
          </div>
        </div>
      </td>
      <td><span class="vr-lang-pill">${v.lang.substring(0,2).toUpperCase()}</span></td>
      <td style="font-size:11.5px;color:var(--vr-muted)">${v.accent}</td>
      <td>${genderCell(v.gender)}</td>
      <td>${ucChip(v.useCase)}</td>
      <td class="vr-tone-cell">${v.tone}</td>
      <td>${mosCell(v.mos)}</td>
      <td>${simCell(v.sim)}</td>
      <td style="font-size:11.5px;font-variant-numeric:tabular-nums;color:var(--vr-muted)">${v.latency} ms</td>
      <td>${statusBadge(v.status)}</td>
      <td class="vr-customer-cell">${v.customer}</td>
    `;
    tbody.appendChild(tr);
  });

  if (window.$ && $.fn.DataTable) {
    $('#tblVoices').DataTable({
      pageLength : 10,
      lengthMenu : [10, 25, 50],
      order      : [[7, 'desc']],
      columnDefs : [{ orderable: false, targets: [8] }],
      language   : {
        search           : '',
        searchPlaceholder: 'Search voices…',
        lengthMenu       : '_MENU_ rows',
        info             : 'Showing _START_–_END_ of _TOTAL_ voices',
        paginate         : { previous: '‹', next: '›' },
      },
    });
  }
}

/* ══════════════════════════════════════════════════════════════
   INIT — guarded against Chart.js not yet defined
   Uses DOMContentLoaded when the script is deferred OR runs
   immediately if DOM is already parsed (jsp:include case)
══════════════════════════════════════════════════════════════ */
function vrInit() {
  if (typeof Chart === 'undefined') {
    console.error('voice-registry.js: Chart.js is not loaded. Ensure chart.umd.min.js loads before this script.');
    return;
  }
  try { buildChartVoiceStatus();  } catch(e) { console.error('chartVoiceStatus', e); }
  try { buildChartVoiceMOS();     } catch(e) { console.error('chartVoiceMOS', e); }
  try { buildChartUseCase();      } catch(e) { console.error('chartUseCase', e); }
  try { buildChartGender();       } catch(e) { console.error('chartGender', e); }
  try { buildChartLang();         } catch(e) { console.error('chartLang', e); }
  try { buildChartSpeakerSim();   } catch(e) { console.error('chartSpeakerSim', e); }
  try { buildTable();             } catch(e) { console.error('buildTable', e); }
}

// If the DOM is already ready (script tag inside body/JSP include), run now.
// If it's deferred or in <head>, wait for DOMContentLoaded.
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', vrInit);
} else {
  vrInit();
}