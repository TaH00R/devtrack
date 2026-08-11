package com.devtrack.backend.controllers;


import com.devtrack.backend.dto.GoalRequestDTO;
import com.devtrack.backend.dto.GoalResponseDTO;
import com.devtrack.backend.entities.Goal;
import com.devtrack.backend.services.GoalService;
import jakarta.validation.Valid;
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
    public GoalResponseDTO createGoal(
            @Valid @RequestBody GoalRequestDTO goalRequestDTO) {
        return  goalService.createGoal(goalRequestDTO);
    }

    @GetMapping
    public List<GoalResponseDTO> getAllGoals() {
        return  goalService.getAllGoals();
    }

    @GetMapping("/{id}")
    public  GoalResponseDTO getGoalById(@PathVariable Long id) {
        return   goalService.getGoalById(id);
    }

    @PatchMapping("/{id}")
    public  GoalResponseDTO updateGoal(
            @PathVariable Long id,
            @Valid @RequestBody GoalRequestDTO goalRequestDTO) {
        return   goalService.updateGoal(id, goalRequestDTO);
    }

    @DeleteMapping("/{id}")
    public  void deleteGoal(@PathVariable Long id) {
        goalService.deleteGoal(id);
    }
}
