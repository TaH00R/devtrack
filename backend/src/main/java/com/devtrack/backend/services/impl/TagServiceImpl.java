package com.devtrack.backend.services.impl;

import com.devtrack.backend.entities.Tag;
import com.devtrack.backend.models.DevtrackApiException;
import com.devtrack.backend.repos.TagRepository;
import com.devtrack.backend.services.TagService;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TagServiceImpl implements TagService {
    private final TagRepository tagRepository;

    public TagServiceImpl(TagRepository tagRepository) {
        this.tagRepository = tagRepository;
    }

    @Override
    public Tag createTag(Tag tag) {
        return tagRepository.save(tag);
    }

    @Override
    public Tag getTagById(Long id) {
        return tagRepository.findById(id)
                .orElseThrow(()-> new DevtrackApiException(HttpStatus.BAD_REQUEST, "Tag Not Found"));
    }

    @Override
    public List<Tag> getAllTags() {
        return tagRepository.findAll();
    }

    @Override
    public Tag updateTag(Long id, Tag tag) {
        Tag existingTag = tagRepository.findById(id)
                .orElseThrow(()-> new DevtrackApiException(HttpStatus.BAD_REQUEST, "Tag Not Found"));

        existingTag.setName(tag.getName());

        return  tagRepository.save(existingTag);
    }

    @Override
    public void deleteTag(Long id) {
        tagRepository.deleteById(id);
    }
}
