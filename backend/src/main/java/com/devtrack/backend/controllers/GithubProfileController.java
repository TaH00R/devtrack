package com.devtrack.backend.controllers;

import com.devtrack.backend.entities.GithubProfile;
import com.devtrack.backend.services.GithubProfileService;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@RestController
@RequestMapping("/api/github-profile")
public class GithubProfileController {
    private final GithubProfileService githubProfileService;

    public GithubProfileController(GithubProfileService githubProfileService) {
        this.githubProfileService = githubProfileService;
    }

    @PostMapping
    public GithubProfile createGithubProfile(@RequestBody GithubProfile profile) {
        return  githubProfileService.createGithubProfile(profile);
    }

    @GetMapping
    public List<GithubProfile> getAllGithubProfiles() {
        return  githubProfileService.getAllGithubProfiles();
    }

    @GetMapping("/{id}")
    public  GithubProfile getGithubProfileById(@PathVariable Long id) {
        return   githubProfileService.getGithubProfileById(id);
    }

    @PatchMapping("/{id}")
    public GithubProfile updateGithubProfile(@PathVariable Long id, @RequestBody GithubProfile profile) {
        return   githubProfileService.updateGithubProfile(id, profile);
    }

    @DeleteMapping("/{id}")
    public  void deleteGithubProfile(@PathVariable Long id) {
        githubProfileService.deleteGithubProfile(id);
    }
}
