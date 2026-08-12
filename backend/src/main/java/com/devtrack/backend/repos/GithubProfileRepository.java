package com.devtrack.backend.repos;

import com.devtrack.backend.entities.GithubProfile;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface GithubProfileRepository extends JpaRepository<GithubProfile, Long> {

    List<GithubProfile> findAllByUserId(Long userId);
}