import request from "../utils/request";

export const userApi = {
  register: (data) => request.post("/user/register", data),
  login: (data) => request.post("/user/login", data),
  current: () => request.get("/user/current"),
  updateProfile: (data) => request.put("/user/profile", data),
  updatePassword: (data) => request.put("/user/password", data),
};

export const categoryApi = {
  list: () => request.get("/category/list"),
  create: (data) => request.post("/admin/category", data),
  update: (id, data) => request.put(`/admin/category/${id}`, data),
  remove: (id) => request.delete(`/admin/category/${id}`),
};

export const recipeApi = {
  list: (params) => request.get("/recipe/list", { params }),
  detail: (id) => request.get(`/recipe/${id}`),
  create: (data) => request.post("/recipe", data),
  update: (id, data) => request.put(`/recipe/${id}`, data),
  remove: (id) => request.delete(`/recipe/${id}`),
  mine: () => request.get("/recipe/my"),
};

export const favoriteApi = {
  add: (recipeId) => request.post(`/favorite/${recipeId}`),
  cancel: (recipeId) => request.delete(`/favorite/${recipeId}`),
  mine: () => request.get("/favorite/my"),
};

export const commentApi = {
  create: (data) => request.post("/comment", data),
  list: (recipeId) => request.get(`/comment/recipe/${recipeId}`),
  remove: (id) => request.delete(`/comment/${id}`),
};

export const adminApi = {
  stat: () => request.get("/admin/stat"),
  users: () => request.get("/admin/user/list"),
  enableUser: (id) => request.put(`/admin/user/${id}/enable`),
  disableUser: (id) => request.put(`/admin/user/${id}/disable`),
  recipes: () => request.get("/admin/recipe/list"),
  toggleRecipe: (id) => request.put(`/admin/recipe/${id}/disable`),
};
