package com.election.servlet.admin;

import com.election.dao.AdminDAO;
import com.election.model.Admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/login")
public class AdminLoginServlet extends HttpServlet {

    private final AdminDAO adminDAO = new AdminDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("admin_id") != null) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }
        request.getRequestDispatcher("/admin/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Username and password are required.");
            request.getRequestDispatcher("/admin/login.jsp").forward(request, response);
            return;
        }

        try {
            Admin admin = adminDAO.validateAdmin(username.trim(), password);
            if (admin != null) {
                HttpSession session = request.getSession(true);
                session.setAttribute("admin_id", admin.getAdminId());
                session.setAttribute("admin_username", admin.getUsername());
                session.setMaxInactiveInterval(60 * 60); // 1 hour
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                request.setAttribute("error", "Invalid username or password.");
                request.getRequestDispatcher("/admin/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "A system error occurred. Please try again.");
            request.getRequestDispatcher("/admin/login.jsp").forward(request, response);
        }
    }
}
