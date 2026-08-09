package com.devtrack.backend.services.impl;

import com.devtrack.backend.entities.GithubProfile;
import com.devtrack.backend.models.DevtrackApiException;
import com.devtrack.backend.repos.GithubProfileRepository;
import com.devtrack.backend.services.GithubProfileService;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class GithubProfileServiceImpl implements GithubProfileService {
    private final GithubProfileRepository githubProfileRepository;

    public GithubProfileServiceImpl(GithubProfileRepository githubProfileRepository) {
        this.githubProfileRepository = githubProfileRepository;
    }

    @Override
    public GithubProfile createGithubProfile(GithubProfile profile) {
        return githubProfileRepository.save(profile);
    }

    @Override
    public GithubProfile getGithubProfileById(Long id) {
        return githubProfileRepository.findById(id).
                orElseThrow(()->new DevtrackApiException(HttpStatus.BAD_REQUEST, "Github Profile Not Found"));
    }

    @Override
    public List<GithubProfile> getAllGithubProfiles() {
        return githubProfileRepository.findAll();
    }

    @Override
    public GithubProfile updateGithubProfile(Long id, GithubProfile profile) {
        GithubProfile oldProfile = githubProfileRepository.findById(id)
                .orElseThrow(()->new DevtrackApiException(HttpStatus.BAD_REQUEST, "Profile Not Found"));

        oldProfile.setProfileUrl(profile.getProfileUrl());
        oldProfile.setFollowers(profile.getFollowers());
        oldProfile.setUsername(profile.getUsername());
        oldProfile.setFollowers(profile.getFollowers());
        oldProfile.setPublicRepos(profile.getPublicRepos());

        return  githubProfileRepository.save(oldProfile);
    }

    @Override
    public void deleteGithubProfile(Long id) {
        githubProfileRepository.deleteById(id);
    }
}
