package com.devtrack.backend.services.impl;

import com.devtrack.backend.entities.LeetcodeProfile;
import com.devtrack.backend.entities.User;
import com.devtrack.backend.models.DevtrackApiException;
import com.devtrack.backend.repos.LeetcodeProfileRepository;
import com.devtrack.backend.security.CustomUserDetails;
import com.devtrack.backend.services.LeetcodeProfileService;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class LeetcodeProfileServiceImpl implements LeetcodeProfileService {

    private final LeetcodeProfileRepository leetcodeProfileRepository;

    public LeetcodeProfileServiceImpl(
            LeetcodeProfileRepository leetcodeProfileRepository
    ) {
        this.leetcodeProfileRepository = leetcodeProfileRepository;
    }

    private User getCurrentUser() {

        Authentication authentication =
                SecurityContextHolder.getContext().getAuthentication();

        CustomUserDetails userDetails =
                (CustomUserDetails) authentication.getPrincipal();

        return userDetails.getUser();
    }

    private LeetcodeProfile getProfile(Long id) {

        return leetcodeProfileRepository.findById(id)
                .orElseThrow(() ->
                        new DevtrackApiException(
                                HttpStatus.BAD_REQUEST,
                                "Leetcode Profile Not Found"
                        )
                );
    }

    @Override
    public LeetcodeProfile createLeetcodeProfile(
            LeetcodeProfile profile
    ) {

        User currentUser = getCurrentUser();

        profile.setUser(currentUser);

        return leetcodeProfileRepository.save(profile);
    }

    @Override
    public LeetcodeProfile getLeetcodeProfileById(Long id) {

        LeetcodeProfile profile = getProfile(id);

        User currentUser = getCurrentUser();

        if (!profile.getUser().getId().equals(currentUser.getId())) {
            throw new DevtrackApiException(
                    HttpStatus.FORBIDDEN,
                    "You do not have access to this Leetcode profile"
            );
        }

        return profile;
    }

    @Override
    public List<LeetcodeProfile> getAllLeetcodeProfiles() {

        User currentUser = getCurrentUser();

        return leetcodeProfileRepository.findAllByUserId(
                currentUser.getId()
        );
    }

    @Override
    public LeetcodeProfile updateLeetcodeProfile(
            Long id,
            LeetcodeProfile profile
    ) {

        LeetcodeProfile oldProfile = getProfile(id);

        User currentUser = getCurrentUser();

        if (!oldProfile.getUser().getId().equals(currentUser.getId())) {
            throw new DevtrackApiException(
                    HttpStatus.FORBIDDEN,
                    "You do not have access to this Leetcode profile"
            );
        }

        oldProfile.setEasySolved(profile.getEasySolved());
        oldProfile.setUsername(profile.getUsername());
        oldProfile.setHardSolved(profile.getHardSolved());
        oldProfile.setMediumSolved(profile.getMediumSolved());
        oldProfile.setTotalSolved(profile.getTotalSolved());
        oldProfile.setContestRatings(profile.getContestRatings());

        return leetcodeProfileRepository.save(oldProfile);
    }

    @Override
    public void deleteLeetcodeProfile(Long id) {

        LeetcodeProfile profile = getProfile(id);

        User currentUser = getCurrentUser();

        if (!profile.getUser().getId().equals(currentUser.getId())) {
            throw new DevtrackApiException(
                    HttpStatus.FORBIDDEN,
                    "You do not have access to this Leetcode profile"
            );
        }

        leetcodeProfileRepository.delete(profile);
    }
}