# 干支刷题学习 App

纯前端「天干地支 / 命理」刷题+学习 App——从零基础到读懂断命流程的完整学习工具。

## 技术栈
- Vue 3 + Vite 5 + TypeScript
- 纯静态产物，无后端、无数据库、无 systemd 服务
- vue-router（4 个底部 tab + 3 个学习子页）

## 部署
- **域名**: `https://bazi.2018to.top/`
- **服务器目录**: `/var/www/bazi/`
- **nginx**: 独立 server block（`/etc/nginx/sites-available/bazi`），certbot HTTPS
- **DNS**: 阿里云 A 记录 `bazi.2018to.top → 139.196.233.57`
- **更新流程**: `npm run build && scp -r dist/* ali2shanghai:/var/www/bazi/`
- SSH 前置：需先跑 `whitelist-ip`

## 目录结构
```
src/
├── data/                  # 知识库（纯数据，TS 类型安全）
│   ├── types.ts              # 类型定义
│   ├── tiangan.ts            # 10天干（说文解字+记忆法）
│   ├── dizhi.ts             # 12地支（藏干+生肖+时辰+类别）
│   ├── advanced.ts          # 五行生克+十神+旺相休囚死+天干五合+三合局+四库
│   ├── dizhi-relations.ts   # 六大关系（六合/六冲/三合/三刑/三会/六害+断语）
│   ├── geju.ts              # 八正格+外格（成破救+相神）
│   ├── lunming.ts           # 子平三派（格局/旺衰/调候）+三书+调候用神
│   └── xingming.ts          # 姓名学（五格剖象法+81数理）
├── composables/           # 逻辑
│   ├── useQuiz.ts            # 题库生成（约400+题，8大scope）
│   ├── useProgress.ts        # 答题统计（localStorage）
│   └── useWrongBook.ts       # 错题本（连对2次移出）
├── components/
│   ├── QuestionCard.vue      # 题目卡（自动跳题+精简模式）
│   ├── CharCard.vue          # 单字释义卡
│   ├── CharGrid.vue          # 宫格
│   ├── WuxingBadge.vue       # 五行色标
│   ├── BottomNav.vue         # 底部导航
│   └── RelationWheel.vue     # 地支关系圆图（SVG 可交互）
├── pages/
│   ├── StudyPage.vue         # 学习首页（/）
│   ├── RelationsPage.vue     # 地支六大关系（/relations）
│   ├── LunmingPage.vue       # 子平论命流程（/lunming）
│   ├── XingmingPage.vue      # 姓名学+五格计算器（/xingming）
│   ├── QuizPage.vue          # 答题（/quiz）
│   ├── ChallengePage.vue     # 60秒挑战（/challenge）
│   └── ProfilePage.vue       # 我的+错题本（/profile）
├── styles/tokens.css      # 五行配色设计令牌
├── App.vue / main.ts / env.d.ts
├── package.json / vite.config.ts / tsconfig.json
└── index.html
```

## 知识体系覆盖（从地基到断命全链）
基础（22字+藏干，含说文解字/记忆法）→ 进阶（五行生克+十神+旺相休囚死+天干五合化气）→ 地支六大关系（六合/六冲/三合/三刑/三会/六害，含圆图+断语+应用）→ 论命三派（格局派/旺衰派/调候派+三书+八正格+用神选取）→ 姓名学（五格剖象法+计算器+81数理，明确标注≠八字）

## 题库 8 大 scope
天干 / 地支 / 藏干 / 关系（含子筛选）/ 论命（格局+用神，含子筛选）/ 姓名学 / 进阶 / 全部。每题解析含原理+取象+应用+喜忌。
