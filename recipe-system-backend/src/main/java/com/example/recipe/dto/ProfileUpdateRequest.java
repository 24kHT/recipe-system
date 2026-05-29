package com.example.recipe.dto;

import lombok.Data;

@Data
public class ProfileUpdateRequest {
    private String nickname;
    private String avatar;
    private String email;
    private String phone;
    private String bio;
}
