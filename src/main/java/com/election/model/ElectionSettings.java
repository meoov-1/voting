package com.election.model;

import java.sql.Timestamp;

public class ElectionSettings {

    private int id;
    private String electionTitle;
    private boolean isActive;
    private String endTime;
    private Timestamp createdAt;

    public ElectionSettings() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getElectionTitle() { return electionTitle; }
    public void setElectionTitle(String electionTitle) { this.electionTitle = electionTitle; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }

    public String getEndTime() { return endTime; }
    public void setEndTime(String endTime) { this.endTime = endTime; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    @Override
    public String toString() {
        return "ElectionSettings{id=" + id + ", electionTitle='" + electionTitle + "', isActive=" + isActive + ", endTime='" + endTime + "'}";
    }
}
