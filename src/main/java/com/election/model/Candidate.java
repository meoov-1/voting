package com.election.model;

public class Candidate {

    private int candidateId;
    private String name;
    private String position;
    private String imagePath;
    private String bio;
    private int voteCount;

    public Candidate() {}

    public Candidate(String name, String position, String imagePath, String bio) {
        this.name = name;
        this.position = position;
        this.imagePath = imagePath;
        this.bio = bio;
        this.voteCount = 0;
    }

    public int getCandidateId() { return candidateId; }
    public void setCandidateId(int candidateId) { this.candidateId = candidateId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getPosition() { return position; }
    public void setPosition(String position) { this.position = position; }

    public String getImagePath() { return imagePath; }
    public void setImagePath(String imagePath) { this.imagePath = imagePath; }

    public String getBio() { return bio; }
    public void setBio(String bio) { this.bio = bio; }

    public int getVoteCount() { return voteCount; }
    public void setVoteCount(int voteCount) { this.voteCount = voteCount; }

    @Override
    public String toString() {
        return "Candidate{candidateId=" + candidateId + ", name='" + name + "', position='" + position + "', voteCount=" + voteCount + "}";
    }
}
