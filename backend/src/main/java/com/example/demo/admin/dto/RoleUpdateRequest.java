package com.example.demo.admin.dto;

import jakarta.validation.constraints.NotEmpty;

import java.util.List;

public record RoleUpdateRequest(
        @NotEmpty(message = "roles is required")
        List<String> roles
) {}
