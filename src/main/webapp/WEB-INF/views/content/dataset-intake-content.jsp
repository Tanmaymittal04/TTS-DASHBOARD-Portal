<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%>

<style>
/* ══════════════════════════════════════════════════════════════
   DATASET INTAKE — ENTERPRISE UI  (all scoped to .di-* or page-*)
   ══════════════════════════════════════════════════════════════ */

/* ── Reset & Root ── */
*, *::before, *::after { box-sizing: border-box; }

:root {
  --di-bg:           #0f1117;
  --di-surface:      #181b23;
  --di-surface2:     #1e222e;
  --di-surface3:     #252a38;
  --di-border:       rgba(255,255,255,0.07);
  --di-border-hover: rgba(255,255,255,0.14);
  --di-text:         #e2e4ed;
  --di-text-muted:   #7a7f96;
  --di-text-dim:     #4e5368;
  --di-accent:       #5794f2;
  --di-accent2:      #3a6fd8;
  --di-radius:       12px;
  --di-radius-sm:    8px;
  --di-radius-xs:    5px;
  --di-shadow:       0 2px 16px rgba(0,0,0,0.45);
  --di-shadow-lg:    0 8px 40px rgba(0,0,0,0.65);
  --di-transition:   0.22s cubic-bezier(0.4,0,0.2,1);

  /* accent palette */
  --col-blue:   #5794f2;
  --col-teal:   #01a9b1;
  --col-purple: #b877d9;
  --col-orange: #ff9830;
  --col-green:  #73bf69;
  --col-cyan:   #56d0e0;
  --col-lime:   #c8f000;
  --col-yellow: #fade2a;
  --col-red:    #f2495c;
}

/* ── Page Header ── */
.page-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  flex-wrap: wrap;
  gap: 12px;
  padding: 24px 28px 20px;
  background: linear-gradient(135deg, #13172100 0%, rgba(87,148,242,0.04) 100%);
  border-bottom: 1px solid var(--di-border);
  margin-bottom: 0;
}

.page-title {
  font-size: clamp(1.3rem, 2.5vw, 1.75rem);
  font-weight: 700;
  color: var(--di-text);
  margin: 0;
  letter-spacing: -0.3px;
  background: linear-gradient(135deg, #e2e4ed 0%, #5794f2 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.page-subtitle {
  font-size: 0.82rem;
  color: var(--di-text-muted);
  margin: 3px 0 0;
  letter-spacing: 0.01em;
}

.page-header-actions {
  display: flex;
  align-items: center;
  gap: 12px;
}

.live-clock {
  font-size: 0.78rem;
  font-family: 'Courier New', monospace;
  color: var(--di-text-muted);
  background: var(--di-surface2);
  border: 1px solid var(--di-border);
  padding: 6px 14px;
  border-radius: 20px;
  letter-spacing: 0.04em;
  white-space: nowrap;
}

/* ── KPI Grid ── */
.kpi-grid {
  display: grid;
  gap: 14px;
  padding: 20px 28px;
  background: var(--di-bg);
}

.kpi-8 { grid-template-columns: repeat(8, 1fr); }

@media (max-width: 1280px) { .kpi-8 { grid-template-columns: repeat(4, 1fr); } }
@media (max-width: 768px)  { .kpi-8 { grid-template-columns: repeat(2, 1fr); } }
@media (max-width: 420px)  { .kpi-8 { grid-template-columns: 1fr 1fr; gap: 10px; padding: 14px 16px; } }

.kpi-card {
  position: relative;
  background: var(--di-surface);
  border: 1px solid var(--di-border);
  border-radius: var(--di-radius);
  padding: 16px 14px 14px;
  overflow: hidden;
  transition: transform var(--di-transition), box-shadow var(--di-transition), border-color var(--di-transition);
  cursor: default;
}

.kpi-card:hover {
  transform: translateY(-2px);
  box-shadow: var(--di-shadow);
  border-color: var(--di-border-hover);
}

.kpi-card::before {
  content: '';
  position: absolute;
  top: 0; left: 0;
  width: 100%; height: 3px;
  border-radius: var(--di-radius) var(--di-radius) 0 0;
}

.kpi-card.accent-blue::before   { background: var(--col-blue); }
.kpi-card.accent-teal::before   { background: var(--col-teal); }
.kpi-card.accent-purple::before { background: var(--col-purple); }
.kpi-card.accent-orange::before { background: var(--col-orange); }
.kpi-card.accent-green::before  { background: var(--col-green); }
.kpi-card.accent-cyan::before   { background: var(--col-cyan); }
.kpi-card.accent-lime::before   { background: var(--col-lime); }
.kpi-card.accent-yellow::before { background: var(--col-yellow); }

.kpi-icon-bg {
  font-size: 1.35rem;
  line-height: 1;
  margin-bottom: 8px;
  opacity: 0.85;
}

.kpi-label {
  font-size: 0.7rem;
  font-weight: 600;
  color: var(--di-text-muted);
  text-transform: uppercase;
  letter-spacing: 0.07em;
  margin-bottom: 4px;
}

.kpi-value {
  font-size: clamp(1.4rem, 2.2vw, 1.85rem);
  font-weight: 800;
  color: var(--di-text);
  line-height: 1;
  letter-spacing: -0.5px;
}

.kpi-unit {
  font-size: 0.75rem;
  font-weight: 500;
  color: var(--di-text-muted);
  margin-left: 2px;
}

/* ── Section Header ── */
.di-section-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  flex-wrap: wrap;
  gap: 10px;
  padding: 22px 28px 12px;
}

.di-section-title {
  font-size: clamp(1rem, 1.8vw, 1.15rem);
  font-weight: 700;
  color: var(--di-text);
  margin: 0;
  display: flex;
  align-items: center;
  gap: 8px;
}

.di-section-icon { font-size: 1.1rem; }

.di-section-badge {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-width: 22px;
  height: 22px;
  padding: 0 7px;
  border-radius: 11px;
  font-size: 0.7rem;
  font-weight: 700;
  background: rgba(87,148,242,0.18);
  color: var(--col-blue);
  border: 1px solid rgba(87,148,242,0.28);
}

.di-section-sub {
  font-size: 0.78rem;
  color: var(--di-text-muted);
  margin: 4px 0 0;
}

/* ── User Card Grid ── */
.di-user-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 16px;
  padding: 4px 28px 24px;
}

@media (max-width: 640px) {
  .di-user-grid { grid-template-columns: 1fr; padding: 4px 14px 20px; }
}

.di-user-card {
  background: var(--di-surface);
  border: 1px solid var(--di-border);
  border-radius: var(--di-radius);
  padding: 16px;
  cursor: pointer;
  transition: all var(--di-transition);
  position: relative;
  overflow: hidden;
}

.di-user-card::after {
  content: '';
  position: absolute;
  inset: 0;
  background: radial-gradient(circle at 80% 20%, rgba(87,148,242,0.06) 0%, transparent 70%);
  opacity: 0;
  transition: opacity var(--di-transition);
  pointer-events: none;
}

.di-user-card:hover,
.di-user-card.di-active {
  border-color: rgba(87,148,242,0.4);
  box-shadow: 0 0 0 1px rgba(87,148,242,0.2), var(--di-shadow);
  transform: translateY(-2px);
}

.di-user-card:hover::after,
.di-user-card.di-active::after { opacity: 1; }

.di-user-card.di-active {
  background: linear-gradient(135deg, var(--di-surface) 0%, rgba(87,148,242,0.06) 100%);
}

.di-uc-header {
  display: flex;
  align-items: center;
  gap: 11px;
  margin-bottom: 13px;
}

.di-uc-avatar {
  width: 38px;
  height: 38px;
  border-radius: 50%;
  background: linear-gradient(135deg, var(--col-blue) 0%, var(--col-purple) 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 700;
  font-size: 1rem;
  color: #fff;
  flex-shrink: 0;
  box-shadow: 0 2px 8px rgba(87,148,242,0.3);
}

.di-uc-info { flex: 1; min-width: 0; }

.di-uc-name {
  font-weight: 600;
  font-size: 0.9rem;
  color: var(--di-text);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.di-uc-meta {
  font-size: 0.72rem;
  color: var(--di-text-muted);
  margin-top: 2px;
}

.di-uc-arrow {
  font-size: 1.2rem;
  color: var(--di-text-muted);
  transition: transform var(--di-transition), color var(--di-transition);
  flex-shrink: 0;
  width: 20px;
  text-align: center;
}

.di-user-card.di-active .di-uc-arrow { color: var(--col-blue); }

.di-uc-stats {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 6px;
  margin-bottom: 12px;
}

.di-uc-stat {
  background: var(--di-surface2);
  border: 1px solid var(--di-border);
  border-radius: var(--di-radius-xs);
  padding: 6px 4px;
  text-align: center;
}

.di-uc-sv {
  font-size: 0.85rem;
  font-weight: 700;
  color: var(--di-text);
  line-height: 1.2;
}

.di-uc-sl {
  font-size: 0.62rem;
  color: var(--di-text-muted);
  text-transform: uppercase;
  letter-spacing: 0.05em;
  margin-top: 2px;
}

.di-uc-bar-wrap {
  display: flex;
  align-items: center;
  gap: 8px;
}

.di-uc-bar {
  flex: 1;
  height: 5px;
  background: var(--di-surface3);
  border-radius: 3px;
  overflow: hidden;
}

.di-uc-bar-fill {
  height: 100%;
  background: linear-gradient(90deg, var(--col-blue) 0%, var(--col-teal) 100%);
  border-radius: 3px;
  transition: width 0.6s ease;
}

.di-uc-bar-label {
  font-size: 0.7rem;
  color: var(--di-text-muted);
  white-space: nowrap;
  font-weight: 500;
}

/* ── Batch Section ── */
.di-batch-section {
  margin: 0 28px 24px;
  background: var(--di-surface);
  border: 1px solid var(--di-border);
  border-radius: var(--di-radius);
  overflow: hidden;
  box-shadow: var(--di-shadow);
  animation: diFadeSlide 0.3s ease both;
}

@keyframes diFadeSlide {
  from { opacity: 0; transform: translateY(-8px); }
  to   { opacity: 1; transform: translateY(0); }
}

@media (max-width: 640px) {
  .di-batch-section { margin: 0 14px 20px; }
}

.di-hidden { display: none !important; }

.di-batch-section .di-section-header {
  padding: 16px 20px 12px;
  background: var(--di-surface2);
  border-bottom: 1px solid var(--di-border);
  margin: 0;
  align-items: center;
}

.di-highlight {
  color: var(--col-blue);
  font-weight: 600;
}

.di-close-btn {
  display: inline-flex;
  align-items: center;
  gap: 5px;
  font-size: 0.78rem;
  font-weight: 600;
  color: var(--di-text-muted);
  background: var(--di-surface3);
  border: 1px solid var(--di-border);
  border-radius: 20px;
  padding: 6px 14px;
  cursor: pointer;
  transition: all var(--di-transition);
  white-space: nowrap;
}

.di-close-btn:hover {
  color: var(--di-text);
  border-color: var(--di-border-hover);
  background: rgba(242,73,92,0.08);
}

/* ── Panel ── */
.di-panel {
  background: var(--di-surface);
  border: 1px solid var(--di-border);
  border-radius: var(--di-radius);
  overflow: hidden;
}

.di-panel-header {
  padding: 12px 16px;
  background: var(--di-surface2);
  border-bottom: 1px solid var(--di-border);
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.di-panel-title {
  font-size: 0.82rem;
  font-weight: 600;
  color: var(--di-text);
  letter-spacing: 0.01em;
}

.di-panel-body { padding: 16px; }
.di-p0 .di-panel-body { padding: 0; }

/* ── DataTable Overrides ── */
.di-table { color: var(--di-text); font-size: 0.8rem; }

div.dataTables_wrapper { color: var(--di-text); }

.di-table.dataTable thead th {
  background: var(--di-surface2) !important;
  color: var(--di-text-muted);
  font-size: 0.7rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.06em;
  border-bottom: 1px solid var(--di-border) !important;
  border-top: none !important;
  padding: 10px 12px;
  white-space: nowrap;
}

.di-table.dataTable tbody tr {
  background: var(--di-surface) !important;
  border-bottom: 1px solid var(--di-border);
  transition: background var(--di-transition);
}

.di-table.dataTable tbody tr:hover {
  background: var(--di-surface2) !important;
}

.di-table.dataTable tbody td {
  padding: 9px 12px;
  border-top: none !important;
  vertical-align: middle;
  color: var(--di-text);
}

.dataTables_wrapper .dataTables_filter input {
  background: var(--di-surface2);
  border: 1px solid var(--di-border);
  border-radius: var(--di-radius-xs);
  color: var(--di-text);
  padding: 5px 10px;
  font-size: 0.78rem;
  outline: none;
  transition: border-color var(--di-transition);
  margin-left: 6px;
}

.dataTables_wrapper .dataTables_filter input:focus {
  border-color: var(--col-blue);
  box-shadow: 0 0 0 2px rgba(87,148,242,0.15);
}

.dataTables_wrapper .dataTables_filter label,
.dataTables_wrapper .dataTables_length label,
.dataTables_wrapper .dataTables_info { color: var(--di-text-muted); font-size: 0.78rem; }

.dataTables_wrapper .dataTables_length select {
  background: var(--di-surface2);
  border: 1px solid var(--di-border);
  border-radius: var(--di-radius-xs);
  color: var(--di-text);
  padding: 4px 6px;
  font-size: 0.78rem;
  outline: none;
  margin: 0 4px;
}

.dataTables_wrapper .dataTables_paginate .paginate_button {
  color: var(--di-text-muted) !important;
  font-size: 0.78rem;
  padding: 4px 9px !important;
  border-radius: var(--di-radius-xs) !important;
  border: none !important;
  transition: all var(--di-transition);
}

.dataTables_wrapper .dataTables_paginate .paginate_button:hover {
  background: var(--di-surface3) !important;
  color: var(--di-text) !important;
  border: none !important;
}

.dataTables_wrapper .dataTables_paginate .paginate_button.current {
  background: rgba(87,148,242,0.15) !important;
  color: var(--col-blue) !important;
  border: 1px solid rgba(87,148,242,0.3) !important;
  font-weight: 600;
}

.dataTables_wrapper .dataTables_paginate .paginate_button.disabled {
  opacity: 0.35 !important;
}

.di-dt-top {
  display: flex;
  align-items: center;
  justify-content: space-between;
  flex-wrap: wrap;
  gap: 8px;
  padding: 12px 16px;
  background: var(--di-surface2);
  border-bottom: 1px solid var(--di-border);
}

.di-dt-bot {
  display: flex;
  align-items: center;
  justify-content: space-between;
  flex-wrap: wrap;
  gap: 8px;
  padding: 10px 16px;
  background: var(--di-surface2);
  border-top: 1px solid var(--di-border);
}

/* ── Badges ── */
.di-badge {
  display: inline-flex;
  align-items: center;
  padding: 2px 9px;
  border-radius: 12px;
  font-size: 0.68rem;
  font-weight: 600;
  letter-spacing: 0.03em;
  white-space: nowrap;
  text-transform: capitalize;
}

.di-badge-success { background: rgba(115,191,105,0.15); color: var(--col-green);  border: 1px solid rgba(115,191,105,0.25); }
.di-badge-info    { background: rgba(87,148,242,0.15);  color: var(--col-blue);   border: 1px solid rgba(87,148,242,0.25); }
.di-badge-warn    { background: rgba(255,152,48,0.15);  color: var(--col-orange); border: 1px solid rgba(255,152,48,0.25); }
.di-badge-danger  { background: rgba(242,73,92,0.15);   color: var(--col-red);    border: 1px solid rgba(242,73,92,0.25); }
.di-badge-purple  { background: rgba(184,119,217,0.15); color: var(--col-purple); border: 1px solid rgba(184,119,217,0.25); }
.di-badge-ok      { background: rgba(115,191,105,0.1);  color: var(--col-green);  border: 1px solid rgba(115,191,105,0.2); }
.di-badge-muted   { background: var(--di-surface3);     color: var(--di-text-muted); border: 1px solid var(--di-border); }

/* ── Mini Bar ── */
.di-mini-bar {
  height: 4px;
  background: var(--di-surface3);
  border-radius: 3px;
  overflow: hidden;
  margin-bottom: 3px;
  width: 60px;
}

.di-mini-fill {
  height: 100%;
  border-radius: 3px;
  transition: width 0.5s ease;
}

.di-fill-green  { background: linear-gradient(90deg, var(--col-green), var(--col-teal)); }
.di-fill-orange { background: var(--col-orange); }
.di-fill-red    { background: var(--col-red); }

/* ── Drawer ── */
.di-drawer {
  position: fixed;
  inset: 0;
  z-index: 1050;
  display: flex;
  align-items: stretch;
  justify-content: flex-end;
  pointer-events: none;
}

.di-drawer.di-open { pointer-events: all; }

.di-drawer-overlay {
  position: absolute;
  inset: 0;
  background: rgba(0,0,0,0.65);
  backdrop-filter: blur(3px);
  -webkit-backdrop-filter: blur(3px);
  opacity: 0;
  transition: opacity var(--di-transition);
}

.di-drawer.di-open .di-drawer-overlay { opacity: 1; }

.di-drawer-panel {
  position: relative;
  z-index: 1;
  width: min(820px, 95vw);
  height: 100vh;
  background: var(--di-surface);
  border-left: 1px solid var(--di-border);
  box-shadow: -8px 0 40px rgba(0,0,0,0.6);
  display: flex;
  flex-direction: column;
  transform: translateX(100%);
  transition: transform 0.32s cubic-bezier(0.4,0,0.2,1);
}

.di-drawer.di-open .di-drawer-panel { transform: translateX(0); }

.di-drawer-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  padding: 18px 22px;
  background: var(--di-surface2);
  border-bottom: 1px solid var(--di-border);
  flex-shrink: 0;
}

.di-drawer-titles { flex: 1; min-width: 0; }

.di-drawer-title {
  font-size: clamp(0.9rem, 1.5vw, 1.05rem);
  font-weight: 700;
  color: var(--di-text);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.di-drawer-sub {
  font-size: 0.72rem;
  color: var(--di-text-muted);
  font-family: 'Courier New', monospace;
  margin-top: 2px;
}

.di-drawer-close {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  background: var(--di-surface3);
  border: 1px solid var(--di-border);
  color: var(--di-text-muted);
  font-size: 0.9rem;
  cursor: pointer;
  transition: all var(--di-transition);
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.di-drawer-close:hover {
  background: rgba(242,73,92,0.15);
  border-color: rgba(242,73,92,0.35);
  color: var(--col-red);
}

.di-drawer-body {
  flex: 1;
  overflow-y: auto;
  overflow-x: hidden;
  padding: 20px 22px;
  scroll-behavior: smooth;
}

/* Scrollbar */
.di-drawer-body::-webkit-scrollbar { width: 5px; }
.di-drawer-body::-webkit-scrollbar-track { background: transparent; }
.di-drawer-body::-webkit-scrollbar-thumb { background: var(--di-surface3); border-radius: 3px; }
.di-drawer-body::-webkit-scrollbar-thumb:hover { background: var(--di-text-dim); }

/* ── Drawer Sections ── */
.di-drw-section { margin-bottom: 22px; }

.di-drw-sec-title {
  font-size: 0.78rem;
  font-weight: 700;
  color: var(--di-text-muted);
  text-transform: uppercase;
  letter-spacing: 0.08em;
  margin-bottom: 12px;
  padding-bottom: 8px;
  border-bottom: 1px solid var(--di-border);
  display: flex;
  align-items: center;
  gap: 6px;
}

/* ── Info Grid ── */
.di-info-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  gap: 10px;
}

@media (max-width: 540px) { .di-info-grid { grid-template-columns: 1fr 1fr; } }

.di-info-item {
  background: var(--di-surface2);
  border: 1px solid var(--di-border);
  border-radius: var(--di-radius-sm);
  padding: 10px 12px;
  transition: border-color var(--di-transition);
}

.di-info-item:hover { border-color: var(--di-border-hover); }

.di-info-key {
  font-size: 0.67rem;
  font-weight: 600;
  color: var(--di-text-muted);
  text-transform: uppercase;
  letter-spacing: 0.07em;
  margin-bottom: 4px;
}

.di-info-val {
  font-size: 0.8rem;
  color: var(--di-text);
  font-weight: 500;
  word-break: break-all;
}

.di-info-divider {
  font-size: 0.72rem;
  font-weight: 700;
  color: var(--di-text-muted);
  text-transform: uppercase;
  letter-spacing: 0.06em;
  padding: 6px 0 2px;
  border-top: 1px solid var(--di-border);
  margin-top: 4px;
}

/* ── Metrics Row ── */
.di-metrics-row {
  display: grid;
  grid-template-columns: repeat(7, 1fr);
  gap: 10px;
}

@media (max-width: 900px) { .di-metrics-row { grid-template-columns: repeat(4, 1fr); } }
@media (max-width: 540px) { .di-metrics-row { grid-template-columns: repeat(3, 1fr); } }

.di-m-card {
  background: var(--di-surface2);
  border: 1px solid var(--di-border);
  border-radius: var(--di-radius-sm);
  padding: 12px 10px;
  text-align: center;
  position: relative;
  overflow: hidden;
  transition: transform var(--di-transition), box-shadow var(--di-transition);
}

.di-m-card:hover { transform: translateY(-1px); box-shadow: 0 4px 12px rgba(0,0,0,0.3); }

.di-m-card::before {
  content: '';
  position: absolute;
  bottom: 0; left: 0;
  width: 100%; height: 2px;
}

.di-m-blue::before   { background: var(--col-blue); }
.di-m-green::before  { background: var(--col-green); }
.di-m-red::before    { background: var(--col-red); }
.di-m-teal::before   { background: var(--col-teal); }
.di-m-cyan::before   { background: var(--col-cyan); }
.di-m-lime::before   { background: var(--col-lime); }
.di-m-orange::before { background: var(--col-orange); }

.di-m-val {
  font-size: clamp(1rem, 2vw, 1.3rem);
  font-weight: 800;
  color: var(--di-text);
  line-height: 1.2;
  margin-bottom: 3px;
}

.di-m-lbl {
  font-size: 0.65rem;
  color: var(--di-text-muted);
  text-transform: uppercase;
  letter-spacing: 0.06em;
  font-weight: 600;
}

/* ── Charts Row ── */
.di-charts-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 14px;
  margin-bottom: 22px;
}

@media (max-width: 640px) {
  .di-charts-row { grid-template-columns: 1fr; }
}

.di-flex1 { flex: 1; min-width: 0; }

/* ── Skeleton ── */
@keyframes diSkel { 0%,100% { opacity: 0.4; } 50% { opacity: 0.8; } }

.di-skel-line {
  height: 10px;
  background: var(--di-surface3);
  border-radius: 5px;
  margin-bottom: 5px;
  animation: diSkel 1.4s ease-in-out infinite;
}

.di-skel-short { width: 55%; }

/* ── Misc ── */
.di-code {
  font-family: 'Courier New', monospace;
  font-size: 0.74rem;
  background: var(--di-surface3);
  border: 1px solid var(--di-border);
  border-radius: 4px;
  padding: 1px 6px;
  color: var(--col-cyan);
}

.di-num     { font-variant-numeric: tabular-nums; font-weight: 500; }
.di-green   { color: var(--col-green) !important; }
.di-red     { color: var(--col-red)   !important; }
.di-muted   { color: var(--di-text-muted); }
.di-small   { font-size: 0.72rem; }
.di-cfg-val { font-family: 'Courier New', monospace; font-size: 0.78rem; color: var(--col-cyan); }

.di-transcript { cursor: help; }

.di-empty-sm {
  text-align: center;
  padding: 28px 16px;
  color: var(--di-text-muted);
  font-size: 0.8rem;
}

.di-spinner {
  text-align: center;
  padding: 18px;
  color: var(--col-blue);
  font-size: 0.8rem;
}

/* ── Responsive padding fallback ── */
@media (max-width: 640px) {
  .page-header, .di-section-header, .kpi-grid { padding-left: 14px; padding-right: 14px; }
  .di-drawer-body { padding: 14px; }
  .di-batch-section .di-section-header { padding: 12px 14px; }
}
</style>

<script>window._ctx = '${pageContext.request.contextPath}';</script>

<%-- ── PAGE HEADER ──────────────────────────────────────────── --%>
<div class="page-header">
  <div>
    <h1 class="page-title">Dataset Intake</h1>
    <p class="page-subtitle">Pipeline data grouped by User → Batch → Chunks</p>
  </div>
  <div class="page-header-actions">
    <span class="live-clock" id="liveClock"></span>
  </div>
</div>

<%-- ── KPI BANNER ─────────────────────────────────────────────--%>
<div class="kpi-grid kpi-8">
  <div class="kpi-card accent-blue">
    <div class="kpi-icon-bg">🗄️</div>
    <div class="kpi-body">
      <div class="kpi-label">Total Batches</div>
      <div class="kpi-value"><c:out value="${kpis.totalBatches}"/></div>
    </div>
  </div>
  <div class="kpi-card accent-teal">
    <div class="kpi-icon-bg">👤</div>
    <div class="kpi-body">
      <div class="kpi-label">Active Users</div>
      <div class="kpi-value"><c:out value="${kpis.totalUsers}"/></div>
    </div>
  </div>
  <div class="kpi-card accent-purple">
    <div class="kpi-icon-bg">🎙️</div>
    <div class="kpi-body">
      <div class="kpi-label">Speakers</div>
      <div class="kpi-value"><c:out value="${kpis.totalSpeakers}"/></div>
    </div>
  </div>
  <div class="kpi-card accent-orange">
    <div class="kpi-icon-bg">🌐</div>
    <div class="kpi-body">
      <div class="kpi-label">Languages</div>
      <div class="kpi-value"><c:out value="${kpis.totalLanguages}"/></div>
    </div>
  </div>
  <div class="kpi-card accent-green">
    <div class="kpi-icon-bg">⏱️</div>
    <div class="kpi-body">
      <div class="kpi-label">Raw Hours</div>
      <div class="kpi-value"><c:out value="${kpis.totalRawHours}"/><span class="kpi-unit">h</span></div>
    </div>
  </div>
  <div class="kpi-card accent-cyan">
    <div class="kpi-icon-bg">✅</div>
    <div class="kpi-body">
      <div class="kpi-label">Clean Hours</div>
      <div class="kpi-value"><c:out value="${kpis.totalCleanHours}"/><span class="kpi-unit">h</span></div>
    </div>
  </div>
  <div class="kpi-card accent-lime">
    <div class="kpi-icon-bg">🏆</div>
    <div class="kpi-body">
      <div class="kpi-label">Approved</div>
      <div class="kpi-value"><c:out value="${kpis.approvedCount}"/></div>
    </div>
  </div>
  <div class="kpi-card accent-yellow">
    <div class="kpi-icon-bg">📥</div>
    <div class="kpi-body">
      <div class="kpi-label">In Intake</div>
      <div class="kpi-value"><c:out value="${kpis.intakeCount}"/></div>
    </div>
  </div>
</div>

<%-- ── LEVEL 1 : USER CARDS ───────────────────────────────────--%>
<div class="di-section-header">
  <div>
    <h2 class="di-section-title">
      <span class="di-section-icon">👥</span>
      Users
      <span class="di-section-badge">${fn:length(userSummaries)}</span>
    </h2>
    <p class="di-section-sub">Click any user card to expand their batch list</p>
  </div>
</div>

<div class="di-user-grid" id="diUserGrid">
  <c:forEach var="u" items="${userSummaries}" varStatus="vs">
    <c:set var="pr" value="0"/>
    <c:if test="${u.totalFiles > 0}">
      <c:set var="pr" value="${(u.passedFiles * 100) / u.totalFiles}"/>
    </c:if>

    <div class="di-user-card" id="uc-${vs.index}"
         data-username="${u.userName}"
         onclick="diLoadBatches('${u.userName}', ${vs.index})">

      <div class="di-uc-header">
        <div class="di-uc-avatar">${fn:toUpperCase(fn:substring(u.userName,0,1))}</div>
        <div class="di-uc-info">
          <div class="di-uc-name"><c:out value="${u.userName}"/></div>
          <div class="di-uc-meta">
            <c:out value="${u.totalBatches}"/> batches &bull;
            <c:out value="${u.languages}"/> langs &bull;
            <c:out value="${u.speakers}"/> speakers
          </div>
        </div>
        <div class="di-uc-arrow" id="uca-${vs.index}">›</div>
      </div>

      <div class="di-uc-stats">
        <div class="di-uc-stat">
          <div class="di-uc-sv"><c:out value="${u.totalRawHours}"/>h</div>
          <div class="di-uc-sl">Raw</div>
        </div>
        <div class="di-uc-stat">
          <div class="di-uc-sv"><c:out value="${u.totalCleanHours}"/>h</div>
          <div class="di-uc-sl">Clean</div>
        </div>
        <div class="di-uc-stat">
          <div class="di-uc-sv"><c:out value="${u.passedFiles}"/></div>
          <div class="di-uc-sl">Passed</div>
        </div>
        <div class="di-uc-stat">
          <div class="di-uc-sv"><c:out value="${u.approvedBatches}"/></div>
          <div class="di-uc-sl">Approved</div>
        </div>
      </div>

      <div class="di-uc-bar-wrap">
        <div class="di-uc-bar">
          <div class="di-uc-bar-fill" style="width:<fmt:formatNumber value='${pr}' maxFractionDigits='0'/>%"></div>
        </div>
        <span class="di-uc-bar-label">
          <fmt:formatNumber value="${pr}" maxFractionDigits="1"/>% pass rate
        </span>
      </div>
    </div>
  </c:forEach>
</div>

<%-- ── LEVEL 2 : BATCH TABLE ──────────────────────────────────--%>
<div id="diBatchSection" class="di-batch-section di-hidden">
  <div class="di-section-header">
    <h2 class="di-section-title">
      <span class="di-section-icon">📦</span>
      Batches —
      <span id="diBatchUserLabel" class="di-highlight"></span>
    </h2>
    <button class="di-close-btn" onclick="diCloseBatchSection()">✕ Close</button>
  </div>
  <div class="di-panel" style="border:none;border-radius:0;">
    <div class="di-panel-body di-p0">
      <table id="diBatchTable" class="di-table display nowrap" style="width:100%">
        <thead>
          <tr>
            <th>Batch ID</th><th>Source Name</th><th>Type</th>
            <th>Language</th><th>Speaker</th><th>Stage</th>
            <th>License</th><th>Raw h</th><th>Clean h</th>
            <th>Total Files</th><th>Passed</th><th>Failed</th>
            <th>Pass %</th><th>Created</th>
          </tr>
        </thead>
        <tbody id="diBatchTbody"></tbody>
      </table>
    </div>
  </div>
</div>

<%-- ── LEVEL 3 : DETAIL DRAWER ────────────────────────────────--%>
<div id="diDrawer" class="di-drawer">
  <div class="di-drawer-overlay" onclick="diCloseDrawer()"></div>
  <div class="di-drawer-panel">

    <div class="di-drawer-header">
      <div class="di-drawer-titles">
        <div class="di-drawer-title" id="diDrawerTitle">Batch Details</div>
        <div class="di-drawer-sub"   id="diDrawerSub"></div>
      </div>
      <button class="di-drawer-close" onclick="diCloseDrawer()">✕</button>
    </div>

    <div class="di-drawer-body">

      <%-- A : Batch Info + Config --%>
      <div class="di-drw-section">
        <div class="di-drw-sec-title">📋 Batch Info &amp; QC Configuration</div>
        <div class="di-info-grid" id="diBatchInfoGrid">
          <c:forEach begin="0" end="7">
            <div class="di-info-item">
              <div class="di-skel-line"></div>
              <div class="di-skel-line di-skel-short"></div>
            </div>
          </c:forEach>
        </div>
      </div>

      <%-- B : Metrics Cards --%>
      <div class="di-drw-section">
        <div class="di-drw-sec-title">📊 Processing Metrics</div>
        <div class="di-metrics-row" id="diMetricsRow">
          <c:forEach begin="0" end="6">
            <div class="di-m-card di-m-blue">
              <div class="di-skel-line"></div>
              <div class="di-skel-line di-skel-short"></div>
            </div>
          </c:forEach>
        </div>
      </div>

      <%-- C : Charts Row --%>
      <div class="di-charts-row">
        <div class="di-panel">
          <div class="di-panel-header">
            <div class="di-panel-title">Failure Breakdown</div>
          </div>
          <div class="di-panel-body">
            <div style="height:200px;position:relative;"><canvas id="diFailChart"></canvas></div>
          </div>
        </div>
        <div class="di-panel" id="diQcPanel">
          <div class="di-panel-header">
            <div class="di-panel-title">QC Scores (Radar)</div>
          </div>
          <div class="di-panel-body">
            <div style="height:200px;position:relative;"><canvas id="diQcChart"></canvas></div>
          </div>
        </div>
      </div>

      <%-- D : Chunk Table --%>
      <div class="di-drw-section">
        <div class="di-drw-sec-title">
          🎵 Audio Chunks
          <span class="di-section-badge" id="diChunkCount">–</span>
        </div>
        <div style="overflow-x:auto;border:1px solid var(--di-border);border-radius:var(--di-radius-sm);overflow:hidden;">
          <table id="diChunkTable" class="di-table display nowrap" style="width:100%">
            <thead>
              <tr>
                <th>Chunk ID</th><th>Video</th><th>Start</th><th>End</th>
                <th>Dur(s)</th><th>Lang</th><th>SNR</th><th>Silence</th>
                <th>Clipping</th><th>Spk Sim</th><th>Dup?</th>
                <th>Passed</th><th>QC</th><th>Fail Reason</th><th>Transcript</th>
              </tr>
            </thead>
            <tbody id="diChunkTbody"></tbody>
          </table>
        </div>
      </div>

    </div><%-- /.di-drawer-body --%>
  </div><%-- /.di-drawer-panel --%>
</div><%-- /#diDrawer --%>

<script src="${pageContext.request.contextPath}/static/js/dataset-intake.js"></script>