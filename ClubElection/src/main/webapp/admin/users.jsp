<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.election.model.User, java.util.List" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Voters – Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="admin-page">

<%
    List<User> users      = (List<User>) request.getAttribute("users");
    String filter         = (String) request.getAttribute("filter");
    int totalCount        = request.getAttribute("totalCount")   != null ? (int) request.getAttribute("totalCount")   : 0;
    int votedCount        = request.getAttribute("votedCount")   != null ? (int) request.getAttribute("votedCount")   : 0;
    int notVotedCount     = request.getAttribute("notVotedCount")!= null ? (int) request.getAttribute("notVotedCount"): 0;
    int pendingCount      = request.getAttribute("pendingCount") != null ? (int) request.getAttribute("pendingCount") : 0;
    boolean electionActive = request.getAttribute("electionActive") != null && (boolean) request.getAttribute("electionActive");
    String adminUsername  = (String) session.getAttribute("admin_username");
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
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 00-3-3.87"/><path d="M16 3.13a4 4 0 010 7.75"/></svg>
            Candidates
        </a>
        <a href="${pageContext.request.contextPath}/admin/users" class="sidebar-link active">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
            Voters
            <% if (pendingCount > 0) { %><span class="sidebar-badge"><%= pendingCount %></span><% } %>
        </a>
        <a href="${pageContext.request.contextPath}/admin/election-settings" class="sidebar-link">
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
            <h1 class="topbar-title">Voter Management</h1>
        </div>
        <div class="topbar-right">
            <button class="theme-toggle" onclick="toggleTheme()" aria-label="Toggle theme">
                <svg class="icon-sun" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="5"/><line x1="12" y1="1" x2="12" y2="3"/><line x1="12" y1="21" x2="12" y2="23"/></svg>
                <svg class="icon-moon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 12.79A9 9 0 1111.21 3 7 7 0 0021 12.79z"/></svg>
            </button>
        </div>
    </header>

    <div class="admin-content">

        <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-error"><%= request.getAttribute("error") %></div>
        <% } %>
        <% if (request.getAttribute("success") != null) { %>
        <div class="alert alert-success"><%= request.getAttribute("success") %></div>
        <% } %>

        <!-- Privacy Notice (only for non-pending tabs) -->
        <% if (!"pending".equals(filter)) { %>
        <div class="privacy-notice glass">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
            <div>
                <strong>Privacy Protected</strong>
                <% if (electionActive) { %>
                <span>Live voting progress is hidden until the election ends.</span>
                <% } else { %>
                <span>You can see who has voted, but vote choices are never stored or displayed. Voting is fully anonymous.</span>
                <% } %>
            </div>
        </div>
        <% } %>

        <!-- Pending approval banner -->
        <% if (pendingCount > 0) { %>
        <div class="pending-banner glass">
            <div class="pending-banner-left">
                <div class="pending-icon">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                </div>
                <div>
                    <strong><%= pendingCount %> user<%= pendingCount != 1 ? "s" : "" %> waiting for approval</strong>
                    <span>Review and approve or reject pending registrations.</span>
                </div>
            </div>
            <a href="${pageContext.request.contextPath}/admin/users?filter=pending" class="btn btn-warning btn-sm">
                Review Now
            </a>
        </div>
        <% } %>

        <!-- Filter Tabs -->
        <div class="filter-tabs">
            <a href="${pageContext.request.contextPath}/admin/users" class="filter-tab <%= "all".equals(filter) ? "active" : "" %>">
                Approved <span class="tab-count"><%= totalCount %></span>
            </a>
            <% if (!electionActive) { %>
            <a href="${pageContext.request.contextPath}/admin/users?filter=voted" class="filter-tab <%= "voted".equals(filter) ? "active" : "" %>">
                Voted <span class="tab-count tab-count-green"><%= votedCount %></span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/users?filter=not_voted" class="filter-tab <%= "not_voted".equals(filter) ? "active" : "" %>">
                Not Voted <span class="tab-count tab-count-orange"><%= notVotedCount %></span>
            </a>
            <% } %>
            <a href="${pageContext.request.contextPath}/admin/users?filter=pending" class="filter-tab <%= "pending".equals(filter) ? "active" : "" %>">
                Pending
                <span class="tab-count <%= pendingCount > 0 ? "tab-count-red" : "" %>"><%= pendingCount %></span>
            </a>
        </div>

        <!-- Search (not shown on pending tab) -->
        <% if (!"pending".equals(filter)) { %>
        <div class="search-bar glass">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
            <input type="text" id="searchInput" class="search-input" placeholder="Search by name or email..." oninput="filterTable(this.value)">
        </div>
        <% } %>

        <!-- ── PENDING TAB ── -->
        <% if ("pending".equals(filter)) { %>
            <% if (users == null || users.isEmpty()) { %>
            <div class="empty-state glass">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 11-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
                <h3>No Pending Approvals</h3>
                <p>All registrations have been reviewed. Nothing to approve right now.</p>
            </div>
            <% } else { %>
            <div class="admin-table-wrap glass">
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Registered</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% int i = 1; for (User u : users) { %>
                        <tr>
                            <td class="row-num"><%= i++ %></td>
                            <td>
                                <div class="table-user">
                                    <div class="user-avatar user-avatar-sm pending-avatar"><%= u.getFullName().substring(0,1).toUpperCase() %></div>
                                    <strong><%= u.getFullName() %></strong>
                                </div>
                            </td>
                            <td class="user-email"><%= u.getEmail() %></td>
                            <td class="user-date"><%= u.getCreatedAt() != null ? u.getCreatedAt().toString().substring(0,10) : "—" %></td>
                            <td>
                                <div class="table-actions">
                                    <form action="${pageContext.request.contextPath}/admin/users" method="post" style="display:inline;">
                                        <input type="hidden" name="action" value="approve">
                                        <input type="hidden" name="userId" value="<%= u.getUserId() %>">
                                        <button type="submit" class="btn btn-success btn-xs">
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"/></svg>
                                            Approve
                                        </button>
                                    </form>
                                    <button class="btn btn-danger btn-xs"
                                            onclick="confirmReject(<%= u.getUserId() %>, '<%= u.getFullName().replace("'", "\\'") %>')">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
                                        Reject
                                    </button>
                                </div>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            <p class="table-count"><%= users.size() %> pending registration<%= users.size() != 1 ? "s" : "" %></p>
            <% } %>

        <!-- ── ALL / VOTED / NOT VOTED TABS ── -->
        <% } else { %>
            <% if (users == null || users.isEmpty()) { %>
            <div class="empty-state glass">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                <h3>No Users Found</h3>
                <p>No approved users match the current filter.</p>
            </div>
            <% } else { %>
            <div class="admin-table-wrap glass">
                <table class="admin-table" id="usersTable">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Registered</th>
                            <th><%= electionActive ? "Voting Privacy" : "Vote Status" %></th>
                        </tr>
                    </thead>
                    <tbody>
                        <% int j = 1; for (User u : users) { %>
                        <tr class="user-row">
                            <td class="row-num"><%= j++ %></td>
                            <td>
                                <div class="table-user">
                                    <div class="user-avatar user-avatar-sm"><%= u.getFullName().substring(0,1).toUpperCase() %></div>
                                    <strong class="user-fullname"><%= u.getFullName() %></strong>
                                </div>
                            </td>
                            <td class="user-email"><%= u.getEmail() %></td>
                            <td class="user-date"><%= u.getCreatedAt() != null ? u.getCreatedAt().toString().substring(0,10) : "—" %></td>
                            <td>
                                <% if (electionActive) { %>
                                <span class="status-pill pill-pending">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
                                    Hidden Until End
                                </span>
                                <% } else if (u.isHasVoted()) { %>
                                <span class="status-pill pill-voted">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"/></svg>
                                    Voted
                                </span>
                                <% } else { %>
                                <span class="status-pill pill-pending">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                                    Not Voted
                                </span>
                                <% } %>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            <p class="table-count">Showing <%= users.size() %> user<%= users.size() != 1 ? "s" : "" %></p>
            <% } %>
        <% } %>

    </div><!-- /admin-content -->
</div><!-- /admin-main -->

<!-- Reject Confirm Modal -->
<div class="modal-overlay" id="rejectModal">
    <div class="modal glass">
        <div class="modal-icon modal-icon-danger">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
        </div>
        <h3>Reject Registration</h3>
        <p>Are you sure you want to reject <strong id="rejectName"></strong>? Their account will be permanently deleted.</p>
        <div class="modal-actions">
            <button class="btn btn-ghost" onclick="closeRejectModal()">Cancel</button>
            <form id="rejectForm" action="${pageContext.request.contextPath}/admin/users" method="post" style="display:inline;">
                <input type="hidden" name="action" value="reject">
                <input type="hidden" name="userId" id="rejectUserId">
                <button type="submit" class="btn btn-danger">Reject &amp; Delete</button>
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
function filterTable(query) {
    const rows = document.querySelectorAll('#usersTable tbody .user-row');
    const q = query.toLowerCase();
    rows.forEach(row => {
        const name  = row.querySelector('.user-fullname')?.textContent.toLowerCase() || '';
        const email = row.querySelector('.user-email')?.textContent.toLowerCase() || '';
        row.style.display = (name.includes(q) || email.includes(q)) ? '' : 'none';
    });
}
function confirmReject(id, name) {
    document.getElementById('rejectName').textContent = name;
    document.getElementById('rejectUserId').value = id;
    document.getElementById('rejectModal').classList.add('active');
}
function closeRejectModal() {
    document.getElementById('rejectModal').classList.remove('active');
}
document.getElementById('rejectModal')?.addEventListener('click', function(e) {
    if (e.target === this) closeRejectModal();
});
</script>
</body>
</html>
