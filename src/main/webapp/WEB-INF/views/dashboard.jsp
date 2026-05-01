<%-- ═══════════════════════════════════════════════════════════════
     dashboard.jsp — Main Overview Dashboard
     KPI cards + 4 summary charts + recent activity table
════════════════════════════════════════════════════════════════ --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"     %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"      %>

<!-- ── KPI CARDS ROW ──────────────────────────────────────────── -->
<div class="kpi-grid">

  <div class="kpi-card">
    <div class="kpi-icon kpi-icon--primary">
      <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
           stroke="currentColor" stroke-width="2" stroke-linecap="round">
        <ellipse cx="12" cy="5" rx="9" ry="3"/>
        <path d="M21 12c0 1.66-4 3-9 3s-9-1.34-9-3"/>
        <path d="M3 5v14c0 1.66 4 3 9 3s9-1.34 9-3V5"/>
      </svg>
    </div>
    <div class="kpi-body">
      <span class="kpi-label">Total Datasets</span>
      <span class="kpi-value">10</span>
      <span class="kpi-delta kpi-delta--up">+2 this month</span>
    </div>
  </div>

  <div class="kpi-card">
    <div class="kpi-icon kpi-icon--success">
      <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
           stroke="currentColor" stroke-width="2" stroke-linecap="round">
        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
        <circle cx="9" cy="7" r="4"/>
        <path d="M23 21v-2a4 4 0 0 0-3-3.87"/>
        <path d="M16 3.13a4 4 0 0 1 0 7.75"/>
      </svg>
    </div>
    <div class="kpi-body">
      <span class="kpi-label">Active Speakers</span>
      <span class="kpi-value">11</span>
      <span class="kpi-delta kpi-delta--up">+1 this month</span>
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
      <span class="kpi-label">Total Audio Hours</span>
      <span class="kpi-value">368.7h</span>
      <span class="kpi-delta kpi-delta--up">+19.2h this month</span>
    </div>
  </div>

  <div class="kpi-card">
    <div class="kpi-icon kpi-icon--warning">
      <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
           stroke="currentColor" stroke-width="2" stroke-linecap="round">
        <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/>
      </svg>
    </div>
    <div class="kpi-body">
      <span class="kpi-label">Live Deployments</span>
      <span class="kpi-value">5</span>
      <span class="kpi-delta kpi-delta--neutral">+0 this week</span>
    </div>
  </div>

  <div class="kpi-card">
    <div class="kpi-icon kpi-icon--success">
      <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
           stroke="currentColor" stroke-width="2" stroke-linecap="round">
        <polyline points="9 11 12 14 22 4"/>
        <path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/>
      </svg>
    </div>
    <div class="kpi-body">
      <span class="kpi-label">QC Pass Rate</span>
      <span class="kpi-value">87.4%</span>
      <span class="kpi-delta kpi-delta--up">+0.6% vs last week</span>
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
      <span class="kpi-label">Training Jobs</span>
      <span class="kpi-value">10</span>
      <span class="kpi-delta kpi-delta--info">1 running, 2 queued</span>
    </div>
  </div>

</div><!-- /.kpi-grid -->

<!-- ── CHARTS ROW 1 ────────────────────────────────────────────── -->
<div class="charts-row">

  <div class="chart-card chart-card--half">
    <div class="chart-card-header">
      <span class="chart-title">Dataset Status Distribution</span>
    </div>
    <div class="chart-body" style="height:220px">
      <canvas id="chartOverviewDatasetStatus"></canvas>
    </div>
  </div>

  <div class="chart-card chart-card--half">
    <div class="chart-card-header">
      <span class="chart-title">Audio Hours by Language</span>
    </div>
    <div class="chart-body" style="height:220px">
      <canvas id="chartOverviewHoursByLang"></canvas>
    </div>
  </div>

</div>

<!-- ── CHARTS ROW 2 ────────────────────────────────────────────── -->
<div class="charts-row">

  <div class="chart-card chart-card--half">
    <div class="chart-card-header">
      <span class="chart-title">Training Job Status</span>
    </div>
    <div class="chart-body" style="height:220px">
      <canvas id="chartOverviewJobStatus"></canvas>
    </div>
  </div>

  <div class="chart-card chart-card--half">
    <div class="chart-card-header">
      <span class="chart-title">Best Model MOS by Language</span>
    </div>
    <div class="chart-body" style="height:220px">
      <canvas id="chartOverviewMOS"></canvas>
    </div>
  </div>

</div>

<!-- ── RECENT ACTIVITY TABLE ──────────────────────────────────── -->
<div class="section-card" style="margin-top:24px">
  <div class="section-card-header">
    <span class="section-title">Recent Activity</span>
    <a href="${pageContext.request.contextPath}/datasets"
       class="btn btn-sm btn-outline">View All</a>
  </div>
  <div class="table-responsive">
    <table class="data-table" id="tblRecentActivity">
      <thead>
        <tr>
          <th>Dataset</th>
          <th>Language</th>
          <th>Clips</th>
          <th>Hours</th>
          <th>Status</th>
          <th>Created</th>
        </tr>
      </thead>
      <tbody id="recentActivityBody"></tbody>
    </table>
  </div>
</div>