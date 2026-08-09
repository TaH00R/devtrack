package com.devtrack.backend.services;

import com.devtrack.backend.entities.Task;

import java.util.List;

public interface TaskService {
    Task createTask(Task task);

    Task getTaskById(Long id);

    List<Task> getAllTasks();

    Task updateTask(Long id, Task task);

    void deleteTask(Long id);
}
