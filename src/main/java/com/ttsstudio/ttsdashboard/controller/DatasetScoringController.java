package com.ttsstudio.ttsdashboard.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class DatasetScoringController {

    /**
     * Dataset Scoring Dashboard
     * Shows training readiness scores and approval gating
     */
    @GetMapping("/scoring")
    public String scoring(Model model) {
        model.addAttribute("pageTitle",    "Dataset Scoring");
        model.addAttribute("pageSubtitle", "Training readiness scores and approval gating");
        model.addAttribute("activePage",   "scoring");
        model.addAttribute("contentPage",  "/WEB-INF/views/content/scoring-content.jsp");
        return "layout/base";
    }
}
