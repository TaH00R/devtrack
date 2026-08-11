package com.devtrack.backend.controllers;

import com.devtrack.backend.dto.NoteRequestDTO;
import com.devtrack.backend.dto.NoteResponseDTO;
import com.devtrack.backend.services.NoteService;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/notes")
public class NoteController {
    private final NoteService noteService;

    public NoteController(NoteService noteService) {
        this.noteService = noteService;
    }

    @PostMapping
    public NoteResponseDTO createNote(
            @Valid @RequestBody NoteRequestDTO noteRequestDTO) {
        return  noteService.createNote(noteRequestDTO);
    };

    @GetMapping
    public List<NoteResponseDTO> getAllNotes() {
        return  noteService.getAllNotes();
    }

    @GetMapping("/{id}")
    public  NoteResponseDTO getNoteById(@PathVariable Long id) {
        return   noteService.getNoteById(id);
    }

    @PatchMapping("/{id}")
    public  NoteResponseDTO updateNote(
            @PathVariable Long id,
            @Valid @RequestBody NoteRequestDTO noteRequestDTO) {
        return   noteService.updateNote(id, noteRequestDTO);
    }

    @DeleteMapping("/{id}")
    public  void deleteNote(@PathVariable Long id) {
        noteService.deleteNote(id);
    }
}
