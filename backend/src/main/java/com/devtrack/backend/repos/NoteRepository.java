package com.devtrack.backend.repos;

import com.devtrack.backend.entities.Note;
import org.springframework.data.jpa.repository.JpaRepository;

public interface NoteRepository extends JpaRepository<Note, Long> {
}