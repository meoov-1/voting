package com.election.servlet.admin;

import com.election.dao.*;
import com.election.model.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final CandidateDAO candidateDAO = new CandidateDAO();
    private final VoteDAO voteDAO = new VoteDAO();
    private final ElectionSettingsDAO settingsDAO = new ElectionSettingsDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check admin session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin_id") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        try {
            int totalUsers = userDAO.getTotalUserCount();
            int votedCount = userDAO.getUsersWhoVoted().size();
            int notVotedCount = userDAO.getUsersWhoNotVoted().size();
            int totalVotes = voteDAO.getTotalVotes();
            int pendingCount = userDAO.getPendingUserCount();
            List<Candidate> candidates = candidateDAO.getAllCandidates();
            ElectionSettings settings = settingsDAO.getSettings();

            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("votedCount", votedCount);
            request.setAttribute("notVotedCount", notVotedCount);
            request.setAttribute("totalVotes", totalVotes);
            request.setAttribute("pendingCount", pendingCount);
            request.setAttribute("candidates", candidates);
            request.setAttribute("settings", settings);

            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to load dashboard data.");
            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
        }
    }
}
