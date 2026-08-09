package com.devtrack.backend.services;

import com.devtrack.backend.entities.Tag;

import java.util.List;

public interface TagService {
    Tag createTag(Tag tag);

    Tag getTagById(Long id);

    List<Tag> getAllTags();

    Tag updateTag(Long id, Tag tag);

    void deleteTag(Long id);
}
