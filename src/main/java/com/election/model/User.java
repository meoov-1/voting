package com.election.model;

import java.sql.Timestamp;

public class User {

    private int userId;
    private String fullName;
    private String email;
    private String password;
    private boolean hasVoted;
    private boolean isApproved;
    private Timestamp createdAt;

    public User() {}

    public User(String fullName, String email, String password) {
        this.fullName = fullName;
        this.email = email;
        this.password = password;
        this.hasVoted = false;
        this.isApproved = false;
    }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public boolean isHasVoted() { return hasVoted; }
    public void setHasVoted(boolean hasVoted) { this.hasVoted = hasVoted; }

    public boolean isApproved() { return isApproved; }
    public void setApproved(boolean approved) { isApproved = approved; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    @Override
    public String toString() {
        return "User{userId=" + userId + ", fullName='" + fullName + "', email='" + email + "', hasVoted=" + hasVoted + ", isApproved=" + isApproved + "}";
    }
}
