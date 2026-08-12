package com.devtrack.backend.services.impl;

import com.devtrack.backend.dto.ProjectRequestDTO;
import com.devtrack.backend.dto.ProjectResponseDTO;
import com.devtrack.backend.entities.Project;
import com.devtrack.backend.entities.User;
import com.devtrack.backend.models.DevtrackApiException;
import com.devtrack.backend.repos.ProjectRepository;
import com.devtrack.backend.security.CustomUserDetails;
import com.devtrack.backend.services.ProjectService;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ProjectServiceImpl implements ProjectService {

    private final ProjectRepository projectRepository;

    public ProjectServiceImpl(ProjectRepository projectRepository) {
        this.projectRepository = projectRepository;
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

    private User getCurrentUser() {

        Authentication authentication =
                SecurityContextHolder.getContext().getAuthentication();

        CustomUserDetails userDetails =
                (CustomUserDetails) authentication.getPrincipal();

        return userDetails.getUser();
    }

    @Override
    public ProjectResponseDTO createProject(
            ProjectRequestDTO projectRequestDTO
    ) {

        Project project = new Project();

        project.setName(projectRequestDTO.getName());
        project.setDescription(projectRequestDTO.getDescription());
        project.setGithubUrl(projectRequestDTO.getGithubUrl());

        User currentUser = getCurrentUser();

        project.setUser(currentUser);

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

        User currentUser = getCurrentUser();

        if (!project.getUser().getId().equals(currentUser.getId())) {
            throw new DevtrackApiException(
                    HttpStatus.FORBIDDEN,
                    "You do not have access to this project"
            );
        }

        return convertToResponseDTO(project);
    }

    @Override
    public List<ProjectResponseDTO> getAllProjects() {

        User currentUser = getCurrentUser();

        return projectRepository.findAllByUserId(currentUser.getId())
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

        User currentUser = getCurrentUser();

        if (!existingProject.getUser().getId().equals(currentUser.getId())) {
            throw new DevtrackApiException(
                    HttpStatus.FORBIDDEN,
                    "You do not have access to this project"
            );
        }

        existingProject.setName(projectRequestDTO.getName());
        existingProject.setDescription(projectRequestDTO.getDescription());
        existingProject.setGithubUrl(projectRequestDTO.getGithubUrl());

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

        User currentUser = getCurrentUser();

        if (!project.getUser().getId().equals(currentUser.getId())) {
            throw new DevtrackApiException(
                    HttpStatus.FORBIDDEN,
                    "You do not have access to this project"
            );
        }

        projectRepository.delete(project);
    }
}