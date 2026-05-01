<%-- ═══════════════════════════════════════════════════════════════
     topbar.jsp — Top navigation bar
     Page title slot, global search, notifications, user dropdown
════════════════════════════════════════════════════════════════ --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"      %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"  %>

<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<header class="topbar" id="topbar">

  <!-- ── LEFT: Page title ─────────────────────────────────────── -->
  <div class="topbar-left">
    <h1 class="page-title">
      <c:out value="${pageTitle}" default="Dashboard"/>
    </h1>
    <c:if test="${not empty pageSubtitle}">
      <span class="page-subtitle">
        <c:out value="${pageSubtitle}"/>
      </span>
    </c:if>
  </div>

  <!-- ── RIGHT: Actions ──────────────────────────────────────── -->
  <div class="topbar-right">

    <!-- Global search -->
    <div class="topbar-search" id="topbarSearch">
      <svg class="search-icon" width="14" height="14" viewBox="0 0 24 24"
           fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round">
        <circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>
      </svg>
      <input type="text" id="globalSearchInput"
             class="search-input" placeholder="Search datasets, speakers…"
             autocomplete="off" spellcheck="false"/>
      <kbd class="search-kbd">⌘K</kbd>
    </div>

    <!-- Language filter pill -->
    <div class="topbar-pill" id="langFilterWrap">
      <select id="globalLangFilter" class="pill-select" title="Filter by language">
        <option value="">All Languages</option>
        <option value="hi">Hindi</option>
        <option value="ta">Tamil</option>
        <option value="te">Telugu</option>
        <option value="ml">Malayalam</option>
        <option value="kn">Kannada</option>
        <option value="bn">Bengali</option>
        <option value="mr">Marathi</option>
        <option value="gu">Gujarati</option>
      </select>
    </div>

    <!-- Notifications bell -->
    <button class="topbar-icon-btn" id="notifBtn"
            aria-label="Notifications" title="Notifications">
      <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
           stroke="currentColor" stroke-width="2" stroke-linecap="round">
        <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/>
        <path d="M13.73 21a2 2 0 0 1-3.46 0"/>
      </svg>
      <span class="notif-badge" id="notifCount">3</span>
    </button>

    <!-- Notifications dropdown -->
    <div class="dropdown-panel" id="notifPanel" hidden>
      <div class="dropdown-header">
        <span>Notifications</span>
        <button class="btn-text-sm" id="markAllRead">Mark all read</button>
      </div>
      <ul class="notif-list" id="notifList">
        <li class="notif-item unread">
          <span class="notif-dot"></span>
          <div class="notif-body">
            <p class="notif-msg">Training job <strong>job_007</strong> is now running (epoch 14/20)</p>
            <span class="notif-time">2 min ago</span>
          </div>
        </li>
        <li class="notif-item unread">
          <span class="notif-dot"></span>
          <div class="notif-body">
            <p class="notif-msg">Dataset <strong>ds_kn_001</strong> scoring flagged as <em>Rejected</em></p>
            <span class="notif-time">18 min ago</span>
          </div>
        </li>
        <li class="notif-item unread">
          <span class="notif-dot"></span>
          <div class="notif-body">
            <p class="notif-msg">QC batch completed — <strong>5,821</strong> clips failed review</p>
            <span class="notif-time">1 hr ago</span>
          </div>
        </li>
      </ul>
      <a href="${ctx}/notifications" class="dropdown-footer">View all notifications</a>
    </div>

    <!-- Theme toggle -->
    <button class="topbar-icon-btn" id="themeToggleBtn"
            aria-label="Toggle theme" title="Toggle theme">
      <svg class="icon-sun" width="18" height="18" viewBox="0 0 24 24" fill="none"
           stroke="currentColor" stroke-width="2" stroke-linecap="round">
        <circle cx="12" cy="12" r="5"/>
        <line x1="12" y1="1"  x2="12" y2="3"/>
        <line x1="12" y1="21" x2="12" y2="23"/>
        <line x1="4.22" y1="4.22" x2="5.64" y2="5.64"/>
        <line x1="18.36" y1="18.36" x2="19.78" y2="19.78"/>
        <line x1="1" y1="12" x2="3" y2="12"/>
        <line x1="21" y1="12" x2="23" y2="12"/>
        <line x1="4.22" y1="19.78" x2="5.64" y2="18.36"/>
        <line x1="18.36" y1="5.64" x2="19.78" y2="4.22"/>
      </svg>
      <svg class="icon-moon" width="18" height="18" viewBox="0 0 24 24" fill="none"
           stroke="currentColor" stroke-width="2" stroke-linecap="round"
           style="display:none">
        <path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"/>
      </svg>
    </button>

    <!-- User dropdown -->
    <div class="topbar-user" id="userMenuWrap">
      <button class="user-menu-btn" id="userMenuBtn" aria-label="User menu">
        <div class="user-avatar-sm">
          <c:out value="${fn:substring(sessionScope.userName, 0, 1)}"/>
        </div>
        <span class="user-name-sm">
          <c:out value="${sessionScope.userName}"/>
        </span>
        <svg width="12" height="12" viewBox="0 0 24 24" fill="none"
             stroke="currentColor" stroke-width="2" stroke-linecap="round">
          <polyline points="6 9 12 15 18 9"/>
        </svg>
      </button>

      <div class="dropdown-panel user-dropdown" id="userDropdown" hidden>
        <div class="dropdown-header">
          <strong><c:out value="${sessionScope.userName}"/></strong>
          <span class="badge-role">
            <c:out value="${sessionScope.userRole}"/>
          </span>
        </div>
        <ul class="user-menu-list">
          <li>
            <a href="${ctx}/profile">
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none"
                   stroke="currentColor" stroke-width="2" stroke-linecap="round">
                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                <circle cx="12" cy="7" r="4"/>
              </svg>
              Profile
            </a>
          </li>
          <c:if test="${sessionScope.userRole == 'ADMIN' || sessionScope.userRole == 'SUPERADMIN'}">
            <li>
              <a href="${ctx}/admin/config">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none"
                     stroke="currentColor" stroke-width="2" stroke-linecap="round">
                  <circle cx="12" cy="12" r="3"/>
                  <path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-2.82 1.17V21a2 2 0 0 1-4 0v-.09a1.65 1.65 0 0 0-2.82-1.17l-.06.06a2 2 0 0 1-2.83-2.83l.06-.06A1.65 1.65 0 0 0 4.68 15a1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1 0-4h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 2.83-2.83l.06.06A1.65 1.65 0 0 0 9 4.68a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 2.83l-.06.06A1.65 1.65 0 0 0 19.4 9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1z"/>
                </svg>
                Settings
              </a>
            </li>
          </c:if>
          <li class="divider"></li>
          <li>
            <a href="${ctx}/logout" class="logout-link">
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none"
                   stroke="currentColor" stroke-width="2" stroke-linecap="round">
                <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/>
                <polyline points="16 17 21 12 16 7"/>
                <line x1="21" y1="12" x2="9" y2="12"/>
              </svg>
              Logout
            </a>
          </li>
        </ul>
      </div>
    </div><!-- /.topbar-user -->

  </div><!-- /.topbar-right -->

</header><!-- /.topbar -->

<script>
  /* ── Topbar interactive behaviours ─────────────────────────── */
  (function () {

    /* Notifications toggle */
    const notifBtn   = document.getElementById('notifBtn');
    const notifPanel = document.getElementById('notifPanel');
    const markAll    = document.getElementById('markAllRead');
    const notifCount = document.getElementById('notifCount');

    if (notifBtn && notifPanel) {
      notifBtn.addEventListener('click', e => {
        e.stopPropagation();
        notifPanel.hidden = !notifPanel.hidden;
        userDropdown.hidden = true;
      });
      if (markAll) {
        markAll.addEventListener('click', () => {
          document.querySelectorAll('.notif-item.unread').forEach(el =>
            el.classList.remove('unread')
          );
          notifCount.textContent = '0';
          notifCount.style.display = 'none';
        });
      }
    }

    /* User dropdown toggle */
    const userMenuBtn  = document.getElementById('userMenuBtn');
    const userDropdown = document.getElementById('userDropdown');

    if (userMenuBtn && userDropdown) {
      userMenuBtn.addEventListener('click', e => {
        e.stopPropagation();
        userDropdown.hidden = !userDropdown.hidden;
        if (notifPanel) notifPanel.hidden = true;
      });
    }

    /* Close panels on outside click */
    document.addEventListener('click', () => {
      if (notifPanel)   notifPanel.hidden   = true;
      if (userDropdown) userDropdown.hidden = true;
    });

    /* Theme toggle */
    const themeBtn  = document.getElementById('themeToggleBtn');
    const sunIcon   = themeBtn  && themeBtn.querySelector('.icon-sun');
    const moonIcon  = themeBtn  && themeBtn.querySelector('.icon-moon');
    const THEME_KEY = 'tts_theme';

    function applyTheme(dark) {
      document.body.classList.toggle('dark-theme',  dark);
      document.body.classList.toggle('light-theme', !dark);
      if (sunIcon)  sunIcon.style.display  = dark  ? 'block' : 'none';
      if (moonIcon) moonIcon.style.display = !dark ? 'block' : 'none';
    }

    const savedTheme = localStorage.getItem(THEME_KEY);
    applyTheme(savedTheme !== 'light');

    if (themeBtn) {
      themeBtn.addEventListener('click', () => {
        const isDark = document.body.classList.contains('dark-theme');
        localStorage.setItem(THEME_KEY, isDark ? 'light' : 'dark');
        applyTheme(!isDark);
      });
    }

    /* ⌘K / Ctrl+K — focus global search */
    document.addEventListener('keydown', e => {
      if ((e.metaKey || e.ctrlKey) && e.key === 'k') {
        e.preventDefault();
        const input = document.getElementById('globalSearchInput');
        if (input) input.focus();
      }
    });

  })();
</script>