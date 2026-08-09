package com.devtrack.backend.services.impl;

import com.devtrack.backend.entities.LeetcodeProfile;
import com.devtrack.backend.models.DevtrackApiException;
import com.devtrack.backend.repos.LeetcodeProfileRepository;
import com.devtrack.backend.services.LeetcodeProfileService;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class LeetcodeProfileServiceImpl implements LeetcodeProfileService {
    private final LeetcodeProfileRepository leetcodeProfileRepository;

    public LeetcodeProfileServiceImpl(LeetcodeProfileRepository leetcodeProfileRepository) {
        this.leetcodeProfileRepository = leetcodeProfileRepository;
    }

    @Override
    public LeetcodeProfile createLeetcodeProfile(LeetcodeProfile profile) {
        return leetcodeProfileRepository.save(profile);
    }

    @Override
    public LeetcodeProfile getLeetcodeProfileById(Long id) {
        return leetcodeProfileRepository.findById(id).
                orElseThrow(()-> new DevtrackApiException(HttpStatus.BAD_REQUEST, "Leetcode Profile Not Found"));
    }

    @Override
    public List<LeetcodeProfile> getAllLeetcodeProfiles() {
        return leetcodeProfileRepository.findAll();
    }

    @Override
    public LeetcodeProfile updateLeetcodeProfile(Long id, LeetcodeProfile profile) {
        LeetcodeProfile oldProfile = leetcodeProfileRepository.findById(id).
                orElseThrow(()-> new DevtrackApiException(HttpStatus.BAD_REQUEST, "Leetcode Profile Not Found"));

        oldProfile.setEasySolved(profile.getEasySolved());
        oldProfile.setUsername(profile.getUsername());
        oldProfile.setHardSolved(profile.getHardSolved());
        oldProfile.setMediumSolved(profile.getMediumSolved());
        oldProfile.setTotalSolved(profile.getTotalSolved());
        oldProfile.setContestRatings(profile.getContestRatings());

        return  leetcodeProfileRepository.save(oldProfile);
    }

    @Override
    public void deleteLeetcodeProfile(Long id) {
        leetcodeProfileRepository.deleteById(id);
    }
}
