package com.example.demo.test;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.security.core.Authentication;

import java.util.HashMap;
import java.util.Map;

@RestController
public class TestController {

    @GetMapping("/api/test")
    public String tokenTest() {
        return "OK - authorized";
    }

    @GetMapping("/api/admin/ping")
    public String adminPing() {
        return "ADMIN OK";
    }

    @GetMapping("/api/employee/ping")
    public String employeePing() {
        return "EMPLOYEE OK";
    }

    @GetMapping("/api/me")
    public Map<String, Object> me(Authentication auth) {
        Map<String, Object> res = new HashMap<>();
        res.put("authenticated", auth != null && auth.isAuthenticated());
        res.put("principal", auth == null ? null : auth.getPrincipal());
        res.put("authorities", auth == null ? null : auth.getAuthorities());
        return res;
    }

}
