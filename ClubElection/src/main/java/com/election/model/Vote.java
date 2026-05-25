package com.election.model;

import java.sql.Timestamp;

public class Vote {

    private int voteId;
    private int candidateId;
    private Timestamp votedAt;

    public Vote() {}

    public Vote(int candidateId) {
        this.candidateId = candidateId;
    }

    public int getVoteId() { return voteId; }
    public void setVoteId(int voteId) { this.voteId = voteId; }

    public int getCandidateId() { return candidateId; }
    public void setCandidateId(int candidateId) { this.candidateId = candidateId; }

    public Timestamp getVotedAt() { return votedAt; }
    public void setVotedAt(Timestamp votedAt) { this.votedAt = votedAt; }

    @Override
    public String toString() {
        return "Vote{voteId=" + voteId + ", candidateId=" + candidateId + ", votedAt=" + votedAt + "}";
    }
}
