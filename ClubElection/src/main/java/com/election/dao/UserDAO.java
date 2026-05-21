package com.election.dao;

import com.election.model.User;
import com.election.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    public boolean registerUser(User user) throws SQLException {
        String checkSql = "SELECT COUNT(*) FROM users WHERE email = ?";
        String insertSql = "INSERT INTO users (full_name, email, password, is_approved) VALUES (?, ?, ?, FALSE)";

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();

            // Check email uniqueness
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setString(1, user.getEmail());
                ResultSet rs = checkStmt.executeQuery();
                if (rs.next() && rs.getInt(1) > 0) {
                    return false; // Email already exists
                }
            }

            // Insert user
            try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                insertStmt.setString(1, user.getFullName());
                insertStmt.setString(2, user.getEmail());
                insertStmt.setString(3, user.getPassword());
                int rows = insertStmt.executeUpdate();
                return rows > 0;
            }
        } finally {
            DBConnection.close(conn);
        }
    }

    public User getUserByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM users WHERE email = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, email);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    return mapUser(rs);
                }
            }
        } finally {
            DBConnection.close(conn);
        }
        return null;
    }

    public User getUserById(int id) throws SQLException {
        String sql = "SELECT * FROM users WHERE user_id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, id);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    return mapUser(rs);
                }
            }
        } finally {
            DBConnection.close(conn);
        }
        return null;
    }

    public boolean markUserAsVoted(int userId) throws SQLException {
        String sql = "UPDATE users SET has_voted = TRUE WHERE user_id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, userId);
                return stmt.executeUpdate() > 0;
            }
        } finally {
            DBConnection.close(conn);
        }
    }

    public boolean markUserAsVoted(int userId, Connection conn) throws SQLException {
        String sql = "UPDATE users SET has_voted = TRUE WHERE user_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            return stmt.executeUpdate() > 0;
        }
    }

    public List<User> getAllUsers() throws SQLException {
        String sql = "SELECT * FROM users WHERE is_approved = TRUE ORDER BY created_at DESC";
        List<User> users = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                    users.add(mapUser(rs));
                }
            }
        } finally {
            DBConnection.close(conn);
        }
        return users;
    }

    public List<User> getUsersWhoVoted() throws SQLException {
        String sql = "SELECT * FROM users WHERE is_approved = TRUE AND has_voted = TRUE ORDER BY created_at DESC";
        List<User> users = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                    users.add(mapUser(rs));
                }
            }
        } finally {
            DBConnection.close(conn);
        }
        return users;
    }

    public List<User> getUsersWhoNotVoted() throws SQLException {
        String sql = "SELECT * FROM users WHERE is_approved = TRUE AND has_voted = FALSE ORDER BY created_at DESC";
        List<User> users = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                    users.add(mapUser(rs));
                }
            }
        } finally {
            DBConnection.close(conn);
        }
        return users;
    }

    public int getTotalUserCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM users WHERE is_approved = TRUE";
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

    public boolean updatePassword(String email, String newHashedPassword) throws SQLException {
        String sql = "UPDATE users SET password = ? WHERE email = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, newHashedPassword);
                stmt.setString(2, email);
                return stmt.executeUpdate() > 0;
            }
        } finally {
            DBConnection.close(conn);
        }
    }

    public boolean approveUser(int userId) throws SQLException {
        String sql = "UPDATE users SET is_approved = TRUE WHERE user_id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, userId);
                return stmt.executeUpdate() > 0;
            }
        } finally {
            DBConnection.close(conn);
        }
    }

    public boolean rejectUser(int userId) throws SQLException {
        String sql = "DELETE FROM users WHERE user_id = ? AND is_approved = FALSE";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, userId);
                return stmt.executeUpdate() > 0;
            }
        } finally {
            DBConnection.close(conn);
        }
    }

    public List<User> getPendingUsers() throws SQLException {
        String sql = "SELECT * FROM users WHERE is_approved = FALSE ORDER BY created_at DESC";
        List<User> users = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                    users.add(mapUser(rs));
                }
            }
        } finally {
            DBConnection.close(conn);
        }
        return users;
    }

    public int getPendingUserCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM users WHERE is_approved = FALSE";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) return rs.getInt(1);
            }
        } finally {
            DBConnection.close(conn);
        }
        return 0;
    }

    private User mapUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setFullName(rs.getString("full_name"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setHasVoted(rs.getBoolean("has_voted"));
        user.setApproved(rs.getBoolean("is_approved"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        return user;
    }
}
