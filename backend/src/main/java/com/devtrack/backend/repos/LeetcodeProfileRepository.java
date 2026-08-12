package com.devtrack.backend.repos;

import com.devtrack.backend.entities.LeetcodeProfile;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface LeetcodeProfileRepository extends JpaRepository<LeetcodeProfile, Long> {

    List<LeetcodeProfile> findAllByUserId(Long userId);
}