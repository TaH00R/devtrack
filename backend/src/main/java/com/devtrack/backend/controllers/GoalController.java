package com.devtrack.backend.controllers;


import com.devtrack.backend.entities.Goal;
import com.devtrack.backend.services.GoalService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/goals")
public class GoalController {
    private final GoalService goalService;

    public GoalController(GoalService goalService) {
        this.goalService = goalService;
    }

    @PostMapping
    public Goal createGoal(@RequestBody Goal goal) {
        return  goalService.createGoal(goal);
    }

    @GetMapping
    public List<Goal> getAllGoals() {
        return  goalService.getAllGoals();
    }

    @GetMapping("/{id}")
    public  Goal getGoalById(@PathVariable Long id) {
        return   goalService.getGoalById(id);
    }

    @PatchMapping("/{id}")
    public  Goal updateGoal(@PathVariable Long id, @RequestBody Goal goal) {
        return   goalService.updateGoal(id, goal);
    }

    @DeleteMapping("/{id}")
    public  void deleteGoal(@PathVariable Long id) {
        goalService.deleteGoal(id);
    }
}
