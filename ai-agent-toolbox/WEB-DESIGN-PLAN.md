# AI 魔法工具箱 — 網頁設計規劃

> 將 `ai-agent-toolbox-for-sme-report.md` 製作成高品質視覺網頁

---

## 設計目標

- 面向中小企業主的友善介面
- 最佳視覺設計與 UI/UX 體驗
- 配合現有 warm 風格的封面與插圖

---

## 推薦 Skills 組合

### 已安裝（可直接使用）

| Skill | 用途 | 指令 |
|-------|------|------|
| `frontend-design` | 生成高品質前端介面，避免 AI 美學陷阱 | 直接請 Claude 設計 |
| `ui-ux-pro-max` | 50 種風格、21 色盤、50 字體配對 | `/ui-ux-pro-max` |
| `canvas-design` | 視覺藝術設計（海報、圖形） | `/canvas-design` |
| `vercel-react-best-practices` | React/Next.js 效能最佳化 | 自動套用 |
| `web-design-guidelines` | UI 程式碼審查與可及性檢查 | `/web-design-guidelines` |

### 需要安裝

```bash
# Tailwind 設計系統
npx skills add wshobson/agents@tailwind-design-system -g -y

# 前端設計模式
npx skills add sickn33/antigravity-awesome-skills@frontend-patterns -g -y
```

---

## 建議工作流程

```
Step 1: 規劃視覺風格
        └── 使用 ui-ux-pro-max 選擇風格、色盤、字體

Step 2: 生成介面程式碼
        └── 使用 frontend-design 生成 React/HTML

Step 3: 審查可及性
        └── 使用 web-design-guidelines 檢查

Step 4: 效能優化
        └── 套用 vercel-react-best-practices
```

---

## 現有素材

| 素材 | 路徑 |
|------|------|
| 文章內容 | `ai-agent-toolbox-for-sme-report.md` |
| 封面圖片 | `cover.png` |
| 插圖 | `illustrations/*.png` (4 張) |

---

## 風格建議

根據封面設計（warm palette），網頁應延續：

| 維度 | 建議 |
|------|------|
| 色盤 | Warm tones（橙、米、棕） |
| 字體 | 親和的無襯線體 |
| 風格 | 現代簡約，不過度技術感 |
| 互動 | 平滑動畫，直覺導航 |

---

## 下一步

1. 退出 Claude，執行安裝指令
2. 重新啟動 Claude
3. 執行：`/ui-ux-pro-max` 規劃視覺風格
4. 開始設計網頁

---

## 設計網頁指令

```請重新掃描已經安裝的 Skills 依照 WEB-DESIGN-PLAN.md 的內容，開始 AI 魔法工具箱 — 網頁設計規劃，將 `ai-agent-toolbox-for-sme-report.md` 製作成高品質視覺網頁，首先依照 WEB-DESIGN-PLAN.md 的建議工作流程， Step 1: 規劃視覺風格 使用 /ui-ux-pro-max skills 選擇風格、色盤、字體```

```開始 step 2，html 檔名使用跟來源 markdown 檔案相同檔名```

```/web-design-guidelines```


*建立日期：2026-01-28*
