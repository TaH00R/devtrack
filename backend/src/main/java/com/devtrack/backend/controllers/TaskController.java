package com.devtrack.backend.controllers;

import com.devtrack.backend.dto.TaskRequestDTO;
import com.devtrack.backend.dto.TaskResponseDTO;
import com.devtrack.backend.services.TaskService;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@RestController
@RequestMapping("/api/tasks")
public class TaskController {
    private final TaskService taskService;

    public TaskController(TaskService taskService) {
        this.taskService = taskService;
    }

    @PostMapping
    public TaskResponseDTO createTask(
            @RequestBody TaskRequestDTO taskRequestDTO
    ) {
        return  taskService.createTask(taskRequestDTO);
    }

    @GetMapping("/{id}")
    public  TaskResponseDTO getTaskById(
            @PathVariable Long id
    ) {
        return  taskService.getTaskById(id);
    }

    @GetMapping
    public List<TaskResponseDTO> getAllTasks() {
        return  taskService.getAllTasks();
    }

    @PatchMapping("/{id}")
    public  TaskResponseDTO updateTask(
            @PathVariable Long id, @RequestBody TaskRequestDTO taskRequestDTO
    ) {
        return   taskService.updateTask(id, taskRequestDTO);
    }

    @DeleteMapping("/{id}")
    public  void deleteTask(@PathVariable Long id) {
        taskService.deleteTask(id);
    }
}
