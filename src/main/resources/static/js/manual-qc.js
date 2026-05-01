// =============================================================
//  manual-qc.js — Manual QC Review Dashboard
//  Fully self-contained; data is hardcoded for Phase-1 demo.
// =============================================================
window.addEventListener('load', function () {
  'use strict';

  /* ══════════════════════════════════════════════════════════
     HARDCODED SEED DATA
  ═══════════════════════════════════════════════════════════ */
  const BATCHES = [
    {
      id: 'BATCH_HI_001', name: 'Hindi Studio — Batch 001',
      language: 'Hindi', script: 'Devanagari',
      langCode: 'HI', langColor: '#f97316', langBg: 'rgba(249,115,22,0.15)',
      speaker: 'SPK_003', date: '2026-04-28', status: 'pending',
      clips: [
        { id:'CLIP_00142', duration:5.2,  transcript:'नमस्ते, मेरा नाम राहुल है और मैं दिल्ली से हूँ।' },
        { id:'CLIP_00143', duration:6.8,  transcript:'आज मौसम बहुत अच्छा है। हम बाहर जा सकते हैं।' },
        { id:'CLIP_00144', duration:4.1,  transcript:'कृपया अपना सामान यहाँ रखें और आगे बढ़ें।' },
        { id:'CLIP_00145', duration:7.3,  transcript:'भारत एक विविधताओं से भरा देश है जहाँ अनेक भाषाएँ बोली जाती हैं।' },
        { id:'CLIP_00146', duration:5.5,  transcript:'यह पुस्तक बहुत रोचक है। मैंने इसे एक ही दिन में पढ़ लिया।' },
        { id:'CLIP_00147', duration:9.5,  transcript:'स्वास्थ्य ही सबसे बड़ा धन है। हमें अपने स्वास्थ्य का ध्यान रखना चाहिए।' },
      ]
    },
    {
      id: 'BATCH_EN_002', name: 'English Field — Batch 002',
      language: 'English', script: 'Latin',
      langCode: 'EN', langColor: '#6366f1', langBg: 'rgba(99,102,241,0.15)',
      speaker: 'SPK_001', date: '2026-04-29', status: 'pending',
      clips: [
        { id:'CLIP_00201', duration:4.8, transcript:'The quick brown fox jumps over the lazy dog near the river bank.' },
        { id:'CLIP_00202', duration:6.2, transcript:'She sells sea shells by the sea shore every morning before sunrise.' },
        { id:'CLIP_00203', duration:5.1, transcript:'Technology has changed the way we communicate with each other globally.' },
        { id:'CLIP_00204', duration:7.4, transcript:'The weather forecast predicts heavy rainfall in the northern regions tomorrow.' },
        { id:'CLIP_00205', duration:8.2, transcript:'Learning a new language opens up many doors and creates wonderful opportunities.' },
      ]
    },
    {
      id: 'BATCH_TA_003', name: 'Tamil Studio — Batch 003',
      language: 'Tamil', script: 'Tamil',
      langCode: 'TA', langColor: '#22c55e', langBg: 'rgba(34,197,94,0.15)',
      speaker: 'SPK_005', date: '2026-04-30', status: 'pending',
      clips: [
        { id:'CLIP_00301', duration:5.6, transcript:'வணக்கம், என் பெயர் கார்த்திக். நான் சென்னையிலிருந்து வருகிறேன்.' },
        { id:'CLIP_00302', duration:7.1, transcript:'தமிழ் மொழி மிகவும் பழமையான மொழிகளில் ஒன்று.' },
        { id:'CLIP_00303', duration:4.9, transcript:'இன்று வானிலை மிகவும் நல்லாக இருக்கிறது.' },
        { id:'CLIP_00304', duration:6.3, transcript:'கல்வியே மனிதனின் மிகப்பெரிய செல்வம்.' },
        { id:'CLIP_00305', duration:8.0, transcript:'நம் நாட்டில் பல மொழிகள் பேசப்படுகின்றன, அனைத்தும் சிறப்பானவை.' },
        { id:'CLIP_00306', duration:5.8, transcript:'உடல் நலம் தான் மிகவும் முக்கியமான செல்வம்.' },
        { id:'CLIP_00307', duration:6.5, transcript:'புதிய தொழில்நுட்பம் நம் வாழ்க்கையை மாற்றி அமைத்துள்ளது.' },
      ]
    },
    {
      id: 'BATCH_TE_004', name: 'Telugu Field — Batch 004',
      language: 'Telugu', script: 'Telugu',
      langCode: 'TE', langColor: '#06b6d4', langBg: 'rgba(6,182,212,0.15)',
      speaker: 'SPK_004', date: '2026-04-30', status: 'pending',
      clips: [
        { id:'CLIP_00401', duration:5.0, transcript:'నమస్కారం, నా పేరు శ్రీనివాస్. నేను హైదరాబాద్ నుండి వచ్చాను.' },
        { id:'CLIP_00402', duration:6.5, transcript:'తెలుగు భాష చాలా అందమైన భాష మరియు ప్రాచీనమైనది.' },
        { id:'CLIP_00403', duration:4.7, transcript:'ఈరోజు వాతావరణం చాలా బాగుంది.' },
        { id:'CLIP_00404', duration:7.8, transcript:'విద్యే మానవుడికి అత్యుత్తమ సంపద అని అందరూ అంటారు.' },
      ]
    },
  ];

  const QUESTIONS = [
    {
      id:'q1', short:'Pronunciation & Intelligibility', weight:0.25,
      long:'Were the words pronounced correctly and was the speech clearly intelligible throughout the batch?'
    },
    {
      id:'q2', short:'Transcript Accuracy', weight:0.20,
      long:'Did the spoken content match the transcript accurately, with correct target-language script and minimal code-switching?'
    },
    {
      id:'q3', short:'Accent Consistency', weight:0.15,
      long:'Was the accent consistent and appropriate for the target language across the batch?'
    },
    {
      id:'q4', short:'Tone & Naturalness', weight:0.15,
      long:'Was the speaker\'s tone neutral, natural, and free from signs of fatigue (flat delivery, rushed speech, loss of energy)?'
    },
    {
      id:'q5', short:'Audio Artifacts', weight:0.15,
      long:'Were there any distracting breathing sounds, mouth noise, or other non-speech artifacts in the batch?'
    },
    {
      id:'q6', short:'Pacing & Timing', weight:0.10,
      long:'Was the pacing natural, with no unnatural pauses, abrupt cuts, or irregular silence gaps?'
    },
  ];

  const SCORE_LABELS = { 1:'Reject', 2:'Reject', 3:'Border', 4:'Usable', 5:'Excel' };

  /* ══════════════════════════════════════════════════════════
     STATE
  ═══════════════════════════════════════════════════════════ */
  let activeBatchId  = BATCHES[0].id;
  let activeClipIdx  = -1;
  let scores         = {};   // { q1: null, … q6: null }
  let playedClips    = new Set();
  let batchResults   = {};   // { [batchId]: { scores, decision, total } }
  let audioEl        = null; // single shared Audio element
  let isPlaying      = false;

  /* ══════════════════════════════════════════════════════════
     HELPERS
  ═══════════════════════════════════════════════════════════ */
  function el(id) { return document.getElementById(id); }
  function fmtTime(s) {
    if (!isFinite(s)) return '0:00';
    const m = Math.floor(s / 60), sec = Math.floor(s % 60);
    return `${m}:${sec.toString().padStart(2,'0')}`;
  }
  function calcWeighted() {
    let total = 0, allScored = true;
    QUESTIONS.forEach(q => {
      const v = scores[q.id];
      if (v == null) { allScored = false; return; }
      total += v * q.weight;
    });
    return allScored ? +total.toFixed(2) : null;
  }
  function getVerdict(score) {
    if (score == null)  return { cls:'pending',    label:'Not Scored' };
    if (score >= 4.5)   return { cls:'excellent',  label:'Excellent'  };
    if (score >= 3.5)   return { cls:'usable',     label:'Usable'     };
    if (score >= 2.5)   return { cls:'borderline', label:'Borderline' };
    return               { cls:'reject',     label:'Reject'     };
  }
  function activeBatch() { return BATCHES.find(b => b.id === activeBatchId); }

  /* ══════════════════════════════════════════════════════════
     RENDER — BATCH SELECTOR
  ═══════════════════════════════════════════════════════════ */
  function renderBatchSelector() {
    const row = el('batchSelectorRow');
    row.innerHTML = '';
    BATCHES.forEach(batch => {
      const res = batchResults[batch.id];
      const status = res ? res.decision : batch.status;
      const card = document.createElement('div');
      card.className = `batch-card ${batch.id === activeBatchId ? 'active' : ''} ${status !== 'pending' ? status : ''}`;
      card.dataset.batchId = batch.id;

      const totalDur = batch.clips.reduce((s, c) => s + c.duration, 0).toFixed(1);

      card.innerHTML = `
        <div class="batch-lang-badge" style="background:${batch.langBg};color:${batch.langColor}">${batch.langCode}</div>
        <div class="batch-info">
          <div class="batch-name">${batch.name}</div>
          <div class="batch-meta">${batch.clips.length} clips &middot; ${batch.speaker} &middot; ${totalDur}s &middot; ${batch.date}</div>
        </div>
        <span class="batch-status-pill ${status}">${status}</span>`;
      card.addEventListener('click', () => selectBatch(batch.id));
      row.appendChild(card);
    });
  }

  /* ══════════════════════════════════════════════════════════
     RENDER — CLIP LIST
  ═══════════════════════════════════════════════════════════ */
  function renderClipList() {
    const batch = activeBatch();
    const list  = el('clipsList');
    list.innerHTML = '';

    batch.clips.forEach((clip, idx) => {
      const played = playedClips.has(clip.id);
      const row = document.createElement('div');
      row.className = `clip-row ${idx === activeClipIdx ? 'active' : ''} ${played ? 'played' : ''}`;
      row.dataset.idx = idx;

      const preview = clip.transcript.length > 55
        ? clip.transcript.slice(0, 55) + '…' : clip.transcript;

      row.innerHTML = `
        <span class="clip-num">${String(idx+1).padStart(2,'0')}</span>
        <button class="clip-play-btn" title="Play ${clip.id}">
          ${idx === activeClipIdx && isPlaying ? '&#9646;&#9646;' : '&#9654;'}
        </button>
        <div class="clip-body">
          <div class="clip-id-label">${clip.id}</div>
          <div class="clip-transcript-preview">${preview}</div>
        </div>
        <span class="clip-duration">${clip.duration}s</span>
        <span class="clip-played-dot ${played ? '' : 'hidden'}"></span>`;

      row.querySelector('.clip-play-btn').addEventListener('click', e => {
        e.stopPropagation();
        if (idx === activeClipIdx) { togglePlayPause(); }
        else { selectClip(idx); }
      });
      row.addEventListener('click', () => selectClip(idx));
      list.appendChild(row);
    });

    // update panel header
    el('leftPanelTitle').textContent  = batch.name;
    el('leftPanelSub').textContent    = `${batch.language} · ${batch.speaker} · ${batch.clips.length} clips`;
    el('leftBadge').textContent       = batch.date;
    el('scoringBatchName').textContent = batch.name;
    updateProgressBar();
  }

  function updateProgressBar() {
    const batch = activeBatch();
    const count = batch.clips.filter(c => playedClips.has(c.id)).length;
    const total = batch.clips.length;
    const pct   = total > 0 ? (count / total * 100) : 0;
    el('bpFill').style.width  = pct + '%';
    el('bpCount').textContent = `${count} / ${total}`;
  }

  /* ══════════════════════════════════════════════════════════
     RENDER — SCORING FORM
  ═══════════════════════════════════════════════════════════ */
  function renderScoringForm() {
    const container = el('scoringQuestions');
    container.innerHTML = '';
    const pctFmt = w => (w * 100).toFixed(0) + '%';

    QUESTIONS.forEach(q => {
      const curScore = scores[q.id];
      const div = document.createElement('div');
      div.className = 'q-row';
      div.innerHTML = `
        <div class="q-top">
          <span class="q-badge">${pctFmt(q.weight)}</span>
          <span class="q-label">${q.short}</span>
        </div>
        <div class="q-long-text">${q.long}</div>
        <div class="score-btn-group" id="btnGroup_${q.id}">
          ${[1,2,3,4,5].map(n => `
            <button class="score-btn ${curScore === n ? 'active-'+n : ''}" data-q="${q.id}" data-n="${n}">
              <span class="score-btn-num">${n}</span>
              <span class="score-btn-lbl">${SCORE_LABELS[n]}</span>
            </button>`).join('')}
        </div>`;
      container.appendChild(div);
    });

    // event delegation on the container
    container.addEventListener('click', e => {
      const btn = e.target.closest('.score-btn');
      if (!btn) return;
      const qId = btn.dataset.q;
      const n   = parseInt(btn.dataset.n);
      setScore(qId, n);
    });
  }

  /* ══════════════════════════════════════════════════════════
     RENDER — SCORE SUMMARY
  ═══════════════════════════════════════════════════════════ */
  function renderScoreSummary() {
    const total   = calcWeighted();
    const verdict = getVerdict(total);

    el('finalScore').innerHTML  = total != null
      ? `${total.toFixed(2)}<span>/ 5.0</span>`
      : `—<span>/ 5.0</span>`;

    const vEl = el('scoreVerdict');
    vEl.className = `score-verdict ${verdict.cls}`;
    vEl.textContent = verdict.label;

    // breakdown bars
    const bd = el('scoreBreakdown');
    bd.innerHTML = '';
    QUESTIONS.forEach(q => {
      const v = scores[q.id];
      const pts = v != null ? (v * q.weight).toFixed(2) : '—';
      const fillPct = v != null ? (v / 5 * 100) : 0;
      const fillColor = v == null ? 'var(--mqc-faint)'
        : v <= 2 ? '#ef4444' : v === 3 ? '#f59e0b' : '#22c55e';
      bd.innerHTML += `
        <div class="breakdown-row">
          <span class="breakdown-label" title="${q.short}">${q.short}</span>
          <div class="breakdown-track">
            <div class="breakdown-fill" style="width:${fillPct}%;background:${fillColor}"></div>
          </div>
          <span class="breakdown-pts">${pts}</span>
        </div>`;
    });

    // enable/disable decision buttons
    const allScored = QUESTIONS.every(q => scores[q.id] != null);
    el('btnAccept').disabled = !allScored;
    el('btnReject').disabled = !allScored;
  }

  /* ══════════════════════════════════════════════════════════
     AUDIO PLAYER
  ═══════════════════════════════════════════════════════════ */
  function initAudio() {
    audioEl = new Audio();
    audioEl.preload = 'metadata';

    audioEl.addEventListener('timeupdate', () => {
      if (!audioEl.duration) return;
      const pct = (audioEl.currentTime / audioEl.duration) * 100;
      el('progressBarFill').style.width = pct + '%';
      el('timeCurrent').textContent = fmtTime(audioEl.currentTime);
    });

    audioEl.addEventListener('loadedmetadata', () => {
      el('timeDuration').textContent = fmtTime(audioEl.duration);
    });

    audioEl.addEventListener('ended', () => {
      isPlaying = false;
      el('playPauseBtn').innerHTML = '&#9654;';
      markClipPlayed(activeClipIdx);
      // auto-advance
      const batch = activeBatch();
      if (activeClipIdx < batch.clips.length - 1) {
        setTimeout(() => selectClip(activeClipIdx + 1), 600);
      }
    });

    audioEl.addEventListener('play',  () => { isPlaying = true;  el('playPauseBtn').innerHTML = '&#9646;&#9646;'; renderClipList(); });
    audioEl.addEventListener('pause', () => { isPlaying = false; el('playPauseBtn').innerHTML = '&#9654;';        renderClipList(); });

    // progress bar click-to-seek
    el('progressBarOuter').addEventListener('click', e => {
      if (!audioEl.duration) return;
      const rect = e.currentTarget.getBoundingClientRect();
      audioEl.currentTime = ((e.clientX - rect.left) / rect.width) * audioEl.duration;
    });

    el('playPauseBtn').addEventListener('click', togglePlayPause);
    el('btnPrevClip').addEventListener('click', () => { if (activeClipIdx > 0) selectClip(activeClipIdx - 1); });
    el('btnNextClip').addEventListener('click', () => {
      const batch = activeBatch();
      if (activeClipIdx < batch.clips.length - 1) selectClip(activeClipIdx + 1);
    });
  }

  function togglePlayPause() {
    if (!audioEl) return;
    if (audioEl.paused) { audioEl.play().catch(() => {}); }
    else                { audioEl.pause(); }
  }

  function loadClipInPlayer(clip, idx) {
    el('playerEmpty').style.display   = 'none';
    el('playerActive').style.display  = 'block';
    el('playerClipId').textContent    = clip.id;
    el('playerTranscript').textContent = clip.transcript;
    el('timeCurrent').textContent     = '0:00';
    el('timeDuration').textContent    = fmtTime(clip.duration);
    el('progressBarFill').style.width = '0%';

    // In a real app: audioEl.src = contextPath + '/audio/' + clip.id + '.wav';
    // Demo: use a silent data-URI so the player loads cleanly
    audioEl.src = 'data:audio/wav;base64,UklGRiQAAABXQVZFZm10IBAAAAABAAEARKwAAIhYAQACABAAZGF0YQAAAAA=';
    audioEl.load();

    const batch = activeBatch();
    el('btnPrevClip').disabled = idx === 0;
    el('btnNextClip').disabled = idx === batch.clips.length - 1;
  }

  function markClipPlayed(idx) {
    const batch = activeBatch();
    if (idx < 0 || idx >= batch.clips.length) return;
    playedClips.add(batch.clips[idx].id);
    updateProgressBar();
    renderClipList();
  }

  /* ══════════════════════════════════════════════════════════
     ACTIONS
  ═══════════════════════════════════════════════════════════ */
  function selectBatch(batchId) {
    if (audioEl) { audioEl.pause(); isPlaying = false; }
    activeBatchId = batchId;
    activeClipIdx = -1;
    resetScores();
    playedClips = new Set();

    // restore previous result if any
    const saved = batchResults[batchId];
    if (saved) { scores = { ...saved.scores }; }

    renderBatchSelector();
    renderClipList();
    renderScoringForm();
    renderScoreSummary();

    el('playerEmpty').style.display  = 'block';
    el('playerActive').style.display = 'none';
  }

  function selectClip(idx) {
    if (audioEl && isPlaying) { audioEl.pause(); }
    activeClipIdx = idx;
    const clip = activeBatch().clips[idx];
    loadClipInPlayer(clip, idx);
    renderClipList();
    // mark as played when selected (simulate listening)
    markClipPlayed(idx);
    // auto-play
    setTimeout(() => { audioEl.play().catch(() => {}); }, 100);
  }

  function setScore(qId, n) {
    scores[qId] = n;
    // update just the button group for this question
    const grp = el('btnGroup_' + qId);
    if (grp) {
      grp.querySelectorAll('.score-btn').forEach(btn => {
        const v = parseInt(btn.dataset.n);
        btn.className = `score-btn ${v === n ? 'active-'+v : ''}`;
      });
    }
    renderScoreSummary();
  }

  function resetScores() {
    scores = {};
    QUESTIONS.forEach(q => { scores[q.id] = null; });
  }

  function recordDecision(decision) {
    const total = calcWeighted();
    batchResults[activeBatchId] = {
      scores  : { ...scores },
      decision: decision,
      total   : total,
      ts      : new Date().toISOString(),
    };

    // update BATCHES status
    const batch = BATCHES.find(b => b.id === activeBatchId);
    if (batch) batch.status = decision;

    renderBatchSelector();
    showToast(decision);
  }

  /* ── Decision buttons ─────────────────────────────────── */
  el('btnAccept').addEventListener('click', () => {
    if (calcWeighted() == null) return;
    recordDecision('accepted');
  });
  el('btnReject').addEventListener('click', () => {
    if (calcWeighted() == null) return;
    recordDecision('rejected');
  });

  /* ══════════════════════════════════════════════════════════
     TOAST
  ═══════════════════════════════════════════════════════════ */
  function showToast(decision) {
    const toast   = el('mqcToast');
    const icon    = el('toastIcon');
    const msg     = el('toastMsg');
    const batch   = activeBatch();
    const total   = batchResults[activeBatchId]?.total;

    if (decision === 'accepted') {
      icon.textContent = '✓';
      icon.style.color = '#22c55e';
      msg.textContent  = `${batch.name} accepted — score ${total?.toFixed(2)} / 5.0`;
    } else {
      icon.textContent = '✗';
      icon.style.color = '#ef4444';
      msg.textContent  = `${batch.name} rejected — score ${total?.toFixed(2)} / 5.0`;
    }

    toast.classList.add('show');
    setTimeout(() => toast.classList.remove('show'), 3500);
  }

  /* ══════════════════════════════════════════════════════════
     INIT
  ═══════════════════════════════════════════════════════════ */
  function init() {
    initAudio();
    resetScores();
    renderBatchSelector();
    renderClipList();
    renderScoringForm();
    renderScoreSummary();
  }

  init();
});