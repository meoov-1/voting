package com.election.servlet.admin;

import com.election.dao.ElectionSettingsDAO;
import com.election.model.ElectionSettings;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/election-control")
public class ElectionControlServlet extends HttpServlet {

    private final ElectionSettingsDAO settingsDAO = new ElectionSettingsDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin_id") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        String action = request.getParameter("action");

        try {
            if ("start".equals(action)) {
                settingsDAO.setElectionActive(true);
                response.sendRedirect(request.getContextPath() + "/admin/dashboard?msg=Election+started");
            } else if ("stop".equals(action)) {
                settingsDAO.setElectionActive(false);
                response.sendRedirect(request.getContextPath() + "/admin/dashboard?msg=Election+stopped");
            } else if ("setEndTime".equals(action)) {
                String endTime = request.getParameter("endTime");
                settingsDAO.setEndTime(endTime);
                response.sendRedirect(request.getContextPath() + "/admin/election-settings?msg=End+time+updated");
            } else if ("updateSettings".equals(action)) {
                ElectionSettings settings = settingsDAO.getSettings();
                if (settings != null) {
                    String title = request.getParameter("electionTitle");
                    String endTime = request.getParameter("endTime");
                    String isActiveParam = request.getParameter("isActive");

                    if (title != null && !title.trim().isEmpty()) {
                        settings.setElectionTitle(title.trim());
                    }
                    settings.setEndTime(endTime);
                    settings.setActive("on".equals(isActiveParam) || "true".equals(isActiveParam));
                    settingsDAO.updateSettings(settings);
                }
                response.sendRedirect(request.getContextPath() + "/admin/election-settings?msg=Settings+updated");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?error=Operation+failed");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin_id") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }
        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
    }
}
