package com.ttsstudio.ttsdashboard.model;

/**
 * Maps to: qc_scoring
 * Per-batch QC dimension scores (Q1-Q6) and total.
 */
public class QcScoring {

    private Long   qcScoreId;
    private String batchId;
    private Double q1Score;
    private Double q2Score;
    private Double q3Score;
    private Double q4Score;
    private Double q5Score;
    private Double q6Score;
    private Double totalQcScore;

    /* ── Constructors ─────────────────────────────────────── */
    public QcScoring() {}

    public QcScoring(Long qcScoreId, String batchId,
                     Double q1Score, Double q2Score, Double q3Score,
                     Double q4Score, Double q5Score, Double q6Score,
                     Double totalQcScore) {
        this.qcScoreId    = qcScoreId;
        this.batchId      = batchId;
        this.q1Score      = q1Score;
        this.q2Score      = q2Score;
        this.q3Score      = q3Score;
        this.q4Score      = q4Score;
        this.q5Score      = q5Score;
        this.q6Score      = q6Score;
        this.totalQcScore = totalQcScore;
    }

    /* ── Getters & Setters ────────────────────────────────── */
    public Long   getQcScoreId()    { return qcScoreId; }
    public void   setQcScoreId(Long v)      { this.qcScoreId = v; }

    public String getBatchId()      { return batchId; }
    public void   setBatchId(String v)      { this.batchId = v; }

    public Double getQ1Score()      { return q1Score; }
    public void   setQ1Score(Double v)      { this.q1Score = v; }

    public Double getQ2Score()      { return q2Score; }
    public void   setQ2Score(Double v)      { this.q2Score = v; }

    public Double getQ3Score()      { return q3Score; }
    public void   setQ3Score(Double v)      { this.q3Score = v; }

    public Double getQ4Score()      { return q4Score; }
    public void   setQ4Score(Double v)      { this.q4Score = v; }

    public Double getQ5Score()      { return q5Score; }
    public void   setQ5Score(Double v)      { this.q5Score = v; }

    public Double getQ6Score()      { return q6Score; }
    public void   setQ6Score(Double v)      { this.q6Score = v; }

    public Double getTotalQcScore() { return totalQcScore; }
    public void   setTotalQcScore(Double v) { this.totalQcScore = v; }

    @Override
    public String toString() {
        return "QcScoring{batchId='" + batchId + "', totalQcScore=" + totalQcScore + "}";
    }
}
