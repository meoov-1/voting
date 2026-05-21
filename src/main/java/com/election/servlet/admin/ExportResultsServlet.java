package com.election.servlet.admin;

import com.election.dao.CandidateDAO;
import com.election.dao.VoteDAO;
import com.election.model.Candidate;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.util.List;

@WebServlet("/admin/export")
public class ExportResultsServlet extends HttpServlet {

    private final CandidateDAO candidateDAO = new CandidateDAO();
    private final VoteDAO voteDAO = new VoteDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin_id") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        try {
            List<Candidate> candidates = candidateDAO.getAllCandidates();
            int totalVotes = voteDAO.getTotalVotes();

            response.setContentType("text/csv");
            response.setHeader("Content-Disposition", "attachment; filename=\"election_results.csv\"");
            response.setCharacterEncoding("UTF-8");

            PrintWriter writer = response.getWriter();

            // CSV Header
            writer.println("Candidate Name,Position,Vote Count,Percentage");

            // CSV Rows
            for (Candidate c : candidates) {
                double percentage = totalVotes > 0
                        ? Math.round((c.getVoteCount() * 100.0 / totalVotes) * 100.0) / 100.0
                        : 0.0;
                writer.println(
                    escapeCsv(c.getName()) + "," +
                    escapeCsv(c.getPosition()) + "," +
                    c.getVoteCount() + "," +
                    percentage + "%"
                );
            }

            // Summary row
            writer.println();
            writer.println("Total Votes,," + totalVotes + ",100%");

            writer.flush();

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to export results.");
        }
    }

    private String escapeCsv(String value) {
        if (value == null) return "";
        if (value.contains(",") || value.contains("\"") || value.contains("\n")) {
            return "\"" + value.replace("\"", "\"\"") + "\"";
        }
        return value;
    }
}
