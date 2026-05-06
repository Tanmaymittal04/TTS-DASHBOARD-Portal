package com.ttsstudio.ttsdashboard.repository;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Repository
public class TtsDashboardRepository {

    private final JdbcTemplate jdbcTemplate;

    public TtsDashboardRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    // ── 1. KPI Summary ─────────────────────────────────────────────────────────
    public Map<String, Object> getDatasetIntakeKpis() {
        String sql = """
            SELECT
                COUNT(DISTINCT pm.batch_id)                                          AS totalDatasets,
                ROUND(COALESCE(SUM(m.total_hours), 0), 1)                           AS totalRawHours,
                SUM(CASE WHEN LOWER(pm.status) = 'approved'  THEN 1 ELSE 0 END)    AS licenseApproved,
                SUM(CASE WHEN LOWER(pm.status) = 'pending'   THEN 1 ELSE 0 END)    AS licensePending,
                SUM(CASE WHEN LOWER(pm.status) = 'rejected'  THEN 1 ELSE 0 END)    AS rejected,
                COUNT(DISTINCT cm.language)                                          AS totalLanguages
            FROM pipeline_master pm
            LEFT JOIN metrics m       ON m.batch_id  = pm.batch_id
            LEFT JOIN chunk_master cm ON cm.batch_id = pm.batch_id
            """;

        return jdbcTemplate.queryForObject(sql, (rs, rowNum) -> {
            Map<String, Object> map = new LinkedHashMap<>();
            map.put("totalDatasets",   rs.getInt("totalDatasets"));
            map.put("totalRawHours",   rs.getDouble("totalRawHours"));
            map.put("licenseApproved", rs.getInt("licenseApproved"));
            map.put("licensePending",  rs.getInt("licensePending"));
            map.put("rejected",        rs.getInt("rejected"));
            map.put("totalLanguages",  rs.getInt("totalLanguages"));
            return map;
        });
    }

    // ── 2. Source Type Distribution ────────────────────────────────────────────
    // FIX: GROUP BY must use the exact same expression as SELECT
    public List<Map<String, Object>> getSourceTypeDistribution() {
        String sql = """
            SELECT
                LOWER(COALESCE(source_type, 'unknown')) AS label,
                COUNT(*) AS value
            FROM pipeline_master
            GROUP BY LOWER(COALESCE(source_type, 'unknown'))
            ORDER BY value DESC
            """;

        return jdbcTemplate.queryForList(sql);
    }

    // ── 3. Raw vs Clean Hours by Language ─────────────────────────────────────
    // No LOWER() on GROUP BY column — cm.language is already the raw value, safe
    public List<Map<String, Object>> getRawVsCleanByLanguage() {
        String sql = """
            SELECT
                cm.language AS label,
                ROUND(COALESCE(SUM(m.total_hours),  0), 1) AS rawHours,
                ROUND(COALESCE(SUM(m.passed_hours), 0), 1) AS cleanHours
            FROM pipeline_master pm
            LEFT JOIN metrics m       ON m.batch_id  = pm.batch_id
            LEFT JOIN chunk_master cm ON cm.batch_id = pm.batch_id
            WHERE cm.language IS NOT NULL
              AND cm.language <> ''
            GROUP BY cm.language
            ORDER BY cm.language
            """;

        return jdbcTemplate.queryForList(sql);
    }

    // ── 4. License Status Breakdown ────────────────────────────────────────────
    // FIX: GROUP BY LOWER(COALESCE(...)) must match SELECT expression exactly
    public List<Map<String, Object>> getLicenseStatusBreakdown() {
        String sql = """
            SELECT
                LOWER(COALESCE(status, 'unknown')) AS label,
                COUNT(*) AS value
            FROM pipeline_master
            GROUP BY LOWER(COALESCE(status, 'unknown'))
            ORDER BY value DESC
            """;

        return jdbcTemplate.queryForList(sql);
    }

    // ── 5. Speaker Count by Language ──────────────────────────────────────────
    // Safe — GROUP BY cm.language matches SELECT cm.language
    public List<Map<String, Object>> getSpeakerCountByLanguage() {
        String sql = """
            SELECT
                cm.language AS label,
                COUNT(DISTINCT pm.speaker_id) AS value
            FROM pipeline_master pm
            LEFT JOIN chunk_master cm ON cm.batch_id = pm.batch_id
            WHERE cm.language IS NOT NULL
              AND cm.language <> ''
            GROUP BY cm.language
            ORDER BY cm.language
            """;

        return jdbcTemplate.queryForList(sql);
    }

    // ── 6. Clean Yield % by Language ──────────────────────────────────────────
    // Safe — inner subquery groups by cm.language, outer selects from alias x
    public List<Map<String, Object>> getCleanYieldByLanguage() {
        String sql = """
            SELECT
                x.label,
                x.rawHours,
                x.cleanHours,
                CASE
                    WHEN x.rawHours = 0 THEN 0
                    ELSE ROUND((x.cleanHours / x.rawHours) * 100, 1)
                END AS yieldPct
            FROM (
                SELECT
                    cm.language AS label,
                    ROUND(COALESCE(SUM(m.total_hours),  0), 1) AS rawHours,
                    ROUND(COALESCE(SUM(m.passed_hours), 0), 1) AS cleanHours
                FROM pipeline_master pm
                LEFT JOIN metrics m       ON m.batch_id  = pm.batch_id
                LEFT JOIN chunk_master cm ON cm.batch_id = pm.batch_id
                WHERE cm.language IS NOT NULL
                  AND cm.language <> ''
                GROUP BY cm.language
            ) x
            ORDER BY x.label
            """;

        return jdbcTemplate.queryForList(sql);
    }

    // ── 7. Pipeline Stage Distribution ────────────────────────────────────────
    // FIX: GROUP BY LOWER(COALESCE(...)) must match SELECT expression exactly
    public List<Map<String, Object>> getPipelineStageDistribution() {
        String sql = """
            SELECT
                LOWER(COALESCE(current_stage, 'unknown')) AS label,
                COUNT(*) AS value
            FROM pipeline_master
            GROUP BY LOWER(COALESCE(current_stage, 'unknown'))
            ORDER BY value DESC
            """;

        return jdbcTemplate.queryForList(sql);
    }

    // ── 8. Dataset Registry Table Rows ────────────────────────────────────────
    // FIX: All non-aggregated SELECT expressions must appear in GROUP BY.
    // LOWER(COALESCE(pm.status,...)) and LOWER(COALESCE(pm.current_stage,...))
    // are derived — wrap raw columns in GROUP BY to stay ONLY_FULL_GROUP_BY safe.
    public List<Map<String, Object>> getDatasetRegistryRows() {
        String sql = """
            SELECT
                pm.batch_id                                         AS id,
                pm.source_name                                      AS name,
                COALESCE(MAX(cm.language), '-')                     AS language,
                '-'                                                 AS accent,
                COALESCE(pm.source_type, '-')                       AS source,
                ROUND(COALESCE(MAX(m.total_hours),  0), 1)         AS rawHours,
                ROUND(COALESCE(MAX(m.passed_hours), 0), 1)         AS cleanHours,
                COALESCE(MAX(m.total_files), 0)                    AS clips,
                COUNT(DISTINCT pm.speaker_id)                       AS speakers,
                LOWER(COALESCE(pm.status, 'unknown'))               AS license,
                LOWER(COALESCE(pm.current_stage, 'unknown'))        AS status,
                COALESCE(pm.user_name, '-')                         AS assignedTo
            FROM pipeline_master pm
            LEFT JOIN metrics m       ON m.batch_id  = pm.batch_id
            LEFT JOIN chunk_master cm ON cm.batch_id = pm.batch_id
            GROUP BY
                pm.batch_id,
                pm.source_name,
                pm.source_type,
                pm.status,
                pm.current_stage,
                pm.user_name
            ORDER BY pm.created_at DESC
            """;

        return jdbcTemplate.queryForList(sql);
    }
}