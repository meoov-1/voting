package com.election.dao;

import com.election.model.ElectionSettings;
import com.election.util.DBConnection;

import java.sql.*;

public class ElectionSettingsDAO {

    public ElectionSettings getSettings() throws SQLException {
        String sql = "SELECT * FROM election_settings ORDER BY id DESC LIMIT 1";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    ElectionSettings settings = new ElectionSettings();
                    settings.setId(rs.getInt("id"));
                    settings.setElectionTitle(rs.getString("election_title"));
                    settings.setActive(rs.getBoolean("is_active"));
                    Timestamp endTs = rs.getTimestamp("end_time");
                    if (endTs != null) {
                        // Format as datetime-local compatible string
                        settings.setEndTime(endTs.toString().substring(0, 16).replace(" ", "T"));
                    } else {
                        settings.setEndTime(null);
                    }
                    settings.setCreatedAt(rs.getTimestamp("created_at"));
                    return settings;
                }
            }
        } finally {
            DBConnection.close(conn);
        }
        return null;
    }

    public boolean updateSettings(ElectionSettings s) throws SQLException {
        String sql = "UPDATE election_settings SET election_title = ?, is_active = ?, end_time = ? WHERE id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, s.getElectionTitle());
                stmt.setBoolean(2, s.isActive());
                if (s.getEndTime() != null && !s.getEndTime().isEmpty()) {
                    stmt.setString(3, s.getEndTime().replace("T", " "));
                } else {
                    stmt.setNull(3, Types.TIMESTAMP);
                }
                stmt.setInt(4, s.getId());
                return stmt.executeUpdate() > 0;
            }
        } finally {
            DBConnection.close(conn);
        }
    }

    public boolean setElectionActive(boolean active) throws SQLException {
        String sql = "UPDATE election_settings SET is_active = ? ORDER BY id DESC LIMIT 1";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setBoolean(1, active);
                return stmt.executeUpdate() > 0;
            }
        } finally {
            DBConnection.close(conn);
        }
    }

    /**
     * Resets all voting data in a single transaction:
     *  - Clears the votes table
     *  - Resets all candidates vote_count to 0
     *  - Resets all users has_voted to FALSE
     *  - Sets election active = TRUE
     */
    public void startFreshElection() throws SQLException {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            try {
                // 1. Delete all votes
                try (PreparedStatement s = conn.prepareStatement("DELETE FROM votes")) {
                    s.executeUpdate();
                }
                // 2. Reset candidate vote counts
                try (PreparedStatement s = conn.prepareStatement("UPDATE candidates SET vote_count = 0")) {
                    s.executeUpdate();
                }
                // 3. Reset all approved users has_voted flag
                try (PreparedStatement s = conn.prepareStatement("UPDATE users SET has_voted = FALSE")) {
                    s.executeUpdate();
                }
                // 4. Activate the election
                try (PreparedStatement s = conn.prepareStatement(
                        "UPDATE election_settings SET is_active = TRUE ORDER BY id DESC LIMIT 1")) {
                    s.executeUpdate();
                }
                conn.commit();
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

    public boolean setEndTime(String endTime) throws SQLException {
        String sql = "UPDATE election_settings SET end_time = ? ORDER BY id DESC LIMIT 1";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                if (endTime != null && !endTime.isEmpty()) {
                    stmt.setString(1, endTime.replace("T", " "));
                } else {
                    stmt.setNull(1, Types.TIMESTAMP);
                }
                return stmt.executeUpdate() > 0;
            }
        } finally {
            DBConnection.close(conn);
        }
    }
}
