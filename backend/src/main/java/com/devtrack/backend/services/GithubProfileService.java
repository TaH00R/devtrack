package com.devtrack.backend.services;

import com.devtrack.backend.entities.GithubProfile;

import java.util.List;

public interface GithubProfileService {
    GithubProfile createGithubProfile(GithubProfile profile);

    GithubProfile getGithubProfileById(Long id);

    List<GithubProfile> getAllGithubProfiles();

    GithubProfile updateGithubProfile(Long id, GithubProfile profile);

    void deleteGithubProfile(Long id);
}
