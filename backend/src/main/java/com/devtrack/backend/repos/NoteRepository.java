package com.devtrack.backend.repos;

import com.devtrack.backend.entities.Note;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface NoteRepository extends JpaRepository<Note, Long> {

    List<Note> findAllByUserId(Long userId);
}