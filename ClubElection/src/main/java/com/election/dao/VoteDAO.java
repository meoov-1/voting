package com.election.dao;

import com.election.util.DBConnection;

import java.sql.*;

public class VoteDAO {

    public boolean castVote(int candidateId) throws SQLException {
        String sql = "INSERT INTO votes (candidate_id) VALUES (?)";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, candidateId);
                return stmt.executeUpdate() > 0;
            }
        } finally {
            DBConnection.close(conn);
        }
    }

    public boolean castVote(int candidateId, Connection conn) throws SQLException {
        String sql = "INSERT INTO votes (candidate_id) VALUES (?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, candidateId);
            return stmt.executeUpdate() > 0;
        }
    }

    public int getVoteCountByCandidate(int candidateId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM votes WHERE candidate_id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, candidateId);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } finally {
            DBConnection.close(conn);
        }
        return 0;
    }

    public int getTotalVotes() throws SQLException {
        String sql = "SELECT COUNT(*) FROM votes";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } finally {
            DBConnection.close(conn);
        }
        return 0;
    }
}
