package com.devtrack.backend.services;

import com.devtrack.backend.entities.User;

import java.util.List;

public interface UserService {

    User createUser(User user);

    User getUserById(Long id);

    List<User> getAllUsers();

    void deleteUser(Long id);
}