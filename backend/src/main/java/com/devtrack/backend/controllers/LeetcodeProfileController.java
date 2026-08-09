package com.devtrack.backend.controllers;


import com.devtrack.backend.entities.LeetcodeProfile;
import com.devtrack.backend.services.LeetcodeProfileService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/leetcode-profile")
public class LeetcodeProfileController {
    private final LeetcodeProfileService leetcodeProfileService;

    public LeetcodeProfileController(LeetcodeProfileService leetcodeProfileService) {
        this.leetcodeProfileService = leetcodeProfileService;
    }

    @PostMapping
    public LeetcodeProfile createLeetcodeProfile(@RequestBody LeetcodeProfile leetcodeProfile) {
        return  leetcodeProfileService.createLeetcodeProfile(leetcodeProfile);
    }

    @GetMapping
    public List<LeetcodeProfile> getAllLeetcodeProfiles() {
        return  leetcodeProfileService.getAllLeetcodeProfiles();
    }

    @GetMapping("/{id}")
    public  LeetcodeProfile getLeetcodeProfileById(@PathVariable Long id) {
        return  leetcodeProfileService.getLeetcodeProfileById(id);
    }

    @PatchMapping("/{id}")
    public LeetcodeProfile updateLeetcodeProfile(@PathVariable Long id, @RequestBody LeetcodeProfile updatedLeetcodeProfile) {
        return   leetcodeProfileService.updateLeetcodeProfile(id, updatedLeetcodeProfile);
    }

    @DeleteMapping("/{id}")
    public  void deleteLeetcodeProfile(@PathVariable Long id) {
        leetcodeProfileService.deleteLeetcodeProfile(id);
    }
}
