# 干支刷题 App（Flutter）

天干地支 / 命理 刷题 + 学习 Android App。Flutter + Riverpod + go_router，**纯本地无后端**。

> 本仓库由 Vue 版本重构而来，原 Vue 源码保留在 `legacy_vue/` 作数据迁移参考，迁移完成后可删除。

## 命令

| 命令 | 含义 |
|------|------|
| `flutter pub get` | 安装依赖 |
| `flutter run` | 运行（需连接设备/模拟器） |
| `flutter analyze` | 静态分析（提交前必跑） |
| `flutter test` | 单元/Widget 测试 |
| `flutter build apk --release` | 构建 release APK |

本地无 Android SDK 时无需运行，直接推送后由 GitHub Actions 构建。

## 架构

```
lib/
├── main.dart              # 入口 + ProviderScope
├── app.dart               # MaterialApp.router（主题 + 路由）
├── core/                  # 主题、配色（五行色）、路由
│   ├── app_colors.dart    #   对应 Vue 的 tokens.css
│   ├── theme.dart         #   暗色墨系 Material 3 主题
│   └── app_router.dart    #   go_router 配置
├── data/                  # 知识库（从 legacy_vue/src/data 迁移）
├── domain/                # 题目生成逻辑（对应 useQuiz.ts）
├── providers/             # Riverpod providers（进度/错题本等）
├── features/              # 功能页面
│   ├── home/              #   底部导航壳（学习/答题/挑战/我的）
│   ├── study/             #   学习模式
│   ├── quiz/              #   答题训练
│   ├── challenge/         #   挑战模式
│   └── profile/           #   统计 / 错题本
└── shared/widgets/        # 共享组件（WuxingBadge 等）
```

## 状态管理

Riverpod（`flutter_riverpod`）。Provider 定义放 `lib/providers/`，页面用 `ConsumerWidget` / `ConsumerStatefulWidget` 消费。

## 持久化

`shared_preferences`（对应 Vue 的 localStorage）。键名加版本后缀（如 `bazi-progress-v1`）。

## 设计语言

暗色墨系护眼专注。五行配色：木绿 / 火红 / 土黄 / 金灰 / 水蓝，定义在 `core/app_colors.dart`。

## 部署

推送 `main` 分支 → GitHub Actions 自动构建 release APK → Actions 页面下载 artifact 安装。

## 数据迁移来源

`legacy_vue/src/data/*.ts` 是题库知识源，需 1:1 迁移为 Dart 常量。范围：天干、地支、藏干、地支关系、格局、论命、姓名学、子平真诠（8 大 scope，约 5700 行）。
