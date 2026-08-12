package com.devtrack.backend.services.impl;

import com.devtrack.backend.dto.UserRequestDTO;
import com.devtrack.backend.dto.UserResponseDTO;
import com.devtrack.backend.entities.User;
import com.devtrack.backend.models.DevtrackApiException;
import com.devtrack.backend.repos.UserRepository;
import com.devtrack.backend.security.CustomUserDetails;
import com.devtrack.backend.services.UserService;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public UserServiceImpl(
            UserRepository userRepository,
            PasswordEncoder passwordEncoder
    ) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
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
    public UserResponseDTO createUser(UserRequestDTO userRequestDTO) {

        User user = new User();

        user.setUserName(userRequestDTO.getUserName());
        user.setEmail(userRequestDTO.getEmail());
        user.setPassword(
                passwordEncoder.encode(userRequestDTO.getPassword())
        );
        user.setDisplayName(userRequestDTO.getDisplayName());

        User savedUser = userRepository.save(user);

        return convertToResponseDTO(savedUser);
    }

    @Override
    public UserResponseDTO getUserById(Long id) {

        User currentUser = getCurrentUser();

        if (!currentUser.getId().equals(id)) {
            throw new DevtrackApiException(
                    HttpStatus.FORBIDDEN,
                    "You do not have access to this user"
            );
        }

        return convertToResponseDTO(currentUser);
    }

    @Override
    public List<UserResponseDTO> getAllUsers() {

        throw new DevtrackApiException(
                HttpStatus.FORBIDDEN,
                "You cannot access all users"
        );
    }

    @Override
    public UserResponseDTO updateUser(
            Long id,
            UserRequestDTO userRequestDTO
    ) {

        User currentUser = getCurrentUser();

        if (!currentUser.getId().equals(id)) {
            throw new DevtrackApiException(
                    HttpStatus.FORBIDDEN,
                    "You cannot update another user"
            );
        }

        currentUser.setUserName(userRequestDTO.getUserName());
        currentUser.setEmail(userRequestDTO.getEmail());
        currentUser.setPassword(
                passwordEncoder.encode(userRequestDTO.getPassword())
        );
        currentUser.setDisplayName(userRequestDTO.getDisplayName());

        User updatedUser = userRepository.save(currentUser);

        return convertToResponseDTO(updatedUser);
    }

    @Override
    public void deleteUser(Long id) {

        User currentUser = getCurrentUser();

        if (!currentUser.getId().equals(id)) {
            throw new DevtrackApiException(
                    HttpStatus.FORBIDDEN,
                    "You cannot delete another user"
            );
        }

        userRepository.delete(currentUser);
    }

    private UserResponseDTO convertToResponseDTO(User user) {

        return new UserResponseDTO(
                user.getId(),
                user.getUserName(),
                user.getEmail(),
                user.getDisplayName()
        );
    }
}