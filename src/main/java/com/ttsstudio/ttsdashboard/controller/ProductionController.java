package com.ttsstudio.ttsdashboard.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class ProductionController {

    /**
     * Production Monitor Dashboard
     * Shows live TTS request volume, latency and failure tracking
     */
    @GetMapping("/production")
    public String production(Model model) {
        model.addAttribute("pageTitle",    "Production Monitor");
        model.addAttribute("pageSubtitle", "Live TTS request volume, latency and failure tracking");
        model.addAttribute("activePage",   "production");
        model.addAttribute("contentPage",  "/WEB-INF/views/content/production-content.jsp");
        return "layout/base";
    }
}
