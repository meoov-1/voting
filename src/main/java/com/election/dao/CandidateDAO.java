package com.election.dao;

import com.election.model.Candidate;
import com.election.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CandidateDAO {

    public List<Candidate> getAllCandidates() throws SQLException {
        String sql = "SELECT * FROM candidates ORDER BY position, name";
        List<Candidate> candidates = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                    candidates.add(mapCandidate(rs));
                }
            }
        } finally {
            DBConnection.close(conn);
        }
        return candidates;
    }

    public Candidate getCandidateById(int id) throws SQLException {
        String sql = "SELECT * FROM candidates WHERE candidate_id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, id);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    return mapCandidate(rs);
                }
            }
        } finally {
            DBConnection.close(conn);
        }
        return null;
    }

    public boolean addCandidate(Candidate c) throws SQLException {
        String sql = "INSERT INTO candidates (name, position, image_path, bio) VALUES (?, ?, ?, ?)";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, c.getName());
                stmt.setString(2, c.getPosition());
                stmt.setString(3, c.getImagePath());
                stmt.setString(4, c.getBio());
                return stmt.executeUpdate() > 0;
            }
        } finally {
            DBConnection.close(conn);
        }
    }

    public boolean updateCandidate(Candidate c) throws SQLException {
        String sql = "UPDATE candidates SET name = ?, position = ?, image_path = ?, bio = ? WHERE candidate_id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, c.getName());
                stmt.setString(2, c.getPosition());
                stmt.setString(3, c.getImagePath());
                stmt.setString(4, c.getBio());
                stmt.setInt(5, c.getCandidateId());
                return stmt.executeUpdate() > 0;
            }
        } finally {
            DBConnection.close(conn);
        }
    }

    public boolean deleteCandidate(int id) throws SQLException {
        // First delete related votes to maintain referential integrity
        String deleteVotesSql = "DELETE FROM votes WHERE candidate_id = ?";
        String deleteCandidateSql = "DELETE FROM candidates WHERE candidate_id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            try {
                try (PreparedStatement stmt = conn.prepareStatement(deleteVotesSql)) {
                    stmt.setInt(1, id);
                    stmt.executeUpdate();
                }
                try (PreparedStatement stmt = conn.prepareStatement(deleteCandidateSql)) {
                    stmt.setInt(1, id);
                    int rows = stmt.executeUpdate();
                    conn.commit();
                    return rows > 0;
                }
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        } finally {
            DBConnection.close(conn);
        }
    }

    public boolean incrementVoteCount(int candidateId) throws SQLException {
        String sql = "UPDATE candidates SET vote_count = vote_count + 1 WHERE candidate_id = ?";
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

    public boolean incrementVoteCount(int candidateId, Connection conn) throws SQLException {
        String sql = "UPDATE candidates SET vote_count = vote_count + 1 WHERE candidate_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, candidateId);
            return stmt.executeUpdate() > 0;
        }
    }

    private Candidate mapCandidate(ResultSet rs) throws SQLException {
        Candidate c = new Candidate();
        c.setCandidateId(rs.getInt("candidate_id"));
        c.setName(rs.getString("name"));
        c.setPosition(rs.getString("position"));
        c.setImagePath(rs.getString("image_path"));
        c.setBio(rs.getString("bio"));
        c.setVoteCount(rs.getInt("vote_count"));
        return c;
    }
}
