package com.ttsstudio.ttsdashboard.controller;

import com.ttsstudio.ttsdashboard.repository.TtsDashboardRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequiredArgsConstructor
public class DatasetIntakeApiController {

    private final TtsDashboardRepository repo;

    @GetMapping("/api/datasets/overview")
    public Map<String, Object> overview() {
        Map<String, Object> response = new LinkedHashMap<>();
        response.put("kpis", repo.getDatasetIntakeKpis());
        response.put("sourceDistribution", repo.getSourceTypeDistribution());
        response.put("rawVsCleanByLanguage", repo.getRawVsCleanByLanguage());
        response.put("licenseStatus", repo.getLicenseStatusBreakdown());
        response.put("speakerCountByLanguage", repo.getSpeakerCountByLanguage());
        response.put("cleanYieldByLanguage", repo.getCleanYieldByLanguage());
        response.put("pipelineStageDistribution", repo.getPipelineStageDistribution());
        response.put("tableRows", repo.getDatasetRegistryRows());
        response.put("timestamp", System.currentTimeMillis());
        return response;
    }
}