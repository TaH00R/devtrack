package com.devtrack.backend.services.impl;

import com.devtrack.backend.entities.Project;
import com.devtrack.backend.models.DevtrackApiException;
import com.devtrack.backend.repos.ProjectRepository;
import com.devtrack.backend.services.ProjectService;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ProjectServiceImpl implements ProjectService {
    private final ProjectRepository projectRepository;

    public ProjectServiceImpl(ProjectRepository projectRepository) {
        this.projectRepository = projectRepository;
    }

    @Override
    public Project createProject(Project project) {
        return projectRepository.save(project);
    }

    @Override
    public Project getProjectById(Long id) {
        return projectRepository.findById(id)
                .orElseThrow(()-> new DevtrackApiException(HttpStatus.BAD_REQUEST, "Project not found"));
    }

    @Override
    public List<Project> getAllProjects() {
        return projectRepository.findAll();
    }

    @Override
    public Project updateProject(Long id, Project project) {
        Project existingProject = projectRepository.findById(id)
                .orElseThrow(()-> new DevtrackApiException(HttpStatus.BAD_REQUEST, "Project not found"));

        existingProject.setName(project.getName());
        existingProject.setDescription(project.getDescription());
        existingProject.setGithubUrl(project.getGithubUrl());

        return projectRepository.save(existingProject);
    }

    @Override
    public void deleteProject(Long id) {
        projectRepository.deleteById(id);
    }
}
