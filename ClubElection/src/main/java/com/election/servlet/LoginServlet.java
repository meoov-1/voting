package com.election.servlet;

import com.election.dao.UserDAO;
import com.election.model.User;
import com.election.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user_id") != null) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Email and password are required.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        try {
            User user = userDAO.getUserByEmail(email.trim().toLowerCase());
            if (user != null && PasswordUtil.verifyPassword(password, user.getPassword())) {
                // Check approval status
                if (!user.isApproved()) {
                    request.setAttribute("error", "Your account is pending admin approval. Please wait for approval before logging in.");
                    request.getRequestDispatcher("/login.jsp").forward(request, response);
                    return;
                }
                HttpSession session = request.getSession(true);
                session.setAttribute("user_id", user.getUserId());
                session.setAttribute("user_name", user.getFullName());
                session.setAttribute("user_email", user.getEmail());
                session.setAttribute("has_voted", user.isHasVoted());
                session.setMaxInactiveInterval(60 * 60); // 1 hour
                response.sendRedirect(request.getContextPath() + "/dashboard");
            } else {
                request.setAttribute("error", "Invalid email or password. Please try again.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "A system error occurred. Please try again later.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}
