package com.example.demo.auth;

import com.example.demo.auth.dto.MeResponse;
import com.example.demo.auth.dto.RegisterRequest;
import com.example.demo.user.UserEntity;
import com.example.demo.user.UserRepository;
import jakarta.validation.Valid;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final AuthService authService;
    private final UserRepository userRepository;

    public AuthController(AuthService authService, UserRepository userRepository) {
        this.authService = authService;
        this.userRepository = userRepository;
    }

    @PostMapping("/login")
    public TokenResponse login(@RequestBody LoginRequest request) {
        String token = authService.login(request.email(), request.password());
        return new TokenResponse(token);
    }

    @PostMapping("/register")
    public TokenResponse register(@Valid @RequestBody RegisterRequest request) {
        String token = authService.register(request.email(), request.password(), request.fullName());
        return new TokenResponse(token);
    }


    @GetMapping("/me")
    public MeResponse me(Authentication authentication) {
        String email = authentication.getName();

        UserEntity user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found"));

        return new MeResponse(
                user.getId(),
                user.getEmail(),
                user.getFullName(),
                user.getRoles().stream().map(Enum::name).sorted().toList(),
                user.isActive()
        );
    }

    public record TokenResponse(String accessToken) {}
    public record LoginRequest(String email, String password) {}
}
