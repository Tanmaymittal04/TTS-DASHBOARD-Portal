package com.ttsstudio.ttsdashboard.model;

import java.time.LocalDateTime;

/**
 * Maps to: pipeline_master
 * Central table — every batch starts here.
 */
public class PipelineMaster {

    private String        batchId;
    private String        userName;
    private String        sourceType;
    private String        sourceUrl;
    private String        sourceName;
    private String        speakerId;
    private String        speakerName;
    private String        speakerGender;
    private String        currentStage;
    private String        status;
    private String        s3PrefixPath;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    /* ── Constructors ─────────────────────────────────────── */
    public PipelineMaster() {}

    public PipelineMaster(String batchId, String userName, String sourceType,
                          String sourceUrl, String sourceName,
                          String speakerId, String speakerName,
                          String speakerGender, String currentStage,
                          String status, String s3PrefixPath,
                          LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.batchId       = batchId;
        this.userName      = userName;
        this.sourceType    = sourceType;
        this.sourceUrl     = sourceUrl;
        this.sourceName    = sourceName;
        this.speakerId     = speakerId;
        this.speakerName   = speakerName;
        this.speakerGender = speakerGender;
        this.currentStage  = currentStage;
        this.status        = status;
        this.s3PrefixPath  = s3PrefixPath;
        this.createdAt     = createdAt;
        this.updatedAt     = updatedAt;
    }

    /* ── Getters & Setters ────────────────────────────────── */
    public String        getBatchId()       { return batchId; }
    public void          setBatchId(String v)       { this.batchId = v; }

    public String        getUserName()      { return userName; }
    public void          setUserName(String v)      { this.userName = v; }

    public String        getSourceType()    { return sourceType; }
    public void          setSourceType(String v)    { this.sourceType = v; }

    public String        getSourceUrl()     { return sourceUrl; }
    public void          setSourceUrl(String v)     { this.sourceUrl = v; }

    public String        getSourceName()    { return sourceName; }
    public void          setSourceName(String v)    { this.sourceName = v; }

    public String        getSpeakerId()     { return speakerId; }
    public void          setSpeakerId(String v)     { this.speakerId = v; }

    public String        getSpeakerName()   { return speakerName; }
    public void          setSpeakerName(String v)   { this.speakerName = v; }

    public String        getSpeakerGender() { return speakerGender; }
    public void          setSpeakerGender(String v) { this.speakerGender = v; }

    public String        getCurrentStage()  { return currentStage; }
    public void          setCurrentStage(String v)  { this.currentStage = v; }

    public String        getStatus()        { return status; }
    public void          setStatus(String v)        { this.status = v; }

    public String        getS3PrefixPath()  { return s3PrefixPath; }
    public void          setS3PrefixPath(String v)  { this.s3PrefixPath = v; }

    public LocalDateTime getCreatedAt()     { return createdAt; }
    public void          setCreatedAt(LocalDateTime v) { this.createdAt = v; }

    public LocalDateTime getUpdatedAt()     { return updatedAt; }
    public void          setUpdatedAt(LocalDateTime v) { this.updatedAt = v; }

    @Override
    public String toString() {
        return "PipelineMaster{batchId='" + batchId + "', status='" + status
                + "', currentStage='" + currentStage + "'}";
    }
}
