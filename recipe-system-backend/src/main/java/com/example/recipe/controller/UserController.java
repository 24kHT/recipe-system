package com.example.recipe.controller;

import com.example.recipe.common.Result;
import com.example.recipe.dto.LoginRequest;
import com.example.recipe.dto.PasswordUpdateRequest;
import com.example.recipe.dto.ProfileUpdateRequest;
import com.example.recipe.dto.RegisterRequest;
import com.example.recipe.service.UserService;
import com.example.recipe.vo.LoginVO;
import com.example.recipe.vo.UserVO;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/user")
public class UserController {
    private final UserService userService;

    @PostMapping("/register")
    public Result<UserVO> register(@Valid @RequestBody RegisterRequest request) {
        return Result.ok("注册成功", userService.register(request));
    }

    @PostMapping("/login")
    public Result<LoginVO> login(@Valid @RequestBody LoginRequest request) {
        return Result.ok("登录成功", userService.login(request));
    }

    @GetMapping("/current")
    public Result<UserVO> current() {
        return Result.ok(userService.current());
    }

    @PutMapping("/profile")
    public Result<UserVO> updateProfile(@RequestBody ProfileUpdateRequest request) {
        return Result.ok("个人信息已更新", userService.updateProfile(request));
    }

    @PutMapping("/password")
    public Result<Void> updatePassword(@Valid @RequestBody PasswordUpdateRequest request) {
        userService.updatePassword(request);
        return Result.ok("密码已修改", null);
    }
}
