package com.ttsstudio.ttsdashboard.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class QualityController {

    /**
     * QC & Data Quality Dashboard
     * Shows audio clip validation, noise analysis and quality metrics
     */
    @GetMapping("/qc")
    public String qcDashboard(Model model) {
        model.addAttribute("pageTitle",    "QC & Data Quality");
        model.addAttribute("pageSubtitle", "Audio clip validation, noise analysis and quality metrics");
        model.addAttribute("activePage",   "qc");
        model.addAttribute("contentPage",  "/WEB-INF/views/content/qc-content.jsp");
        return "layout/base";
    }

    /**
     * Manual QC Review Dashboard
     * Human reviewers score batches of audio clips against 6 weighted criteria
     */
    @GetMapping("/manual-qc")
    public String manualQcDashboard(Model model) {
        model.addAttribute("pageTitle",    "Manual QC Review");
        model.addAttribute("pageSubtitle", "Batch-level human evaluation — pronunciation, accuracy, tone, pacing");
        model.addAttribute("activePage",   "manual-qc");
        model.addAttribute("contentPage",  "/WEB-INF/views/content/manual-qc-content.jsp");
        return "layout/base";
    }
}
