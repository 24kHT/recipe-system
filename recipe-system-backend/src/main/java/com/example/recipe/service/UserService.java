package com.example.recipe.service;

import com.example.recipe.dto.LoginRequest;
import com.example.recipe.dto.PasswordUpdateRequest;
import com.example.recipe.dto.ProfileUpdateRequest;
import com.example.recipe.dto.RegisterRequest;
import com.example.recipe.vo.LoginVO;
import com.example.recipe.vo.UserVO;

public interface UserService {
    UserVO register(RegisterRequest request);

    LoginVO login(LoginRequest request);

    UserVO current();

    UserVO updateProfile(ProfileUpdateRequest request);

    void updatePassword(PasswordUpdateRequest request);
}
