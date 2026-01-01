package com.example.demo.admin;

import com.example.demo.admin.dto.UserSummary;
import com.example.demo.user.Role;
import com.example.demo.user.UserEntity;
import com.example.demo.user.UserRepository;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@Service
public class AdminUserService {


    private final UserRepository userRepository;

    public AdminUserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public List<UserSummary> listUsers() {
        return userRepository.findAll().stream()
                .map(this::toSummary)
                .toList();
    }

    public UserSummary setRoles(Long userId, List<String> roles) {
        if (roles == null || roles.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "roles cannot be empty");
        }

        List<String> normalized = roles.stream()
                .map(r -> r == null ? "" : r.trim().toUpperCase())
                .filter(r -> !r.isBlank())
                .toList();

        if (normalized.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "roles cannot be empty");
        }

        UserEntity user = userRepository.findById(userId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found"));

        user.getRoles().clear();
        for (String r : normalized) {
            user.getRoles().add(parseRole(r));
        }

        UserEntity saved = userRepository.save(user);
        return toSummary(saved);
    }


    private UserSummary toSummary(UserEntity u) {
        return new UserSummary(
                u.getId(),
                u.getFullName(),
                u.getEmail(),
                u.getRoles().stream().map(Enum::name).sorted().toList(),
                u.isActive()
        );
    }

    public UserSummary addRole(Long userId, String role) {
        Role parsed = parseRole(role);


        UserEntity user = userRepository.findById(userId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found"));
        if (user.getRoles().contains(parsed)) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "User already has role: " + parsed);
        }

        user.getRoles().add(parsed);
        UserEntity saved = userRepository.save(user);
        return toSummary(saved);
    }


    public UserSummary removeRole(Long userId, String role) {
        Role parsed = parseRole(role);

        UserEntity user = userRepository.findById(userId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found"));
        user.getRoles().remove(parsed);
        if (user.getRoles().isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "User must have at least one role");
        }
        UserEntity saved = userRepository.save(user);
        return toSummary(saved);
    }


    private Role parseRole(String role) {
        if (role == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "role is required");
        }
        String normalized = role.trim().toUpperCase();
        try {
            return Role.valueOf(normalized);
        } catch (IllegalArgumentException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid role: " + normalized);
        }
    }


}
