package com.devtrack.backend.repos;

import com.devtrack.backend.entities.GithubProfile;
import org.springframework.data.jpa.repository.JpaRepository;

public interface GithubProfileRepository extends JpaRepository<GithubProfile, Long> {
}