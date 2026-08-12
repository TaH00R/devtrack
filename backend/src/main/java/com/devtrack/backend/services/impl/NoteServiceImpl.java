package com.devtrack.backend.services.impl;

import com.devtrack.backend.dto.NoteRequestDTO;
import com.devtrack.backend.dto.NoteResponseDTO;
import com.devtrack.backend.entities.Note;
import com.devtrack.backend.entities.User;
import com.devtrack.backend.models.DevtrackApiException;
import com.devtrack.backend.repos.NoteRepository;
import com.devtrack.backend.repos.UserRepository;
import com.devtrack.backend.security.CustomUserDetails;
import com.devtrack.backend.services.NoteService;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class NoteServiceImpl implements NoteService {

    private final NoteRepository noteRepository;

    public NoteServiceImpl(
            NoteRepository noteRepository
    ) {
        this.noteRepository = noteRepository;
    }

    private NoteResponseDTO convertToResponseDTO(Note note) {
        return new NoteResponseDTO(
                note.getId(),
                note.getTitle(),
                note.getContent(),
                note.getUser().getId()
        );
    }

    private User getCurrentUser() {

        Authentication authentication =
                SecurityContextHolder.getContext().getAuthentication();

        assert authentication != null;
        CustomUserDetails userDetails =
                (CustomUserDetails) authentication.getPrincipal();

        assert userDetails != null;
        return userDetails.getUser();
    }

    @Override
    public NoteResponseDTO createNote(NoteRequestDTO noteRequestDTO) {

        Note note = new Note();

        note.setTitle(noteRequestDTO.getTitle());
        note.setContent(noteRequestDTO.getContent());

        User currentUser = getCurrentUser();

        note.setUser(currentUser);

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

        User currentUser = getCurrentUser();

        if (!note.getUser().getId().equals(currentUser.getId())) {
            throw new DevtrackApiException(
                    HttpStatus.FORBIDDEN,
                    "You do not have access to this note"
            );
        }

        return convertToResponseDTO(note);
    }

    @Override
    public List<NoteResponseDTO> getAllNotes() {

        User currentUser = getCurrentUser();

        return noteRepository.findAllByUserId(currentUser.getId())
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

        User currentUser = getCurrentUser();

        if (!existingNote.getUser().getId().equals(currentUser.getId())) {
            throw new DevtrackApiException(
                    HttpStatus.FORBIDDEN,
                    "You do not have access to this note"
            );
        }

        existingNote.setTitle(noteRequestDTO.getTitle());
        existingNote.setContent(noteRequestDTO.getContent());

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

        User currentUser = getCurrentUser();

        if (!note.getUser().getId().equals(currentUser.getId())) {
            throw new DevtrackApiException(
                    HttpStatus.FORBIDDEN,
                    "You do not have access to this note"
            );
        }

        noteRepository.delete(note);
    }
}