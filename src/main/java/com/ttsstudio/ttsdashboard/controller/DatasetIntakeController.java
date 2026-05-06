package com.ttsstudio.ttsdashboard.controller;

import com.ttsstudio.ttsdashboard.repository.DatasetIntakeRepository;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import java.util.*;

@Controller
@RequestMapping("/datasets")
public class DatasetIntakeController {

    private final DatasetIntakeRepository repo;

    public DatasetIntakeController(DatasetIntakeRepository repo) {
        this.repo = repo;
    }

    // GET /dataset-intake  →  full page
    @GetMapping
    public String intakePage(Model model) {
        model.addAttribute("pageTitle",     "Dataset Intake");
        model.addAttribute("activeMenu",    "dataset-intake");
        model.addAttribute("contentPage",   "/WEB-INF/views/content/dataset-intake-content.jsp");
        model.addAttribute("kpis",          repo.getIntakePageKpis());
        model.addAttribute("userSummaries", repo.getUserSummaries());
        return "layout/base";
    }

    // AJAX — batch table for a user
    @GetMapping("/batches")
    @ResponseBody
    public List<Map<String, Object>> batches(@RequestParam String userName) {
        System.out.println("[DEBUG] userName received: '" + userName + "'");
        return repo.getBatchesByUser(userName);
    }

    // AJAX — full batch detail + init_config + metrics
    @GetMapping("/batch-detail")
    @ResponseBody
    public Map<String, Object> batchDetail(@RequestParam String batchId) {
        return repo.getBatchDetail(batchId);
    }

    // AJAX — all chunks in a batch
    @GetMapping("/chunks")
    @ResponseBody
    public Map<String, Object> chunks(
            @RequestParam String batchId,
            @RequestParam(defaultValue = "1")  int    draw,
            @RequestParam(defaultValue = "0")  int    start,
            @RequestParam(defaultValue = "25") int    length,
            @RequestParam(name = "search[value]", defaultValue = "") String search,
            @RequestParam(name = "order[0][column]", defaultValue = "2") int orderColIdx,
            @RequestParam(name = "order[0][dir]",    defaultValue = "asc") String orderDir) {

        // Map DataTables column index → SQL alias
        String[] colMap = {
                "chunk_id","video_id","startSec","endSec","duration",
                "language","snrDb","silenceRatio","clippingRatio","speakerSimilarity",
                "duplicate","passed","qcPassed","failureReasons","transcript"
        };
        String orderCol = (orderColIdx >= 0 && orderColIdx < colMap.length)
                ? colMap[orderColIdx] : "startSec";

        int    total    = repo.getChunkCount(batchId, null);
        int    filtered = repo.getChunkCount(batchId, search);
        List<Map<String, Object>> data = repo.getChunksByBatchPaged(
                batchId, start, length, search, orderCol, orderDir.toUpperCase()
        );

        Map<String, Object> response = new LinkedHashMap<>();
        response.put("draw",            draw);
        response.put("recordsTotal",    total);
        response.put("recordsFiltered", filtered);
        response.put("data",            data);
        return response;
    }

    // AJAX — failure breakdown for bar chart
    @GetMapping("/failures")
    @ResponseBody
    public List<Map<String, Object>> failures(@RequestParam String batchId) {
        return repo.getFailureBreakdown(batchId);
    }

    // AJAX — QC radar data
    @GetMapping("/qc-score")
    @ResponseBody
    public Map<String, Object> qcScore(@RequestParam String batchId) {
        return repo.getQcScoring(batchId);
    }
}