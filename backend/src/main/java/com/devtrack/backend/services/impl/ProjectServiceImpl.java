package com.devtrack.backend.services.impl;

import com.devtrack.backend.dto.ProjectRequestDTO;
import com.devtrack.backend.dto.ProjectResponseDTO;
import com.devtrack.backend.entities.Project;
import com.devtrack.backend.entities.User;
import com.devtrack.backend.models.DevtrackApiException;
import com.devtrack.backend.repos.ProjectRepository;
import com.devtrack.backend.repos.UserRepository;
import com.devtrack.backend.services.ProjectService;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ProjectServiceImpl implements ProjectService {

    private final ProjectRepository projectRepository;
    private final UserRepository userRepository;

    public ProjectServiceImpl(
            ProjectRepository projectRepository,
            UserRepository userRepository
    ) {
        this.projectRepository = projectRepository;
        this.userRepository = userRepository;
    }

    private ProjectResponseDTO convertToResponseDTO(Project project) {

        return new ProjectResponseDTO(
                project.getId(),
                project.getName(),
                project.getDescription(),
                project.getGithubUrl(),
                project.getUser().getId()
        );
    }

    @Override
    public ProjectResponseDTO createProject(
            ProjectRequestDTO projectRequestDTO
    ) {

        Project project = new Project();

        project.setName(projectRequestDTO.getName());
        project.setDescription(projectRequestDTO.getDescription());
        project.setGithubUrl(projectRequestDTO.getGithubUrl());

        User user = userRepository.findById(
                projectRequestDTO.getUserId()
        ).orElseThrow(() ->
                new DevtrackApiException(
                        HttpStatus.BAD_REQUEST,
                        "User not found"
                )
        );

        project.setUser(user);

        Project savedProject = projectRepository.save(project);

        return convertToResponseDTO(savedProject);
    }

    @Override
    public ProjectResponseDTO getProjectById(Long id) {

        Project project = projectRepository.findById(id)
                .orElseThrow(() ->
                        new DevtrackApiException(
                                HttpStatus.BAD_REQUEST,
                                "Project not found"
                        )
                );

        return convertToResponseDTO(project);
    }

    @Override
    public List<ProjectResponseDTO> getAllProjects() {

        return projectRepository.findAll()
                .stream()
                .map(this::convertToResponseDTO)
                .toList();
    }

    @Override
    public ProjectResponseDTO updateProject(
            Long id,
            ProjectRequestDTO projectRequestDTO
    ) {

        Project existingProject = projectRepository.findById(id)
                .orElseThrow(() ->
                        new DevtrackApiException(
                                HttpStatus.BAD_REQUEST,
                                "Project not found"
                        )
                );

        existingProject.setName(projectRequestDTO.getName());
        existingProject.setDescription(projectRequestDTO.getDescription());
        existingProject.setGithubUrl(projectRequestDTO.getGithubUrl());

        User user = userRepository.findById(
                projectRequestDTO.getUserId()
        ).orElseThrow(() ->
                new DevtrackApiException(
                        HttpStatus.BAD_REQUEST,
                        "User not found"
                )
        );

        existingProject.setUser(user);

        Project updatedProject = projectRepository.save(existingProject);

        return convertToResponseDTO(updatedProject);
    }

    @Override
    public void deleteProject(Long id) {

        Project project = projectRepository.findById(id)
                .orElseThrow(() ->
                        new DevtrackApiException(
                                HttpStatus.BAD_REQUEST,
                                "Project not found"
                        )
                );

        projectRepository.delete(project);
    }
}