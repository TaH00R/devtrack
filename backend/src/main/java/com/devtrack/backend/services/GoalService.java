package com.devtrack.backend.services;

import com.devtrack.backend.dto.GoalRequestDTO;
import com.devtrack.backend.dto.GoalResponseDTO;
import com.devtrack.backend.entities.Goal;

import java.util.List;

public interface GoalService {
    GoalResponseDTO createGoal(GoalRequestDTO goalRequestDTO);

    GoalResponseDTO getGoalById(Long id);

    List<GoalResponseDTO> getAllGoals();

    GoalResponseDTO updateGoal(Long id, GoalRequestDTO goalRequestDTO);

    void deleteGoal(Long id);
}
