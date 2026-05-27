<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.election.model.Candidate" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Candidate – Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="admin-page">

<%
    Candidate candidate = (Candidate) request.getAttribute("candidate");
    String adminUsername = (String) session.getAttribute("admin_username");
    if (candidate == null) {
        response.sendRedirect(request.getContextPath() + "/admin/candidates");
        return;
    }
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
        <a href="${pageContext.request.contextPath}/admin/candidates" class="sidebar-link active">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2"/><circle cx="9" cy="7" r="4"/></svg>
            Candidates
        </a>
        <a href="${pageContext.request.contextPath}/admin/users" class="sidebar-link">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
            Voters
        </a>
        <a href="${pageContext.request.contextPath}/admin/election-settings" class="sidebar-link">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="3"/></svg>
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
            <a href="${pageContext.request.contextPath}/admin/candidates" class="btn btn-ghost btn-sm">← Back</a>
            <h1 class="topbar-title">Edit Candidate</h1>
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

        <div class="form-card glass">
            <h2 class="form-card-title">Edit: <%= candidate.getName() %></h2>
            <form action="${pageContext.request.contextPath}/admin/candidates" method="post" enctype="multipart/form-data" class="admin-form">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="candidateId" value="<%= candidate.getCandidateId() %>">
                <input type="hidden" name="existingImage" value="<%= candidate.getImagePath() != null ? candidate.getImagePath() : "" %>">

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">Full Name <span class="required">*</span></label>
                        <input type="text" name="name" class="form-input" value="<%= candidate.getName() %>" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Position / Role <span class="required">*</span></label>
                        <input type="text" name="position" class="form-input" value="<%= candidate.getPosition() %>" required>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Bio / Description</label>
                    <textarea name="bio" class="form-textarea" rows="4"><%= candidate.getBio() != null ? candidate.getBio() : "" %></textarea>
                </div>

                <div class="form-group">
                    <label class="form-label">Candidate Photo</label>
                    <div class="file-upload-area" id="uploadArea" onclick="document.getElementById('imageInput').click()">
                        <div class="file-upload-preview" id="previewWrap" style="<%= (candidate.getImagePath() != null && !candidate.getImagePath().isEmpty()) ? "display:block;" : "display:none;" %>">
                            <% if (candidate.getImagePath() != null && !candidate.getImagePath().isEmpty()) { %>
                            <img id="previewImg" src="${pageContext.request.contextPath}/<%= candidate.getImagePath() %>" alt="Current photo">
                            <% } else { %>
                            <img id="previewImg" src="" alt="Preview">
                            <% } %>
                        </div>
                        <div class="file-upload-placeholder" id="uploadPlaceholder" style="<%= (candidate.getImagePath() != null && !candidate.getImagePath().isEmpty()) ? "display:none;" : "display:flex;" %>">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M21 15v4a2 2 0 01-2 2H5a2 2 0 01-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/></svg>
                            <span>Click to upload new photo</span>
                            <small>Leave empty to keep current photo</small>
                        </div>
                        <input type="file" id="imageInput" name="image" accept="image/*" style="display:none;" onchange="previewImage(this)">
                    </div>
                </div>

                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/admin/candidates" class="btn btn-ghost">Cancel</a>
                    <button type="submit" class="btn btn-primary">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 21H5a2 2 0 01-2-2V5a2 2 0 012-2h11l5 5v11a2 2 0 01-2 2z"/><polyline points="17 21 17 13 7 13 7 21"/><polyline points="7 3 7 8 15 8"/></svg>
                        Save Changes
                    </button>
                </div>
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
function previewImage(input) {
    if (input.files && input.files[0]) {
        const reader = new FileReader();
        reader.onload = function(e) {
            document.getElementById('previewImg').src = e.target.result;
            document.getElementById('previewWrap').style.display = 'block';
            document.getElementById('uploadPlaceholder').style.display = 'none';
        };
        reader.readAsDataURL(input.files[0]);
    }
}
const uploadArea = document.getElementById('uploadArea');
uploadArea.addEventListener('dragover', e => { e.preventDefault(); uploadArea.classList.add('drag-over'); });
uploadArea.addEventListener('dragleave', () => uploadArea.classList.remove('drag-over'));
uploadArea.addEventListener('drop', e => {
    e.preventDefault();
    uploadArea.classList.remove('drag-over');
    const file = e.dataTransfer.files[0];
    if (file && file.type.startsWith('image/')) {
        document.getElementById('imageInput').files = e.dataTransfer.files;
        previewImage(document.getElementById('imageInput'));
    }
});
</script>
</body>
</html>
