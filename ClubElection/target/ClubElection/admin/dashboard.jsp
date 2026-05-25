<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.election.model.Candidate, com.election.model.ElectionSettings, java.util.List" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard – Club Election</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="admin-page">

<%
    ElectionSettings settings = (ElectionSettings) request.getAttribute("settings");
    List<Candidate> candidates = (List<Candidate>) request.getAttribute("candidates");
    int totalUsers   = request.getAttribute("totalUsers")   != null ? (int) request.getAttribute("totalUsers")   : 0;
    int votedCount   = request.getAttribute("votedCount")   != null ? (int) request.getAttribute("votedCount")   : 0;
    int notVotedCount= request.getAttribute("notVotedCount")!= null ? (int) request.getAttribute("notVotedCount"): 0;
    int totalVotes   = request.getAttribute("totalVotes")   != null ? (int) request.getAttribute("totalVotes")   : 0;
    int pendingCount = request.getAttribute("pendingCount") != null ? (int) request.getAttribute("pendingCount") : 0;
    boolean isActive = settings != null && settings.isActive();
    String adminUsername = (String) session.getAttribute("admin_username");
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
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-link active">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>
            Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/admin/candidates" class="sidebar-link">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 00-3-3.87"/><path d="M16 3.13a4 4 0 010 7.75"/></svg>
            Candidates
        </a>
        <a href="${pageContext.request.contextPath}/admin/users" class="sidebar-link">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
            Voters
        </a>
        <a href="${pageContext.request.contextPath}/admin/election-settings" class="sidebar-link">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 00.33 1.82l.06.06a2 2 0 010 2.83 2 2 0 01-2.83 0l-.06-.06a1.65 1.65 0 00-1.82-.33 1.65 1.65 0 00-1 1.51V21a2 2 0 01-4 0v-.09A1.65 1.65 0 009 19.4a1.65 1.65 0 00-1.82.33l-.06.06a2 2 0 01-2.83-2.83l.06-.06A1.65 1.65 0 004.68 15a1.65 1.65 0 00-1.51-1H3a2 2 0 010-4h.09A1.65 1.65 0 004.6 9a1.65 1.65 0 00-.33-1.82l-.06-.06a2 2 0 012.83-2.83l.06.06A1.65 1.65 0 009 4.68a1.65 1.65 0 001-1.51V3a2 2 0 014 0v.09a1.65 1.65 0 001 1.51 1.65 1.65 0 001.82-.33l.06-.06a2 2 0 012.83 2.83l-.06.06A1.65 1.65 0 0019.4 9a1.65 1.65 0 001.51 1H21a2 2 0 010 4h-.09a1.65 1.65 0 00-1.51 1z"/></svg>
            Settings
        </a>
        <a href="${pageContext.request.contextPath}/admin/export" class="sidebar-link">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 01-2 2H5a2 2 0 01-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
            Export CSV
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

<!-- Main -->
<div class="admin-main">

    <!-- Top Bar -->
    <header class="admin-topbar glass">
        <div class="topbar-left">
            <button class="sidebar-toggle" onclick="toggleSidebar()" aria-label="Toggle sidebar">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="3" y1="12" x2="21" y2="12"/><line x1="3" y1="6" x2="21" y2="6"/><line x1="3" y1="18" x2="21" y2="18"/></svg>
            </button>
            <h1 class="topbar-title">Dashboard</h1>
        </div>
        <div class="topbar-right">
            <button class="theme-toggle" onclick="toggleTheme()" aria-label="Toggle theme">
                <svg class="icon-sun" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="5"/><line x1="12" y1="1" x2="12" y2="3"/><line x1="12" y1="21" x2="12" y2="23"/><line x1="4.22" y1="4.22" x2="5.64" y2="5.64"/><line x1="18.36" y1="18.36" x2="19.78" y2="19.78"/><line x1="1" y1="12" x2="3" y2="12"/><line x1="21" y1="12" x2="23" y2="12"/><line x1="4.22" y1="19.78" x2="5.64" y2="18.36"/><line x1="18.36" y1="5.64" x2="19.78" y2="4.22"/></svg>
                <svg class="icon-moon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 12.79A9 9 0 1111.21 3 7 7 0 0021 12.79z"/></svg>
            </button>
            <span class="election-status-badge <%= isActive ? "badge-active" : "badge-inactive" %>">
                <span class="status-dot"></span>
                <%= isActive ? "Election Live" : "Election Stopped" %>
            </span>
        </div>
    </header>

    <div class="admin-content">

        <!-- Alerts -->
        <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-error"><%= request.getAttribute("error") %></div>
        <% } %>
        <% String msg = request.getParameter("msg"); if (msg != null && !msg.isEmpty()) { %>
        <div class="alert alert-success"><%= msg %></div>
        <% } %>

        <!-- Stats Cards -->
        <div class="stats-grid">
            <div class="stat-card glass">
                <div class="stat-icon stat-icon-blue">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 00-3-3.87"/><path d="M16 3.13a4 4 0 010 7.75"/></svg>
                </div>
                <div class="stat-info">
                    <span class="stat-value"><%= totalUsers %></span>
                    <span class="stat-label">Total Registered</span>
                </div>
            </div>
            <div class="stat-card glass">
                <div class="stat-icon stat-icon-green">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 11-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
                </div>
                <div class="stat-info">
                    <span class="stat-value"><%= votedCount %></span>
                    <span class="stat-label">Voted</span>
                </div>
            </div>
            <div class="stat-card glass">
                <div class="stat-icon stat-icon-orange">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                </div>
                <div class="stat-info">
                    <span class="stat-value"><%= notVotedCount %></span>
                    <span class="stat-label">Not Voted</span>
                </div>
            </div>
            <div class="stat-card glass">
                <div class="stat-icon stat-icon-purple">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"/></svg>
                </div>
                <div class="stat-info">
                    <span class="stat-value"><%= totalVotes %></span>
                    <span class="stat-label">Total Votes Cast</span>
                </div>
            </div>
            <% if (pendingCount > 0) { %>
            <a href="${pageContext.request.contextPath}/admin/users?filter=pending" class="stat-card glass stat-card-link">
                <div class="stat-icon stat-icon-warning">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                </div>
                <div class="stat-info">
                    <span class="stat-value"><%= pendingCount %></span>
                    <span class="stat-label">Pending Approval ↗</span>
                </div>
            </a>
            <% } %>
        </div>

        <!-- Voter Turnout Bar -->
        <% if (totalUsers > 0) { %>
        <div class="turnout-card glass">
            <div class="turnout-header">
                <h3>Voter Turnout</h3>
                <span class="turnout-pct"><%= Math.round(votedCount * 100.0 / totalUsers) %>%</span>
            </div>
            <div class="progress-bar">
                <div class="progress-fill" style="width: <%= Math.round(votedCount * 100.0 / totalUsers) %>%"></div>
            </div>
            <div class="turnout-labels">
                <span><%= votedCount %> voted</span>
                <span><%= notVotedCount %> pending</span>
            </div>
        </div>
        <% } %>

        <!-- Election Control -->
        <div class="control-card glass">
            <div class="control-header">
                <h3>Election Control</h3>
                <span class="election-status-badge <%= isActive ? "badge-active" : "badge-inactive" %>">
                    <span class="status-dot"></span>
                    <%= isActive ? "Active" : "Stopped" %>
                </span>
            </div>
            <% if (settings != null) { %>
            <p class="control-title-text"><strong><%= settings.getElectionTitle() %></strong></p>
            <% if (settings.getEndTime() != null && !settings.getEndTime().isEmpty()) { %>
            <p class="control-endtime">End time: <strong><%= settings.getEndTime().replace("T", " ") %></strong></p>
            <% } %>
            <% } %>
            <div class="control-actions">
                <button type="button" class="btn btn-success" <%= isActive ? "disabled" : "" %>
                        onclick="confirmStartElection()">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                    Start Election
                </button>
                <form action="${pageContext.request.contextPath}/admin/election-control" method="post" style="display:inline;">
                    <input type="hidden" name="action" value="stop">
                    <button type="submit" class="btn btn-danger" <%= !isActive ? "disabled" : "" %>>
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="6" y="4" width="4" height="16"/><rect x="14" y="4" width="4" height="16"/></svg>
                        Stop Election
                    </button>
                </form>
                <a href="${pageContext.request.contextPath}/admin/election-settings" class="btn btn-ghost">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 00.33 1.82l.06.06a2 2 0 010 2.83 2 2 0 01-2.83 0l-.06-.06a1.65 1.65 0 00-1.82-.33 1.65 1.65 0 00-1 1.51V21a2 2 0 01-4 0v-.09A1.65 1.65 0 009 19.4a1.65 1.65 0 00-1.82.33l-.06.06a2 2 0 01-2.83-2.83l.06-.06A1.65 1.65 0 004.68 15a1.65 1.65 0 00-1.51-1H3a2 2 0 010-4h.09A1.65 1.65 0 004.6 9a1.65 1.65 0 00-.33-1.82l-.06-.06a2 2 0 012.83-2.83l.06.06A1.65 1.65 0 009 4.68a1.65 1.65 0 001-1.51V3a2 2 0 014 0v.09a1.65 1.65 0 001 1.51 1.65 1.65 0 001.82-.33l.06-.06a2 2 0 012.83 2.83l-.06.06A1.65 1.65 0 0019.4 9a1.65 1.65 0 001.51 1H21a2 2 0 010 4h-.09a1.65 1.65 0 00-1.51 1z"/></svg>
                    Settings
                </a>
                <a href="${pageContext.request.contextPath}/admin/export" class="btn btn-ghost">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 01-2 2H5a2 2 0 01-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
                    Export CSV
                </a>
            </div>
        </div>

        <!-- Live Results -->
        <div class="results-section">
            <div class="section-header">
                <h3 class="section-title">Live Vote Counts</h3>
                <a href="${pageContext.request.contextPath}/admin/candidates" class="btn btn-ghost btn-sm">Manage Candidates</a>
            </div>
            <% if (candidates == null || candidates.isEmpty()) { %>
            <div class="empty-state glass">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2"/><circle cx="9" cy="7" r="4"/></svg>
                <h3>No Candidates</h3>
                <p>Add candidates to see live results.</p>
                <a href="${pageContext.request.contextPath}/admin/candidates?action=add" class="btn btn-primary">Add Candidate</a>
            </div>
            <% } else { %>
            <div class="results-list">
                <% for (Candidate c : candidates) {
                    double pct = totalVotes > 0 ? (c.getVoteCount() * 100.0 / totalVotes) : 0;
                %>
                <div class="result-row glass">
                    <div class="result-candidate">
                        <% if (c.getImagePath() != null && !c.getImagePath().isEmpty()) { %>
                        <img src="${pageContext.request.contextPath}/<%= c.getImagePath() %>" alt="<%= c.getName() %>" class="result-avatar">
                        <% } else { %>
                        <div class="result-avatar-placeholder"><%= c.getName().substring(0,1).toUpperCase() %></div>
                        <% } %>
                        <div>
                            <strong><%= c.getName() %></strong>
                            <span class="result-position"><%= c.getPosition() %></span>
                        </div>
                    </div>
                    <div class="result-bar-wrap">
                        <div class="result-bar">
                            <div class="result-bar-fill" style="width: <%= String.format("%.1f", pct) %>%"></div>
                        </div>
                        <span class="result-pct"><%= String.format("%.1f", pct) %>%</span>
                    </div>
                    <div class="result-count"><%= c.getVoteCount() %> votes</div>
                </div>
                <% } %>
            </div>
            <% } %>
        </div>

    </div><!-- /admin-content -->
</div><!-- /admin-main -->

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

</body>
</html>
