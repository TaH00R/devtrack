package com.devtrack.backend.services.impl;

import com.devtrack.backend.entities.Goal;
import com.devtrack.backend.models.DevtrackApiException;
import com.devtrack.backend.repos.GoalRepository;
import com.devtrack.backend.services.GoalService;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class GoalServiceImpl implements GoalService {
    private final GoalRepository goalRepository;

    public GoalServiceImpl(GoalRepository goalRepository) {
        this.goalRepository = goalRepository;
    }

    @Override
    public Goal createGoal(Goal goal) {
        return goalRepository.save(goal);
    }

    @Override
    public Goal getGoalById(Long id) {
        return goalRepository.findById(id).
                orElseThrow(()->new DevtrackApiException(HttpStatus.BAD_REQUEST, "Goal Not Found"));
    }

    @Override
    public List<Goal> getAllGoals() {
        return goalRepository.findAll();
    }

    @Override
    public Goal updateGoal(Long id, Goal goal) {
        Goal existingGoal = goalRepository.findById(id).
                orElseThrow(()->new DevtrackApiException(HttpStatus.BAD_REQUEST, "Goal Not Found"));

        existingGoal.setDescription(goal.getDescription());
        existingGoal.setCompleted(goal.isCompleted());
        existingGoal.setDeadline(goal.getDeadline());
        existingGoal.setTitle(goal.getTitle());

        return  goalRepository.save(existingGoal);
    }

    @Override
    public void deleteGoal(Long id) {
        goalRepository.deleteById(id);
    }
}
