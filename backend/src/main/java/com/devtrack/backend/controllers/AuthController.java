package com.devtrack.backend.controllers;

import com.devtrack.backend.dto.AuthResponseDTO;
import com.devtrack.backend.dto.LoginRequestDTO;
import com.devtrack.backend.services.AuthService;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/login")
    public AuthResponseDTO login(
            @Valid @RequestBody LoginRequestDTO loginRequestDTO
    ) {
        return authService.login(loginRequestDTO);
    }
}