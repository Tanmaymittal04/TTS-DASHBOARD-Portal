package com.ttsstudio.ttsdashboard.repository;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import java.util.*;

@Repository
public class DatasetIntakeRepository {

    private final JdbcTemplate jdbc;

    public DatasetIntakeRepository(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    // ── LEVEL 1 : Page KPIs ─────────────────────────────────────
    public Map<String, Object> getIntakePageKpis() {
        String sql = """
        SELECT
            COUNT(DISTINCT pm.batch_id)                                            AS totalBatches,
            COUNT(DISTINCT pm.user_name)                                           AS totalUsers,
            COUNT(DISTINCT pm.speaker_id)                                          AS totalSpeakers,
            COUNT(DISTINCT cm.language)                                            AS totalLanguages,
            ROUND(COALESCE(SUM(m.total_hours),  0) / 3600, 1)                      AS totalRawHours,
            ROUND(COALESCE(SUM(m.passed_hours), 0) / 3600, 1)                      AS totalCleanHours,
            SUM(CASE WHEN LOWER(pm.current_stage)='approved' THEN 1 ELSE 0 END)   AS approvedCount,
            SUM(CASE WHEN LOWER(pm.current_stage)='intake'   THEN 1 ELSE 0 END)   AS intakeCount
        FROM pipeline_master pm
        LEFT JOIN metrics      m  ON m.batch_id  = pm.batch_id
        LEFT JOIN chunk_master cm ON cm.batch_id = pm.batch_id
        """;

        // ✅ RowMapper gives exact camelCase keys
        return jdbc.queryForObject(sql, (rs, rowNum) -> {
            Map<String, Object> map = new LinkedHashMap<>();
            map.put("totalBatches",    rs.getInt("totalBatches"));
            map.put("totalUsers",      rs.getInt("totalUsers"));
            map.put("totalSpeakers",   rs.getInt("totalSpeakers"));
            map.put("totalLanguages",  rs.getInt("totalLanguages"));
            map.put("totalRawHours",   rs.getDouble("totalRawHours"));
            map.put("totalCleanHours", rs.getDouble("totalCleanHours"));
            map.put("approvedCount",   rs.getInt("approvedCount"));
            map.put("intakeCount",     rs.getInt("intakeCount"));
            return map;
        });
    }

    // ── LEVEL 1 : User summary cards ────────────────────────────
    public List<Map<String, Object>> getUserSummaries() {
        String sql = """
        SELECT
            pm.user_name                                                               AS userName,
            COUNT(DISTINCT pm.batch_id)                                                AS totalBatches,
            ROUND(COALESCE(SUM(m.total_hours),  0) / 3600, 1)                          AS totalRawHours,
            ROUND(COALESCE(SUM(m.passed_hours), 0) / 3600, 1)                          AS totalCleanHours,
            COALESCE(SUM(m.total_files),  0)                                          AS totalFiles,
            COALESCE(SUM(m.passed_files), 0)                                          AS passedFiles,
            COUNT(DISTINCT cm.language)                                                AS languages,
            COUNT(DISTINCT pm.speaker_id)                                              AS speakers,
            SUM(CASE WHEN LOWER(pm.current_stage)='approved' THEN 1 ELSE 0 END)       AS approvedBatches,
            SUM(CASE WHEN LOWER(pm.current_stage)='intake'   THEN 1 ELSE 0 END)       AS intakeBatches
        FROM pipeline_master pm
        LEFT JOIN metrics      m  ON m.batch_id  = pm.batch_id
        LEFT JOIN chunk_master cm ON cm.batch_id = pm.batch_id
        GROUP BY pm.user_name
        ORDER BY totalRawHours DESC
        """;

        // ✅ Use RowMapper to control exact key names — never rely on JDBC alias casing
        return jdbc.query(sql, (rs, rowNum) -> {
            Map<String, Object> map = new LinkedHashMap<>();
            map.put("userName",        rs.getString("userName"));
            map.put("totalBatches",    rs.getInt("totalBatches"));
            map.put("totalRawHours",   rs.getDouble("totalRawHours"));
            map.put("totalCleanHours", rs.getDouble("totalCleanHours"));
            map.put("totalFiles",      rs.getLong("totalFiles"));
            map.put("passedFiles",     rs.getLong("passedFiles"));
            map.put("languages",       rs.getInt("languages"));
            map.put("speakers",        rs.getInt("speakers"));
            map.put("approvedBatches", rs.getLong("approvedBatches"));
            map.put("intakeBatches",   rs.getLong("intakeBatches"));
            return map;
        });
    }

    // ── LEVEL 2 : Batches for a user ────────────────────────────
    public List<Map<String, Object>> getBatchesByUser(String userName) {
        String sql = """
            SELECT
                pm.batch_id                                                              AS batchId,
                pm.source_name                                                           AS sourceName,
                COALESCE(pm.source_type, '-')                                           AS sourceType,
                COALESCE(MAX(cm.language), '-')                                         AS language,
                pm.speaker_name                                                          AS speakerName,
                pm.speaker_gender                                                        AS speakerGender,
                LOWER(COALESCE(pm.current_stage, 'unknown'))                            AS currentStage,
                LOWER(COALESCE(pm.status, 'unknown'))                                   AS licenseStatus,
                ROUND(COALESCE(MAX(m.total_hours),  0) / 3600, 1)                       AS rawHours,
                ROUND(COALESCE(MAX(m.passed_hours), 0) / 3600, 1)                       AS cleanHours,
                COALESCE(MAX(m.total_files),  0)                                       AS totalFiles,
                COALESCE(MAX(m.passed_files), 0)                                       AS passedFiles,
                COALESCE(MAX(m.failed_files), 0)                                       AS failedFiles,
                CASE
                    WHEN COALESCE(MAX(m.total_files),0)=0 THEN 0
                    ELSE ROUND(COALESCE(MAX(m.passed_files),0)*100.0/COALESCE(MAX(m.total_files),1),1)
                END                                                                      AS passRate,
                DATE_FORMAT(pm.created_at, '%d-%b-%Y')                                 AS createdAt,
                DATE_FORMAT(pm.updated_at, '%d-%b-%Y')                                 AS updatedAt
            FROM pipeline_master pm
            LEFT JOIN metrics      m  ON m.batch_id  = pm.batch_id
            LEFT JOIN chunk_master cm ON cm.batch_id = pm.batch_id
            WHERE pm.user_name = ?
            GROUP BY
                pm.batch_id, pm.source_name, pm.source_type,
                pm.speaker_name, pm.speaker_gender,
                pm.current_stage, pm.status,
                pm.created_at, pm.updated_at
            ORDER BY pm.created_at DESC
            """;
        return jdbc.queryForList(sql, userName);
    }

    // ── LEVEL 3-A : Full batch header ───────────────────────────
    public Map<String, Object> getBatchDetail(String batchId) {
        String sql = """
            SELECT
                pm.batch_id, pm.user_name, pm.source_name, pm.source_type,
                pm.source_url, pm.speaker_id, pm.speaker_name, pm.speaker_gender,
                pm.current_stage, pm.status, pm.s3_prefix_path,
                DATE_FORMAT(pm.created_at, '%d-%b-%Y %H:%i') AS createdAt,
                DATE_FORMAT(pm.updated_at, '%d-%b-%Y %H:%i') AS updatedAt,
                COALESCE(m.total_files,                0)    AS totalFiles,
                COALESCE(m.passed_files,               0)    AS passedFiles,
                COALESCE(m.failed_files,               0)    AS failedFiles,
                ROUND(COALESCE(m.total_hours,  0) / 3600, 2)  AS totalHours,
                ROUND(COALESCE(m.passed_hours, 0) / 3600, 2)  AS passedHours,
                COALESCE(m.snr_fail_counter,           0)    AS snrFails,
                COALESCE(m.silence_ratio_fail_counter, 0)    AS silenceFails,
                COALESCE(m.clipping_fail_counter,      0)    AS clippingFails,
                COALESCE(m.speaker_sim_fail_counter,   0)    AS speakerSimFails,
                COALESCE(m.duplicate_fail_counter,     0)    AS duplicateFails,
                ic.snr                AS cfgSnr,
                ic.silence_ratio      AS cfgSilenceRatio,
                ic.clipping           AS cfgClipping,
                ic.speaker_similarity AS cfgSpeakerSimilarity,
                ic.sampling_rate      AS cfgSamplingRate,
                ic.duplication        AS cfgDuplication
            FROM pipeline_master pm
            LEFT JOIN metrics     m  ON m.batch_id  = pm.batch_id
            LEFT JOIN init_config ic ON ic.batch_id = pm.batch_id
            WHERE pm.batch_id = ?
            """;
        List<Map<String, Object>> rows = jdbc.queryForList(sql, batchId);
        return rows.isEmpty() ? new LinkedHashMap<>() : rows.get(0);
    }

    public List<Map<String, Object>> getChunksByBatchPaged(
            String batchId, int start, int length, String search,
            String orderCol, String orderDir) {

        // ✅ Maps DataTables column name → actual DB column (no aliases in ORDER BY)
        Map<String, String> colToSql = new LinkedHashMap<>();
        colToSql.put("chunk_id",          "cm.chunk_id");
        colToSql.put("video_id",          "cm.video_id");
        colToSql.put("startSec",          "cm.start_sec");        // alias → real col
        colToSql.put("endSec",            "cm.end_sec");
        colToSql.put("duration",          "cm.duration");
        colToSql.put("language",          "cm.language");
        colToSql.put("snrDb",             "cm.snr_db");
        colToSql.put("silenceRatio",      "cm.silence_ratio");
        colToSql.put("clippingRatio",     "cm.clipping_ratio");
        colToSql.put("speakerSimilarity", "cm.speaker_similarity");

        // Safe fallback — always a real column
        String orderSqlCol = colToSql.getOrDefault(orderCol, "cm.start_sec");

        // Safe direction
        String safeDir = "DESC".equalsIgnoreCase(orderDir) ? "DESC" : "ASC";

        List<Object> params = new ArrayList<>();
        params.add(batchId);

        // Optional search clause
        String searchClause = "";
        if (search != null && !search.isBlank()) {
            searchClause = "AND (cm.chunk_id LIKE ? OR cm.language LIKE ? OR cm.transcript LIKE ?) ";
            String like = "%" + search + "%";
            params.add(like);
            params.add(like);
            params.add(like);
        }

        params.add(length);
        params.add(start);

        // ✅ Plain String.format — no text block concatenation issues
        String sql = String.format(
                "SELECT " +
                        "  cm.chunk_id, " +
                        "  cm.video_id, " +
                        "  ROUND(cm.start_sec,          2) AS startSec, " +
                        "  ROUND(cm.end_sec,            2) AS endSec, " +
                        "  ROUND(cm.duration,           2) AS duration, " +
                        "  cm.language, " +
                        "  ROUND(cm.snr_db,             2) AS snrDb, " +
                        "  ROUND(cm.silence_ratio,      3) AS silenceRatio, " +
                        "  ROUND(cm.clipping_ratio,     3) AS clippingRatio, " +
                        "  ROUND(cm.speaker_similarity, 3) AS speakerSimilarity, " +
                        "  cm.duplicate, " +
                        "  cm.passed, " +
                        "  cm.qc_passed                     AS qcPassed, " +
                        "  COALESCE(cm.failure_reasons,    '-') AS failureReasons, " +
                        "  COALESCE(cm.qc_failure_reasons, '-') AS qcFailureReasons, " +
                        "  cm.transcript, " +
                        "  cm.audio_path                    AS audioPath, " +
                        "  DATE_FORMAT(cm.created_at, '%%d-%%b-%%Y %%H:%%i') AS createdAt " +
                        "FROM chunk_master cm " +
                        "WHERE cm.batch_id = ? " +
                        "%s" +                       // searchClause slot
                        "ORDER BY %s %s " +          // orderSqlCol + safeDir
                        "LIMIT ? OFFSET ?",
                searchClause, orderSqlCol, safeDir
        );

        return jdbc.query(sql, params.toArray(), (rs, rowNum) -> {
            Map<String, Object> map = new LinkedHashMap<>();
            map.put("chunk_id",          rs.getString("chunk_id"));
            map.put("video_id",          rs.getString("video_id"));
            map.put("startSec",          rs.getDouble("startSec"));
            map.put("endSec",            rs.getDouble("endSec"));
            map.put("duration",          rs.getDouble("duration"));
            map.put("language",          rs.getString("language"));
            map.put("snrDb",             rs.getDouble("snrDb"));
            map.put("silenceRatio",      rs.getDouble("silenceRatio"));
            map.put("clippingRatio",     rs.getDouble("clippingRatio"));
            map.put("speakerSimilarity", rs.getDouble("speakerSimilarity"));
            map.put("duplicate",         rs.getBoolean("duplicate"));
            map.put("passed",            rs.getBoolean("passed"));
            map.put("qcPassed",          rs.getBoolean("qcPassed"));
            map.put("failureReasons",    rs.getString("failureReasons"));
            map.put("qcFailureReasons",  rs.getString("qcFailureReasons"));
            map.put("transcript",        rs.getString("transcript"));
            map.put("audioPath",         rs.getString("audioPath"));
            map.put("createdAt",         rs.getString("createdAt"));
            return map;
        });
    }

    // ── LEVEL 3-B : Count for pagination ────────────────────────
    public int getChunkCount(String batchId, String search) {
        if (search != null && !search.isBlank()) {
            String sql = """
            SELECT COUNT(*) FROM chunk_master cm
            WHERE cm.batch_id = ?
            AND (cm.chunk_id LIKE ? OR cm.language LIKE ? OR cm.transcript LIKE ?)
            """;
            String like = "%" + search + "%";
            return jdbc.queryForObject(sql, Integer.class, batchId, like, like, like);
        }
        String sql = "SELECT COUNT(*) FROM chunk_master WHERE batch_id = ?";
        return jdbc.queryForObject(sql, Integer.class, batchId);
    }

    // ── LEVEL 3-C : Failure breakdown (bar chart) ───────────────
    public List<Map<String, Object>> getFailureBreakdown(String batchId) {
        String sql = """
            SELECT 'SNR'            AS reason, snr_fail_counter           AS failCount FROM metrics WHERE batch_id=?
            UNION ALL
            SELECT 'Silence Ratio',            silence_ratio_fail_counter             FROM metrics WHERE batch_id=?
            UNION ALL
            SELECT 'Clipping',                 clipping_fail_counter                  FROM metrics WHERE batch_id=?
            UNION ALL
            SELECT 'Speaker Sim.',             speaker_sim_fail_counter               FROM metrics WHERE batch_id=?
            UNION ALL
            SELECT 'Duplicate',                duplicate_fail_counter                 FROM metrics WHERE batch_id=?
            """;
        return jdbc.queryForList(sql, batchId, batchId, batchId, batchId, batchId);
    }

    // ── LEVEL 3-D : QC scoring (radar chart) ────────────────────
    public Map<String, Object> getQcScoring(String batchId) {
        String sql = """
            SELECT q1_score,q2_score,q3_score,q4_score,q5_score,q6_score,total_qc_score
            FROM qc_scoring WHERE batch_id = ?
            """;
        List<Map<String, Object>> rows = jdbc.queryForList(sql, batchId);
        return rows.isEmpty() ? new LinkedHashMap<>() : rows.get(0);
    }
}