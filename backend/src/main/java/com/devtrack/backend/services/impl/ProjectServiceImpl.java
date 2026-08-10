package com.devtrack.backend.services.impl;

import com.devtrack.backend.dto.ProjectRequestDTO;
import com.devtrack.backend.dto.ProjectResponseDTO;
import com.devtrack.backend.dto.TaskResponseDTO;
import com.devtrack.backend.entities.Project;
import com.devtrack.backend.entities.Tag;
import com.devtrack.backend.entities.Task;
import com.devtrack.backend.models.DevtrackApiException;
import com.devtrack.backend.repos.ProjectRepository;
import com.devtrack.backend.services.ProjectService;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class ProjectServiceImpl implements ProjectService {
    private final ProjectRepository projectRepository;

    public ProjectServiceImpl(ProjectRepository projectRepository) {
        this.projectRepository = projectRepository;
    }

    //conversion function
    private ProjectResponseDTO convertToResponseDTO(Project project) {

        return new TaskResponseDTO(
                project.getId(),
                project.getDescription(),
                project.getGithubUrl(),
                project.getName(),
        );
    }

    @Override
    public ProjectResponseDTO createProject(ProjectRequestDTO projectRequestDTO) {
        return projectRepository.save(project);
    }

    @Override
    public ProjectResponseDTO getProjectById(Long id) {
        return projectRepository.findById(id)
                .orElseThrow(()-> new DevtrackApiException(HttpStatus.BAD_REQUEST, "Project not found"));
    }

    @Override
    public List<ProjectResponseDTO> getAllProjects() {
        return projectRepository.findAll();
    }

    @Override
    public ProjectResponseDTO updateProject(Long id, ProjectRequestDTO projectRequestDTO) {
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
