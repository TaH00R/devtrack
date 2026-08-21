package com.devtrack.backend.controllers;

import com.devtrack.backend.dto.UserRequestDTO;
import com.devtrack.backend.dto.UserResponseDTO;
import com.devtrack.backend.services.UserService;
import jakarta.validation.Valid;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/users")
public class UserController {

    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @PostMapping
    public UserResponseDTO createUser(
            @Valid @RequestBody UserRequestDTO userRequestDTO
    ) {
        return userService.createUser(userRequestDTO);
    }

    @GetMapping("/me")
    public UserResponseDTO getCurrentUser(
            Authentication authentication
    ) {
        return userService.getUserByUsername(
                authentication.getName()
        );
    }

    @GetMapping("/{id}")
    public UserResponseDTO getUserById(
            @PathVariable Long id
    ) {
        return userService.getUserById(id);
    }

    @GetMapping
    public List<UserResponseDTO> getAllUsers() {
        return userService.getAllUsers();
    }

    @PutMapping("/{id}")
    public UserResponseDTO updateUser(
            @PathVariable Long id,
            @Valid @RequestBody UserRequestDTO userRequestDTO
    ) {
        return userService.updateUser(id, userRequestDTO);
    }

    @DeleteMapping("/{id}")
    public void deleteUser(
            @PathVariable Long id
    ) {
        userService.deleteUser(id);
    }
}