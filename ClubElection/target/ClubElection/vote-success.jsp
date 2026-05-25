<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Must be logged in
    if (session == null || session.getAttribute("user_id") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String userName = (String) session.getAttribute("user_name");
%>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vote Submitted – Club Election</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="auth-page">

<div class="auth-bg">
    <div class="bg-orb orb-1"></div>
    <div class="bg-orb orb-2"></div>
    <div class="bg-orb orb-3"></div>
</div>

<div class="auth-container">
    <div class="auth-card glass success-card">

        <div class="success-animation">
            <div class="success-circle">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                    <polyline points="20 6 9 17 4 12"/>
                </svg>
            </div>
        </div>

        <h1 class="success-title">Vote Cast!</h1>
        <p class="success-message">
            Thank you, <strong><%= userName != null ? userName : "Voter" %></strong>!<br>
            Your vote has been recorded <strong>anonymously</strong> and securely.
        </p>

        <div class="success-info-grid">
            <div class="success-info-item glass">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
                <span>Your vote is anonymous</span>
            </div>
            <div class="success-info-item glass">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"/></svg>
                <span>Securely recorded</span>
            </div>
            <div class="success-info-item glass">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="4.93" y1="4.93" x2="19.07" y2="19.07"/></svg>
                <span>Cannot vote again</span>
            </div>
        </div>

        <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary btn-full">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/></svg>
            Back to Dashboard
        </a>

        <a href="${pageContext.request.contextPath}/logout" class="btn btn-ghost btn-full" style="margin-top:0.75rem;">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
            Logout
        </a>

    </div>
</div>

<script>
(function() {
    const saved = localStorage.getItem('theme');
    if (saved) document.documentElement.setAttribute('data-theme', saved);
})();
</script>
</body>
</html>
