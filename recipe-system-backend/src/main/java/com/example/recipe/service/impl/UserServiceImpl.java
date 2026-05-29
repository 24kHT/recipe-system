package com.example.recipe.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.example.recipe.context.UserContext;
import com.example.recipe.dto.LoginRequest;
import com.example.recipe.dto.PasswordUpdateRequest;
import com.example.recipe.dto.ProfileUpdateRequest;
import com.example.recipe.dto.RegisterRequest;
import com.example.recipe.entity.User;
import com.example.recipe.exception.BusinessException;
import com.example.recipe.mapper.UserMapper;
import com.example.recipe.service.UserService;
import com.example.recipe.util.JwtUtil;
import com.example.recipe.vo.LoginVO;
import com.example.recipe.vo.UserVO;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {
    private final UserMapper userMapper;
    private final JwtUtil jwtUtil;
    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    @Override
    public UserVO register(RegisterRequest request) {
        boolean exists = userMapper.selectCount(new LambdaQueryWrapper<User>()
                .eq(User::getUsername, request.getUsername())
                .eq(User::getDeleted, 0)) > 0;
        if (exists) {
            throw BusinessException.badRequest("用户名已存在");
        }
        LocalDateTime time = LocalDateTime.now();
        User user = new User();
        user.setUsername(request.getUsername());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setNickname(StringUtils.hasText(request.getNickname()) ? request.getNickname() : request.getUsername());
        user.setEmail(request.getEmail());
        user.setPhone(request.getPhone());
        user.setRole("USER");
        user.setStatus(1);
        user.setDeleted(0);
        user.setCreateTime(time);
        user.setUpdateTime(time);
        userMapper.insert(user);
        return UserVO.from(user);
    }

    @Override
    public LoginVO login(LoginRequest request) {
        User user = userMapper.selectOne(new LambdaQueryWrapper<User>()
                .eq(User::getUsername, request.getUsername())
                .eq(User::getDeleted, 0));
        if (user == null || !passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            throw BusinessException.badRequest("用户名或密码错误");
        }
        if (user.getStatus() == null || user.getStatus() != 1) {
            throw BusinessException.forbidden("用户已被禁用");
        }
        return new LoginVO(jwtUtil.createToken(user.getId(), user.getUsername(), user.getRole()), UserVO.from(user));
    }

    @Override
    public UserVO current() {
        User user = currentUser();
        return UserVO.from(user);
    }

    @Override
    public UserVO updateProfile(ProfileUpdateRequest request) {
        User user = currentUser();
        user.setNickname(request.getNickname());
        user.setAvatar(request.getAvatar());
        user.setEmail(request.getEmail());
        user.setPhone(request.getPhone());
        user.setBio(request.getBio());
        user.setUpdateTime(LocalDateTime.now());
        userMapper.updateById(user);
        return UserVO.from(user);
    }

    @Override
    public void updatePassword(PasswordUpdateRequest request) {
        User user = currentUser();
        if (!passwordEncoder.matches(request.getOldPassword(), user.getPassword())) {
            throw BusinessException.badRequest("原密码错误");
        }
        user.setPassword(passwordEncoder.encode(request.getNewPassword()));
        user.setUpdateTime(LocalDateTime.now());
        userMapper.updateById(user);
    }

    private User currentUser() {
        Long userId = UserContext.userId();
        if (userId == null) {
            throw BusinessException.unauthorized("未登录或 token 无效");
        }
        User user = userMapper.selectById(userId);
        if (user == null || user.getDeleted() == 1) {
            throw BusinessException.unauthorized("用户不存在");
        }
        if (user.getStatus() == null || user.getStatus() != 1) {
            throw BusinessException.forbidden("用户已被禁用");
        }
        return user;
    }
}
