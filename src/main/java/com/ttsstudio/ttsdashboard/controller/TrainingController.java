package com.ttsstudio.ttsdashboard.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class TrainingController {

    /**
     * Training Jobs Dashboard
     * Shows XTTS fine-tuning runs, loss curves and GPU utilization
     */
    @GetMapping("/training")
    public String training(Model model) {
        model.addAttribute("pageTitle",    "Training Jobs");
        model.addAttribute("pageSubtitle", "XTTS fine-tuning runs, loss curves and GPU utilization");
        model.addAttribute("activePage",   "training");
        model.addAttribute("contentPage",  "/WEB-INF/views/content/training-content.jsp");
        return "layout/base";
    }
}
