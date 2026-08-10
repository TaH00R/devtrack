package com.devtrack.backend.services.impl;

import com.devtrack.backend.dto.TaskRequestDTO;
import com.devtrack.backend.dto.TaskResponseDTO;
import com.devtrack.backend.entities.Project;
import com.devtrack.backend.entities.Tag;
import com.devtrack.backend.entities.Task;
import com.devtrack.backend.models.DevtrackApiException;
import com.devtrack.backend.repos.ProjectRepository;
import com.devtrack.backend.repos.TagRepository;
import com.devtrack.backend.repos.TaskRepository;
import com.devtrack.backend.repos.UserRepository;
import com.devtrack.backend.services.TaskService;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class TaskServiceImpl implements TaskService {
    private final TaskRepository taskRepository;
    private final ProjectRepository projectRepository;
    private  final TagRepository tagRepository;

    public TaskServiceImpl(TaskRepository taskRepository, ProjectRepository projectRepository, UserRepository userRepository, TagRepository tagRepository) {
        this.taskRepository = taskRepository;
        this.projectRepository = projectRepository;
        this.tagRepository = tagRepository;
    }

    //conversion function
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

    @Override
    public TaskResponseDTO createTask(TaskRequestDTO taskRequestDTO) {

        Task task = new Task();

        // Normal fields
        task.setTitle(taskRequestDTO.getTitle());
        task.setDescription(taskRequestDTO.getDescription());
        task.setCompleted(taskRequestDTO.isCompleted());

        // Project relationship
        Project project;
        project = projectRepository.findById(
                taskRequestDTO.getProjectId()
        ).orElseThrow(() ->
                new DevtrackApiException(HttpStatus.BAD_REQUEST,"Project not found")
        );

        task.setProject(project);

        // Tag relationships
        Set<Tag> tags;
        tags = taskRequestDTO.getTagIds()
                .stream()
                .map(tagId -> tagRepository.findById(tagId)
                        .orElseThrow(() ->
                                new DevtrackApiException(HttpStatus.BAD_REQUEST,
                                        "Tag not found: " + tagId
                                )
                        ))
                .collect(Collectors.toSet());

        task.setTags(tags);

        // Save entity
        Task savedTask = taskRepository.save(task);

        // Convert entity → response DTO
        return convertToResponseDTO(savedTask);
    }

    @Override
    public TaskResponseDTO getTaskById(
            Long id
    ) {
        Task task = taskRepository.findById(id)
                .orElseThrow(()-> new DevtrackApiException(HttpStatus.BAD_REQUEST,"Task not found"));

        return convertToResponseDTO(task);
    }

    @Override
    public List<TaskResponseDTO> getAllTasks() {

        return taskRepository.findAll()
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
                .orElseThrow(() -> new DevtrackApiException(HttpStatus.BAD_REQUEST,"Task not found"));

        task.setCompleted(taskRequestDTO.isCompleted());
        task.setDescription(taskRequestDTO.getDescription());
        task.setTitle(taskRequestDTO.getTitle());

        Project project;
        project = projectRepository.findById(
                taskRequestDTO.getProjectId()
        ).orElseThrow(() ->
                new DevtrackApiException(HttpStatus.BAD_REQUEST,"Project not found")
        );

        task.setProject(project);

        Set<Tag> tags;
        tags = taskRequestDTO.getTagIds()
                .stream()
                .map(tagId -> tagRepository.findById(tagId)
                        .orElseThrow(() ->
                                new DevtrackApiException(HttpStatus.BAD_REQUEST,
                                        "Tag not found: " + tagId
                                )
                        ))
                .collect(Collectors.toSet());

        task.setTags(tags);

        Task updatedTask = taskRepository.save(task);
        return convertToResponseDTO(updatedTask);
    }

    @Override
    public void deleteTask(Long id) {
        Task task = taskRepository.findById(id)
                .orElseThrow(()-> new DevtrackApiException(HttpStatus.BAD_REQUEST,"Task not found"));

        taskRepository.delete(task);
    }


}
