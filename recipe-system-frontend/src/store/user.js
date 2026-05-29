import { defineStore } from "pinia";
import { userApi } from "../api";

export const useUserStore = defineStore("user", {
  state: () => ({
    token: localStorage.getItem("recipe_token") || "",
    user: JSON.parse(localStorage.getItem("recipe_user") || "null"),
  }),
  getters: {
    isLogin: (state) => Boolean(state.token && state.user),
    isAdmin: (state) => state.user?.role === "ADMIN",
  },
  actions: {
    setSession(payload) {
      this.token = payload.token;
      this.user = payload.user;
      localStorage.setItem("recipe_token", this.token);
      localStorage.setItem("recipe_user", JSON.stringify(this.user));
    },
    async login(form) {
      const data = await userApi.login(form);
      this.setSession(data);
    },
    async refresh() {
      if (!this.token) return;
      this.user = await userApi.current();
      localStorage.setItem("recipe_user", JSON.stringify(this.user));
    },
    logout() {
      this.token = "";
      this.user = null;
      localStorage.removeItem("recipe_token");
      localStorage.removeItem("recipe_user");
    },
  },
});
