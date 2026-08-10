package com.devtrack.backend.services.impl;

import com.devtrack.backend.dto.NoteRequestDTO;
import com.devtrack.backend.dto.NoteResponseDTO;
import com.devtrack.backend.entities.Note;
import com.devtrack.backend.entities.User;
import com.devtrack.backend.models.DevtrackApiException;
import com.devtrack.backend.repos.NoteRepository;
import com.devtrack.backend.repos.UserRepository;
import com.devtrack.backend.services.NoteService;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class NoteServiceImpl implements NoteService {

    private final NoteRepository noteRepository;
    private final UserRepository userRepository;

    public NoteServiceImpl(
            NoteRepository noteRepository,
            UserRepository userRepository
    ) {
        this.noteRepository = noteRepository;
        this.userRepository = userRepository;
    }

    private NoteResponseDTO convertToResponseDTO(Note note) {
        return new NoteResponseDTO(
                note.getId(),
                note.getTitle(),
                note.getContent(),
                note.getUser().getId()
        );
    }

    @Override
    public NoteResponseDTO createNote(NoteRequestDTO noteRequestDTO) {

        Note note = new Note();

        note.setTitle(noteRequestDTO.getTitle());
        note.setContent(noteRequestDTO.getContent());

        User user = userRepository.findById(
                noteRequestDTO.getUserId()
        ).orElseThrow(() ->
                new DevtrackApiException(
                        HttpStatus.BAD_REQUEST,
                        "User not found"
                )
        );

        note.setUser(user);

        Note savedNote = noteRepository.save(note);

        return convertToResponseDTO(savedNote);
    }

    @Override
    public NoteResponseDTO getNoteById(Long id) {

        Note note = noteRepository.findById(id)
                .orElseThrow(() ->
                        new DevtrackApiException(
                                HttpStatus.BAD_REQUEST,
                                "Note Not Found"
                        )
                );

        return convertToResponseDTO(note);
    }

    @Override
    public List<NoteResponseDTO> getAllNotes() {

        return noteRepository.findAll()
                .stream()
                .map(this::convertToResponseDTO)
                .toList();
    }

    @Override
    public NoteResponseDTO updateNote(
            Long id,
            NoteRequestDTO noteRequestDTO
    ) {

        Note existingNote = noteRepository.findById(id)
                .orElseThrow(() ->
                        new DevtrackApiException(
                                HttpStatus.BAD_REQUEST,
                                "Note Not Found"
                        )
                );

        existingNote.setTitle(noteRequestDTO.getTitle());
        existingNote.setContent(noteRequestDTO.getContent());

        User user = userRepository.findById(
                noteRequestDTO.getUserId()
        ).orElseThrow(() ->
                new DevtrackApiException(
                        HttpStatus.BAD_REQUEST,
                        "User not found"
                )
        );

        existingNote.setUser(user);

        Note updatedNote = noteRepository.save(existingNote);

        return convertToResponseDTO(updatedNote);
    }

    @Override
    public void deleteNote(Long id) {

        Note note = noteRepository.findById(id)
                .orElseThrow(() ->
                        new DevtrackApiException(
                                HttpStatus.BAD_REQUEST,
                                "Note Not Found"
                        )
                );

        noteRepository.delete(note);
    }
}