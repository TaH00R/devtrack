package com.devtrack.backend.services;

import com.devtrack.backend.entities.Goal;

import java.util.List;

public interface GoalService {
    Goal createGoal(Goal goal);

    Goal getGoalById(Long id);

    List<Goal> getAllGoals();

    Goal updateGoal(Long id, Goal goal);

    void deleteGoal(Long id);
}
