package com.devtrack.backend.services;

import com.devtrack.backend.dto.AuthResponseDTO;
import com.devtrack.backend.dto.LoginRequestDTO;
import com.devtrack.backend.security.JwtTokenProvider;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;

@Service
public class AuthService {

    private final AuthenticationManager authenticationManager;
    private final JwtTokenProvider jwtTokenProvider;

    public AuthService(
            AuthenticationManager authenticationManager,
            JwtTokenProvider jwtTokenProvider
    ) {
        this.authenticationManager = authenticationManager;
        this.jwtTokenProvider = jwtTokenProvider;
    }

    public AuthResponseDTO login(LoginRequestDTO request) {

        Authentication authentication =
                authenticationManager.authenticate(
                        new UsernamePasswordAuthenticationToken(
                                request.getEmail(),
                                request.getPassword()
                        )
                );

        String token = jwtTokenProvider.generateToken(authentication);

        return new AuthResponseDTO(token);
    }
}