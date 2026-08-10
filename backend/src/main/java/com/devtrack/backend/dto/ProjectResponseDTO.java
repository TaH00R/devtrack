package com.devtrack.backend.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class ProjectResponseDTO {

    private Long id;

    private String name;

    private String description;

    private String githubUrl;

    private Long userId;
}
