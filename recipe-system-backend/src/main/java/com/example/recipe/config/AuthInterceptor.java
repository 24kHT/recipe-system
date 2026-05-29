package com.example.recipe.config;

import com.example.recipe.context.LoginUser;
import com.example.recipe.context.UserContext;
import com.example.recipe.entity.User;
import com.example.recipe.exception.BusinessException;
import com.example.recipe.mapper.UserMapper;
import com.example.recipe.util.JwtUtil;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import org.springframework.util.AntPathMatcher;
import org.springframework.util.StringUtils;
import org.springframework.web.servlet.HandlerInterceptor;

@Component
@RequiredArgsConstructor
public class AuthInterceptor implements HandlerInterceptor {
    private final JwtUtil jwtUtil;
    private final UserMapper userMapper;
    private final AntPathMatcher matcher = new AntPathMatcher();

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
        String token = resolveToken(request);
        LoginUser loginUser = null;
        if (StringUtils.hasText(token)) {
            try {
                loginUser = jwtUtil.parseToken(token);
                User user = userMapper.selectById(loginUser.getId());
                if (user == null || user.getDeleted() == 1 || user.getStatus() != 1) {
                    throw BusinessException.unauthorized("用户不存在或已被禁用");
                }
                UserContext.set(loginUser);
            } catch (Exception ex) {
                if (!isPublic(request)) {
                    throw BusinessException.unauthorized("未登录或 token 无效");
                }
            }
        }
        if (!isPublic(request) && loginUser == null) {
            throw BusinessException.unauthorized("未登录或 token 无效");
        }
        if (request.getRequestURI().startsWith("/api/admin/") && (loginUser == null || !loginUser.isAdmin())) {
            throw BusinessException.forbidden("没有管理员权限");
        }
        return true;
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) {
        UserContext.clear();
    }

    private String resolveToken(HttpServletRequest request) {
        String auth = request.getHeader("Authorization");
        if (StringUtils.hasText(auth) && auth.startsWith("Bearer ")) {
            return auth.substring(7);
        }
        return null;
    }

    private boolean isPublic(HttpServletRequest request) {
        String method = request.getMethod();
        String path = request.getRequestURI();
        if ("OPTIONS".equalsIgnoreCase(method)) {
            return true;
        }
        if (matcher.match("/swagger-ui/**", path) || matcher.match("/v3/api-docs/**", path) || matcher.match("/swagger-ui.html", path)) {
            return true;
        }
        if ("POST".equals(method) && ("/api/user/login".equals(path) || "/api/user/register".equals(path))) {
            return true;
        }
        if ("GET".equals(method) && ("/api/category/list".equals(path) || "/api/recipe/list".equals(path))) {
            return true;
        }
        if ("GET".equals(method) && (matcher.match("/api/recipe/{id}", path) || matcher.match("/api/comment/recipe/{id}", path))) {
            return true;
        }
        return false;
    }
}
