package com.devtrack.backend.repos;

import com.devtrack.backend.entities.Task;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface TaskRepository extends JpaRepository<Task,Long> {
    List<Task> findAllByProjectUserId(Long userId);
}
