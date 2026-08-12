package com.devtrack.backend.models;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.context.request.WebRequest;

import java.nio.file.AccessDeniedException;
import java.util.HashMap;
import java.util.Map;

@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(DevtrackApiException.class)
    public ResponseEntity<ErrorDetails> handleDevtrackApiException(
            DevtrackApiException exception,
            WebRequest request
    ) {

        final ErrorDetails errorDetails = new ErrorDetails();

        errorDetails.setErrorCode(exception.getStatus().value());
        errorDetails.setErrorMessage(exception.getMessage());
        errorDetails.setDevErrorMessage(request.getDescription(false));
        errorDetails.setTimestamp(System.currentTimeMillis());

        return new ResponseEntity<>(
                errorDetails,
                exception.getStatus()
        );
    }

    @ExceptionHandler(AccessDeniedException.class)
    public ResponseEntity<ErrorDetails> handleAccessDeniedException(
            AccessDeniedException exception,
            WebRequest request
    ) {

        final ErrorDetails errorDetails = new ErrorDetails();

        errorDetails.setErrorCode(HttpStatus.FORBIDDEN.value());
        errorDetails.setErrorMessage(exception.getMessage());
        errorDetails.setDevErrorMessage(request.getDescription(false));
        errorDetails.setTimestamp(System.currentTimeMillis());

        return new ResponseEntity<>(
                errorDetails,
                HttpStatus.FORBIDDEN
        );
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<Map<String, String>> handleValidationErrors(
            MethodArgumentNotValidException exception
    ) {

        Map<String, String> errors = new HashMap<>();

        exception.getBindingResult()
                .getFieldErrors()
                .forEach(error ->
                        errors.put(
                                error.getField(),
                                error.getDefaultMessage()
                        )
                );

        return ResponseEntity
                .badRequest()
                .body(errors);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorDetails> handleGlobalException(
            Exception exception,
            WebRequest request
    ) {

        final ErrorDetails errorDetails = new ErrorDetails();

        errorDetails.setErrorCode(
                HttpStatus.INTERNAL_SERVER_ERROR.value()
        );
        errorDetails.setErrorMessage(exception.getMessage());
        errorDetails.setDevErrorMessage(request.getDescription(false));
        errorDetails.setTimestamp(System.currentTimeMillis());

        return new ResponseEntity<>(
                errorDetails,
                HttpStatus.INTERNAL_SERVER_ERROR
        );
    }
}