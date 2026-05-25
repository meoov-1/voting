package com.election.dao;

import com.election.model.Admin;
import com.election.util.DBConnection;
import com.election.util.PasswordUtil;

import java.sql.*;

public class AdminDAO {

    public Admin getAdminByUsername(String username) throws SQLException {
        String sql = "SELECT * FROM admins WHERE username = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, username);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    Admin admin = new Admin();
                    admin.setAdminId(rs.getInt("admin_id"));
                    admin.setUsername(rs.getString("username"));
                    admin.setPassword(rs.getString("password"));
                    return admin;
                }
            }
        } finally {
            DBConnection.close(conn);
        }
        return null;
    }

    public Admin validateAdmin(String username, String password) throws SQLException {
        Admin admin = getAdminByUsername(username);
        if (admin != null && PasswordUtil.verifyPassword(password, admin.getPassword())) {
            return admin;
        }
        return null;
    }
}
