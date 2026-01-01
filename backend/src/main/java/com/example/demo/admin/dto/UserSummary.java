package com.example.demo.admin.dto;

import java.util.List;

public record UserSummary(
        Long id,
        String fullName,
        String email,
        List<String> roles,
        boolean active
) {}
