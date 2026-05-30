<template>
  <section class="panel">
    <h2>后台管理</h2>
    <div class="admin-stats">
      <div v-for="item in statCards" :key="item.label" class="stat-card">
        <span>{{ item.label }}</span>
        <strong>{{ item.value }}</strong>
      </div>
    </div>
    <el-tabs v-model="activeTab">
      <el-tab-pane label="用户" name="users">
        <el-table :data="users" border>
          <el-table-column prop="username" label="用户名" />
          <el-table-column prop="nickname" label="昵称" />
          <el-table-column prop="role" label="角色" width="100" />
          <el-table-column label="状态" width="100">
            <template #default="{ row }">{{ row.status === 1 ? "启用" : "禁用" }}</template>
          </el-table-column>
          <el-table-column label="操作" width="140">
            <template #default="{ row }">
              <el-button size="small" @click="toggleUser(row)">
                {{ row.status === 1 ? "禁用" : "启用" }}
              </el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-tab-pane>

      <el-tab-pane label="菜谱" name="recipes">
        <el-table :data="recipes" border>
          <el-table-column prop="title" label="菜谱" />
          <el-table-column prop="categoryName" label="分类" width="120" />
          <el-table-column prop="authorName" label="作者" width="140" />
          <el-table-column label="状态" width="110">
            <template #default="{ row }">
              <span :class="['recipe-status-badge', row.status === 1 ? 'is-online' : 'is-offline']">
                {{ row.status === 1 ? "上架" : "下架" }}
                <span class="recipe-status-icon" aria-hidden="true">{{ row.status === 1 ? "✓" : "×" }}</span>
              </span>
            </template>
          </el-table-column>
          <el-table-column label="操作" width="170">
            <template #default="{ row }">
              <RouterLink :to="`/recipe/${row.id}`"><el-button link type="primary">查看</el-button></RouterLink>
              <el-button link type="primary" @click="toggleRecipe(row)">切换状态</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-tab-pane>

      <el-tab-pane label="分类" name="categories">
        <div class="inline-row">
          <el-input v-model="categoryForm.name" placeholder="分类名称" />
          <el-input v-model="categoryForm.icon" placeholder="图标标识" />
          <el-input-number v-model="categoryForm.sort" :min="0" />
          <el-button type="primary" @click="saveCategory">{{ editingCategoryId ? "保存" : "新增" }}</el-button>
        </div>
        <el-table :data="categories" border>
          <el-table-column prop="name" label="名称" />
          <el-table-column prop="icon" label="图标" />
          <el-table-column prop="sort" label="排序" width="100" />
          <el-table-column label="操作" width="150">
            <template #default="{ row }">
              <el-button link type="primary" @click="editCategory(row)">编辑</el-button>
              <el-button link type="danger" @click="removeCategory(row.id)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-tab-pane>
    </el-tabs>
  </section>
</template>

<script setup>
import { computed, onMounted, reactive, ref } from "vue";
import { adminApi, categoryApi } from "../api";

const activeTab = ref("users");
const stat = ref({});
const users = ref([]);
const recipes = ref([]);
const categories = ref([]);
const editingCategoryId = ref(null);
const categoryForm = reactive({
  name: "",
  icon: "",
  sort: 0,
  status: 1,
});

const statCards = computed(() => [
  { label: "用户", value: stat.value.userCount || 0 },
  { label: "菜谱", value: stat.value.recipeCount || 0 },
  { label: "分类", value: stat.value.categoryCount || 0 },
  { label: "评论", value: stat.value.commentCount || 0 },
]);

async function loadAll() {
  const [statData, userList, recipeList, categoryList] = await Promise.all([
    adminApi.stat(),
    adminApi.users(),
    adminApi.recipes(),
    categoryApi.list(),
  ]);
  stat.value = statData;
  users.value = userList;
  recipes.value = recipeList;
  categories.value = categoryList;
}

async function toggleUser(row) {
  if (row.status === 1) {
    await adminApi.disableUser(row.id);
  } else {
    await adminApi.enableUser(row.id);
  }
  await loadAll();
}

async function toggleRecipe(row) {
  await adminApi.toggleRecipe(row.id);
  await loadAll();
}

function editCategory(row) {
  editingCategoryId.value = row.id;
  Object.assign(categoryForm, {
    name: row.name,
    icon: row.icon,
    sort: row.sort || 0,
    status: row.status ?? 1,
  });
}

async function saveCategory() {
  if (editingCategoryId.value) {
    await categoryApi.update(editingCategoryId.value, categoryForm);
  } else {
    await categoryApi.create(categoryForm);
  }
  editingCategoryId.value = null;
  Object.assign(categoryForm, { name: "", icon: "", sort: 0, status: 1 });
  await loadAll();
}

async function removeCategory(id) {
  await categoryApi.remove(id);
  await loadAll();
}

onMounted(loadAll);
</script>
