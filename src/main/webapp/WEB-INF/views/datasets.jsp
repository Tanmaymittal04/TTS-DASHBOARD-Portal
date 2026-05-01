<%-- ═══════════════════════════════════════════════════════════════
     datasets.jsp — Datasets Management Page
     Charts: status doughnut, clips by language bar,
             hours by category grouped bar
     DataTable: full datasets list
════════════════════════════════════════════════════════════════ --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- ── KPI ROW ──────────────────────────────────────────────────── -->
<div class="kpi-grid kpi-grid--4">

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
      <span class="kpi-label">Approved</span>
      <span class="kpi-value">6</span>
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
      <span class="kpi-value">166,600</span>
    </div>
  </div>

  <div class="kpi-card">
    <div class="kpi-icon kpi-icon--warning">
      <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
           stroke="currentColor" stroke-width="2" stroke-linecap="round">
        <circle cx="12" cy="12" r="10"/>
        <polyline points="12 6 12 12 16 14"/>
      </svg>
    </div>
    <div class="kpi-body">
      <span class="kpi-label">Total Hours</span>
      <span class="kpi-value">325.7h</span>
    </div>
  </div>

</div>

<!-- ── CHARTS ROW ─────────────────────────────────────────────────── -->
<div class="charts-row">

  <div class="chart-card chart-card--third">
    <div class="chart-card-header">
      <span class="chart-title">Status Distribution</span>
    </div>
    <div class="chart-body" style="height:200px">
      <canvas id="chartDSStatus"></canvas>
    </div>
  </div>

  <div class="chart-card chart-card--third">
    <div class="chart-card-header">
      <span class="chart-title">Clips by Language</span>
    </div>
    <div class="chart-body" style="height:200px">
      <canvas id="chartDSClipsByLang"></canvas>
    </div>
  </div>

  <div class="chart-card chart-card--third">
    <div class="chart-card-header">
      <span class="chart-title">Hours by Category</span>
    </div>
    <div class="chart-body" style="height:200px">
      <canvas id="chartDSHoursByCategory"></canvas>
    </div>
  </div>

</div>

<!-- ── DATASETS TABLE ─────────────────────────────────────────────── -->
<div class="section-card">
  <div class="section-card-header">
    <span class="section-title">All Datasets</span>
    <c:if test="${sessionScope.userRole == 'ADMIN' || sessionScope.userRole == 'SUPERADMIN'}">
      <a href="${pageContext.request.contextPath}/intake"
         class="btn btn-sm btn-primary">+ New Dataset</a>
    </c:if>
  </div>
  <div class="table-responsive">
    <table class="data-table" id="tblDatasets">
      <thead>
        <tr>
          <th>ID</th>
          <th>Name</th>
          <th>Language</th>
          <th>Category</th>
          <th class="dt-right">Clips</th>
          <th class="dt-right">Hours</th>
          <th class="dt-right">Speakers</th>
          <th>Status</th>
          <th>Created By</th>
          <th>Created At</th>
        </tr>
      </thead>
      <tbody id="datasetTableBody"></tbody>
    </table>
  </div>
</div>