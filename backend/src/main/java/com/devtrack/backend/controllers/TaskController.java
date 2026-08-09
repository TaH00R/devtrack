package com.devtrack.backend.controllers;

import com.devtrack.backend.entities.Task;
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
    public Task createTask(@RequestBody Task task) {
        return  taskService.createTask(task);
    }

    @GetMapping("/{id}")
    public  Task getTaskById(@PathVariable Long id) {
        return  taskService.getTaskById(id);
    }

    @GetMapping
    public List<Task> getAllTasks() {
        return  taskService.getAllTasks();
    }

    @PatchMapping("/{id}")
    public  Task updateTask(@PathVariable Long id, @RequestBody Task task) {
        return   taskService.updateTask(id, task);
    }

    @DeleteMapping("/{id}")
    public  void deleteTask(@PathVariable Long id) {
        taskService.deleteTask(id);
    }
}
