package com.election.servlet.admin;

import com.election.dao.ElectionSettingsDAO;
import com.election.model.ElectionSettings;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/election-settings")
public class ElectionSettingsServlet extends HttpServlet {

    private final ElectionSettingsDAO settingsDAO = new ElectionSettingsDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin_id") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        try {
            ElectionSettings settings = settingsDAO.getSettings();
            request.setAttribute("settings", settings);

            String msg = request.getParameter("msg");
            if (msg != null) {
                request.setAttribute("success", msg);
            }

            request.getRequestDispatcher("/admin/election-settings.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to load election settings.");
            request.getRequestDispatcher("/admin/election-settings.jsp").forward(request, response);
        }
    }
}
