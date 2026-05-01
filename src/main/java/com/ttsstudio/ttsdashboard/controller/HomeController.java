package com.ttsstudio.ttsdashboard.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    /**
     * Redirect root URL → Executive Overview
     */
    @GetMapping("/")
    public String root() {
        return "redirect:/overview";
    }

    /**
     * Executive Overview Dashboard
     */
    @GetMapping("/overview")
    public String overview(Model model) {
        model.addAttribute("pageTitle",    "Executive Overview");
        model.addAttribute("pageSubtitle", "Full TTS pipeline health at a glance");
        model.addAttribute("activePage",   "overview");
        model.addAttribute("contentPage",  "/WEB-INF/views/content/overview-content.jsp");
        return "layout/base";
    }
}
