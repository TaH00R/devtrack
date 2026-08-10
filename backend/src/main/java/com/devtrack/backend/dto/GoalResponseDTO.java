package com.devtrack.backend.dto;


import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class GoalResponseDTO {

    private Long id;

    private String title;

    private String description;

    private boolean completed;

    private LocalDate deadline;

    private Long userId;
}
