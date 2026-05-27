<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.election.model.Candidate, com.election.model.ElectionSettings, com.election.model.User, java.util.List" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vote – Club Election</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="dashboard-page">

<%
    User currentUser = (User) request.getAttribute("user");
    ElectionSettings settings = (ElectionSettings) request.getAttribute("settings");
    List<Candidate> candidates = (List<Candidate>) request.getAttribute("candidates");
    boolean hasVoted = currentUser != null && currentUser.isHasVoted();
    boolean electionActive = settings != null && settings.isActive();
    String electionTitle = settings != null ? settings.getElectionTitle() : "Club Election";
    String endTime = (settings != null && settings.getEndTime() != null) ? settings.getEndTime() : null;
%>

<!-- Navbar -->
<nav class="navbar glass">
    <div class="nav-brand">
        <div class="brand-icon brand-icon-sm">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"/>
            </svg>
        </div>
        <span class="nav-title"><%= electionTitle %></span>
    </div>
    <div class="nav-actions">
        <button class="theme-toggle" onclick="toggleTheme()" aria-label="Toggle theme">
            <svg class="icon-sun" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="5"/><line x1="12" y1="1" x2="12" y2="3"/><line x1="12" y1="21" x2="12" y2="23"/><line x1="4.22" y1="4.22" x2="5.64" y2="5.64"/><line x1="18.36" y1="18.36" x2="19.78" y2="19.78"/><line x1="1" y1="12" x2="3" y2="12"/><line x1="21" y1="12" x2="23" y2="12"/><line x1="4.22" y1="19.78" x2="5.64" y2="18.36"/><line x1="18.36" y1="5.64" x2="19.78" y2="4.22"/></svg>
            <svg class="icon-moon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 12.79A9 9 0 1111.21 3 7 7 0 0021 12.79z"/></svg>
        </button>
        <div class="nav-user">
            <div class="user-avatar"><%= currentUser != null ? currentUser.getFullName().substring(0,1).toUpperCase() : "U" %></div>
            <span class="user-name"><%= currentUser != null ? currentUser.getFullName() : "" %></span>
        </div>
        <a href="${pageContext.request.contextPath}/logout" class="btn btn-ghost btn-sm">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
            Logout
        </a>
    </div>
</nav>

<main class="main-content">

    <!-- Alerts -->
    <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-error alert-floating">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
        <%= request.getAttribute("error") %>
    </div>
    <% } %>

    <!-- Status Banner -->
    <div class="status-banner <%= hasVoted ? "banner-voted" : (electionActive ? "banner-active" : "banner-inactive") %>">
        <% if (hasVoted) { %>
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 11-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
            <div>
                <strong>Vote Cast Successfully</strong>
                <span>Your vote has been recorded anonymously. Thank you for participating!</span>
            </div>
        <% } else if (electionActive) { %>
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
            <div>
                <strong>Election is Live</strong>
                <span>Select a candidate below and cast your vote. You can only vote once.</span>
            </div>
        <% } else { %>
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="4.93" y1="4.93" x2="19.07" y2="19.07"/></svg>
            <div>
                <strong>Election Not Active</strong>
                <span>The election has not started yet or has ended. Please check back later.</span>
            </div>
        <% } %>
    </div>

    <!-- Countdown Timer -->
    <% if (electionActive && endTime != null && !endTime.isEmpty()) { %>
    <div class="countdown-wrap glass">
        <div class="countdown-label">Election ends in</div>
        <div class="countdown-timer" id="countdown" data-end="<%= endTime %>">
            <div class="countdown-unit"><span id="cd-days">00</span><small>Days</small></div>
            <div class="countdown-sep">:</div>
            <div class="countdown-unit"><span id="cd-hours">00</span><small>Hours</small></div>
            <div class="countdown-sep">:</div>
            <div class="countdown-unit"><span id="cd-mins">00</span><small>Mins</small></div>
            <div class="countdown-sep">:</div>
            <div class="countdown-unit"><span id="cd-secs">00</span><small>Secs</small></div>
        </div>
    </div>
    <% } %>

    <!-- Section Header -->
    <div class="section-header">
        <h2 class="section-title">Candidates</h2>
        <% if (candidates != null) { %>
        <span class="section-badge"><%= candidates.size() %> candidate<%= candidates.size() != 1 ? "s" : "" %></span>
        <% } %>
    </div>

    <!-- Candidates Grid -->
    <% if (candidates == null || candidates.isEmpty()) { %>
    <div class="empty-state glass">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 00-3-3.87"/><path d="M16 3.13a4 4 0 010 7.75"/></svg>
        <h3>No Candidates Yet</h3>
        <p>Candidates will appear here once added by the admin.</p>
    </div>
    <% } else { %>
    <form action="${pageContext.request.contextPath}/vote" method="post" id="voteForm">
        <div class="candidates-grid">
            <% for (Candidate c : candidates) { %>
            <div class="candidate-card glass <%= (hasVoted || !electionActive) ? "card-disabled" : "" %>" onclick="<%= (!hasVoted && electionActive) ? "selectCandidate(this, " + c.getCandidateId() + ")" : "" %>">
                <input type="radio" name="candidateId" value="<%= c.getCandidateId() %>" id="c<%= c.getCandidateId() %>"
                       class="candidate-radio" <%= (hasVoted || !electionActive) ? "disabled" : "" %>>
                <div class="candidate-select-ring"></div>
                <div class="candidate-img-wrap">
                    <% if (c.getImagePath() != null && !c.getImagePath().isEmpty()) { %>
                    <img src="${pageContext.request.contextPath}/<%= c.getImagePath() %>" alt="<%= c.getName() %>" class="candidate-img" loading="lazy">
                    <% } else { %>
                    <div class="candidate-img-placeholder">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                    </div>
                    <% } %>
                </div>
                <div class="candidate-info">
                    <h3 class="candidate-name"><%= c.getName() %></h3>
                    <span class="candidate-position"><%= c.getPosition() %></span>
                    <% if (c.getBio() != null && !c.getBio().isEmpty()) { %>
                    <p class="candidate-bio"><%= c.getBio() %></p>
                    <% } %>
                </div>
                <div class="candidate-check">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><polyline points="20 6 9 17 4 12"/></svg>
                </div>
            </div>
            <% } %>
        </div>

        <% if (!hasVoted && electionActive) { %>
        <div class="vote-action-bar" id="voteActionBar">
            <div class="vote-action-inner glass">
                <div class="selected-info" id="selectedInfo">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 12l2 2 4-4"/><circle cx="12" cy="12" r="10"/></svg>
                    <span id="selectedName">No candidate selected</span>
                </div>
                <button type="button" class="btn btn-primary" id="voteBtn" disabled onclick="confirmVote()">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"/></svg>
                    Cast Vote
                </button>
            </div>
        </div>
        <% } %>
    </form>
    <% } %>

</main>

<!-- Vote Confirmation Modal -->
<div class="modal-overlay" id="voteModal" role="dialog" aria-modal="true" aria-labelledby="modalTitle">
    <div class="modal glass">
        <div class="modal-icon modal-icon-warn">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M10.29 3.86L1.82 18a2 2 0 001.71 3h16.94a2 2 0 001.71-3L13.71 3.86a2 2 0 00-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
        </div>
        <h3 id="modalTitle">Confirm Your Vote</h3>
        <p>You are about to vote for <strong id="modalCandidateName"></strong>.</p>
        <p class="modal-warning">⚠ This action is <strong>irreversible</strong>. You can only vote once.</p>
        <div class="modal-actions">
            <button class="btn btn-ghost" onclick="closeModal()">Cancel</button>
            <button class="btn btn-primary" onclick="submitVote()">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 12l2 2 4-4"/></svg>
                Confirm Vote
            </button>
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

let selectedCandidateName = '';

function selectCandidate(card, id) {
    document.querySelectorAll('.candidate-card').forEach(c => c.classList.remove('selected'));
    card.classList.add('selected');
    document.getElementById('c' + id).checked = true;
    selectedCandidateName = card.querySelector('.candidate-name').textContent;
    document.getElementById('selectedName').textContent = selectedCandidateName;
    document.getElementById('voteBtn').disabled = false;
    document.getElementById('voteActionBar').classList.add('visible');
}

function confirmVote() {
    if (!selectedCandidateName) return;
    document.getElementById('modalCandidateName').textContent = selectedCandidateName;
    document.getElementById('voteModal').classList.add('active');
}

function closeModal() {
    document.getElementById('voteModal').classList.remove('active');
}

function submitVote() {
    document.getElementById('voteForm').submit();
}

document.getElementById('voteModal')?.addEventListener('click', function(e) {
    if (e.target === this) closeModal();
});

// Countdown timer
const countdownEl = document.getElementById('countdown');
if (countdownEl) {
    const endStr = countdownEl.dataset.end.replace('T', ' ');
    const endDate = new Date(endStr);

    function updateCountdown() {
        const now = new Date();
        const diff = endDate - now;
        if (diff <= 0) {
            document.getElementById('cd-days').textContent = '00';
            document.getElementById('cd-hours').textContent = '00';
            document.getElementById('cd-mins').textContent = '00';
            document.getElementById('cd-secs').textContent = '00';
            return;
        }
        const days = Math.floor(diff / 86400000);
        const hours = Math.floor((diff % 86400000) / 3600000);
        const mins = Math.floor((diff % 3600000) / 60000);
        const secs = Math.floor((diff % 60000) / 1000);
        document.getElementById('cd-days').textContent = String(days).padStart(2,'0');
        document.getElementById('cd-hours').textContent = String(hours).padStart(2,'0');
        document.getElementById('cd-mins').textContent = String(mins).padStart(2,'0');
        document.getElementById('cd-secs').textContent = String(secs).padStart(2,'0');
    }
    updateCountdown();
    setInterval(updateCountdown, 1000);
}
</script>
</body>
</html>
