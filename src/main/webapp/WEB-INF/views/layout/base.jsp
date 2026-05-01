<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>TTS Portal — ${pageTitle}</title>

  <!-- Google Fonts: Inter -->
  <link rel="preconnect" href="https://fonts.googleapis.com"/>
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin/>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet"/>

  <!-- Bootstrap 5 -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"/>

  <!-- DataTables Bootstrap 5 skin -->
  <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css"/>

  <!-- App CSS -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/main.css"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/dashboard.css"/>
</head>
<body>

<!-- ═══════════════════════════════════════════════════════════════
     SIDEBAR
════════════════════════════════════════════════════════════════ -->
<nav class="sidebar" id="sidebar">

  <!-- Logo + collapse button -->
  <div class="sidebar-header">
    <div class="sidebar-logo">
      <svg width="30" height="30" viewBox="0 0 32 32" fill="none" aria-label="TTS Portal">
        <rect width="32" height="32" rx="8" fill="#6366f1"/>
        <path d="M8 16 Q12 8 16 16 Q20 24 24 16"
              stroke="white" stroke-width="2.5" fill="none" stroke-linecap="round"/>
        <circle cx="8"  cy="16" r="2" fill="white"/>
        <circle cx="24" cy="16" r="2" fill="white"/>
      </svg>
      <span class="sidebar-brand">TTS Portal</span>
    </div>
    <button class="sidebar-toggle" id="sidebarToggle" aria-label="Toggle sidebar">&#9776;</button>
  </div>

  <!-- PIPELINE section -->
  <div class="sidebar-section-label">PIPELINE</div>
  <ul class="sidebar-nav">
    <li>
      <a href="${pageContext.request.contextPath}/overview"
         class="nav-link ${activePage == 'overview' ? 'active' : ''}">
        <span class="nav-icon">&#127968;</span>
        <span class="nav-text">Executive Overview</span>
      </a>
    </li>
    <li>
      <a href="${pageContext.request.contextPath}/datasets"
         class="nav-link ${activePage == 'datasets' ? 'active' : ''}">
        <span class="nav-icon">&#128230;</span>
        <span class="nav-text">Dataset Intake</span>
      </a>
    </li>
    <li>
      <a href="${pageContext.request.contextPath}/qc"
         class="nav-link ${activePage == 'qc' ? 'active' : ''}">
        <span class="nav-icon">&#128269;</span>
        <span class="nav-text">QC &amp; Data Quality</span>
      </a>
    </li>
    <li>
      <a href="${pageContext.request.contextPath}/manual-qc"
         class="nav-link ${activePage == 'qc' ? 'active' : ''}">
        <span class="nav-icon">&#128203;</span>
        <span class="nav-text">Manual QC</span>
      </a>
    </li>
    <li>
      <a href="${pageContext.request.contextPath}/scoring"
         class="nav-link ${activePage == 'scoring' ? 'active' : ''}">
        <span class="nav-icon">&#11088;</span>
        <span class="nav-text">Dataset Scoring</span>
      </a>
    </li>
  </ul>

  <!-- TRAINING section -->
  <div class="sidebar-section-label">TRAINING</div>
  <ul class="sidebar-nav">
    <li>
      <a href="${pageContext.request.contextPath}/training"
         class="nav-link ${activePage == 'training' ? 'active' : ''}">
        <span class="nav-icon">&#128640;</span>
        <span class="nav-text">Training Jobs</span>
      </a>
    </li>
    <li>
      <a href="${pageContext.request.contextPath}/evaluation"
         class="nav-link ${activePage == 'evaluation' ? 'active' : ''}">
        <span class="nav-icon">&#128202;</span>
        <span class="nav-text">Evaluation</span>
      </a>
    </li>
  </ul>

  <!-- PRODUCTION section -->
  <div class="sidebar-section-label">PRODUCTION</div>
  <ul class="sidebar-nav">
    <li>
      <a href="${pageContext.request.contextPath}/voices"
         class="nav-link ${activePage == 'voices' ? 'active' : ''}">
        <span class="nav-icon">&#127908;</span>
        <span class="nav-text">Voice Registry</span>
      </a>
    </li>
    <li>
      <a href="${pageContext.request.contextPath}/production"
         class="nav-link ${activePage == 'production' ? 'active' : ''}">
        <span class="nav-icon">&#9889;</span>
        <span class="nav-text">Production Monitor</span>
      </a>
    </li>
  </ul>

</nav>
<!-- end sidebar -->

<!-- ═══════════════════════════════════════════════════════════════
     MAIN WRAPPER
════════════════════════════════════════════════════════════════ -->
<div class="main-wrapper" id="mainWrapper">

  <!-- TOPBAR -->
  <header class="topbar">
    <div class="topbar-left">
      <h1 class="page-title">${pageTitle}</h1>
      <span class="page-subtitle">${pageSubtitle}</span>
    </div>
    <div class="topbar-right">
      <div class="status-indicator">
        <span class="status-dot"></span>
        <span class="status-text">Live</span>
      </div>
      <div class="topbar-date" id="topbarDate"></div>
      <button class="theme-toggle" id="themeToggle" aria-label="Toggle theme">&#9790;</button>
    </div>
  </header>

  <!-- PAGE CONTENT injected here -->
  <main class="page-content">
    <jsp:include page="${contentPage}"/>
  </main>

  <!-- FOOTER -->
  <footer class="page-footer">
    TTS Training Dashboard &copy; 2026 &mdash; Cyfuture AI
    &nbsp;|&nbsp; Phase 1 &mdash; Hardcoded Seed Data
  </footer>

</div>
<!-- end main-wrapper -->

<!-- ═══════════════════════════════════════════════════════════════
     GLOBAL SCRIPTS
════════════════════════════════════════════════════════════════ -->
<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<!-- Bootstrap 5 -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<!-- DataTables -->
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>

<!-- Chart.js 4 -->
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>

<!-- Three.js -->
<script src="https://cdn.jsdelivr.net/npm/three@0.160.0/build/three.min.js"></script>

<!-- Seed Data — must load before any page JS -->
<script src="${pageContext.request.contextPath}/static/js/seed-data.js"></script>

<!-- Global UI: topbar date, theme toggle, sidebar collapse -->
<script>
  // ── Topbar date ─────────────────────────────────────────────
  document.getElementById('topbarDate').textContent =
    new Date().toLocaleDateString('en-IN', {
      weekday: 'short', year: 'numeric', month: 'short', day: 'numeric'
    });

  // ── Theme toggle ─────────────────────────────────────────────
  const html         = document.documentElement;
  const themeBtn     = document.getElementById('themeToggle');
  let   currentTheme = 'dark';

  themeBtn.addEventListener('click', () => {
    currentTheme = currentTheme === 'dark' ? 'light' : 'dark';
    html.setAttribute('data-theme', currentTheme);
    themeBtn.innerHTML = currentTheme === 'dark' ? '&#9790;' : '&#9728;';
  });

  // ── Sidebar collapse ─────────────────────────────────────────
  document.getElementById('sidebarToggle').addEventListener('click', () => {
    document.getElementById('sidebar').classList.toggle('collapsed');
    document.getElementById('mainWrapper').classList.toggle('expanded');
  });
</script>

</body>
</html>