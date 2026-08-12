package com.devtrack.backend.services.impl;

import com.devtrack.backend.dto.TaskRequestDTO;
import com.devtrack.backend.dto.TaskResponseDTO;
import com.devtrack.backend.entities.Project;
import com.devtrack.backend.entities.Tag;
import com.devtrack.backend.entities.Task;
import com.devtrack.backend.entities.User;
import com.devtrack.backend.models.DevtrackApiException;
import com.devtrack.backend.repos.ProjectRepository;
import com.devtrack.backend.repos.TagRepository;
import com.devtrack.backend.repos.TaskRepository;
import com.devtrack.backend.security.CustomUserDetails;
import com.devtrack.backend.services.TaskService;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class TaskServiceImpl implements TaskService {

    private final TaskRepository taskRepository;
    private final ProjectRepository projectRepository;
    private final TagRepository tagRepository;

    public TaskServiceImpl(
            TaskRepository taskRepository,
            ProjectRepository projectRepository,
            TagRepository tagRepository
    ) {
        this.taskRepository = taskRepository;
        this.projectRepository = projectRepository;
        this.tagRepository = tagRepository;
    }

    private TaskResponseDTO convertToResponseDTO(Task task) {

        Set<Long> tagIds = task.getTags()
                .stream()
                .map(Tag::getId)
                .collect(Collectors.toSet());

        return new TaskResponseDTO(
                task.getId(),
                task.getTitle(),
                task.getDescription(),
                task.isCompleted(),
                task.getProject().getId(),
                tagIds
        );
    }

    private User getCurrentUser() {

        Authentication authentication =
                SecurityContextHolder.getContext().getAuthentication();

        CustomUserDetails userDetails =
                (CustomUserDetails) authentication.getPrincipal();

        return userDetails.getUser();
    }

    private void checkProjectOwnership(Project project) {

        User currentUser = getCurrentUser();

        if (!project.getUser().getId().equals(currentUser.getId())) {
            throw new DevtrackApiException(
                    HttpStatus.FORBIDDEN,
                    "You do not have access to this project"
            );
        }
    }

    @Override
    public TaskResponseDTO createTask(TaskRequestDTO taskRequestDTO) {

        Task task = new Task();

        task.setTitle(taskRequestDTO.getTitle());
        task.setDescription(taskRequestDTO.getDescription());
        task.setCompleted(taskRequestDTO.isCompleted());

        Project project = projectRepository.findById(
                taskRequestDTO.getProjectId()
        ).orElseThrow(() ->
                new DevtrackApiException(
                        HttpStatus.BAD_REQUEST,
                        "Project not found"
                )
        );

        checkProjectOwnership(project);

        task.setProject(project);

        Set<Tag> tags = taskRequestDTO.getTagIds()
                .stream()
                .map(tagId -> tagRepository.findById(tagId)
                        .orElseThrow(() ->
                                new DevtrackApiException(
                                        HttpStatus.BAD_REQUEST,
                                        "Tag not found: " + tagId
                                )
                        )
                )
                .collect(Collectors.toSet());

        task.setTags(tags);

        Task savedTask = taskRepository.save(task);

        return convertToResponseDTO(savedTask);
    }

    @Override
    public TaskResponseDTO getTaskById(Long id) {

        Task task = taskRepository.findById(id)
                .orElseThrow(() ->
                        new DevtrackApiException(
                                HttpStatus.BAD_REQUEST,
                                "Task not found"
                        )
                );

        checkProjectOwnership(task.getProject());

        return convertToResponseDTO(task);
    }

    @Override
    public List<TaskResponseDTO> getAllTasks() {

        User currentUser = getCurrentUser();

        return taskRepository.findAllByProjectUserId(currentUser.getId())
                .stream()
                .map(this::convertToResponseDTO)
                .toList();
    }

    @Override
    public TaskResponseDTO updateTask(
            Long id,
            TaskRequestDTO taskRequestDTO
    ) {

        Task task = taskRepository.findById(id)
                .orElseThrow(() ->
                        new DevtrackApiException(
                                HttpStatus.BAD_REQUEST,
                                "Task not found"
                        )
                );

        checkProjectOwnership(task.getProject());

        task.setTitle(taskRequestDTO.getTitle());
        task.setDescription(taskRequestDTO.getDescription());
        task.setCompleted(taskRequestDTO.isCompleted());

        Project project = projectRepository.findById(
                taskRequestDTO.getProjectId()
        ).orElseThrow(() ->
                new DevtrackApiException(
                        HttpStatus.BAD_REQUEST,
                        "Project not found"
                )
        );

        checkProjectOwnership(project);

        task.setProject(project);

        Set<Tag> tags = taskRequestDTO.getTagIds()
                .stream()
                .map(tagId -> tagRepository.findById(tagId)
                        .orElseThrow(() ->
                                new DevtrackApiException(
                                        HttpStatus.BAD_REQUEST,
                                        "Tag not found: " + tagId
                                )
                        )
                )
                .collect(Collectors.toSet());

        task.setTags(tags);

        Task updatedTask = taskRepository.save(task);

        return convertToResponseDTO(updatedTask);
    }

    @Override
    public void deleteTask(Long id) {

        Task task = taskRepository.findById(id)
                .orElseThrow(() ->
                        new DevtrackApiException(
                                HttpStatus.BAD_REQUEST,
                                "Task not found"
                        )
                );

        checkProjectOwnership(task.getProject());

        taskRepository.delete(task);
    }
}