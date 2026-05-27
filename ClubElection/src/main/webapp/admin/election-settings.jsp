<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.election.model.ElectionSettings" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Election Settings – Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="admin-page">

<%
    ElectionSettings settings = (ElectionSettings) request.getAttribute("settings");
    String adminUsername = (String) session.getAttribute("admin_username");
    boolean isActive = settings != null && settings.isActive();
%>

<!-- Sidebar -->
<aside class="admin-sidebar glass">
    <div class="sidebar-brand">
        <div class="brand-icon brand-icon-admin">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
        </div>
        <span>Admin Panel</span>
    </div>
    <nav class="sidebar-nav">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-link">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>
            Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/admin/candidates" class="sidebar-link">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2"/><circle cx="9" cy="7" r="4"/></svg>
            Candidates
        </a>
        <a href="${pageContext.request.contextPath}/admin/users" class="sidebar-link">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
            Voters
        </a>
        <a href="${pageContext.request.contextPath}/admin/election-settings" class="sidebar-link active">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 00.33 1.82l.06.06a2 2 0 010 2.83 2 2 0 01-2.83 0l-.06-.06a1.65 1.65 0 00-1.82-.33 1.65 1.65 0 00-1 1.51V21a2 2 0 01-4 0v-.09A1.65 1.65 0 009 19.4a1.65 1.65 0 00-1.82.33l-.06.06a2 2 0 01-2.83-2.83l.06-.06A1.65 1.65 0 004.68 15a1.65 1.65 0 00-1.51-1H3a2 2 0 010-4h.09A1.65 1.65 0 004.6 9a1.65 1.65 0 00-.33-1.82l-.06-.06a2 2 0 012.83-2.83l.06.06A1.65 1.65 0 009 4.68a1.65 1.65 0 001-1.51V3a2 2 0 014 0v.09a1.65 1.65 0 001 1.51 1.65 1.65 0 001.82-.33l.06-.06a2 2 0 012.83 2.83l-.06.06A1.65 1.65 0 0019.4 9a1.65 1.65 0 001.51 1H21a2 2 0 010 4h-.09a1.65 1.65 0 00-1.51 1z"/></svg>
            Settings
        </a>
    </nav>
    <div class="sidebar-footer">
        <div class="sidebar-user">
            <div class="user-avatar user-avatar-sm"><%= adminUsername != null ? adminUsername.substring(0,1).toUpperCase() : "A" %></div>
            <span><%= adminUsername != null ? adminUsername : "Admin" %></span>
        </div>
        <a href="${pageContext.request.contextPath}/logout" class="btn btn-ghost btn-sm">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
            Logout
        </a>
    </div>
</aside>

<div class="admin-main">
    <header class="admin-topbar glass">
        <div class="topbar-left">
            <button class="sidebar-toggle" onclick="toggleSidebar()" aria-label="Toggle sidebar">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="3" y1="12" x2="21" y2="12"/><line x1="3" y1="6" x2="21" y2="6"/><line x1="3" y1="18" x2="21" y2="18"/></svg>
            </button>
            <h1 class="topbar-title">Election Settings</h1>
        </div>
        <div class="topbar-right">
            <button class="theme-toggle" onclick="toggleTheme()" aria-label="Toggle theme">
                <svg class="icon-sun" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="5"/><line x1="12" y1="1" x2="12" y2="3"/><line x1="12" y1="21" x2="12" y2="23"/></svg>
                <svg class="icon-moon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 12.79A9 9 0 1111.21 3 7 7 0 0021 12.79z"/></svg>
            </button>
            <span class="election-status-badge <%= isActive ? "badge-active" : "badge-inactive" %>">
                <span class="status-dot"></span>
                <%= isActive ? "Active" : "Stopped" %>
            </span>
        </div>
    </header>

    <div class="admin-content">

        <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-error"><%= request.getAttribute("error") %></div>
        <% } %>
        <% if (request.getAttribute("success") != null) { %>
        <div class="alert alert-success"><%= request.getAttribute("success") %></div>
        <% } %>

        <!-- Settings Form -->
        <div class="form-card glass">
            <h2 class="form-card-title">Election Configuration</h2>
            <form action="${pageContext.request.contextPath}/admin/election-control" method="post" class="admin-form">
                <input type="hidden" name="action" value="updateSettings">

                <div class="form-group">
                    <label class="form-label">Election Title</label>
                    <input type="text" name="electionTitle" class="form-input"
                           value="<%= settings != null ? settings.getElectionTitle() : "Club Election" %>"
                           placeholder="e.g. Club Election 2025">
                </div>

                <div class="form-group">
                    <label class="form-label">Election End Date &amp; Time</label>
                    <input type="datetime-local" name="endTime" class="form-input"
                           value="<%= (settings != null && settings.getEndTime() != null) ? settings.getEndTime() : "" %>">
                    <small class="form-hint">Leave empty for no automatic end time.</small>
                </div>

                <div class="form-group">
                    <label class="form-label toggle-label">
                        <span>Election Active</span>
                        <div class="toggle-switch">
                            <input type="checkbox" name="isActive" id="isActiveToggle" <%= isActive ? "checked" : "" %>>
                            <span class="toggle-slider"></span>
                        </div>
                    </label>
                    <small class="form-hint">Toggle to start or stop the election immediately.</small>
                </div>

                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-ghost">Cancel</a>
                    <button type="submit" class="btn btn-primary">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 21H5a2 2 0 01-2-2V5a2 2 0 012-2h11l5 5v11a2 2 0 01-2 2z"/><polyline points="17 21 17 13 7 13 7 21"/><polyline points="7 3 7 8 15 8"/></svg>
                        Save Settings
                    </button>
                </div>
            </form>
        </div>

        <!-- Quick Controls -->
        <div class="form-card glass">
            <h2 class="form-card-title">Quick Controls</h2>
            <div class="quick-controls">
                <div class="quick-control-item">
                    <div>
                        <strong>Start Election</strong>
                        <p>Immediately open voting. <strong>All previous votes will be reset.</strong></p>
                    </div>
                    <button type="button" class="btn btn-success" <%= isActive ? "disabled" : "" %>
                            onclick="confirmStartElection()">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                        Start
                    </button>
                </div>
                <div class="quick-control-divider"></div>
                <div class="quick-control-item">
                    <div>
                        <strong>Stop Election</strong>
                        <p>Immediately close voting. Results will still be visible.</p>
                    </div>
                    <form action="${pageContext.request.contextPath}/admin/election-control" method="post">
                        <input type="hidden" name="action" value="stop">
                        <button type="submit" class="btn btn-danger" <%= !isActive ? "disabled" : "" %>>
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="6" y="4" width="4" height="16"/><rect x="14" y="4" width="4" height="16"/></svg>
                            Stop
                        </button>
                    </form>
                </div>
            </div>
        </div>

    </div>
</div>

<!-- Start Election Confirmation Modal -->
<div class="modal-overlay" id="startElectionModal" role="dialog" aria-modal="true">
    <div class="modal glass">
        <div class="modal-icon modal-icon-warn">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M10.29 3.86L1.82 18a2 2 0 001.71 3h16.94a2 2 0 001.71-3L13.71 3.86a2 2 0 00-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
        </div>
        <h3>Start New Election?</h3>
        <p>This will <strong>reset all existing votes</strong> and mark every voter as "not voted".</p>
        <p class="modal-warning">⚠ All current vote data will be permanently erased. This cannot be undone.</p>
        <div class="modal-actions">
            <button class="btn btn-ghost" onclick="closeStartModal()">Cancel</button>
            <form action="${pageContext.request.contextPath}/admin/election-control" method="post" style="display:inline;">
                <input type="hidden" name="action" value="start">
                <button type="submit" class="btn btn-success">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                    Yes, Start &amp; Reset
                </button>
            </form>
        </div>
    </div>
</div>

<script>
(function() {
    const saved = localStorage.getItem('theme');
    if (saved) document.documentElement.setAttribute('data-theme', saved);
})();
function toggleTheme() {
    const html = document.documentElement;
    html.setAttribute('data-theme', html.getAttribute('data-theme') === 'dark' ? 'light' : 'dark');
    localStorage.setItem('theme', html.getAttribute('data-theme'));
}
function toggleSidebar() {
    document.querySelector('.admin-sidebar').classList.toggle('open');
}
function confirmStartElection() {
    document.getElementById('startElectionModal').classList.add('active');
}
function closeStartModal() {
    document.getElementById('startElectionModal').classList.remove('active');
}
document.getElementById('startElectionModal')?.addEventListener('click', function(e) {
    if (e.target === this) closeStartModal();
});
</script>
</body>
</html>
