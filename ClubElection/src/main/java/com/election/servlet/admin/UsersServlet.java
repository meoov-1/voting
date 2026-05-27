package com.election.servlet.admin;

import com.election.dao.UserDAO;
import com.election.dao.ElectionSettingsDAO;
import com.election.model.ElectionSettings;
import com.election.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/users")
public class UsersServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final ElectionSettingsDAO settingsDAO = new ElectionSettingsDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin_id") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        String filter = request.getParameter("filter");

        try {
            ElectionSettings settings = settingsDAO.getSettings();
            boolean electionActive = settings != null && settings.isActive();
            List<User> users;
            if (electionActive && ("voted".equals(filter) || "not_voted".equals(filter))) {
                users = userDAO.getAllUsers();
                filter = "all";
            } else if ("voted".equals(filter)) {
                users = userDAO.getUsersWhoVoted();
            } else if ("not_voted".equals(filter)) {
                users = userDAO.getUsersWhoNotVoted();
            } else if ("pending".equals(filter)) {
                users = userDAO.getPendingUsers();
            } else {
                users = userDAO.getAllUsers();
                filter = "all";
            }

            int totalCount    = userDAO.getTotalUserCount();
            int votedCount    = userDAO.getUsersWhoVoted().size();
            int notVotedCount = userDAO.getUsersWhoNotVoted().size();
            int pendingCount  = userDAO.getPendingUserCount();

            request.setAttribute("users", users);
            request.setAttribute("filter", filter);
            request.setAttribute("totalCount", totalCount);
            request.setAttribute("votedCount", votedCount);
            request.setAttribute("notVotedCount", notVotedCount);
            request.setAttribute("pendingCount", pendingCount);
            request.setAttribute("electionActive", electionActive);

            String msg = request.getParameter("msg");
            if (msg != null) request.setAttribute("success", msg);

            request.getRequestDispatcher("/admin/users.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to load users.");
            request.getRequestDispatcher("/admin/users.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin_id") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        String action     = request.getParameter("action");
        String userIdParam = request.getParameter("userId");

        if (userIdParam == null || userIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/users?filter=pending");
            return;
        }

        try {
            int userId = Integer.parseInt(userIdParam.trim());

            if ("approve".equals(action)) {
                userDAO.approveUser(userId);
                response.sendRedirect(request.getContextPath() + "/admin/users?filter=pending&msg=User+approved+successfully");
            } else if ("reject".equals(action)) {
                userDAO.rejectUser(userId);
                response.sendRedirect(request.getContextPath() + "/admin/users?filter=pending&msg=User+rejected+and+removed");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/users");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/users?filter=pending&msg=Operation+failed");
        }
    }
}
