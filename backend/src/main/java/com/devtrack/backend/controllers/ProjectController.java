package com.devtrack.backend.controllers;


import com.devtrack.backend.dto.ProjectRequestDTO;
import com.devtrack.backend.dto.ProjectResponseDTO;
import com.devtrack.backend.services.ProjectService;
import jakarta.validation.Valid;
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
    public ProjectResponseDTO createProject(
           @Valid @RequestBody ProjectRequestDTO projectRequestDTO
    ) {
        return projectService.createProject(projectRequestDTO);
    }
    
    @GetMapping("/{id}")
    public  ProjectResponseDTO getProject(@PathVariable Long id) {
        return  projectService.getProjectById(id);
    }

    @GetMapping
    public List<ProjectResponseDTO> getAllProjects() {
        return projectService.getAllProjects();
    }

    @PatchMapping("/{id}")
    public  ProjectResponseDTO updateProject(
            @PathVariable Long id,
            @Valid @RequestBody ProjectRequestDTO projectRequestDTO) {
        return  projectService.updateProject(id, projectRequestDTO);
    }

    @DeleteMapping("/{id}")
    public void deleteProject(@PathVariable Long id) {
        projectService.deleteProject(id);
    }
}
