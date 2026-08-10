package com.devtrack.backend.services.impl;

import com.devtrack.backend.dto.GoalRequestDTO;
import com.devtrack.backend.dto.GoalResponseDTO;
import com.devtrack.backend.entities.Goal;
import com.devtrack.backend.entities.User;
import com.devtrack.backend.models.DevtrackApiException;
import com.devtrack.backend.repos.GoalRepository;
import com.devtrack.backend.repos.UserRepository;
import com.devtrack.backend.services.GoalService;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class GoalServiceImpl implements GoalService {

    private final GoalRepository goalRepository;
    private final UserRepository userRepository;

    public GoalServiceImpl(
            GoalRepository goalRepository,
            UserRepository userRepository
    ) {
        this.goalRepository = goalRepository;
        this.userRepository = userRepository;
    }

    private GoalResponseDTO convertToResponseDTO(Goal goal) {

        return new GoalResponseDTO(
                goal.getId(),
                goal.getTitle(),
                goal.getDescription(),
                goal.isCompleted(),
                goal.getDeadline(),
                goal.getUser().getId()
        );
    }

    @Override
    public GoalResponseDTO createGoal(GoalRequestDTO goalRequestDTO) {

        Goal goal = new Goal();

        goal.setTitle(goalRequestDTO.getTitle());
        goal.setDescription(goalRequestDTO.getDescription());
        goal.setCompleted(goalRequestDTO.isCompleted());
        goal.setDeadline(goalRequestDTO.getDeadline());

        User user = userRepository.findById(
                goalRequestDTO.getUserId()
        ).orElseThrow(() ->
                new DevtrackApiException(
                        HttpStatus.BAD_REQUEST,
                        "User not found"
                )
        );

        goal.setUser(user);

        Goal savedGoal = goalRepository.save(goal);

        return convertToResponseDTO(savedGoal);
    }

    @Override
    public GoalResponseDTO getGoalById(Long id) {

        Goal goal = goalRepository.findById(id)
                .orElseThrow(() ->
                        new DevtrackApiException(
                                HttpStatus.BAD_REQUEST,
                                "Goal Not Found"
                        )
                );

        return convertToResponseDTO(goal);
    }

    @Override
    public List<GoalResponseDTO> getAllGoals() {

        return goalRepository.findAll()
                .stream()
                .map(this::convertToResponseDTO)
                .toList();
    }

    @Override
    public GoalResponseDTO updateGoal(
            Long id,
            GoalRequestDTO goalRequestDTO
    ) {

        Goal existingGoal = goalRepository.findById(id)
                .orElseThrow(() ->
                        new DevtrackApiException(
                                HttpStatus.BAD_REQUEST,
                                "Goal Not Found"
                        )
                );

        existingGoal.setTitle(goalRequestDTO.getTitle());
        existingGoal.setDescription(goalRequestDTO.getDescription());
        existingGoal.setCompleted(goalRequestDTO.isCompleted());
        existingGoal.setDeadline(goalRequestDTO.getDeadline());

        User user = userRepository.findById(
                goalRequestDTO.getUserId()
        ).orElseThrow(() ->
                new DevtrackApiException(
                        HttpStatus.BAD_REQUEST,
                        "User not found"
                )
        );

        existingGoal.setUser(user);

        Goal updatedGoal = goalRepository.save(existingGoal);

        return convertToResponseDTO(updatedGoal);
    }

    @Override
    public void deleteGoal(Long id) {

        Goal goal = goalRepository.findById(id)
                .orElseThrow(() ->
                        new DevtrackApiException(
                                HttpStatus.BAD_REQUEST,
                                "Goal Not Found"
                        )
                );

        goalRepository.delete(goal);
    }
}