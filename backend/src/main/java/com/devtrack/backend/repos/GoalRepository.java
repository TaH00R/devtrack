package com.devtrack.backend.repos;

import com.devtrack.backend.entities.Goal;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface GoalRepository extends JpaRepository<Goal, Long> {
    List<Goal> findAllByUserId(Long userId);
}