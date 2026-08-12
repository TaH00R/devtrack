package com.devtrack.backend.services.impl;

import com.devtrack.backend.dto.GoalRequestDTO;
import com.devtrack.backend.dto.GoalResponseDTO;
import com.devtrack.backend.entities.Goal;
import com.devtrack.backend.entities.User;
import com.devtrack.backend.models.DevtrackApiException;
import com.devtrack.backend.repos.GoalRepository;
import com.devtrack.backend.security.CustomUserDetails;
import com.devtrack.backend.services.GoalService;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class GoalServiceImpl implements GoalService {

    private final GoalRepository goalRepository;

    public GoalServiceImpl(GoalRepository goalRepository) {
        this.goalRepository = goalRepository;
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

    private User getCurrentUser() {

        Authentication authentication =
                SecurityContextHolder.getContext().getAuthentication();

        CustomUserDetails userDetails =
                (CustomUserDetails) authentication.getPrincipal();

        return userDetails.getUser();
    }

    @Override
    public GoalResponseDTO createGoal(GoalRequestDTO goalRequestDTO) {

        Goal goal = new Goal();

        goal.setTitle(goalRequestDTO.getTitle());
        goal.setDescription(goalRequestDTO.getDescription());
        goal.setCompleted(goalRequestDTO.isCompleted());
        goal.setDeadline(goalRequestDTO.getDeadline());

        User currentUser = getCurrentUser();
        goal.setUser(currentUser);

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

        User currentUser = getCurrentUser();

        if (!goal.getUser().getId().equals(currentUser.getId())) {
            throw new DevtrackApiException(
                    HttpStatus.FORBIDDEN,
                    "You do not have access to this goal"
            );
        }

        return convertToResponseDTO(goal);
    }

    @Override
    public List<GoalResponseDTO> getAllGoals() {

        User currentUser = getCurrentUser();

        return goalRepository.findAllByUserId(currentUser.getId())
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

        User currentUser = getCurrentUser();

        if (!existingGoal.getUser().getId().equals(currentUser.getId())) {
            throw new DevtrackApiException(
                    HttpStatus.FORBIDDEN,
                    "You do not have access to this goal"
            );
        }

        existingGoal.setTitle(goalRequestDTO.getTitle());
        existingGoal.setDescription(goalRequestDTO.getDescription());
        existingGoal.setCompleted(goalRequestDTO.isCompleted());
        existingGoal.setDeadline(goalRequestDTO.getDeadline());

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

        User currentUser = getCurrentUser();

        if (!goal.getUser().getId().equals(currentUser.getId())) {
            throw new DevtrackApiException(
                    HttpStatus.FORBIDDEN,
                    "You do not have access to this goal"
            );
        }

        goalRepository.delete(goal);
    }
}