package com.election.servlet;

import com.election.dao.UserDAO;
import com.election.model.User;
import com.election.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user_id") != null) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validate fields
        if (fullName == null || fullName.trim().isEmpty()) {
            request.setAttribute("error", "Full name is required.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        if (email == null || email.trim().isEmpty() || !email.contains("@")) {
            request.setAttribute("error", "A valid email address is required.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        if (password == null || password.length() < 6) {
            request.setAttribute("error", "Password must be at least 6 characters.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        try {
            User user = new User();
            user.setFullName(fullName.trim());
            user.setEmail(email.trim().toLowerCase());
            user.setPassword(PasswordUtil.hashPassword(password));

            boolean registered = userDAO.registerUser(user);
            if (registered) {
                response.sendRedirect(request.getContextPath() + "/login?success=pending");
            } else {
                request.setAttribute("error", "This email address is already registered. Please log in.");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "A system error occurred. Please try again later.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
}
