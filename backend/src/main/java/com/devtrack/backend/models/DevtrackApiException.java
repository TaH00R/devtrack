package com.devtrack.backend.models;

import lombok.Getter;
import org.springframework.http.HttpStatus;

public class DevtrackApiException extends RuntimeException{
    @Getter
    private final HttpStatus status;
    private final String message;
    public DevtrackApiException(HttpStatus status, String message) {
        this.status = status;
        this.message = message;
    }

    @Override
    public String getMessage() {
        return message;
    }

}