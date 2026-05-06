package com.ttsstudio.ttsdashboard.model;

/**
 * Maps to: metrics
 * Aggregated QC counts and hours per batch.
 */
public class Metrics {

    private Long   metricId;
    private String batchId;
    private int    totalFiles;
    private int    passedFiles;
    private int    failedFiles;
    private double totalHours;
    private double passedHours;
    private int    snrFailCounter;
    private int    silenceRatioFailCounter;
    private int    clippingFailCounter;
    private int    speakerSimFailCounter;
    private int    duplicateFailCounter;

    /* ── Constructors ─────────────────────────────────────── */
    public Metrics() {}

    public Metrics(Long metricId, String batchId,
                   int totalFiles, int passedFiles, int failedFiles,
                   double totalHours, double passedHours,
                   int snrFailCounter, int silenceRatioFailCounter,
                   int clippingFailCounter, int speakerSimFailCounter,
                   int duplicateFailCounter) {
        this.metricId                = metricId;
        this.batchId                 = batchId;
        this.totalFiles              = totalFiles;
        this.passedFiles             = passedFiles;
        this.failedFiles             = failedFiles;
        this.totalHours              = totalHours;
        this.passedHours             = passedHours;
        this.snrFailCounter          = snrFailCounter;
        this.silenceRatioFailCounter = silenceRatioFailCounter;
        this.clippingFailCounter     = clippingFailCounter;
        this.speakerSimFailCounter   = speakerSimFailCounter;
        this.duplicateFailCounter    = duplicateFailCounter;
    }

    /* ── Derived helpers (used directly in JSP EL) ────────── */
    /** Fail rate as a percentage, 0-100 */
    public double getFailRatePercent() {
        if (totalFiles == 0) return 0.0;
        return (failedFiles * 100.0) / totalFiles;
    }

    /** Pass rate as a percentage, 0-100 */
    public double getPassRatePercent() {
        if (totalFiles == 0) return 0.0;
        return (passedFiles * 100.0) / totalFiles;
    }

    /* ── Getters & Setters ────────────────────────────────── */
    public Long   getMetricId()                 { return metricId; }
    public void   setMetricId(Long v)                   { this.metricId = v; }

    public String getBatchId()                  { return batchId; }
    public void   setBatchId(String v)                  { this.batchId = v; }

    public int    getTotalFiles()               { return totalFiles; }
    public void   setTotalFiles(int v)                  { this.totalFiles = v; }

    public int    getPassedFiles()              { return passedFiles; }
    public void   setPassedFiles(int v)                 { this.passedFiles = v; }

    public int    getFailedFiles()              { return failedFiles; }
    public void   setFailedFiles(int v)                 { this.failedFiles = v; }

    public double getTotalHours()               { return totalHours; }
    public void   setTotalHours(double v)               { this.totalHours = v; }

    public double getPassedHours()              { return passedHours; }
    public void   setPassedHours(double v)              { this.passedHours = v; }

    public int    getSnrFailCounter()           { return snrFailCounter; }
    public void   setSnrFailCounter(int v)              { this.snrFailCounter = v; }

    public int    getSilenceRatioFailCounter()  { return silenceRatioFailCounter; }
    public void   setSilenceRatioFailCounter(int v)     { this.silenceRatioFailCounter = v; }

    public int    getClippingFailCounter()      { return clippingFailCounter; }
    public void   setClippingFailCounter(int v)         { this.clippingFailCounter = v; }

    public int    getSpeakerSimFailCounter()    { return speakerSimFailCounter; }
    public void   setSpeakerSimFailCounter(int v)       { this.speakerSimFailCounter = v; }

    public int    getDuplicateFailCounter()     { return duplicateFailCounter; }
    public void   setDuplicateFailCounter(int v)        { this.duplicateFailCounter = v; }

    @Override
    public String toString() {
        return "Metrics{batchId='" + batchId + "', totalFiles=" + totalFiles
                + ", passedFiles=" + passedFiles + "}";
    }
}
