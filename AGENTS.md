# 干支刷题学习 App

纯前端「天干地支 / 命理」刷题+学习 App。Vue 3 + Vite 5 + TypeScript，纯静态，无后端。

## 命令

| 命令 | 含义 |
|------|------|
| `npm run dev` | 开发服务器 (vite, port 5174) |
| `npm run build` | `vue-tsc --noEmit && vite build` (类型检查 + 构建) |
| `npm run build:only` | 仅构建，跳过类型检查 |
| `npm run preview` | 预览构建产物 |

无测试框架，无 linter/formatter 配置。

## 架构

- 入口: `src/main.ts` → `App.vue` + 7 个懒加载路由页面
- 路由: `createWebHistory()` —— 部署需 nginx 回退到 `index.html`
- 路径别名: `@/` → `src/`
- 数据层: `src/data/` 纯 TS 知识库（类型安全，无运行时依赖）
- 逻辑层: `src/composables/` (useQuiz / useProgress / useWrongBook)
- 样式: `src/styles/tokens.css` CSS 变量 + 五行色工具类；无 CSS 框架
- 持久化: localStorage (答题统计 + 错题本)

## 部署

```bash
npm run build && scp -r dist/* ali2shanghai:/var/www/bazi/
```

域名 `bazi.2018to.top`，nginx 独立 server block，certbot HTTPS。SSH 前需先跑 `whitelist-ip`。

## 题库

8 大 scope: `tiangan | dizhi | canggan | relations | lunming | xingming | advanced | all`

关系题和论命题支持子筛选 (`RelationFilter`, `LunmingFilter`)。题目在 `useQuiz.ts` 中生成（非静态数据）。
