package com.example.demo.security.jwt;

import io.jsonwebtoken.Claims;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.List;

@Component
public class JwtAuthFilter extends OncePerRequestFilter {

    private final JwtService jwtService;

    public JwtAuthFilter(JwtService jwtService) {
        this.jwtService = jwtService;
    }

    @Override
    protected void doFilterInternal(
            HttpServletRequest request,
            HttpServletResponse response,
            FilterChain filterChain
    ) throws ServletException, IOException {

        String header = request.getHeader("Authorization");

        if (header == null || !header.startsWith("Bearer ")) {
            filterChain.doFilter(request, response);
            return;
        }

        String token = header.substring(7);

        try {
            Claims claims = jwtService.parseToken(token);

            String email = claims.get("email", String.class);

            @SuppressWarnings("unchecked")
            List<String> roles = (List<String>) claims.get("roles");

            if (roles == null || roles.isEmpty()) {
                String singleRole = claims.get("role", String.class);
                if (singleRole != null && !singleRole.isBlank()) {
                    roles = List.of(singleRole);
                }
            }

            if (roles == null || roles.isEmpty()) {
                roles = List.of("EMPLOYEE");
            }


            var authorities = roles.stream()
                    .filter(r -> r != null && !r.isBlank())
                    .map(String::toUpperCase)
                    .map(r -> new SimpleGrantedAuthority("ROLE_" + r))
                    .toList();

            var authentication = UsernamePasswordAuthenticationToken.authenticated(
                    email,
                    null,
                    authorities
            );

            authentication.setDetails(
                    new WebAuthenticationDetailsSource().buildDetails(request)
            );

            SecurityContextHolder.getContext().setAuthentication(authentication);

        } catch (Exception ignored) {
        }

        filterChain.doFilter(request, response);
    }
}
