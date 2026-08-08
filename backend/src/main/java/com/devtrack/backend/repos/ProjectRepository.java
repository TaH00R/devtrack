package com.devtrack.backend.repos;

import com.devtrack.backend.entities.Project;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ProjectRepository extends JpaRepository<Project, Long> {
}