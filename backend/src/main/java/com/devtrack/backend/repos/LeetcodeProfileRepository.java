package com.devtrack.backend.repos;

import com.devtrack.backend.entities.LeetcodeProfile;
import org.springframework.data.jpa.repository.JpaRepository;

public interface LeetcodeProfileRepository extends JpaRepository<LeetcodeProfile, Long> {
}