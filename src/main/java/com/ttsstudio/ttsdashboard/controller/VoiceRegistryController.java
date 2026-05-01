package com.ttsstudio.ttsdashboard.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class VoiceRegistryController {

    /**
     * Voice Registry Dashboard
     * Shows production voice inventory and deployment status
     */
    @GetMapping("/voices")
    public String voiceRegistry(Model model) {
        model.addAttribute("pageTitle",    "Voice Registry");
        model.addAttribute("pageSubtitle", "Production voice inventory and deployment status");
        model.addAttribute("activePage",   "voices");
        model.addAttribute("contentPage",  "/WEB-INF/views/content/voice-registry-content.jsp");
        return "layout/base";
    }
}
