package com.devtrack.backend.services;

import com.devtrack.backend.entities.LeetcodeProfile;

import java.util.List;

public interface LeetcodeProfileService {
    LeetcodeProfile createLeetcodeProfile(LeetcodeProfile profile);

    LeetcodeProfile getLeetcodeProfileById(Long id);

    List<LeetcodeProfile> getAllLeetcodeProfiles();

    LeetcodeProfile updateLeetcodeProfile(Long id, LeetcodeProfile profile);

    void deleteLeetcodeProfile(Long id);
}
