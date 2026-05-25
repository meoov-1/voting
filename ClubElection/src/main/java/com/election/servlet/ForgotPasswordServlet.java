package com.election.servlet;

import com.election.dao.UserDAO;
import com.election.model.User;
import com.election.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");

        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Please enter your email address.");
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
            return;
        }

        try {
            User user = userDAO.getUserByEmail(email.trim().toLowerCase());
            if (user == null) {
                request.setAttribute("error", "No account found with that email address.");
                request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
                return;
            }

            // Generate a temporary password
            String tempPassword = PasswordUtil.generateTempPassword();
            String hashedTemp = PasswordUtil.hashPassword(tempPassword);

            boolean updated = userDAO.updatePassword(email.trim().toLowerCase(), hashedTemp);
            if (updated) {
                request.setAttribute("success", "Your password has been reset.");
                request.setAttribute("newPassword", tempPassword);
                request.setAttribute("userEmail", email.trim().toLowerCase());
            } else {
                request.setAttribute("error", "Failed to reset password. Please try again.");
            }
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "A system error occurred. Please try again later.");
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
        }
    }
}
