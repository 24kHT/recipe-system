package com.example.recipe.service;

import com.example.recipe.vo.RecipeVO;
import com.example.recipe.vo.UserVO;

import java.util.List;
import java.util.Map;

public interface AdminService {
    Map<String, Long> stat();

    List<UserVO> users();

    void setUserStatus(Long id, Integer status);

    List<RecipeVO> recipes();
}
