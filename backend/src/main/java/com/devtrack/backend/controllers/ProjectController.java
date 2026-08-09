package com.devtrack.backend.controllers;


import com.devtrack.backend.entities.Project;
import com.devtrack.backend.services.ProjectService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/projects")
public class ProjectController {
    private final ProjectService projectService;

    public ProjectController(ProjectService projectService) {
        this.projectService = projectService;
    }

    @PostMapping
    public Project createProject(@RequestBody Project project) {
        return projectService.createProject(project);
    }
    
    @GetMapping("/{id}")
    public  Project getProject(@PathVariable Long id) {
        return  projectService.getProjectById(id);
    }

    @GetMapping
    public List<Project> getAllProjects() {
        return projectService.getAllProjects();
    }

    @PatchMapping("/{id}")
    public  Project updateProject(@PathVariable Long id, @RequestBody Project project) {
        return  projectService.updateProject(id, project);
    }

    @DeleteMapping("/{id}")
    public void deleteProject(@PathVariable Long id) {
        projectService.deleteProject(id);
    }
}
