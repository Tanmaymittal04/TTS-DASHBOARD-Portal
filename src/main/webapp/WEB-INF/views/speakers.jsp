<%-- ═══════════════════════════════════════════════════════════════
     speakers.jsp — Speakers Management Page
     Charts: gender split, recording env, clips/hours by language
     DataTable: full speakers list
════════════════════════════════════════════════════════════════ --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- ── KPI ROW ──────────────────────────────────────────────────── -->
<div class="kpi-grid kpi-grid--4">

  <div class="kpi-card">
    <div class="kpi-icon kpi-icon--primary">
      <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
           stroke="currentColor" stroke-width="2" stroke-linecap="round">
        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
        <circle cx="9" cy="7" r="4"/>
        <path d="M23 21v-2a4 4 0 0 0-3-3.87"/>
        <path d="M16 3.13a4 4 0 0 1 0 7.75"/>
      </svg>
    </div>
    <div class="kpi-body">
      <span class="kpi-label">Total Speakers</span>
      <span class="kpi-value">12</span>
    </div>
  </div>

  <div class="kpi-card">
    <div class="kpi-icon kpi-icon--success">
      <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
           stroke="currentColor" stroke-width="2" stroke-linecap="round">
        <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/>
        <polyline points="22 4 12 14.01 9 11.01"/>
      </svg>
    </div>
    <div class="kpi-body">
      <span class="kpi-label">Active</span>
      <span class="kpi-value">11</span>
    </div>
  </div>

  <div class="kpi-card">
    <div class="kpi-icon kpi-icon--info">
      <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
           stroke="currentColor" stroke-width="2" stroke-linecap="round">
        <path d="M9 18V5l12-2v13"/>
        <circle cx="6" cy="18" r="3"/><circle cx="18" cy="16" r="3"/>
      </svg>
    </div>
    <div class="kpi-body">
      <span class="kpi-label">Total Clips</span>
      <span class="kpi-value">47,800</span>
    </div>
  </div>

  <div class="kpi-card">
    <div class="kpi-icon kpi-icon--purple">
      <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
           stroke="currentColor" stroke-width="2" stroke-linecap="round">
        <circle cx="12" cy="12" r="10"/>
        <polyline points="12 6 12 12 16 14"/>
      </svg>
    </div>
    <div class="kpi-body">
      <span class="kpi-label">Total Hours</span>
      <span class="kpi-value">93.7h</span>
    </div>
  </div>

</div>

<!-- ── CHARTS ROW ────────────────────────────────────────────────── -->
<div class="charts-row">

  <div class="chart-card chart-card--third">
    <div class="chart-card-header">
      <span class="chart-title">Gender Distribution</span>
    </div>
    <div class="chart-body" style="height:200px">
      <canvas id="chartSpeakerGender"></canvas>
    </div>
  </div>

  <div class="chart-card chart-card--third">
    <div class="chart-card-header">
      <span class="chart-title">Recording Environment</span>
    </div>
    <div class="chart-body" style="height:200px">
      <canvas id="chartSpeakerEnv"></canvas>
    </div>
  </div>

  <div class="chart-card chart-card--third">
    <div class="chart-card-header">
      <span class="chart-title">Clips by Language</span>
    </div>
    <div class="chart-body" style="height:200px">
      <canvas id="chartSpeakerClipsByLang"></canvas>
    </div>
  </div>

</div>

<!-- ── SPEAKERS TABLE ─────────────────────────────────────────────── -->
<div class="section-card">
  <div class="section-card-header">
    <span class="section-title">All Speakers</span>
  </div>
  <div class="table-responsive">
    <table class="data-table" id="tblSpeakers">
      <thead>
        <tr>
          <th>ID</th>
          <th>Name</th>
          <th>Language</th>
          <th>Gender</th>
          <th>Age</th>
          <th>Accent</th>
          <th>Environment</th>
          <th class="dt-right">Total Clips</th>
          <th class="dt-right">Hours</th>
          <th>Status</th>
        </tr>
      </thead>
      <tbody id="speakerTableBody"></tbody>
    </table>
  </div>
</div>