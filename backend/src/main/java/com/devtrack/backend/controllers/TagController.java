package com.devtrack.backend.controllers;

import com.devtrack.backend.entities.Tag;
import com.devtrack.backend.entities.Task;
import com.devtrack.backend.services.TagService;
import com.devtrack.backend.services.TaskService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/tags")
public class TagController {
    private final TagService tagService;

    public TagController(TaskService taskService, TagService tagService) {
        this.tagService = tagService;
    }

    @PostMapping
    public Tag createTag(@RequestBody Tag tag) {
        return  tagService.createTag(tag);
    }

    @GetMapping
    public List<Tag> getAllTags() {
        return tagService.getAllTags();
    }

    @GetMapping("/{id}")
    public  Tag getTagById(@PathVariable Long id) {
        return  tagService.getTagById(id);
    }

    @PatchMapping("/{id}")
    public Tag updateTag(@PathVariable Long id, @RequestBody Tag tag) {
        return   tagService.updateTag(id, tag);
    }

    @DeleteMapping("/{id}")
    public  void deleteTag(@PathVariable Long id) {
        tagService.deleteTag(id);
    }
}
