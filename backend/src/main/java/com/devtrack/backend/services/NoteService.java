package com.devtrack.backend.services;

import com.devtrack.backend.dto.NoteRequestDTO;
import com.devtrack.backend.dto.NoteResponseDTO;
import com.devtrack.backend.entities.Note;

import java.util.List;

public interface NoteService {
    NoteResponseDTO createNote(NoteRequestDTO noteRequestDTO);

    NoteResponseDTO getNoteById(Long id);

    List<NoteResponseDTO> getAllNotes();

    NoteResponseDTO updateNote(Long id, NoteRequestDTO noteRequestDTO);

    void deleteNote(Long id);
}
