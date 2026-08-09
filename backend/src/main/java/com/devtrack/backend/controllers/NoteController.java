package com.devtrack.backend.controllers;

import com.devtrack.backend.entities.Note;
import com.devtrack.backend.services.NoteService;
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
    public Note createNote(@RequestBody Note note) {
        return  noteService.createNote(note);
    };

    @GetMapping
    public List<Note> getAllNotes() {
        return  noteService.getAllNotes();
    }

    @GetMapping("/{id}")
    public  Note getNoteById(@PathVariable Long id) {
        return   noteService.getNoteById(id);
    }

    @PatchMapping("/{id}")
    public  Note updateNote(@PathVariable Long id, @RequestBody Note note) {
        return   noteService.updateNote(id, note);
    }

    @DeleteMapping("/{id}")
    public  void deleteNote(@PathVariable Long id) {
        noteService.deleteNote(id);
    }
}
