package com.devtrack.backend.services.impl;

import com.devtrack.backend.entities.Task;
import com.devtrack.backend.entities.User;
import com.devtrack.backend.models.DevtrackApiException;
import com.devtrack.backend.repos.TaskRepository;
import com.devtrack.backend.services.TaskService;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TaskServiceImpl implements TaskService {
    private final TaskRepository taskRepository;

    public TaskServiceImpl(TaskRepository taskRepository) {
        this.taskRepository = taskRepository;
    }

    @Override
    public Task createTask(Task task) {
        return taskRepository.save(task);
    }

    @Override
    public Task getTaskById(Long id) {
        return taskRepository.findById(id)
                .orElseThrow(()-> new DevtrackApiException(HttpStatus.BAD_REQUEST,"Task not found"));
    }

    @Override
    public List<Task> getAllTasks() {
        return taskRepository.findAll();
    }

    @Override
    public Task updateTask(Long id, Task task) {
        Task existingTask = taskRepository.findById(id)
                .orElseThrow(() -> new DevtrackApiException(HttpStatus.BAD_REQUEST,"User not found"));

        existingTask.setCompleted(task.isCompleted());
        existingTask.setDescription(task.getDescription());
        existingTask.setTags(task.getTags());
        existingTask.setTitle(task.getTitle());
        existingTask.setProject(task.getProject());

        return taskRepository.save(existingTask);
    }

    @Override
    public void deleteTask(Long id) {
        taskRepository.deleteById(id);
    }
}
