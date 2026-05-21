package com.election.servlet.admin;

import com.election.dao.CandidateDAO;
import com.election.model.Candidate;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.util.List;
import java.util.UUID;

@WebServlet("/admin/candidates")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,      // 1 MB
    maxFileSize = 1024 * 1024 * 5,         // 5 MB
    maxRequestSize = 1024 * 1024 * 10      // 10 MB
)
public class CandidateServlet extends HttpServlet {

    private final CandidateDAO candidateDAO = new CandidateDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin_id") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        String action = request.getParameter("action");

        try {
            if ("edit".equals(action)) {
                String idParam = request.getParameter("id");
                if (idParam != null) {
                    int id = Integer.parseInt(idParam);
                    Candidate candidate = candidateDAO.getCandidateById(id);
                    request.setAttribute("candidate", candidate);
                }
                request.getRequestDispatcher("/admin/edit-candidate.jsp").forward(request, response);
            } else if ("add".equals(action)) {
                request.getRequestDispatcher("/admin/add-candidate.jsp").forward(request, response);
            } else {
                List<Candidate> candidates = candidateDAO.getAllCandidates();
                request.setAttribute("candidates", candidates);
                request.getRequestDispatcher("/admin/candidates.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to load candidates.");
            request.getRequestDispatcher("/admin/candidates.jsp").forward(request, response);
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

        String action = request.getParameter("action");

        try {
            if ("add".equals(action)) {
                handleAdd(request, response);
            } else if ("edit".equals(action)) {
                handleEdit(request, response);
            } else if ("delete".equals(action)) {
                handleDelete(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/candidates");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Operation failed: " + e.getMessage());
            try {
                List<Candidate> candidates = candidateDAO.getAllCandidates();
                request.setAttribute("candidates", candidates);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            request.getRequestDispatcher("/admin/candidates.jsp").forward(request, response);
        }
    }

    private void handleAdd(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String name = request.getParameter("name");
        String position = request.getParameter("position");
        String bio = request.getParameter("bio");

        if (name == null || name.trim().isEmpty() || position == null || position.trim().isEmpty()) {
            request.setAttribute("error", "Name and position are required.");
            request.getRequestDispatcher("/admin/add-candidate.jsp").forward(request, response);
            return;
        }

        String imagePath = handleImageUpload(request);

        Candidate candidate = new Candidate();
        candidate.setName(name.trim());
        candidate.setPosition(position.trim());
        candidate.setBio(bio != null ? bio.trim() : "");
        candidate.setImagePath(imagePath);

        candidateDAO.addCandidate(candidate);
        response.sendRedirect(request.getContextPath() + "/admin/candidates?success=added");
    }

    private void handleEdit(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String idParam = request.getParameter("candidateId");
        String name = request.getParameter("name");
        String position = request.getParameter("position");
        String bio = request.getParameter("bio");
        String existingImage = request.getParameter("existingImage");

        if (idParam == null || name == null || name.trim().isEmpty() || position == null || position.trim().isEmpty()) {
            request.setAttribute("error", "Name and position are required.");
            request.getRequestDispatcher("/admin/edit-candidate.jsp").forward(request, response);
            return;
        }

        int candidateId = Integer.parseInt(idParam);
        String imagePath = handleImageUpload(request);
        if (imagePath == null || imagePath.isEmpty()) {
            imagePath = existingImage; // Keep existing image if no new one uploaded
        }

        Candidate candidate = new Candidate();
        candidate.setCandidateId(candidateId);
        candidate.setName(name.trim());
        candidate.setPosition(position.trim());
        candidate.setBio(bio != null ? bio.trim() : "");
        candidate.setImagePath(imagePath);

        candidateDAO.updateCandidate(candidate);
        response.sendRedirect(request.getContextPath() + "/admin/candidates?success=updated");
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String idParam = request.getParameter("candidateId");
        if (idParam != null) {
            int candidateId = Integer.parseInt(idParam);
            candidateDAO.deleteCandidate(candidateId);
        }
        response.sendRedirect(request.getContextPath() + "/admin/candidates?success=deleted");
    }

    private String handleImageUpload(HttpServletRequest request) throws Exception {
        Part filePart = request.getPart("image");
        if (filePart == null || filePart.getSize() == 0) {
            return null;
        }

        String fileName = filePart.getSubmittedFileName();
        if (fileName == null || fileName.trim().isEmpty()) {
            return null;
        }

        // Validate file type
        String contentType = filePart.getContentType();
        if (contentType == null || !contentType.startsWith("image/")) {
            return null;
        }

        String extension = fileName.substring(fileName.lastIndexOf('.'));
        String uniqueName = UUID.randomUUID().toString() + extension;

        String uploadDir = getServletContext().getRealPath("/uploads");
        File uploadFolder = new File(uploadDir);
        if (!uploadFolder.exists()) {
            uploadFolder.mkdirs();
        }

        String filePath = uploadDir + File.separator + uniqueName;
        filePart.write(filePath);

        return "uploads/" + uniqueName;
    }
}
