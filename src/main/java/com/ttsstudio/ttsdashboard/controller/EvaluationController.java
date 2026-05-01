package com.ttsstudio.ttsdashboard.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class EvaluationController {

    /**
     * Evaluation Benchmarks Dashboard
     * Shows MOS, WER, CER, latency and model grade results
     */
    @GetMapping("/evaluation")
    public String evaluation(Model model) {
        model.addAttribute("pageTitle",    "Evaluation Benchmarks");
        model.addAttribute("pageSubtitle", "MOS, WER, CER, latency and model grade results");
        model.addAttribute("activePage",   "evaluation");
        model.addAttribute("contentPage",  "/WEB-INF/views/content/evaluation-content.jsp");
        return "layout/base";
    }
}
