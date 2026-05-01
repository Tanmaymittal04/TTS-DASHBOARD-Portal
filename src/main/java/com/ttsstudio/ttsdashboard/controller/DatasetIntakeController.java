package com.ttsstudio.ttsdashboard.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class DatasetIntakeController {

    /**
     * Dataset Intake Dashboard
     * Shows dataset sourcing, language coverage, license tracking
     */
    @GetMapping("/datasets")
    public String datasetIntake(Model model) {
        model.addAttribute("pageTitle",    "Dataset Intake");
        model.addAttribute("pageSubtitle", "Dataset sourcing, language coverage and license tracking");
        model.addAttribute("activePage",   "datasets");
        model.addAttribute("contentPage",  "/WEB-INF/views/content/dataset-intake-content.jsp");
        return "layout/base";
    }
}