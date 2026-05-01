<%-- ═══════════════════════════════════════════════════════════════
     sidebar.jsp — Collapsible sidebar with nav groups,
     active-link detection, and role-based visibility
════════════════════════════════════════════════════════════════ --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<%-- Resolve current URI for active-link highlighting --%>
<c:set var="uri" value="${pageContext.request.requestURI}"/>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<aside class="sidebar" id="sidebar">

  <!-- ── BRAND ───────────────────────────────────────────────── -->
  <div class="sidebar-brand">
    <a href="${ctx}/dashboard" class="brand-link">
      <span class="brand-icon">🎙️</span>
      <span class="brand-text">TTS<span class="brand-accent">Studio</span></span>
    </a>
    <button class="sidebar-collapse-btn" id="sidebarCollapseBtn"
            title="Toggle sidebar" aria-label="Toggle sidebar">
      <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
           stroke="currentColor" stroke-width="2" stroke-linecap="round">
        <line x1="3" y1="12" x2="21" y2="12"/>
        <line x1="3" y1="6"  x2="21" y2="6"/>
        <line x1="3" y1="18" x2="21" y2="18"/>
      </svg>
    </button>
  </div>

  <!-- ── NAV SCROLL AREA ─────────────────────────────────────── -->
  <nav class="sidebar-nav" id="sidebarNav">

    <!-- GROUP: Overview -->
    <div class="nav-group">
      <span class="nav-group-label">Overview</span>

      <a href="${ctx}/dashboard"
         class="nav-link <c:if test='${uri == ctx.concat(\"/dashboard\")}'>active</c:if>">
        <span class="nav-icon">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
               stroke="currentColor" stroke-width="2" stroke-linecap="round">
            <rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/>
            <rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/>
          </svg>
        </span>
        <span class="nav-label">Dashboard</span>
      </a>
    </div>

    <!-- GROUP: Data Collection -->
    <div class="nav-group">
      <span class="nav-group-label">Data Collection</span>

      <a href="${ctx}/speakers"
         class="nav-link <c:if test='${fn:startsWith(uri, ctx.concat(\"/speakers\"))}'>active</c:if>">
        <span class="nav-icon">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
               stroke="currentColor" stroke-width="2" stroke-linecap="round">
            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
            <circle cx="9" cy="7" r="4"/>
            <path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/>
          </svg>
        </span>
        <span class="nav-label">Speakers</span>
      </a>

      <a href="${ctx}/intake"
         class="nav-link <c:if test='${fn:startsWith(uri, ctx.concat(\"/intake\"))}'>active</c:if>">
        <span class="nav-icon">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
               stroke="currentColor" stroke-width="2" stroke-linecap="round">
            <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/>
            <polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/>
          </svg>
        </span>
        <span class="nav-label">Dataset Intake</span>
      </a>

      <a href="${ctx}/datasets"
         class="nav-link <c:if test='${fn:startsWith(uri, ctx.concat(\"/datasets\"))}'>active</c:if>">
        <span class="nav-icon">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
               stroke="currentColor" stroke-width="2" stroke-linecap="round">
            <ellipse cx="12" cy="5" rx="9" ry="3"/>
            <path d="M21 12c0 1.66-4 3-9 3s-9-1.34-9-3"/>
            <path d="M3 5v14c0 1.66 4 3 9 3s9-1.34 9-3V5"/>
          </svg>
        </span>
        <span class="nav-label">Datasets</span>
      </a>
    </div>

    <!-- GROUP: Quality Control -->
    <div class="nav-group">
      <span class="nav-group-label">Quality Control</span>

      <a href="${ctx}/qc"
         class="nav-link <c:if test='${uri == ctx.concat(\"/qc\")}'>active</c:if>">
        <span class="nav-icon">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
               stroke="currentColor" stroke-width="2" stroke-linecap="round">
            <polyline points="9 11 12 14 22 4"/>
            <path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/>
          </svg>
        </span>
        <span class="nav-label">Audio QC</span>
      </a>

        <a href="${ctx}/manual-qc"
           class="nav-link <c:if test='${fn:startsWith(uri, ctx.concat(\"/manual-qc\"))}'>active</c:if>">
          <span class="nav-icon">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                 stroke="currentColor" stroke-width="2" stroke-linecap="round">
              <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
              <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
            </svg>
          </span>
          <span class="nav-label">Manual QC Review</span>
        </a>

      <a href="${ctx}/scoring"
         class="nav-link <c:if test='${fn:startsWith(uri, ctx.concat(\"/scoring\"))}'>active</c:if>">
        <span class="nav-icon">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
               stroke="currentColor" stroke-width="2" stroke-linecap="round">
            <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/>
          </svg>
        </span>
        <span class="nav-label">Dataset Scoring</span>
      </a>
    </div>

    <!-- GROUP: Model Lifecycle -->
    <div class="nav-group">
      <span class="nav-group-label">Model Lifecycle</span>

      <a href="${ctx}/training"
         class="nav-link <c:if test='${fn:startsWith(uri, ctx.concat(\"/training\"))}'>active</c:if>">
        <span class="nav-icon">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
               stroke="currentColor" stroke-width="2" stroke-linecap="round">
            <circle cx="12" cy="12" r="3"/>
            <path d="M19.07 4.93a10 10 0 0 1 0 14.14M4.93 4.93a10 10 0 0 0 0 14.14"/>
          </svg>
        </span>
        <span class="nav-label">Training Jobs</span>
      </a>

      <a href="${ctx}/evaluation"
         class="nav-link <c:if test='${fn:startsWith(uri, ctx.concat(\"/evaluation\"))}'>active</c:if>">
        <span class="nav-icon">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
               stroke="currentColor" stroke-width="2" stroke-linecap="round">
            <line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/>
            <line x1="6"  y1="20" x2="6"  y2="14"/>
          </svg>
        </span>
        <span class="nav-label">Evaluation</span>
      </a>

      <a href="${ctx}/deployment"
         class="nav-link <c:if test='${fn:startsWith(uri, ctx.concat(\"/deployment\"))}'>active</c:if>">
        <span class="nav-icon">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
               stroke="currentColor" stroke-width="2" stroke-linecap="round">
            <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/>
          </svg>
        </span>
        <span class="nav-label">Deployment</span>
      </a>
    </div>

    <!-- GROUP: Admin (role-gated) -->
    <c:if test="${sessionScope.userRole == 'ADMIN' || sessionScope.userRole == 'SUPERADMIN'}">
      <div class="nav-group">
        <span class="nav-group-label">Admin</span>

        <a href="${ctx}/admin/users"
           class="nav-link <c:if test='${fn:startsWith(uri, ctx.concat(\"/admin/users\"))}'>active</c:if>">
          <span class="nav-icon">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                 stroke="currentColor" stroke-width="2" stroke-linecap="round">
              <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
              <circle cx="12" cy="7" r="4"/>
            </svg>
          </span>
          <span class="nav-label">User Management</span>
        </a>

        <a href="${ctx}/admin/config"
           class="nav-link <c:if test='${fn:startsWith(uri, ctx.concat(\"/admin/config\"))}'>active</c:if>">
          <span class="nav-icon">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                 stroke="currentColor" stroke-width="2" stroke-linecap="round">
              <circle cx="12" cy="12" r="3"/>
              <path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-4 0v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83-2.83l.06-.06A1.65 1.65 0 0 0 4.68 15a1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1 0-4h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 2.83-2.83l.06.06A1.65 1.65 0 0 0 9 4.68a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 2.83l-.06.06A1.65 1.65 0 0 0 19.4 9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1z"/>
            </svg>
          </span>
          <span class="nav-label">Configuration</span>
        </a>
      </div>
    </c:if>

  </nav><!-- /.sidebar-nav -->

  <!-- ── SIDEBAR FOOTER ───────────────────────────────────────── -->
  <div class="sidebar-footer">
    <div class="sidebar-user">
      <div class="user-avatar">
        <c:out value="${fn:substring(sessionScope.userName, 0, 1)}"/>
      </div>
      <div class="user-info">
        <span class="user-name"><c:out value="${sessionScope.userName}"/></span>
        <span class="user-role"><c:out value="${sessionScope.userRole}"/></span>
      </div>
    </div>
    <a href="${ctx}/logout" class="btn-logout" title="Logout">
      <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
           stroke="currentColor" stroke-width="2" stroke-linecap="round">
        <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/>
        <polyline points="16 17 21 12 16 7"/>
        <line x1="21" y1="12" x2="9" y2="12"/>
      </svg>
    </a>
  </div>

</aside><!-- /.sidebar -->

<!-- Sidebar collapse JS -->
<script>
  (function () {
    const sidebar = document.getElementById('sidebar');
    const wrapper = document.getElementById('mainWrapper');
    const btn     = document.getElementById('sidebarCollapseBtn');
    const KEY     = 'sidebar_collapsed';

    function apply(collapsed) {
      sidebar.classList.toggle('collapsed', collapsed);
      if (wrapper) wrapper.classList.toggle('sidebar-collapsed', collapsed);
    }

    apply(localStorage.getItem(KEY) === 'true');

    if (btn) {
      btn.addEventListener('click', () => {
        const next = !sidebar.classList.contains('collapsed');
        localStorage.setItem(KEY, next);
        apply(next);
      });
    }
  })();
</script>