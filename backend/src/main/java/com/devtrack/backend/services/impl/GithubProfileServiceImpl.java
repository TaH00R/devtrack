package com.devtrack.backend.services.impl;

import com.devtrack.backend.entities.GithubProfile;
import com.devtrack.backend.entities.User;
import com.devtrack.backend.models.DevtrackApiException;
import com.devtrack.backend.repos.GithubProfileRepository;
import com.devtrack.backend.security.CustomUserDetails;
import com.devtrack.backend.services.GithubProfileService;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class GithubProfileServiceImpl implements GithubProfileService {

    private final GithubProfileRepository githubProfileRepository;

    public GithubProfileServiceImpl(
            GithubProfileRepository githubProfileRepository
    ) {
        this.githubProfileRepository = githubProfileRepository;
    }

    private User getCurrentUser() {

        Authentication authentication =
                SecurityContextHolder.getContext().getAuthentication();

        CustomUserDetails userDetails =
                (CustomUserDetails) authentication.getPrincipal();

        return userDetails.getUser();
    }

    private GithubProfile getProfile(Long id) {

        return githubProfileRepository.findById(id)
                .orElseThrow(() ->
                        new DevtrackApiException(
                                HttpStatus.BAD_REQUEST,
                                "Github Profile Not Found"
                        )
                );
    }

    @Override
    public GithubProfile createGithubProfile(GithubProfile profile) {

        User currentUser = getCurrentUser();

        profile.setUser(currentUser);

        return githubProfileRepository.save(profile);
    }

    @Override
    public GithubProfile getGithubProfileById(Long id) {

        GithubProfile profile = getProfile(id);

        User currentUser = getCurrentUser();

        if (!profile.getUser().getId().equals(currentUser.getId())) {
            throw new DevtrackApiException(
                    HttpStatus.FORBIDDEN,
                    "You do not have access to this Github profile"
            );
        }

        return profile;
    }

    @Override
    public List<GithubProfile> getAllGithubProfiles() {

        User currentUser = getCurrentUser();

        return githubProfileRepository.findAllByUserId(
                currentUser.getId()
        );
    }

    @Override
    public GithubProfile updateGithubProfile(
            Long id,
            GithubProfile profile
    ) {

        GithubProfile oldProfile = getProfile(id);

        User currentUser = getCurrentUser();

        if (!oldProfile.getUser().getId().equals(currentUser.getId())) {
            throw new DevtrackApiException(
                    HttpStatus.FORBIDDEN,
                    "You do not have access to this Github profile"
            );
        }

        oldProfile.setProfileUrl(profile.getProfileUrl());
        oldProfile.setFollowers(profile.getFollowers());
        oldProfile.setUsername(profile.getUsername());
        oldProfile.setPublicRepos(profile.getPublicRepos());

        return githubProfileRepository.save(oldProfile);
    }

    @Override
    public void deleteGithubProfile(Long id) {

        GithubProfile profile = getProfile(id);

        User currentUser = getCurrentUser();

        if (!profile.getUser().getId().equals(currentUser.getId())) {
            throw new DevtrackApiException(
                    HttpStatus.FORBIDDEN,
                    "You do not have access to this Github profile"
            );
        }

        githubProfileRepository.delete(profile);
    }
}