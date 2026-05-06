package com.ttsstudio.ttsdashboard.model;

/**
 * Maps to: init_config
 * QC threshold configuration per batch.
 */
public class InitConfig {

    private Long    configId;
    private String  batchId;
    private Double  snr;
    private Double  silenceRatio;
    private Double  clipping;
    private Double  speakerSimilarity;
    private Integer samplingRate;
    private Boolean duplication;

    /* ── Constructors ─────────────────────────────────────── */
    public InitConfig() {}

    public InitConfig(Long configId, String batchId, Double snr,
                      Double silenceRatio, Double clipping,
                      Double speakerSimilarity, Integer samplingRate,
                      Boolean duplication) {
        this.configId          = configId;
        this.batchId           = batchId;
        this.snr               = snr;
        this.silenceRatio      = silenceRatio;
        this.clipping          = clipping;
        this.speakerSimilarity = speakerSimilarity;
        this.samplingRate      = samplingRate;
        this.duplication       = duplication;
    }

    /* ── Getters & Setters ────────────────────────────────── */
    public Long    getConfigId()          { return configId; }
    public void    setConfigId(Long v)            { this.configId = v; }

    public String  getBatchId()           { return batchId; }
    public void    setBatchId(String v)           { this.batchId = v; }

    public Double  getSnr()               { return snr; }
    public void    setSnr(Double v)               { this.snr = v; }

    public Double  getSilenceRatio()      { return silenceRatio; }
    public void    setSilenceRatio(Double v)      { this.silenceRatio = v; }

    public Double  getClipping()          { return clipping; }
    public void    setClipping(Double v)          { this.clipping = v; }

    public Double  getSpeakerSimilarity() { return speakerSimilarity; }
    public void    setSpeakerSimilarity(Double v) { this.speakerSimilarity = v; }

    public Integer getSamplingRate()      { return samplingRate; }
    public void    setSamplingRate(Integer v)     { this.samplingRate = v; }

    public Boolean getDuplication()       { return duplication; }
    public void    setDuplication(Boolean v)      { this.duplication = v; }

    @Override
    public String toString() {
        return "InitConfig{configId=" + configId + ", batchId='" + batchId + "'}";
    }
}
