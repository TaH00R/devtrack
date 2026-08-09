package com.devtrack.backend.services.impl;

import com.devtrack.backend.entities.Note;
import com.devtrack.backend.models.DevtrackApiException;
import com.devtrack.backend.repos.NoteRepository;
import com.devtrack.backend.services.NoteService;
import org.aspectj.weaver.ast.Not;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class NoteServiceImpl implements NoteService {
    private final NoteRepository noteRepository;

    public NoteServiceImpl(NoteRepository noteRepository) {
        this.noteRepository = noteRepository;
    }

    @Override
    public Note createNote(Note note) {
        return  noteRepository.save(note);
    }

    @Override
    public Note getNoteById(Long id) {
        return noteRepository.findById(id).
                orElseThrow(()-> new DevtrackApiException(HttpStatus.BAD_REQUEST, "Note Not Found"));
    }

    @Override
    public List<Note> getAllNotes() {
        return noteRepository.findAll();
    }

    @Override
    public Note updateNote(Long id, Note note) {
        Note existingNote = noteRepository.findById(id).
                orElseThrow(()-> new DevtrackApiException(HttpStatus.BAD_REQUEST, "Note Not Found"));

        existingNote.setContent(note.getContent());
        existingNote.setTitle(note.getTitle());

        return noteRepository.save(existingNote);
    }

    @Override
    public void deleteNote(Long id) {
        noteRepository.deleteById(id);
    }
}
