package com.devtrack.backend.services;

import com.devtrack.backend.dto.TaskRequestDTO;
import com.devtrack.backend.dto.TaskResponseDTO;
import com.devtrack.backend.entities.Task;

import java.util.List;

public interface TaskService {
    TaskResponseDTO createTask(TaskRequestDTO taskRequestDTO);

    TaskResponseDTO getTaskById(Long id);

    List<TaskResponseDTO> getAllTasks();

    TaskResponseDTO updateTask(Long id, TaskRequestDTO taskRequestDTO);

    void deleteTask(Long id);
}
