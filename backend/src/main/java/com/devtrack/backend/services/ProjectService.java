package com.devtrack.backend.services;

import com.devtrack.backend.dto.ProjectRequestDTO;
import com.devtrack.backend.dto.ProjectResponseDTO;
import com.devtrack.backend.entities.Project;

import java.util.List;

public interface ProjectService {
    ProjectResponseDTO createProject(ProjectRequestDTO projectRequestDTO);

    ProjectResponseDTO getProjectById(Long id);

    List<ProjectResponseDTO> getAllProjects();

    ProjectResponseDTO updateProject(Long id, ProjectRequestDTO projectRequestDTO);

    void deleteProject(Long id);

}
