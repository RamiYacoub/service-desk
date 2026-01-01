package com.example.demo.admin;

import com.example.demo.admin.dto.RoleUpdateRequest;
import com.example.demo.admin.dto.UserSummary;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin/users")
public class AdminUserController {

    private final AdminUserService adminUserService;

    public AdminUserController(AdminUserService adminUserService) {
        this.adminUserService = adminUserService;
    }

    @GetMapping
    public List<UserSummary> list() {
        return adminUserService.listUsers();
    }

    @PutMapping("/{id}/roles")
    public UserSummary setRoles(@PathVariable Long id, @Valid @RequestBody RoleUpdateRequest request) {
        return adminUserService.setRoles(id, request.roles());
    }

    @PostMapping("/{id}/roles/{role}")
    public UserSummary addRole(@PathVariable Long id, @PathVariable String role) {
        return adminUserService.addRole(id, role);
    }

    @DeleteMapping("/{id}/roles/{role}")
    public UserSummary removeRole(@PathVariable Long id, @PathVariable String role) {
        return adminUserService.removeRole(id, role);
    }


}
