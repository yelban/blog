# 圖片生成設計紀錄

> 記錄 ai-agent-toolbox 專案中各文章的封面與插圖設計決策

---

## 設計系統概述

### 封面圖片：五維度設計法

| 維度 | 選項 | 說明 |
|------|------|------|
| Type | hero, conceptual, abstract, editorial, minimal | 視覺類型 |
| Palette | warm, cool, neutral, vibrant, dark, pastel | 色調 |
| Rendering | digital, watercolor, ink, 3d, flat, photo | 渲染風格 |
| Text | title-only, title-subtitle, no-text | 文字層級 |
| Mood | dramatic, balanced, calm | 情緒張力 |

### 文章插圖：Type × Style 矩陣

**Type（類型）**：
- framework：架構圖、概念框架
- infographic：資訊圖表、數據視覺化
- flowchart：流程圖、決策樹
- comparison：對比圖、前後比較

**Style（風格）**：
- warm：溫暖親和，適合面向一般讀者
- blueprint：技術藍圖，適合技術/架構文章

---

## 文章一：AI 魔法工具箱（SME Report）

**檔案**：`ai-agent-toolbox-for-sme-report.md`

### 封面設計

| 維度 | 選擇 | 理由 |
|------|------|------|
| Type | hero | 主視覺突出，吸引中小企業主 |
| Palette | warm | 親和、不嚇人，適合非技術讀者 |
| Rendering | digital | 現代感但不過度技術 |
| Text | title-only | 標題「AI 魔法工具箱」|
| Mood | balanced | 專業但不壓迫 |
| Aspect | 2.35:1 | 電影寬幅，視覺張力 |

**輸出**：`cover.png`

**踩坑紀錄**：
- 第一次生成出現錯誤中文「溫路」
- 嘗試用 "NO TEXT ON IMAGE" 修正 → 用戶否決
- 正確做法：保持原 prompt，重新生成即可

### 插圖設計

| 維度 | 選擇 | 理由 |
|------|------|------|
| Type | mixed | 混合使用 framework + infographic |
| Style | warm | 配合封面的親和風格 |
| Density | balanced | 4 張，重點章節 |

**插圖清單**：

| # | 檔案 | 類型 | 主題 |
|---|------|------|------|
| 1 | illustration-01-skill-framework.png | framework | Agent Skill 三層架構 |
| 2 | illustration-02-cost-comparison.png | infographic | 成本效益比較 |
| 3 | illustration-03-implementation-flow.png | flowchart | 導入流程 |
| 4 | illustration-04-use-cases.png | comparison | 應用場景對比 |

**輸出目錄**：`illustrations/`

---

## 文章二：成本秘訣（Cost Secrets）

**檔案**：`ai-agent-toolbox-cost-secrets.md`

### 封面設計

| 維度 | 選擇 | 理由 |
|------|------|------|
| Type | conceptual | 概念性主題 |
| Palette | **dark** | 「秘訣」暗示機密感 |
| Rendering | digital | 技術文章 |
| Text | title-only | 標題「成本秘訣」|
| Mood | dramatic | 強調重要性 |
| Aspect | 2.35:1 | 統一格式 |

**輸出**：`cover-cost-secrets.png`

### 插圖設計

| 維度 | 選擇 | 理由 |
|------|------|------|
| Type | infographic | 成本數據為主 |
| Style | **blueprint** | 技術分析文章，需要精確感 |
| Density | balanced | 4 張 |

**設計語言**：
- 背景：Blueprint Off-White (#FAF8F5)
- 主色：Engineering Blue (#2563EB)
- 輔色：Navy Blue (#1E3A5F)
- 強調：Amber (#F59E0B)
- 文字：Deep Slate (#334155)
- 線條：90 度直角，無曲線
- 網格：工程圖紙背景

**插圖清單**：

| # | 檔案 | 類型 | 主題 |
|---|------|------|------|
| 1 | illustration-01-system-architecture.png | framework | 訂閱制系統架構 |
| 2 | illustration-02-scale-economics.png | infographic | 規模經濟分析 |
| 3 | illustration-03-delivery-models.png | comparison | 交付模式對比 |
| 4 | illustration-04-expert-advice.png | infographic | 專家建議摘要 |

**輸出目錄**：`illustrations-cost-secrets/`

---

## 文章三：Agent Skills × ERP 智慧層實作方案

**檔案**：`agent-skills-erp-implementation-plan.md`

### 封面設計

| 維度 | 選擇 | 理由 |
|------|------|------|
| Type | conceptual | AI + ERP 融合概念 |
| Palette | **cool** | 企業級技術方案，專業冷靜 |
| Rendering | digital | 系統整合主題 |
| Text | title-only | 標題「AI × ERP 智慧層」|
| Mood | balanced | 穩重可信 |
| Aspect | 2.35:1 | 統一格式 |

**視覺概念**：
- 兩個互連球體：AI（神經網路紋理）+ ERP（結構化資料網格）
- 中央融合區發光，標註「智慧層」
- 色彩：Cyan 漸層（AI）+ Navy 實色（ERP）

**輸出**：`cover-erp-implementation.png`

### 插圖設計

| 維度 | 選擇 | 理由 |
|------|------|------|
| Type | mixed | framework + infographic + comparison |
| Style | **blueprint** | 配合封面 cool 色調，技術架構文章 |
| Density | balanced | 4 張 |

**設計語言**：沿用 Cost Secrets 的 blueprint 風格

**插圖清單**：

| # | 檔案 | 類型 | 主題 |
|---|------|------|------|
| 1 | illustration-01-ai-erp-division.png | framework | AI 做人的事，ERP 做機器的事 |
| 2 | illustration-02-seven-scenarios.png | infographic | 七大應用場景概覽 |
| 3 | illustration-03-edge-ai-architecture.png | framework | Edge AI 混合架構 |
| 4 | illustration-04-before-after-comparison.png | comparison | 傳統 ERP vs ERP + Agent |

**輸出目錄**：`illustrations-erp-implementation/`

---

## 風格選擇決策樹

```
文章主題
├── 面向一般讀者 / 非技術人員
│   └── warm 風格 + warm/vibrant 封面
│
├── 技術架構 / 系統設計
│   └── blueprint 風格 + cool 封面
│
├── 成本分析 / 商業機密
│   └── blueprint 風格 + dark 封面
│
└── 混合內容
    └── 根據核心訊息選擇主風格
```

---

## 經驗總結

### 封面生成

1. **中文字體風險**：AI 圖像生成偶爾產生錯誤中文字
   - 解法：重新生成，不要試圖「強調不要文字」
   - 保持原本的 title 設定，讓 AI 重試

2. **色調與主題匹配**：
   - warm → 親和、入門、面向大眾
   - cool → 專業、技術、企業級
   - dark → 機密、深度、獨家

3. **Aspect Ratio 選擇**：
   - 2.35:1（電影寬幅）：視覺張力強，適合封面
   - 16:9：標準寬螢幕，適合插圖

### 插圖生成

1. **風格統一原則**：同一篇文章的插圖應使用相同風格

2. **與封面協調**：插圖風格應配合封面色調
   - cool 封面 → blueprint 插圖
   - warm 封面 → warm 插圖

3. **Blueprint 風格設計語言**：
   - 90 度直角線條
   - 工程圖紙網格背景
   - 標註式文字（dimension labels）
   - 藍色系主色調
   - 無裝飾性曲線

4. **並行生成**：4 張圖可同時背景生成，節省時間

---

## 偏好設定檔

專案級偏好設定位於：

```
.baoyu-skills/
├── baoyu-cover-image/
│   └── EXTEND.md      # 封面偏好：hero, warm, digital, 2.35:1
└── baoyu-article-illustrator/
    └── EXTEND.md      # 插圖偏好：warm style, illustrations-subdir
```

**注意**：這些是預設值，實際生成時會根據文章內容調整

---

*紀錄日期：2026-01-28*
