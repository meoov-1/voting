package com.election.servlet;

import com.election.dao.CandidateDAO;
import com.election.dao.ElectionSettingsDAO;
import com.election.dao.UserDAO;
import com.election.dao.VoteDAO;
import com.election.model.ElectionSettings;
import com.election.model.User;
import com.election.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;

@WebServlet("/vote")
public class VoteServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final VoteDAO voteDAO = new VoteDAO();
    private final CandidateDAO candidateDAO = new CandidateDAO();
    private final ElectionSettingsDAO settingsDAO = new ElectionSettingsDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (int) session.getAttribute("user_id");
        String candidateIdParam = request.getParameter("candidateId");

        if (candidateIdParam == null || candidateIdParam.trim().isEmpty()) {
            request.setAttribute("error", "No candidate selected.");
            request.getRequestDispatcher("/dashboard").forward(request, response);
            return;
        }

        int candidateId;
        try {
            candidateId = Integer.parseInt(candidateIdParam.trim());
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid candidate selection.");
            request.getRequestDispatcher("/dashboard").forward(request, response);
            return;
        }

        Connection conn = null;
        try {
            // Check election is active
            ElectionSettings settings = settingsDAO.getSettings();
            if (settings == null || !settings.isActive()) {
                request.setAttribute("error", "The election is not currently active.");
                request.getRequestDispatcher("/dashboard").forward(request, response);
                return;
            }

            // Check if election has ended by time
            if (settings.getEndTime() != null && !settings.getEndTime().isEmpty()) {
                java.time.LocalDateTime endTime = java.time.LocalDateTime.parse(settings.getEndTime());
                if (java.time.LocalDateTime.now().isAfter(endTime)) {
                    settingsDAO.setElectionActive(false);
                    request.setAttribute("error", "The election has ended.");
                    request.getRequestDispatcher("/dashboard").forward(request, response);
                    return;
                }
            }

            // Check user has NOT already voted (DB check)
            User user = userDAO.getUserById(userId);
            if (user == null) {
                session.invalidate();
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            if (user.isHasVoted()) {
                session.setAttribute("has_voted", true);
                request.setAttribute("error", "You have already cast your vote.");
                request.getRequestDispatcher("/dashboard").forward(request, response);
                return;
            }

            // Verify candidate exists
            if (candidateDAO.getCandidateById(candidateId) == null) {
                request.setAttribute("error", "Selected candidate does not exist.");
                request.getRequestDispatcher("/dashboard").forward(request, response);
                return;
            }

            // Transactional vote: insert vote + mark user as voted + increment count
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            try {
                voteDAO.castVote(candidateId, conn);
                candidateDAO.incrementVoteCount(candidateId, conn);
                userDAO.markUserAsVoted(userId, conn);
                conn.commit();

                // Update session
                session.setAttribute("has_voted", true);
                response.sendRedirect(request.getContextPath() + "/vote-success");
            } catch (Exception e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "A system error occurred while casting your vote. Please try again.");
            request.getRequestDispatcher("/dashboard").forward(request, response);
        } finally {
            DBConnection.close(conn);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        response.sendRedirect(request.getContextPath() + "/dashboard");
    }
}
