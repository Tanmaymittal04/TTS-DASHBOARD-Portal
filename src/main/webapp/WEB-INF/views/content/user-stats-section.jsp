<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!-- ═══════════════════════════════════════════════════════
     USER-WISE STATS — additional CSS
     ═══════════════════════════════════════════════════════ -->
<style>
/* ── User Card Grid ─────────────────────────────────────── */
.us-user-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:14px}
@media(max-width:1200px){.us-user-grid{grid-template-columns:repeat(2,1fr)}}
@media(max-width:700px) {.us-user-grid{grid-template-columns:1fr}}

.us-user-card{
  background:var(--di-panel);border:1px solid var(--di-border);
  border-radius:12px;overflow:hidden;box-shadow:var(--di-shadow);
  transition:border-color 160ms,box-shadow 160ms;
  animation:diFadeUp 220ms ease both;
}
.us-user-card:hover{
  border-color:var(--di-border-hi);
  box-shadow:0 4px 20px rgba(99,102,241,.12);
}

/* Card Header */
.us-card-head{
  display:flex;align-items:center;gap:12px;
  padding:14px 16px 12px;
  border-bottom:1px solid var(--di-border);
  background:linear-gradient(135deg,var(--di-panel) 0%,var(--di-panel-2) 100%);
  cursor:pointer;user-select:none;
}
.us-avatar{
  width:40px;height:40px;border-radius:50%;flex-shrink:0;
  background:linear-gradient(135deg,
    color-mix(in srgb,var(--us-color,#6366f1) 25%,transparent),
    color-mix(in srgb,var(--us-color,#6366f1) 10%,transparent));
  color:var(--us-color,#6366f1);font-size:13px;font-weight:800;
  display:flex;align-items:center;justify-content:center;
  border:2px solid color-mix(in srgb,var(--us-color,#6366f1) 35%,transparent);
  flex-shrink:0;
}
.us-card-meta{flex:1;min-width:0}
.us-card-name{font-size:13px;font-weight:700;color:var(--di-text)}
.us-card-sub{font-size:11px;color:var(--di-muted);margin-top:1px}
.us-card-toggle{
  width:26px;height:26px;border-radius:6px;flex-shrink:0;
  background:color-mix(in srgb,var(--di-accent) 10%,transparent);
  border:1px solid color-mix(in srgb,var(--di-accent) 20%,transparent);
  color:var(--di-accent);font-size:14px;display:flex;
  align-items:center;justify-content:center;
  transition:transform 220ms,background 160ms;
}
.us-user-card.expanded .us-card-toggle{transform:rotate(45deg)}

/* KPI mini-strip inside card */
.us-kpi-strip{
  display:flex;gap:0;border-bottom:1px solid var(--di-border);
  background:var(--di-panel-2);
}
.us-kpi-item{
  flex:1;padding:10px 12px;border-right:1px solid var(--di-border);
  display:flex;flex-direction:column;gap:2px;
}
.us-kpi-item:last-child{border-right:none}
.us-kpi-label{font-size:9px;font-weight:700;text-transform:uppercase;
  letter-spacing:.09em;color:var(--di-muted)}
.us-kpi-val{font-size:16px;font-weight:700;color:var(--di-text);
  font-variant-numeric:tabular-nums}
.us-kpi-val small{font-size:10px;font-weight:400;color:var(--di-muted)}

/* Chart area in card */
.us-card-chart{padding:14px 16px 10px;height:140px;position:relative}
.us-card-chart canvas{width:100%!important;height:100%!important;display:block}

/* ── Expanded Language Panel ────────────────────────────── */
.us-lang-panel{display:none;border-top:1px solid var(--di-border)}
.us-user-card.expanded .us-lang-panel{display:block}

.us-lang-table-wrap{overflow-x:auto;padding:0}
.us-lang-table{
  width:100%;border-collapse:collapse;font-size:11.5px;
  color:var(--di-text);
}
.us-lang-table thead th{
  font-size:9.5px;font-weight:700;text-transform:uppercase;
  letter-spacing:.07em;color:var(--di-muted);
  background:var(--di-panel-3);border-bottom:1px solid var(--di-border);
  padding:8px 12px;white-space:nowrap;
}
.us-lang-table tbody td{
  padding:8px 12px;border-bottom:1px solid var(--di-border);
  vertical-align:middle;
}
.us-lang-table tbody tr:last-child td{border-bottom:none}
.us-lang-table tbody tr:hover td{background:var(--di-panel-2)}

/* Expand trigger cells */
.us-expand-btn{
  display:inline-flex;align-items:center;gap:5px;
  font-size:10px;font-weight:700;color:var(--di-accent);
  cursor:pointer;padding:3px 8px;border-radius:5px;
  background:color-mix(in srgb,var(--di-accent) 8%,transparent);
  border:1px solid color-mix(in srgb,var(--di-accent) 18%,transparent);
  transition:background 140ms;user-select:none;white-space:nowrap;
}
.us-expand-btn:hover{background:color-mix(in srgb,var(--di-accent) 16%,transparent)}
.us-expand-btn .us-arr{display:inline-block;transition:transform 200ms;font-style:normal}
.us-expand-btn.open .us-arr{transform:rotate(90deg)}

/* ── Batch sub-rows ─────────────────────────────────────── */
.us-batch-row{display:none;background:var(--di-panel-2)}
.us-batch-row.visible{display:table-row}
.us-batch-inner{padding:0 0 0 28px}
.us-batch-table{
  width:100%;border-collapse:collapse;font-size:11px;
  margin:6px 0;
}
.us-batch-table thead th{
  font-size:9px;font-weight:700;text-transform:uppercase;
  letter-spacing:.06em;color:var(--di-muted);
  padding:6px 10px;border-bottom:1px solid var(--di-border);
  background:var(--di-panel-3);
}
.us-batch-table tbody td{
  padding:6px 10px;border-bottom:1px solid var(--di-border);
  vertical-align:middle;
}
.us-batch-table tbody tr:last-child td{border-bottom:none}
.us-batch-table tbody tr:hover td{background:var(--di-faint)}

/* ── Chunk sub-rows ─────────────────────────────────────── */
.us-chunk-row{display:none;background:var(--di-faint)}
.us-chunk-row.visible{display:table-row}
.us-chunk-inner{padding:0 0 0 48px}
.us-chunk-table{
  width:100%;border-collapse:collapse;font-size:10.5px;
}
.us-chunk-table thead th{
  font-size:8.5px;font-weight:700;text-transform:uppercase;
  letter-spacing:.06em;color:var(--di-muted);
  padding:5px 10px;border-bottom:1px solid var(--di-border);
  background:var(--di-panel-4);
}
.us-chunk-table tbody td{
  padding:5px 10px;border-bottom:1px solid var(--di-border);
  vertical-align:middle;
}
.us-chunk-table tbody tr:last-child td{border-bottom:none}

/* ── Shared pills / badges (reuse di-* naming) ──────────── */
.us-lang-pill{
  display:inline-block;font-size:9.5px;font-weight:800;
  letter-spacing:.04em;padding:2px 7px;border-radius:4px;
  background:color-mix(in srgb,var(--di-accent) 14%,transparent);
  color:var(--di-accent);
  border:1px solid color-mix(in srgb,var(--di-accent) 28%,transparent);
}
.us-mono{font-family:'JetBrains Mono','Fira Code',ui-monospace,monospace;
  font-size:10.5px;color:var(--di-accent);font-weight:600}
.us-vid-id{font-family:'JetBrains Mono','Fira Code',ui-monospace,monospace;
  font-size:10px;color:var(--di-cyan);font-weight:600}
.us-chunk-id{font-family:'JetBrains Mono','Fira Code',ui-monospace,monospace;
  font-size:10px;color:var(--di-purple);font-weight:600}

/* Progress mini bar */
.us-prog-wrap{display:flex;align-items:center;gap:6px}
.us-prog-track{flex:1;height:4px;border-radius:3px;
  background:var(--di-faint);overflow:hidden;min-width:40px}
.us-prog-fill{height:100%;border-radius:3px;transition:width .4s}
.us-prog-label{font-size:10px;color:var(--di-muted);
  white-space:nowrap;font-variant-numeric:tabular-nums}

/* Waveform sparkline (CSS-only fake) */
.us-wave{display:inline-flex;align-items:center;gap:1.5px;height:14px}
.us-wave span{
  display:inline-block;width:2.5px;border-radius:1px;
  background:var(--di-cyan);opacity:.7;
}

/* Language stats row at bottom of card */
.us-lang-stats-row{
  display:flex;gap:6px;flex-wrap:wrap;
  padding:10px 16px;border-top:1px solid var(--di-border);
  background:var(--di-panel-2);
}
.us-lang-stat-chip{
  display:inline-flex;align-items:center;gap:5px;
  font-size:10px;padding:3px 8px;border-radius:20px;
  background:var(--di-panel-3);border:1px solid var(--di-border);
  color:var(--di-text);
}
.us-lang-stat-chip .dot{
  width:6px;height:6px;border-radius:50%;flex-shrink:0;
}
</style>

<!-- ═══════════════════════════════════════════════════════
     USER-WISE STATS — HTML skeleton
     ═══════════════════════════════════════════════════════ -->
<div class="di-section-label" style="margin-top:8px">User-Wise Statistics</div>

<!-- Global user selector / search bar -->
<div style="display:flex;align-items:center;gap:10px;margin-bottom:12px;flex-wrap:wrap">
  <div style="position:relative;flex:1;min-width:200px;max-width:320px">
    <input id="usUserSearch" type="text" placeholder="Search users…"
      style="width:100%;padding:7px 12px 7px 34px;border-radius:8px;
             border:1px solid var(--di-border);background:var(--di-panel-3);
             color:var(--di-text);font-size:12px;outline:none;box-sizing:border-box">
    <span style="position:absolute;left:10px;top:50%;transform:translateY(-50%);
                 color:var(--di-muted);font-size:13px;pointer-events:none">⌕</span>
  </div>
  <div style="display:flex;gap:6px;flex-wrap:wrap" id="usLangFilter">
    <button class="us-filter-btn active" data-lang="all"
      style="font-size:10px;font-weight:700;padding:5px 12px;border-radius:20px;
             border:1px solid var(--di-border);background:var(--di-panel-3);
             color:var(--di-muted);cursor:pointer;transition:all 140ms">All Languages</button>
  </div>
  <button id="usExpandAll" style="margin-left:auto;font-size:10px;font-weight:700;
    padding:5px 14px;border-radius:6px;border:1px solid var(--di-border-hi);
    background:color-mix(in srgb,var(--di-accent) 10%,transparent);
    color:var(--di-accent);cursor:pointer">⊞ Expand All</button>
</div>

<!-- User cards injected here -->
<div class="us-user-grid" id="usUserGrid"></div>