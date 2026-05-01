<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
/* ═══════════════════════════════════════════════════════════
   MANUAL QC — PRODUCTION-GRADE INLINE STYLES v2
═══════════════════════════════════════════════════════════ */
[data-theme="dark"] {
  --mqc-bg        : #0f1117;
  --mqc-panel     : #161820;
  --mqc-panel-2   : #1c1f2e;
  --mqc-panel-3   : #222537;
  --mqc-panel-4   : #282b3e;
  --mqc-border    : rgba(255,255,255,0.07);
  --mqc-border-hi : rgba(99,102,241,0.4);
  --mqc-text      : #d8dae8;
  --mqc-muted     : #6b7280;
  --mqc-faint     : #252838;
  --mqc-accent    : #6366f1;
  --mqc-accent-2  : #818cf8;
  --mqc-green     : #22c55e;
  --mqc-red       : #ef4444;
  --mqc-amber     : #f59e0b;
  --mqc-cyan      : #06b6d4;
  --mqc-shadow-sm : 0 1px 4px rgba(0,0,0,0.3);
  --mqc-shadow    : 0 4px 16px rgba(0,0,0,0.45);
  --mqc-shadow-lg : 0 12px 40px rgba(0,0,0,0.6);
  --mqc-glow      : 0 0 0 1px var(--mqc-accent), 0 0 20px rgba(99,102,241,0.2);
}
[data-theme="light"] {
  --mqc-bg        : #e8eaf2;
  --mqc-panel     : #ffffff;
  --mqc-panel-2   : #f3f4f9;
  --mqc-panel-3   : #eceef6;
  --mqc-panel-4   : #e6e8f0;
  --mqc-border    : rgba(0,0,0,0.08);
  --mqc-border-hi : rgba(79,70,229,0.3);
  --mqc-text      : #1a1d2e;
  --mqc-muted     : #6b7280;
  --mqc-faint     : #dde0ec;
  --mqc-accent    : #4f46e5;
  --mqc-accent-2  : #6366f1;
  --mqc-green     : #16a34a;
  --mqc-red       : #dc2626;
  --mqc-amber     : #d97706;
  --mqc-cyan      : #0891b2;
  --mqc-shadow-sm : 0 1px 3px rgba(0,0,0,0.06);
  --mqc-shadow    : 0 4px 12px rgba(0,0,0,0.08);
  --mqc-shadow-lg : 0 12px 32px rgba(0,0,0,0.12);
  --mqc-glow      : 0 0 0 1px var(--mqc-accent), 0 0 16px rgba(79,70,229,0.15);
}

.mqc-page { display:flex; flex-direction:column; gap:14px; padding-bottom:40px; max-width:1600px; }

.mqc-section-label {
  font-size:10px; font-weight:700; letter-spacing:0.14em;
  text-transform:uppercase; color:var(--mqc-muted);
  display:flex; align-items:center; gap:10px;
}
.mqc-section-label::after { content:''; flex:1; height:1px; background:linear-gradient(90deg, var(--mqc-border), transparent); }

/* ═══════════ BATCH SELECTOR ═══════════ */
.batch-selector-row { display:flex; gap:10px; overflow-x:auto; padding-bottom:4px; scrollbar-width:thin; scrollbar-color:var(--mqc-faint) transparent; }
.batch-selector-row::-webkit-scrollbar { height:3px; }
.batch-selector-row::-webkit-scrollbar-thumb { background:var(--mqc-faint); border-radius:3px; }

.batch-card {
  flex-shrink:0; min-width:250px; display:flex; align-items:center; gap:12px;
  background:var(--mqc-panel); border:1px solid var(--mqc-border);
  border-radius:12px; padding:14px 16px; cursor:pointer;
  transition:border-color 160ms ease, box-shadow 160ms ease, transform 160ms ease;
  position:relative; overflow:hidden;
}
.batch-card::after { content:''; position:absolute; inset:0; background:linear-gradient(135deg, rgba(255,255,255,0.02) 0%, transparent 60%); pointer-events:none; }
.batch-card:hover { border-color:var(--mqc-border-hi); transform:translateY(-2px); box-shadow:var(--mqc-shadow); }
.batch-card.active { border-color:var(--mqc-accent) !important; background:color-mix(in srgb, var(--mqc-accent) 7%, var(--mqc-panel)); box-shadow:var(--mqc-glow); }
.batch-card.accepted { border-color:rgba(34,197,94,0.45) !important; }
.batch-card.rejected { border-color:rgba(239,68,68,0.45) !important; }

.batch-lang-badge { width:42px; height:42px; border-radius:10px; display:flex; align-items:center; justify-content:center; font-size:12px; font-weight:800; flex-shrink:0; letter-spacing:-0.01em; }
.batch-info { flex:1; min-width:0; }
.batch-name { font-size:13px; font-weight:600; color:var(--mqc-text); white-space:nowrap; overflow:hidden; text-overflow:ellipsis; margin-bottom:3px; }
.batch-meta { font-size:11px; color:var(--mqc-muted); }
.batch-status-pill { font-size:9px; font-weight:700; letter-spacing:0.06em; text-transform:uppercase; padding:3px 9px; border-radius:20px; flex-shrink:0; }
.batch-status-pill.pending  { background:rgba(245,158,11,0.14); color:var(--mqc-amber);  border:1px solid rgba(245,158,11,0.3); }
.batch-status-pill.accepted { background:rgba(34,197,94,0.14);  color:var(--mqc-green);  border:1px solid rgba(34,197,94,0.3); }
.batch-status-pill.rejected { background:rgba(239,68,68,0.14);  color:var(--mqc-red);    border:1px solid rgba(239,68,68,0.3); }

/* ═══════════ MAIN GRID ═══════════ */
.mqc-main-grid { display:grid; grid-template-columns:minmax(0,1fr) 420px; gap:14px; align-items:start; }
@media (max-width:1180px) { .mqc-main-grid { grid-template-columns:1fr; } }

.mqc-panel { background:var(--mqc-panel); border:1px solid var(--mqc-border); border-radius:12px; box-shadow:var(--mqc-shadow-sm); overflow:hidden; }
.mqc-panel-header { display:flex; align-items:center; justify-content:space-between; padding:14px 18px; border-bottom:1px solid var(--mqc-border); background:linear-gradient(135deg, var(--mqc-panel) 0%, var(--mqc-panel-2) 100%); }
.mqc-panel-title { font-size:13.5px; font-weight:700; color:var(--mqc-text); }
.mqc-panel-sub   { font-size:11px; color:var(--mqc-muted); margin-top:2px; }
.mqc-panel-badge { font-size:10px; font-weight:600; color:var(--mqc-muted); background:var(--mqc-panel-3); border:1px solid var(--mqc-border); padding:2px 8px; border-radius:6px; }

/* ═══════════ CLIPS LIST ═══════════ */
.clips-list { max-height:380px; overflow-y:auto; scrollbar-width:thin; scrollbar-color:var(--mqc-faint) transparent; }
.clips-list::-webkit-scrollbar { width:3px; }
.clips-list::-webkit-scrollbar-thumb { background:var(--mqc-faint); border-radius:3px; }

.clip-row { display:flex; align-items:center; gap:12px; padding:10px 18px; cursor:pointer; border-bottom:1px solid var(--mqc-border); transition:background 120ms ease; position:relative; }
.clip-row:last-child { border-bottom:none; }
.clip-row:hover { background:var(--mqc-panel-2); }
.clip-row.active { background:color-mix(in srgb, var(--mqc-accent) 9%, var(--mqc-panel)); }
.clip-row.active::before { content:''; position:absolute; left:0; top:0; bottom:0; width:3px; background:var(--mqc-accent); border-radius:0 2px 2px 0; }
.clip-row.played .clip-num { color:var(--mqc-green); }

.clip-play-btn { width:32px; height:32px; border-radius:50%; background:var(--mqc-panel-3); border:1px solid var(--mqc-border); color:var(--mqc-text); font-size:10px; display:flex; align-items:center; justify-content:center; flex-shrink:0; cursor:pointer; transition:background 120ms, border-color 120ms, transform 120ms; }
.clip-play-btn:hover { background:var(--mqc-accent); border-color:var(--mqc-accent); color:#fff; transform:scale(1.08); }
.clip-row.active .clip-play-btn { background:var(--mqc-accent); border-color:var(--mqc-accent); color:#fff; }

.clip-num { font-size:10px; font-weight:700; color:var(--mqc-muted); min-width:20px; font-variant-numeric:tabular-nums; }
.clip-body { flex:1; min-width:0; }
.clip-id-label { font-size:11px; font-weight:600; color:var(--mqc-accent); font-family:'JetBrains Mono','Fira Code',ui-monospace,monospace; letter-spacing:0.01em; margin-bottom:2px; }
.clip-transcript-preview { font-size:12px; color:var(--mqc-text); line-height:1.4; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; max-width:100%; }
.clip-duration { font-size:10.5px; color:var(--mqc-muted); flex-shrink:0; font-variant-numeric:tabular-nums; background:var(--mqc-panel-3); border:1px solid var(--mqc-border); padding:2px 7px; border-radius:5px; }
.clip-played-dot { width:7px; height:7px; border-radius:50%; background:var(--mqc-green); flex-shrink:0; box-shadow:0 0 4px var(--mqc-green); }
.clip-played-dot.hidden { visibility:hidden; }

.batch-progress-bar { display:flex; align-items:center; gap:12px; padding:10px 18px; border-top:1px solid var(--mqc-border); background:var(--mqc-panel-2); }
.bp-label { font-size:10.5px; color:var(--mqc-muted); white-space:nowrap; font-weight:500; }
.bp-track { flex:1; height:5px; border-radius:3px; background:var(--mqc-faint); overflow:hidden; }
.bp-fill  { height:100%; border-radius:3px; background:var(--mqc-accent); transition:width 0.4s cubic-bezier(0.4,0,0.2,1); }
.bp-count { font-size:10.5px; color:var(--mqc-text); font-weight:700; white-space:nowrap; font-variant-numeric:tabular-nums; }

/* ═══════════ PLAYER ═══════════ */
.player-section { border-top:1px solid var(--mqc-border); background:linear-gradient(180deg, var(--mqc-panel-2) 0%, var(--mqc-panel-3) 100%); padding:16px 18px; }
.player-clip-info { display:flex; align-items:center; justify-content:space-between; margin-bottom:12px; }
.player-clip-id { font-size:11px; font-weight:700; color:var(--mqc-accent); font-family:'JetBrains Mono','Fira Code',ui-monospace,monospace; letter-spacing:0.02em; }
.player-clip-nav { display:flex; gap:5px; }
.player-nav-btn { width:28px; height:28px; border-radius:7px; background:var(--mqc-panel-4); border:1px solid var(--mqc-border); color:var(--mqc-muted); font-size:10px; display:flex; align-items:center; justify-content:center; cursor:pointer; transition:all 120ms ease; }
.player-nav-btn:hover { border-color:var(--mqc-accent); color:var(--mqc-accent); background:color-mix(in srgb, var(--mqc-accent) 10%, var(--mqc-panel-4)); }
.player-nav-btn:disabled { opacity:0.3; cursor:default; pointer-events:none; }

.audio-controls { display:flex; align-items:center; gap:12px; margin-bottom:12px; }
.play-pause-btn { width:40px; height:40px; border-radius:50%; background:var(--mqc-accent); border:none; color:#fff; font-size:14px; display:flex; align-items:center; justify-content:center; cursor:pointer; flex-shrink:0; transition:transform 120ms ease, box-shadow 120ms ease; box-shadow:0 2px 12px rgba(99,102,241,0.4); }
.play-pause-btn:hover { transform:scale(1.08); box-shadow:0 4px 18px rgba(99,102,241,0.55); }
.play-pause-btn:active { transform:scale(0.94); }

.progress-wrap { flex:1; display:flex; flex-direction:column; gap:5px; }
.progress-bar-outer { height:6px; border-radius:3px; background:var(--mqc-faint); cursor:pointer; overflow:hidden; position:relative; transition:height 120ms; }
.progress-bar-outer:hover { height:8px; }
.progress-bar-fill { height:100%; border-radius:3px; background:linear-gradient(90deg, var(--mqc-accent), var(--mqc-accent-2)); transition:width 0.1s linear; width:0; }
.progress-time { display:flex; justify-content:space-between; font-size:10px; color:var(--mqc-muted); font-variant-numeric:tabular-nums; }

.player-transcript-box { background:var(--mqc-panel); border:1px solid var(--mqc-border); border-radius:9px; padding:12px 14px; margin-top:2px; }
.player-transcript-label { font-size:9px; font-weight:800; letter-spacing:0.12em; text-transform:uppercase; color:var(--mqc-muted); margin-bottom:7px; display:flex; align-items:center; gap:6px; }
.player-transcript-label::before { content:''; width:3px; height:10px; border-radius:2px; background:var(--mqc-accent); display:inline-block; }
.player-transcript-text { font-size:14.5px; line-height:1.7; color:var(--mqc-text); unicode-bidi:normal; direction:auto; }
.player-empty { text-align:center; padding:28px 16px; color:var(--mqc-muted); display:flex; flex-direction:column; align-items:center; gap:8px; }
.player-empty-icon { font-size:28px; opacity:0.4; }
.player-empty-text { font-size:12.5px; }

/* ═══════════ SCORING PANEL ═══════════ */
.scoring-panel { display:flex; flex-direction:column; }
@media (min-width:1180px) {
  .scoring-panel { position:sticky; top:16px; max-height:calc(100vh - 140px); overflow:hidden; }
  .scoring-panel-scroll { flex:1; overflow-y:auto; display:flex; flex-direction:column; scrollbar-width:thin; scrollbar-color:var(--mqc-faint) transparent; }
  .scoring-panel-scroll::-webkit-scrollbar { width:3px; }
  .scoring-panel-scroll::-webkit-scrollbar-thumb { background:var(--mqc-faint); border-radius:3px; }
}

.scoring-questions { padding:0; }
.q-row { padding:11px 16px; border-bottom:1px solid var(--mqc-border); transition:background 100ms; }
.q-row:last-child { border-bottom:none; }
.q-row:hover { background:var(--mqc-panel-2); }
.q-top { display:flex; align-items:center; gap:8px; margin-bottom:6px; }
.q-badge { font-size:9px; font-weight:800; letter-spacing:0.05em; text-transform:uppercase; padding:2px 6px; border-radius:4px; flex-shrink:0; background:color-mix(in srgb, var(--mqc-accent) 14%, transparent); color:var(--mqc-accent); border:1px solid color-mix(in srgb, var(--mqc-accent) 28%, transparent); font-variant-numeric:tabular-nums; }
.q-label { font-size:12px; font-weight:600; color:var(--mqc-text); flex:1; line-height:1.3; }
.q-weight { font-size:10px; font-weight:700; color:var(--mqc-muted); flex-shrink:0; }
.q-long-text { font-size:11px; color:var(--mqc-muted); margin-bottom:8px; line-height:1.45; }
.score-btn-group { display:flex; gap:4px; }
.score-btn { flex:1; padding:7px 2px; border-radius:7px; border:1px solid var(--mqc-border); background:var(--mqc-panel-3); cursor:pointer; text-align:center; transition:all 130ms ease; display:flex; flex-direction:column; align-items:center; gap:2px; }
.score-btn:hover { border-color:var(--mqc-border-hi); background:var(--mqc-panel-2); transform:translateY(-1px); }
.score-btn.active-1,.score-btn.active-2 { background:rgba(239,68,68,0.15); border-color:rgba(239,68,68,0.5); box-shadow:0 2px 8px rgba(239,68,68,0.2); }
.score-btn.active-3 { background:rgba(245,158,11,0.15); border-color:rgba(245,158,11,0.5); box-shadow:0 2px 8px rgba(245,158,11,0.2); }
.score-btn.active-4 { background:rgba(34,197,94,0.12); border-color:rgba(34,197,94,0.45); box-shadow:0 2px 8px rgba(34,197,94,0.18); }
.score-btn.active-5 { background:rgba(34,197,94,0.22); border-color:rgba(34,197,94,0.6); box-shadow:0 2px 8px rgba(34,197,94,0.28); }
.score-btn-num { font-size:15px; font-weight:800; color:var(--mqc-text); line-height:1; }
.score-btn.active-1 .score-btn-num,.score-btn.active-2 .score-btn-num { color:var(--mqc-red); }
.score-btn.active-3 .score-btn-num { color:var(--mqc-amber); }
.score-btn.active-4 .score-btn-num,.score-btn.active-5 .score-btn-num { color:var(--mqc-green); }
.score-btn-lbl { font-size:8px; font-weight:700; text-transform:uppercase; letter-spacing:0.04em; color:var(--mqc-muted); }

/* Score Summary */
.score-summary { padding:16px 18px; border-top:1px solid var(--mqc-border); background:linear-gradient(180deg, var(--mqc-panel-2) 0%, var(--mqc-panel-3) 100%); }
.score-main-row { display:flex; align-items:center; justify-content:space-between; margin-bottom:14px; }
.score-display { display:flex; flex-direction:column; gap:5px; }
.score-label { font-size:9.5px; font-weight:700; text-transform:uppercase; letter-spacing:0.1em; color:var(--mqc-muted); }
.score-final { font-size:36px; font-weight:900; font-variant-numeric:tabular-nums; letter-spacing:-0.03em; color:var(--mqc-text); line-height:1; }
.score-final span { font-size:14px; font-weight:500; color:var(--mqc-muted); }
.score-verdict { display:inline-flex; align-items:center; font-size:11px; font-weight:700; letter-spacing:0.04em; text-transform:uppercase; padding:5px 14px; border-radius:20px; }
.score-verdict.excellent { background:rgba(34,197,94,0.16); color:var(--mqc-green); border:1px solid rgba(34,197,94,0.38); }
.score-verdict.usable    { background:rgba(6,182,212,0.14);  color:var(--mqc-cyan);  border:1px solid rgba(6,182,212,0.35); }
.score-verdict.borderline{ background:rgba(245,158,11,0.14); color:var(--mqc-amber); border:1px solid rgba(245,158,11,0.35); }
.score-verdict.reject    { background:rgba(239,68,68,0.14);  color:var(--mqc-red);   border:1px solid rgba(239,68,68,0.35); }
.score-verdict.pending   { background:rgba(107,114,128,0.1); color:var(--mqc-muted); border:1px solid var(--mqc-border); }
.breakdown-header { font-size:9.5px; font-weight:700; text-transform:uppercase; letter-spacing:0.1em; color:var(--mqc-muted); margin-bottom:8px; }
.score-breakdown { display:flex; flex-direction:column; gap:6px; }
.breakdown-row   { display:flex; align-items:center; gap:8px; }
.breakdown-label { font-size:10.5px; color:var(--mqc-muted); width:130px; flex-shrink:0; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
.breakdown-track { flex:1; height:5px; border-radius:3px; background:var(--mqc-faint); overflow:hidden; }
.breakdown-fill  { height:100%; border-radius:3px; background:var(--mqc-accent); transition:width 0.5s cubic-bezier(0.4,0,0.2,1); }
.breakdown-pts   { font-size:10.5px; font-weight:700; color:var(--mqc-text); min-width:30px; text-align:right; font-variant-numeric:tabular-nums; }

/* Decision Panel */
.decision-panel { padding:16px 18px; border-top:1px solid var(--mqc-border); display:flex; gap:10px; background:var(--mqc-panel); }
.btn-accept,.btn-reject { flex:1; padding:11px 0; border-radius:9px; font-size:13px; font-weight:700; cursor:pointer; display:flex; align-items:center; justify-content:center; gap:7px; letter-spacing:0.02em; transition:all 150ms ease; }
.btn-accept { background:rgba(34,197,94,0.13); color:var(--mqc-green); border:1px solid rgba(34,197,94,0.35); }
.btn-accept:hover { background:rgba(34,197,94,0.25); border-color:rgba(34,197,94,0.65); box-shadow:0 4px 14px rgba(34,197,94,0.2); transform:translateY(-1px); }
.btn-accept:active { transform:scale(0.97); }
.btn-reject { background:rgba(239,68,68,0.1); color:var(--mqc-red); border:1px solid rgba(239,68,68,0.3); }
.btn-reject:hover { background:rgba(239,68,68,0.22); border-color:rgba(239,68,68,0.6); box-shadow:0 4px 14px rgba(239,68,68,0.18); transform:translateY(-1px); }
.btn-reject:active { transform:scale(0.97); }
.btn-accept:disabled,.btn-reject:disabled { opacity:0.35; cursor:not-allowed; pointer-events:none; transform:none; box-shadow:none; }

/* Toast */
.mqc-toast { position:fixed; bottom:28px; right:28px; z-index:9999; background:var(--mqc-panel); border:1px solid var(--mqc-border); border-radius:12px; padding:14px 20px; box-shadow:var(--mqc-shadow-lg); display:flex; align-items:center; gap:12px; font-size:13px; font-weight:500; color:var(--mqc-text); transform:translateY(12px) scale(0.96); opacity:0; transition:all 280ms cubic-bezier(0.16,1,0.3,1); pointer-events:none; }
.mqc-toast.show { transform:translateY(0) scale(1); opacity:1; }
.mqc-toast-icon { font-size:18px; }

/* Animations */
@keyframes mqcFadeIn { from { opacity:0; transform:translateY(6px); } to { opacity:1; transform:translateY(0); } }
.mqc-panel { animation:mqcFadeIn 240ms ease both; }
.batch-card { animation:mqcFadeIn 200ms ease both; }

/* Responsive */
@media (max-width:768px) { .batch-card { min-width:220px; } .score-btn-lbl { display:none; } .breakdown-label { width:100px; } .score-final { font-size:28px; } }
@media (max-width:480px) { .player-section { padding:12px 14px; } .decision-panel { padding:12px 14px; } }
</style>

<!-- PAGE CONTENT -->
<div class="mqc-page">

  <div class="mqc-section-label">Select Batch</div>
  <div class="batch-selector-row" id="batchSelectorRow"></div>

  <div class="mqc-main-grid">

    <!-- LEFT: CLIPS + PLAYER -->
    <div class="mqc-panel" id="leftPanel">
      <div class="mqc-panel-header">
        <div>
          <div class="mqc-panel-title" id="leftPanelTitle">Audio Clips</div>
          <div class="mqc-panel-sub" id="leftPanelSub">Select a batch to begin review</div>
        </div>
        <span class="mqc-panel-badge" id="leftBadge"></span>
      </div>

      <div class="clips-list" id="clipsList"></div>

      <div class="batch-progress-bar">
        <span class="bp-label">Clips reviewed</span>
        <div class="bp-track"><div class="bp-fill" id="bpFill" style="width:0%"></div></div>
        <span class="bp-count" id="bpCount">0 / 0</span>
      </div>

      <div class="player-section" id="playerSection">
        <div class="player-empty" id="playerEmpty">
          <span class="player-empty-icon">&#127911;</span>
          <span class="player-empty-text">Select a clip above to start playback</span>
        </div>
        <div id="playerActive" style="display:none">
          <div class="player-clip-info">
            <span class="player-clip-id" id="playerClipId">—</span>
            <div class="player-clip-nav">
              <button class="player-nav-btn" id="btnPrevClip" title="Previous clip">&#9664;</button>
              <button class="player-nav-btn" id="btnNextClip" title="Next clip">&#9654;</button>
            </div>
          </div>
          <div class="audio-controls">
            <button class="play-pause-btn" id="playPauseBtn">&#9654;</button>
            <div class="progress-wrap">
              <div class="progress-bar-outer" id="progressBarOuter">
                <div class="progress-bar-fill" id="progressBarFill"></div>
              </div>
              <div class="progress-time">
                <span id="timeCurrent">0:00</span>
                <span id="timeDuration">0:00</span>
              </div>
            </div>
          </div>
          <div class="player-transcript-box">
            <div class="player-transcript-label">Transcript</div>
            <div class="player-transcript-text" id="playerTranscript">—</div>
          </div>
        </div>
      </div>
    </div>

    <!-- RIGHT: SCORING PANEL -->
    <div class="mqc-panel scoring-panel" id="scoringPanel">
      <div class="mqc-panel-header">
        <div>
          <div class="mqc-panel-title">Batch QC Scoring</div>
          <div class="mqc-panel-sub" id="scoringBatchName">No batch selected</div>
        </div>
      </div>

      <div class="scoring-panel-scroll">
        <div class="scoring-questions" id="scoringQuestions"></div>

        <div class="score-summary" id="scoreSummary">
          <div class="score-main-row">
            <div class="score-display">
              <span class="score-label">Weighted Score</span>
              <span class="score-final" id="finalScore">—<span>/ 5.0</span></span>
            </div>
            <span class="score-verdict pending" id="scoreVerdict">Not Scored</span>
          </div>
          <div class="breakdown-header">Per-criterion contribution</div>
          <div class="score-breakdown" id="scoreBreakdown"></div>
        </div>

        <div class="decision-panel">
          <button class="btn-accept" id="btnAccept" disabled>&#10003;&nbsp; Accept Batch</button>
          <button class="btn-reject" id="btnReject" disabled>&#10007;&nbsp; Reject Batch</button>
        </div>
      </div>
    </div>

  </div>
</div>

<div class="mqc-toast" id="mqcToast">
  <span class="mqc-toast-icon" id="toastIcon">&#10003;</span>
  <span id="toastMsg">Batch accepted</span>
</div>

<script src="${pageContext.request.contextPath}/static/js/manual-qc.js"></script>