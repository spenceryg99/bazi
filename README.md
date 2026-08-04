# 干支刷题

天干地支 / 命理 刷题 + 学习 Android App。

纯本地、无后端、无广告。覆盖天干地支、藏干、地支六大关系、格局用神、姓名学、子平真诠等 8 大题库。

## 技术栈

- Flutter（仅 Android）
- Riverpod（状态管理）
- go_router（路由）
- shared_preferences（本地持久化）

## 构建

推送 `main` 分支后，GitHub Actions 自动构建 APK，在仓库 Actions 页面下载。

本地构建：

```bash
flutter pub get
flutter run                  # 调试运行
flutter build apk --release  # 构建 APK
```
