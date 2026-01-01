package com.example.demo.auth;

import com.example.demo.security.jwt.JwtService;
import com.example.demo.user.Role;
import com.example.demo.user.UserEntity;
import com.example.demo.user.UserRepository;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.Map;

@Service
public class AuthService {

    private final UserRepository userRepository;
    private final BCryptPasswordEncoder encoder;
    private final JwtService jwtService;

    public AuthService(UserRepository userRepository, BCryptPasswordEncoder encoder, JwtService jwtService) {
        this.userRepository = userRepository;
        this.encoder = encoder;
        this.jwtService = jwtService;
    }

    public String login(String email, String password) {
        UserEntity user = userRepository.findByEmail(email)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Invalid email or password"));

        if (!encoder.matches(password, user.getPassword())) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Invalid email or password");
        }

        Map<String, Object> claims = Map.of(
                "userId", user.getId(),
                "email", user.getEmail(),
                "roles", user.getRoles().stream().map(Enum::name).toList()
        );

        return jwtService.generateToken(claims);
    }

    public String register(String email, String password, String fullName) {

        if (userRepository.findByEmail(email).isPresent()) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Email already registered");
        }

        UserEntity user = new UserEntity();
        user.setEmail(email);
        user.setPassword(encoder.encode(password));
        user.setFullName(fullName);
        user.setActive(true);


        user.getRoles().add(Role.EMPLOYEE);

        UserEntity saved = userRepository.save(user);

        Map<String, Object> claims = Map.of(
                "userId", saved.getId(),
                "email", saved.getEmail(),
                "roles", saved.getRoles().stream().map(Enum::name).toList()
        );

        return jwtService.generateToken(claims);
    }
}
