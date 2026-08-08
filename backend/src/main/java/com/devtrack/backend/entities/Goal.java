package com.devtrack.backend.entities;

import jakarta.persistence.*;

import java.time.LocalDate;

@Entity
public class Goal {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String title;

    private String description;

    private boolean completed;

    private LocalDate deadline;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;
}
