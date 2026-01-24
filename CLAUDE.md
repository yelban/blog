# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 專案說明

GitHub Pages 靜態網站，託管 AI 新聞報告與技術文章。無需建置步驟，直接部署 HTML/CSS/JS。

## 專案架構

```
blog/
├── index.html              # 首頁
├── news/                   # Daily Picks AI News（精選日報）
│   ├── index.html          # 新聞檢視器（含 TTS）
│   ├── reports.json        # 報告索引
│   └── YYYY-MM-DD-news-report.md
├── reports/                # Raw News Scanner（即時掃描）
│   ├── codex-plan.md       # 實作計畫文件
│   └── raw/
│       ├── index.html      # 原始報告檢視器（含 TTS）
│       ├── reports.json    # 報告索引
│       └── global_scan_YYYYMMDD_HHMM.md
└── codex-plan/             # 多語系技術文章
    ├── index.html          # 中文版
    ├── en/index.html       # 英文版
    └── jp/index.html       # 日文版
```

## 新聞檢視器 (news/ & reports/raw/)

兩個檢視器共用相同設計模式：

- **Markdown 渲染**：marked.js CDN
- **TTS 引擎**：Azure、Google Cloud、Gemini、Fish Audio、Web Speech API
- **報告索引**：`reports.json` 需手動或腳本更新
- **Cache-busting**：`?v=${timestamp}` 防止瀏覽器快取

### TTS 內容提取邏輯 (reports/raw/)

| 區塊 | 播放內容 |
|------|---------|
| 頭條精選 (Top 10) | 標題 + 簡介 + 核心觀點 + 啟發 |
| 歐美/日本科技動態 | 表格「中文摘要」欄 |
| 台灣/中國新聞 | 僅標題 |

### 新增報告步驟

1. 將 `.md` 檔案放入對應目錄
2. 更新 `reports.json` 加入新檔名（不含 `.md`）
3. 提交並推送

## 檔名格式

- **news/**：`YYYY-MM-DD-news-report.md`
- **reports/raw/**：`global_scan_YYYYMMDD_HHMM.md`

## UI/UX 設計系統 (reports/raw/)

基於 UI/UX Pro Max 原則優化閱讀體驗：

- **排版**：行高 1.75、行寬 65ch、字間距 -0.011em
- **顏色**：Zinc 色系，Light/Dark 雙模式，對比度 7:1+
- **Header**：backdrop-filter blur + scroll shadow
- **表格**：圓角、hover 效果、sticky headers
- **無障礙**：所有互動元素皆有 focus ring

詳見 `reports/codex-plan.md` 的 UI/UX Refactor 章節。

## 部署

推送至 `main` 分支後自動部署至 GitHub Pages。
