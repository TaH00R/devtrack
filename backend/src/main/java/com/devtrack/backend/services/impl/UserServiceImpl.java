package com.devtrack.backend.services.impl;

import com.devtrack.backend.dto.UserRequestDTO;
import com.devtrack.backend.dto.UserResponseDTO;
import com.devtrack.backend.entities.User;
import com.devtrack.backend.models.DevtrackApiException;
import com.devtrack.backend.repos.UserRepository;
import com.devtrack.backend.services.UserService;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;
    private final  PasswordEncoder passwordEncoder;

    public UserServiceImpl(UserRepository userRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    public UserResponseDTO createUser(UserRequestDTO userRequestDTO) {

        User user = new User();

        user.setUserName(userRequestDTO.getUserName());
        user.setEmail(userRequestDTO.getEmail());
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        user.setDisplayName(userRequestDTO.getDisplayName());

        User savedUser = userRepository.save(user);

        return convertToResponseDTO(savedUser);
    }

    @Override
    public UserResponseDTO getUserById(Long id) {

        User user = userRepository.findById(id)
                .orElseThrow(() -> new DevtrackApiException(HttpStatus.BAD_REQUEST, "User not found"));

        return convertToResponseDTO(user);
    }

    @Override
    public List<UserResponseDTO> getAllUsers() {

        return userRepository.findAll()
                .stream()
                .map(this::convertToResponseDTO)
                .toList();
    }

    @Override
    public UserResponseDTO updateUser(
            Long id,
            UserRequestDTO userRequestDTO
    ) {

        User user = userRepository.findById(id)
                .orElseThrow(() -> new DevtrackApiException(HttpStatus.BAD_REQUEST,"User not found"));

        user.setUserName(userRequestDTO.getUserName());
        user.setEmail(userRequestDTO.getEmail());
        user.setPassword(passwordEncoder.encode(userRequestDTO.getPassword()));
        user.setDisplayName(userRequestDTO.getDisplayName());

        User updatedUser = userRepository.save(user);

        return convertToResponseDTO(updatedUser);
    }

    @Override
    public void deleteUser(Long id) {

        User user = userRepository.findById(id)
                .orElseThrow(() -> new DevtrackApiException(HttpStatus.BAD_REQUEST,"User not found"));

        userRepository.delete(user);
    }

    //conversion function
    private UserResponseDTO convertToResponseDTO(User user) {

        return new UserResponseDTO(
                user.getId(),
                user.getUserName(),
                user.getEmail(),
                user.getDisplayName()
        );
    }
}