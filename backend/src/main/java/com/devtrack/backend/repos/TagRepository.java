package com.devtrack.backend.repos;

import com.devtrack.backend.entities.Tag;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TagRepository extends JpaRepository<Tag, Long> {
}