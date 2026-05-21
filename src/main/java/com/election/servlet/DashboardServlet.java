package com.election.servlet;

import com.election.dao.CandidateDAO;
import com.election.dao.ElectionSettingsDAO;
import com.election.dao.UserDAO;
import com.election.model.Candidate;
import com.election.model.ElectionSettings;
import com.election.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private final CandidateDAO candidateDAO = new CandidateDAO();
    private final ElectionSettingsDAO settingsDAO = new ElectionSettingsDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (int) session.getAttribute("user_id");

        try {
            // Refresh user data from DB to get latest has_voted status
            User user = userDAO.getUserById(userId);
            if (user == null) {
                session.invalidate();
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            // Sync session with DB
            session.setAttribute("has_voted", user.isHasVoted());

            ElectionSettings settings = settingsDAO.getSettings();
            List<Candidate> candidates = candidateDAO.getAllCandidates();

            // Check if election ended by time
            if (settings != null && settings.isActive() && settings.getEndTime() != null && !settings.getEndTime().isEmpty()) {
                try {
                    java.time.LocalDateTime endTime = java.time.LocalDateTime.parse(settings.getEndTime());
                    if (java.time.LocalDateTime.now().isAfter(endTime)) {
                        settingsDAO.setElectionActive(false);
                        settings.setActive(false);
                    }
                } catch (Exception ignored) {}
            }

            request.setAttribute("user", user);
            request.setAttribute("settings", settings);
            request.setAttribute("candidates", candidates);

            request.getRequestDispatcher("/dashboard.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to load dashboard.");
            request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
        }
    }
}
