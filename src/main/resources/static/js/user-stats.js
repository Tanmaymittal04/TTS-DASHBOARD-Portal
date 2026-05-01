(function () {
  'use strict';

  /* ═══════════════════════════════════════════════════════
     CONFIG / PALETTE
  ═══════════════════════════════════════════════════════ */
  const isDark = () =>
    (document.documentElement.getAttribute('data-theme') || 'dark') === 'dark';

  const PAL = ['#6366f1','#22c55e','#06b6d4','#f59e0b','#a855f7',
               '#ec4899','#f97316','#ef4444','#14b8a6','#3b82f6'];

  const a = (hex, op) => hex + Math.round(op * 255).toString(16).padStart(2,'0');

  const gridColor  = () => isDark() ? 'rgba(255,255,255,0.06)' : 'rgba(0,0,0,0.07)';
  const tickColor  = () => isDark() ? '#6b7280' : '#9ca3af';
  const tooltipBg  = () => isDark() ? '#1c1f2e' : '#ffffff';
  const tooltipBdr = () => isDark() ? '#2e3150' : '#e5e7eb';

  const tooltipCfg = () => ({
    backgroundColor: tooltipBg(), borderColor: tooltipBdr(), borderWidth:1,
    titleColor: isDark() ? '#d8dae8' : '#1a1d2e', bodyColor: tickColor(),
    padding:9, cornerRadius:6, titleFont:{size:11,weight:'600'}, bodyFont:{size:10}
  });

  /* ═══════════════════════════════════════════════════════
     SEED DATA GENERATOR
     Hierarchy: User → Language → Batch → Video → Chunks
  ═══════════════════════════════════════════════════════ */
  const LANGS = ['Hindi','Telugu','Tamil','Kannada','Malayalam',
                 'Marathi','Bengali','Gujarati','Punjabi','Urdu'];

  const ACCENTS = {
    Hindi:['Delhi','UP','Bihar'],     Telugu:['Andhra','Telangana'],
    Tamil:['Chennai','Madurai'],      Kannada:['Bengaluru','Mysuru'],
    Malayalam:['Kochi','Trivandrum'], Marathi:['Pune','Mumbai'],
    Bengali:['Kolkata','Dhaka'],      Gujarati:['Ahmedabad','Surat'],
    Punjabi:['Amritsar','Ludhiana'],  Urdu:['Hyderabad','Lucknow']
  };

  const BATCH_STATUSES  = ['completed','in_progress','pending','qc_review'];
  const CHUNK_STATUSES  = ['clean','noisy','rejected','pending'];
  const PIPELINE_STAGES = ['intake','qc','scored','training','approved'];

  /* Deterministic pseudo-random from a seed */
  function seededRand(seed) {
    let s = seed;
    return function() {
      s = (s * 1664525 + 1013904223) & 0xffffffff;
      return (s >>> 0) / 0xffffffff;
    };
  }

  function buildChunks(batchId, videoId, count, rand) {
    return Array.from({ length: count }, (_, ci) => {
      const dur    = +(3 + rand() * 27).toFixed(1);   // 3–30 sec
      const status = CHUNK_STATUSES[Math.floor(rand() * CHUNK_STATUSES.length)];
      return {
        chunkId  : `${videoId}-C${String(ci + 1).padStart(3,'0')}`,
        startSec : +(ci * 30).toFixed(1),
        endSec   : +(ci * 30 + dur).toFixed(1),
        dur,
        snr      : +(15 + rand() * 25).toFixed(1),   // dB
        status,
        waveform : Array.from({length:10}, () => +(rand() * 100).toFixed(0))
      };
    });
  }

  function buildBatches(userId, lang, batchCount, rand) {
    return Array.from({ length: batchCount }, (_, bi) => {
      const batchId  = `B-${userId}-${lang.slice(0,3).toUpperCase()}-${String(bi+1).padStart(2,'0')}`;
      const videoId  = `VID-${batchId.replace('B-','')}`;
      const chunkCnt = 5 + Math.floor(rand() * 16);  // 5–20 chunks
      const chunks   = buildChunks(batchId, videoId, chunkCnt, rand);
      const rawHrs   = +(0.5 + rand() * 4.5).toFixed(2);
      const cleanHrs = +(rawHrs * (0.65 + rand() * 0.30)).toFixed(2);
      const status   = BATCH_STATUSES[Math.floor(rand() * BATCH_STATUSES.length)];
      const stage    = PIPELINE_STAGES[Math.floor(rand() * PIPELINE_STAGES.length)];
      const clips    = Math.round(rawHrs * (380 + rand() * 200));
      return { batchId, videoId, rawHrs, cleanHrs, clips, chunkCnt, chunks,
               status, stage, accent: ACCENTS[lang][bi % ACCENTS[lang].length] };
    });
  }

  function buildUsers(count) {
    return Array.from({ length: count }, (_, ui) => {
      const userId   = `USR-${String(ui + 1).padStart(3,'0')}`;
      const userName = `User ${ui + 1}`;
      const rand     = seededRand(ui * 2053 + 17);
      const color    = PAL[ui % PAL.length];

      /* each user gets 2–5 languages */
      const langCount = 2 + Math.floor(rand() * 4);
      const userLangs = [...LANGS].sort(() => rand() - 0.5).slice(0, langCount);

      const languages = userLangs.map(lang => {
        const batchCount = 2 + Math.floor(rand() * 4);
        const batches    = buildBatches(userId, lang, batchCount, rand);
        const totalRaw   = +batches.reduce((s, b) => s + b.rawHrs, 0).toFixed(2);
        const totalClean = +batches.reduce((s, b) => s + b.cleanHrs, 0).toFixed(2);
        const totalClips = batches.reduce((s, b) => s + b.clips, 0);
        const totalChunks= batches.reduce((s, b) => s + b.chunkCnt, 0);
        return { lang, batches, totalRaw, totalClean, totalClips, totalChunks };
      });

      const totalRaw    = +languages.reduce((s, l) => s + l.totalRaw, 0).toFixed(2);
      const totalClean  = +languages.reduce((s, l) => s + l.totalClean, 0).toFixed(2);
      const totalClips  = languages.reduce((s, l) => s + l.totalClips, 0);
      const totalBatches= languages.reduce((s, l) => s + l.batches.length, 0);
      const totalChunks = languages.reduce((s, l) => s + l.totalChunks, 0);

      return { userId, userName, color, languages,
               totalRaw, totalClean, totalClips, totalBatches, totalChunks };
    });
  }

  const USERS = buildUsers(10);

  /* ═══════════════════════════════════════════════════════
     BADGE / CHIP HELPERS
  ═══════════════════════════════════════════════════════ */
  const batchStatusStyle = {
    completed   : 'background:rgba(34,197,94,.14);color:#22c55e;border-color:rgba(34,197,94,.30)',
    in_progress : 'background:rgba(99,102,241,.14);color:#6366f1;border-color:rgba(99,102,241,.30)',
    pending     : 'background:rgba(107,114,128,.12);color:#9ca3af;border-color:rgba(107,114,128,.25)',
    qc_review   : 'background:rgba(6,182,212,.14);color:#06b6d4;border-color:rgba(6,182,212,.30)'
  };
  const chunkStatusStyle = {
    clean    : 'background:rgba(34,197,94,.14);color:#22c55e;border-color:rgba(34,197,94,.30)',
    noisy    : 'background:rgba(245,158,11,.14);color:#f59e0b;border-color:rgba(245,158,11,.30)',
    rejected : 'background:rgba(239,68,68,.14);color:#ef4444;border-color:rgba(239,68,68,.30)',
    pending  : 'background:rgba(107,114,128,.12);color:#9ca3af;border-color:rgba(107,114,128,.25)'
  };

  const badge = (text, styleStr) =>
    `<span style="display:inline-flex;align-items:center;font-size:9.5px;font-weight:700;
      text-transform:capitalize;letter-spacing:.04em;padding:2px 8px;border-radius:20px;
      border:1px solid;${styleStr}">${text.replace('_',' ')}</span>`;

  const progBar = (val, max, color) => {
    const pct = Math.min(100, (val / max) * 100).toFixed(1);
    return `<div class="us-prog-wrap">
      <div class="us-prog-track">
        <div class="us-prog-fill" style="width:${pct}%;background:${color}"></div>
      </div>
      <span class="us-prog-label">${val}</span>
    </div>`;
  };

  const waveSpan = (arr) =>
    `<span class="us-wave">${arr.map(v =>
      `<span style="height:${Math.max(2,Math.round(v*14/100))}px"></span>`
    ).join('')}</span>`;

  /* ═══════════════════════════════════════════════════════
     RENDER CHUNK ROWS (level 3)
  ═══════════════════════════════════════════════════════ */
  function renderChunks(chunks) {
    return `
    <tr class="us-chunk-row visible">
      <td colspan="99" style="padding:0">
        <div class="us-chunk-inner">
          <table class="us-chunk-table" style="margin:6px 0 8px">
            <thead>
              <tr>
                <th>Chunk ID</th><th>Start</th><th>End</th>
                <th>Duration (s)</th><th>SNR (dB)</th>
                <th>Waveform</th><th>Status</th>
              </tr>
            </thead>
            <tbody>
              ${chunks.map(c => `
              <tr>
                <td><span class="us-chunk-id">${c.chunkId}</span></td>
                <td style="color:var(--di-muted)">${c.startSec}s</td>
                <td style="color:var(--di-muted)">${c.endSec}s</td>
                <td style="font-variant-numeric:tabular-nums">${c.dur}s</td>
                <td style="font-variant-numeric:tabular-nums;color:${
                  c.snr >= 30 ? 'var(--di-green)' : c.snr >= 20 ? 'var(--di-amber)' : 'var(--di-red)'
                }">${c.snr}</td>
                <td>${waveSpan(c.waveform)}</td>
                <td>${badge(c.status, chunkStatusStyle[c.status] || '')}</td>
              </tr>`).join('')}
            </tbody>
          </table>
        </div>
      </td>
    </tr>`;
  }

  /* ═══════════════════════════════════════════════════════
     RENDER BATCH ROWS (level 2)
  ═══════════════════════════════════════════════════════ */
  function renderBatches(batches) {
    const maxRaw = Math.max(...batches.map(b => b.rawHrs), 0.1);
    return batches.map((b, bi) => {
      const bRowId   = `br-${b.batchId.replace(/[^a-z0-9]/gi,'_')}`;
      const chRowId  = `cr-${b.batchId.replace(/[^a-z0-9]/gi,'_')}`;
      return `
      <tr class="us-batch-row visible" id="${bRowId}">
        <td colspan="99" style="padding:0">
          <div class="us-batch-inner">
            <table class="us-batch-table">
              <thead>
                <tr>
                  <th>Batch ID</th><th>Video ID</th><th>Accent</th>
                  <th>Raw Hrs</th><th>Clean Hrs</th><th>Clips</th>
                  <th>Chunks</th><th>Stage</th><th>Status</th><th>Chunks ▾</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td><span class="us-mono">${b.batchId}</span></td>
                  <td><span class="us-vid-id">${b.videoId}</span></td>
                  <td style="font-size:10.5px;color:var(--di-muted)">${b.accent}</td>
                  <td>${progBar(b.rawHrs, maxRaw, '#06b6d4')}</td>
                  <td>${progBar(b.cleanHrs, maxRaw, '#22c55e')}</td>
                  <td style="font-variant-numeric:tabular-nums;font-size:11px">${b.clips.toLocaleString()}</td>
                  <td style="text-align:center;font-weight:700">${b.chunkCnt}</td>
                  <td>${badge(b.stage, batchStatusStyle[b.status] || '')}</td>
                  <td>${badge(b.status, batchStatusStyle[b.status] || '')}</td>
                  <td>
                    <span class="us-expand-btn" id="${chRowId}-btn"
                      onclick="usToggleChunks('${chRowId}',this)">
                      <i class="us-arr">›</i> ${b.chunkCnt} chunks
                    </span>
                  </td>
                </tr>
                <tr class="us-chunk-row" id="${chRowId}">
                  <td colspan="99" style="padding:0">
                    <div class="us-chunk-inner">
                      <table class="us-chunk-table" style="margin:6px 0 8px">
                        <thead>
                          <tr>
                            <th>Chunk ID</th><th>Start</th><th>End</th>
                            <th>Duration (s)</th><th>SNR (dB)</th>
                            <th>Waveform</th><th>Status</th>
                          </tr>
                        </thead>
                        <tbody>
                          ${b.chunks.map(c => `
                          <tr>
                            <td><span class="us-chunk-id">${c.chunkId}</span></td>
                            <td style="color:var(--di-muted)">${c.startSec}s</td>
                            <td style="color:var(--di-muted)">${c.endSec}s</td>
                            <td style="font-variant-numeric:tabular-nums">${c.dur}s</td>
                            <td style="font-variant-numeric:tabular-nums;color:${
                              c.snr >= 30 ? 'var(--di-green)' : c.snr >= 20 ? 'var(--di-amber)' : 'var(--di-red)'
                            }">${c.snr}</td>
                            <td>${waveSpan(c.waveform)}</td>
                            <td>${badge(c.status, chunkStatusStyle[c.status] || '')}</td>
                          </tr>`).join('')}
                        </tbody>
                      </table>
                    </div>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </td>
      </tr>`;
    }).join('');
  }

  /* ═══════════════════════════════════════════════════════
     RENDER LANGUAGE TABLE (level 1, inside card)
  ═══════════════════════════════════════════════════════ */
  function renderLangTable(user) {
    const maxRaw = Math.max(...user.languages.map(l => l.totalRaw), 0.1);
    const rows = user.languages.map((l, li) => {
      const langRowId   = `lr-${user.userId}-${l.lang}`.replace(/[^a-z0-9_]/gi,'_');
      const batchAreaId = `ba-${langRowId}`;
      const yld = ((l.totalClean / l.totalRaw) * 100).toFixed(1);
      const yldColor = yld >= 85 ? 'var(--di-green)' : yld >= 75 ? 'var(--di-amber)' : 'var(--di-red)';

      return `
      <!-- Language row -->
      <tr id="${langRowId}">
        <td><span class="us-lang-pill">${l.lang.slice(0,3).toUpperCase()}</span></td>
        <td style="font-weight:600">${l.lang}</td>
        <td style="text-align:right;font-variant-numeric:tabular-nums">${l.batches.length}</td>
        <td>${progBar(l.totalRaw, maxRaw, '#06b6d4')}</td>
        <td>${progBar(l.totalClean, maxRaw, '#22c55e')}</td>
        <td style="text-align:center;font-weight:700;color:${yldColor}">${yld}%</td>
        <td style="text-align:right;font-variant-numeric:tabular-nums">${l.totalClips.toLocaleString()}</td>
        <td style="text-align:right;font-variant-numeric:tabular-nums">${l.totalChunks}</td>
        <td>
          <span class="us-expand-btn" id="${batchAreaId}-btn"
            onclick="usToggleBatches('${batchAreaId}','${user.userId}','${l.lang}',this)">
            <i class="us-arr">›</i> ${l.batches.length} batches
          </span>
        </td>
      </tr>
      <!-- Batch expansion area -->
      <tr class="us-batch-row" id="${batchAreaId}">
        <td colspan="99" style="padding:0" id="${batchAreaId}-content">
          <!-- batches rendered on first expand -->
        </td>
      </tr>`;
    }).join('');

    return `
    <div class="us-lang-table-wrap">
      <table class="us-lang-table">
        <thead>
          <tr>
            <th></th><th>Language</th><th style="text-align:right">Batches</th>
            <th>Raw Hrs</th><th>Clean Hrs</th><th style="text-align:center">Yield %</th>
            <th style="text-align:right">Clips</th>
            <th style="text-align:right">Chunks</th><th>Detail</th>
          </tr>
        </thead>
        <tbody>${rows}</tbody>
      </table>
    </div>`;
  }

  /* ═══════════════════════════════════════════════════════
     RENDER MINI CHART (per-user language bar chart)
  ═══════════════════════════════════════════════════════ */
  function renderMiniChart(user, canvasId) {
    const labels     = user.languages.map(l => l.lang.slice(0,3).toUpperCase());
    const rawData    = user.languages.map(l => l.totalRaw);
    const cleanData  = user.languages.map(l => l.totalClean);

    return new Chart(document.getElementById(canvasId), {
      type: 'bar',
      data: {
        labels,
        datasets: [
          {
            label: 'Raw Hrs',
            data: rawData,
            backgroundColor: a('#06b6d4', 0.55),
            borderColor: '#06b6d4',
            borderWidth: 1, borderRadius: 3
          },
          {
            label: 'Clean Hrs',
            data: cleanData,
            backgroundColor: a('#22c55e', 0.70),
            borderColor: '#22c55e',
            borderWidth: 1, borderRadius: 3
          }
        ]
      },
      options: {
        responsive: true, maintainAspectRatio: false,
        interaction: { mode:'index', intersect:false },
        plugins: {
          legend: {
            position:'top', align:'end',
            labels: { boxWidth:8, padding:10, color:tickColor(), font:{size:10} }
          },
          tooltip: { ...tooltipCfg() }
        },
        scales: {
          x: {
            grid: { color:gridColor(), drawBorder:false },
            ticks: { color:tickColor(), font:{size:9}, maxRotation:0 }
          },
          y: {
            grid: { color:gridColor(), drawBorder:false },
            ticks: { color:tickColor(), font:{size:9} },
            beginAtZero: true
          }
        }
      }
    });
  }

  /* ═══════════════════════════════════════════════════════
     RENDER LANGUAGE STAT CHIPS (bottom of card)
  ═══════════════════════════════════════════════════════ */
  function renderLangChips(user) {
    return user.languages.map((l, i) =>
      `<span class="us-lang-stat-chip">
        <span class="dot" style="background:${PAL[i % PAL.length]}"></span>
        ${l.lang} &nbsp;<strong>${l.totalRaw}h</strong>
      </span>`
    ).join('');
  }

  /* ═══════════════════════════════════════════════════════
     RENDER SINGLE USER CARD
  ═══════════════════════════════════════════════════════ */
  function renderUserCard(user) {
    const canvasId = `usChart-${user.userId}`;
    const yld = ((user.totalClean / user.totalRaw) * 100).toFixed(1);

    const card = document.createElement('div');
    card.className = 'us-user-card';
    card.dataset.userId = user.userId;
    card.dataset.langs = user.languages.map(l => l.lang).join(',');

    card.innerHTML = `
    <!-- Header -->
    <div class="us-card-head" onclick="usToggleCard('${user.userId}')">
      <div class="us-avatar" style="--us-color:${user.color}">
        ${user.userName.split(' ').map(w=>w[0]).join('').toUpperCase().slice(0,2)}
      </div>
      <div class="us-card-meta">
        <div class="us-card-name">${user.userName}</div>
        <div class="us-card-sub">${user.userId} &nbsp;·&nbsp; ${user.languages.length} languages &nbsp;·&nbsp; ${user.totalBatches} batches</div>
      </div>
      <div class="us-card-toggle">+</div>
    </div>

    <!-- KPI Strip -->
    <div class="us-kpi-strip">
      <div class="us-kpi-item">
        <span class="us-kpi-label">Raw Hours</span>
        <span class="us-kpi-val">${user.totalRaw}<small>h</small></span>
      </div>
      <div class="us-kpi-item">
        <span class="us-kpi-label">Clean Hours</span>
        <span class="us-kpi-val" style="color:var(--di-green)">${user.totalClean}<small>h</small></span>
      </div>
      <div class="us-kpi-item">
        <span class="us-kpi-label">Yield</span>
        <span class="us-kpi-val" style="color:${
          yld >= 85 ? 'var(--di-green)' : yld >= 75 ? 'var(--di-amber)' : 'var(--di-red)'
        }">${yld}<small>%</small></span>
      </div>
      <div class="us-kpi-item">
        <span class="us-kpi-label">Total Clips</span>
        <span class="us-kpi-val">${(user.totalClips/1000).toFixed(1)}<small>k</small></span>
      </div>
      <div class="us-kpi-item">
        <span class="us-kpi-label">Chunks</span>
        <span class="us-kpi-val">${user.totalChunks}</span>
      </div>
    </div>

    <!-- Mini chart -->
    <div class="us-card-chart">
      <canvas id="${canvasId}"></canvas>
    </div>

    <!-- Language stat chips -->
    <div class="us-lang-stats-row">${renderLangChips(user)}</div>

    <!-- Expanded language panel (hidden by default) -->
    <div class="us-lang-panel" id="ulp-${user.userId}">
      ${renderLangTable(user)}
    </div>`;

    return { card, canvasId };
  }

  /* ═══════════════════════════════════════════════════════
     GLOBAL TOGGLE FUNCTIONS (called from inline onclick)
  ═══════════════════════════════════════════════════════ */
  window.usToggleCard = function(userId) {
    const card = document.querySelector(`.us-user-card[data-user-id="${userId}"]`);
    if (card) card.classList.toggle('expanded');
  };

  window.usToggleBatches = function(areaId, userId, lang, btn) {
    const row     = document.getElementById(areaId);
    const content = document.getElementById(areaId + '-content');
    if (!row) return;

    const isOpen = row.classList.contains('visible');
    if (!isOpen) {
      /* Lazy-render batches on first open */
      if (!content.dataset.rendered) {
        const user   = USERS.find(u => u.userId === userId);
        const langObj= user && user.languages.find(l => l.lang === lang);
        if (langObj) {
          content.innerHTML = `
          <div class="us-batch-inner">
            <table class="us-batch-table">
              <thead>
                <tr>
                  <th>Batch ID</th><th>Video ID</th><th>Accent</th>
                  <th>Raw Hrs</th><th>Clean Hrs</th><th>Clips</th>
                  <th>Chunks</th><th>Stage</th><th>Status</th><th>Chunks ▾</th>
                </tr>
              </thead>
              <tbody>
                ${langObj.batches.map(b => {
                  const maxRaw = Math.max(...langObj.batches.map(x => x.rawHrs), 0.1);
                  const chRowId = `cr-${b.batchId.replace(/[^a-z0-9]/gi,'_')}`;
                  return `
                  <tr>
                    <td><span class="us-mono">${b.batchId}</span></td>
                    <td><span class="us-vid-id">${b.videoId}</span></td>
                    <td style="font-size:10.5px;color:var(--di-muted)">${b.accent}</td>
                    <td>${progBar(b.rawHrs, maxRaw, '#06b6d4')}</td>
                    <td>${progBar(b.cleanHrs, maxRaw, '#22c55e')}</td>
                    <td style="font-variant-numeric:tabular-nums;font-size:11px">${b.clips.toLocaleString()}</td>
                    <td style="text-align:center;font-weight:700">${b.chunkCnt}</td>
                    <td>${badge(b.stage, batchStatusStyle[b.status] || '')}</td>
                    <td>${badge(b.status, batchStatusStyle[b.status] || '')}</td>
                    <td>
                      <span class="us-expand-btn" id="${chRowId}-btn"
                        onclick="usToggleChunks('${chRowId}',this)">
                        <i class="us-arr">›</i> ${b.chunkCnt} chunks
                      </span>
                    </td>
                  </tr>
                  <tr class="us-chunk-row" id="${chRowId}">
                    <td colspan="99" style="padding:0">
                      <div class="us-chunk-inner">
                        <table class="us-chunk-table" style="margin:6px 0 8px">
                          <thead>
                            <tr>
                              <th>Chunk ID</th><th>Start</th><th>End</th>
                              <th>Duration (s)</th><th>SNR (dB)</th>
                              <th>Waveform</th><th>Status</th>
                            </tr>
                          </thead>
                          <tbody>
                            ${b.chunks.map(c => `
                            <tr>
                              <td><span class="us-chunk-id">${c.chunkId}</span></td>
                              <td style="color:var(--di-muted)">${c.startSec}s</td>
                              <td style="color:var(--di-muted)">${c.endSec}s</td>
                              <td style="font-variant-numeric:tabular-nums">${c.dur}s</td>
                              <td style="font-variant-numeric:tabular-nums;color:${
                                c.snr >= 30 ? 'var(--di-green)' : c.snr >= 20 ? 'var(--di-amber)' : 'var(--di-red)'
                              }">${c.snr}</td>
                              <td>${waveSpan(c.waveform)}</td>
                              <td>${badge(c.status, chunkStatusStyle[c.status] || '')}</td>
                            </tr>`).join('')}
                          </tbody>
                        </table>
                      </div>
                    </td>
                  </tr>`;
                }).join('')}
              </tbody>
            </table>
          </div>`;
          content.dataset.rendered = '1';
        }
      }
      row.classList.add('visible');
      btn.classList.add('open');
    } else {
      row.classList.remove('visible');
      btn.classList.remove('open');
    }
  };

  window.usToggleChunks = function(chRowId, btn) {
    const row = document.getElementById(chRowId);
    if (!row) return;
    const isOpen = row.classList.contains('visible');
    row.classList.toggle('visible', !isOpen);
    btn.classList.toggle('open', !isOpen);
  };

  /* ═══════════════════════════════════════════════════════
     BUILD LANG FILTER BUTTONS
  ═══════════════════════════════════════════════════════ */
  function buildLangFilters() {
    const allLangs = [...new Set(USERS.flatMap(u => u.languages.map(l => l.lang)))].sort();
    const container = document.getElementById('usLangFilter');
    if (!container) return;

    allLangs.forEach(lang => {
      const btn = document.createElement('button');
      btn.className = 'us-filter-btn';
      btn.dataset.lang = lang;
      btn.textContent = lang;
      btn.style.cssText = `font-size:10px;font-weight:700;padding:5px 12px;border-radius:20px;
        border:1px solid var(--di-border);background:var(--di-panel-3);
        color:var(--di-muted);cursor:pointer;transition:all 140ms`;
      container.appendChild(btn);
    });

    container.addEventListener('click', e => {
      const btn  = e.target.closest('.us-filter-btn');
      if (!btn) return;
      const lang = btn.dataset.lang;

      container.querySelectorAll('.us-filter-btn').forEach(b => {
        b.classList.remove('active');
        b.style.background = 'var(--di-panel-3)';
        b.style.color = 'var(--di-muted)';
        b.style.borderColor = 'var(--di-border)';
      });
      btn.classList.add('active');
      btn.style.background = 'color-mix(in srgb,var(--di-accent) 14%,transparent)';
      btn.style.color = 'var(--di-accent)';
      btn.style.borderColor = 'color-mix(in srgb,var(--di-accent) 35%,transparent)';

      document.querySelectorAll('.us-user-card').forEach(card => {
        if (lang === 'all') {
          card.style.display = '';
        } else {
          const langs = (card.dataset.langs || '').split(',');
          card.style.display = langs.includes(lang) ? '' : 'none';
        }
      });
    });

    // Trigger "All" style
    const allBtn = container.querySelector('[data-lang="all"]');
    if (allBtn) {
      allBtn.style.background = 'color-mix(in srgb,var(--di-accent) 14%,transparent)';
      allBtn.style.color = 'var(--di-accent)';
      allBtn.style.borderColor = 'color-mix(in srgb,var(--di-accent) 35%,transparent)';
    }
  }

  /* ═══════════════════════════════════════════════════════
     SEARCH
  ═══════════════════════════════════════════════════════ */
  function bindSearch() {
    const inp = document.getElementById('usUserSearch');
    if (!inp) return;
    inp.addEventListener('input', () => {
      const q = inp.value.trim().toLowerCase();
      document.querySelectorAll('.us-user-card').forEach(card => {
        const name = (card.querySelector('.us-card-name')?.textContent || '').toLowerCase();
        const id   = (card.dataset.userId || '').toLowerCase();
        const langs= (card.dataset.langs || '').toLowerCase();
        card.style.display = (!q || name.includes(q) || id.includes(q) || langs.includes(q)) ? '' : 'none';
      });
    });
  }

  /* ═══════════════════════════════════════════════════════
     EXPAND ALL
  ═══════════════════════════════════════════════════════ */
  function bindExpandAll() {
    const btn = document.getElementById('usExpandAll');
    if (!btn) return;
    let expanded = false;
    btn.addEventListener('click', () => {
      expanded = !expanded;
      document.querySelectorAll('.us-user-card').forEach(card => {
        if (expanded) card.classList.add('expanded');
        else card.classList.remove('expanded');
      });
      btn.textContent = expanded ? '⊟ Collapse All' : '⊞ Expand All';
    });
  }

  /* ═══════════════════════════════════════════════════════
     INIT
  ═══════════════════════════════════════════════════════ */
  function init() {
    const grid = document.getElementById('usUserGrid');
    if (!grid) return;

    Chart.defaults.font.family = "'Inter', system-ui, -apple-system, sans-serif";
    Chart.defaults.font.size   = 10;
    Chart.defaults.color       = '#6b7280';

    USERS.forEach((user, i) => {
      const { card, canvasId } = renderUserCard(user);
      card.style.animationDelay = `${i * 40}ms`;
      grid.appendChild(card);
      /* Defer chart render slightly so canvas is in DOM */
      setTimeout(() => renderMiniChart(user, canvasId), 50 + i * 20);
    });

    buildLangFilters();
    bindSearch();
    bindExpandAll();
  }

  /* ── Safe boot ── */
  function waitChart(cb, n) {
    n = n || 0;
    if (typeof Chart !== 'undefined') cb();
    else if (n < 40) setTimeout(() => waitChart(cb, n + 1), 100);
  }

  if (document.readyState === 'loading')
    document.addEventListener('DOMContentLoaded', () => waitChart(init));
  else
    waitChart(init);

})();