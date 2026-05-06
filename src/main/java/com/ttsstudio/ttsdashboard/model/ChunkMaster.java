package com.ttsstudio.ttsdashboard.model;

import java.time.LocalDateTime;

/**
 * Maps to: chunk_master
 * Individual audio chunk with QC metrics and transcript.
 */
public class ChunkMaster {

    private String        chunkId;
    private String        batchId;
    private String        videoId;
    private String        videoUrl;
    private Double        startSec;
    private Double        endSec;
    private Double        duration;
    private Integer       samplingRate;
    private Double        silenceRatio;
    private Double        snrDb;
    private Double        clippingRatio;
    private Double        speakerSimilarity;
    private String        language;
    private Boolean       duplicate;
    private String        duplicateOf;
    private String        rawTranscript;
    private String        transcript;
    private Boolean       passed;
    private Boolean       qcPassed;
    private String        failureReasons;
    private String        qcFailureReasons;
    private String        userName;
    private String        audioPath;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    /* ── Constructors ─────────────────────────────────────── */
    public ChunkMaster() {}

    /* ── Getters & Setters ────────────────────────────────── */
    public String        getChunkId()           { return chunkId; }
    public void          setChunkId(String v)           { this.chunkId = v; }

    public String        getBatchId()            { return batchId; }
    public void          setBatchId(String v)            { this.batchId = v; }

    public String        getVideoId()            { return videoId; }
    public void          setVideoId(String v)            { this.videoId = v; }

    public String        getVideoUrl()           { return videoUrl; }
    public void          setVideoUrl(String v)           { this.videoUrl = v; }

    public Double        getStartSec()           { return startSec; }
    public void          setStartSec(Double v)           { this.startSec = v; }

    public Double        getEndSec()             { return endSec; }
    public void          setEndSec(Double v)             { this.endSec = v; }

    public Double        getDuration()           { return duration; }
    public void          setDuration(Double v)           { this.duration = v; }

    public Integer       getSamplingRate()        { return samplingRate; }
    public void          setSamplingRate(Integer v)      { this.samplingRate = v; }

    public Double        getSilenceRatio()        { return silenceRatio; }
    public void          setSilenceRatio(Double v)       { this.silenceRatio = v; }

    public Double        getSnrDb()              { return snrDb; }
    public void          setSnrDb(Double v)              { this.snrDb = v; }

    public Double        getClippingRatio()       { return clippingRatio; }
    public void          setClippingRatio(Double v)      { this.clippingRatio = v; }

    public Double        getSpeakerSimilarity()   { return speakerSimilarity; }
    public void          setSpeakerSimilarity(Double v)  { this.speakerSimilarity = v; }

    public String        getLanguage()            { return language; }
    public void          setLanguage(String v)           { this.language = v; }

    public Boolean       getDuplicate()           { return duplicate; }
    public void          setDuplicate(Boolean v)         { this.duplicate = v; }

    public String        getDuplicateOf()         { return duplicateOf; }
    public void          setDuplicateOf(String v)        { this.duplicateOf = v; }

    public String        getRawTranscript()        { return rawTranscript; }
    public void          setRawTranscript(String v)       { this.rawTranscript = v; }

    public String        getTranscript()           { return transcript; }
    public void          setTranscript(String v)          { this.transcript = v; }

    public Boolean       getPassed()              { return passed; }
    public void          setPassed(Boolean v)             { this.passed = v; }

    public Boolean       getQcPassed()            { return qcPassed; }
    public void          setQcPassed(Boolean v)           { this.qcPassed = v; }

    public String        getFailureReasons()       { return failureReasons; }
    public void          setFailureReasons(String v)      { this.failureReasons = v; }

    public String        getQcFailureReasons()     { return qcFailureReasons; }
    public void          setQcFailureReasons(String v)    { this.qcFailureReasons = v; }

    public String        getUserName()             { return userName; }
    public void          setUserName(String v)            { this.userName = v; }

    public String        getAudioPath()            { return audioPath; }
    public void          setAudioPath(String v)           { this.audioPath = v; }

    public LocalDateTime getCreatedAt()            { return createdAt; }
    public void          setCreatedAt(LocalDateTime v)    { this.createdAt = v; }

    public LocalDateTime getUpdatedAt()            { return updatedAt; }
    public void          setUpdatedAt(LocalDateTime v)    { this.updatedAt = v; }

    @Override
    public String toString() {
        return "ChunkMaster{chunkId='" + chunkId + "', batchId='" + batchId
                + "', passed=" + passed + ", qcPassed=" + qcPassed + "}";
    }
}