package com.devtrack.backend.services;

import com.devtrack.backend.entities.Note;

import java.util.List;

public interface NoteService {
    Note createNote(Note note);

    Note getNoteById(Long id);

    List<Note> getAllNotes();

    Note updateNote(Long id, Note note);

    void deleteNote(Long id);
}
