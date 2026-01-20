# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 專案說明

這是一篇介紹 `/codex-plan` Slash Command 的部落格文章，說明如何在 Claude Code 中整合 Codex CLI 做規劃。

## 專案結構

```
codex-plan/
├── index.md              # Markdown 來源（文章內容）
├── index.html            # 渲染後的 HTML 頁面
├── cover-image/          # 封面圖與產生 prompt
└── illustrations/        # 文章插圖與產生 prompt
```

## 內容關係

- `index.md` 是文章的主要內容來源
- `index.html` 是用 Tailwind CSS 手工排版的展示頁面
- 兩者內容需保持同步：修改 `index.md` 後，需手動更新 `index.html`

## 部署

此專案屬於 GitHub Pages 靜態網站（上層 `/Users/orz99/zoo/blog/`），推送到 main 分支即部署。
