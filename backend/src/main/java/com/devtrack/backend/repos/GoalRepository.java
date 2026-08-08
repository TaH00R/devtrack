package com.devtrack.backend.repos;

import com.devtrack.backend.entities.Goal;
import org.springframework.data.jpa.repository.JpaRepository;

public interface GoalRepository extends JpaRepository<Goal, Long> {
}