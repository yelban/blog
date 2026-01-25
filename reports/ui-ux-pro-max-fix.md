# UI/UX Pro Max Skill 安裝問題與修復

**日期**：2026-01-25
**影響範圍**：`/ui-ux-pro-max` skill 的搜尋功能無法使用

---

## 問題描述

執行 `/ui-ux-pro-max` 時，Python 腳本報錯找不到檔案：

```
can't open file '.claude/skills/ui-ux-pro-max/scripts/search.py': [Errno 2] No such file or directory
```

---

## 問題原因

### 1. `uipro init` 的設計缺陷

`uipro-cli` 的安裝流程：

```
1. 下載 GitHub release 到 /tmp/ 臨時目錄
2. 在專案的 .claude/skills/ 建立 symlinks 指向 /tmp/
3. 系統清理 /tmp/ 後，symlinks 變成 dangling symlinks（失效）
```

檢查發現的 symlinks：

```bash
$ ls -la .claude/skills/ui-ux-pro-max/
data -> /var/folders/.../T/uipro-XXXXXX/.../data      # 指向已清除的臨時目錄
scripts -> /var/folders/.../T/uipro-XXXXXX/.../scripts # 指向已清除的臨時目錄
SKILL.md                                               # 這個是實際檔案
```

### 2. 重複安裝造成混淆

發現兩個目錄都有安裝：

| 位置 | Symlink 目標 | 狀態 |
|------|-------------|------|
| `blog/.claude/skills/ui-ux-pro-max/` | `/T/uipro-Bpq0Bv/...` | ❌ 失效 |
| `blog/reports/.claude/skills/ui-ux-pro-max/` | `/T/uipro-4ZPjFc/...` | ❌ 失效 |

兩個臨時目錄都已被系統清除。

---

## 修復步驟

### Step 1: 移除壞掉的 skill

```bash
# 移除兩個目錄的失效 symlinks
rm -rf /Users/orz99/zoo/blog/reports/.claude/skills/ui-ux-pro-max
rm -rf /Users/orz99/zoo/blog/.claude/skills/ui-ux-pro-max
```

### Step 2: 從 GitHub 下載原始碼

```bash
cd /tmp
curl -sL https://github.com/nextlevelbuilder/ui-ux-pro-max-skill/archive/refs/heads/main.zip -o uipro.zip
unzip -q -o uipro.zip
```

### Step 3: 複製實際檔案（非 symlinks）

```bash
# 建立目標目錄（在 git root 層級）
mkdir -p /Users/orz99/zoo/blog/.claude/skills/ui-ux-pro-max

# 複製實際檔案
cp -r /tmp/ui-ux-pro-max-skill-main/src/ui-ux-pro-max/data /Users/orz99/zoo/blog/.claude/skills/ui-ux-pro-max/
cp -r /tmp/ui-ux-pro-max-skill-main/src/ui-ux-pro-max/scripts /Users/orz99/zoo/blog/.claude/skills/ui-ux-pro-max/
cp /tmp/ui-ux-pro-max-skill-main/.claude/skills/ui-ux-pro-max/SKILL.md /Users/orz99/zoo/blog/.claude/skills/ui-ux-pro-max/
```

### Step 4: 驗證安裝

```bash
# 確認是實際目錄（非 symlinks）
ls -la /Users/orz99/zoo/blog/.claude/skills/ui-ux-pro-max/
# 應顯示 drwxr-xr-x（目錄），而非 lrwxr-xr-x（symlink）

# 測試搜尋功能
python3 /Users/orz99/zoo/blog/.claude/skills/ui-ux-pro-max/scripts/search.py "accessibility" --domain ux -n 3
```

### Step 5: 清理臨時檔案

```bash
rm -rf /tmp/ui-ux-pro-max-skill-main /tmp/uipro.zip
```

---

## 最終配置

```
blog/
├── .claude/
│   └── skills/
│       └── ui-ux-pro-max/     ✅ 實際檔案（永久有效）
│           ├── data/          # CSV 資料庫
│           ├── scripts/       # Python 搜尋腳本
│           └── SKILL.md       # Skill 定義
└── reports/
    └── .claude/
        └── skills/            # 不需要重複安裝
```

---

## 預防措施

### 不要使用 `uipro init`

官方 CLI 的 symlink 設計會導致問題。改用手動安裝：

```bash
# 手動安裝步驟（一次性）
cd /tmp
curl -sL https://github.com/nextlevelbuilder/ui-ux-pro-max-skill/archive/refs/heads/main.zip -o uipro.zip
unzip -q -o uipro.zip

# 複製到專案
mkdir -p <your-project>/.claude/skills/ui-ux-pro-max
cp -r ui-ux-pro-max-skill-main/src/ui-ux-pro-max/{data,scripts} <your-project>/.claude/skills/ui-ux-pro-max/
cp ui-ux-pro-max-skill-main/.claude/skills/ui-ux-pro-max/SKILL.md <your-project>/.claude/skills/ui-ux-pro-max/

# 清理
rm -rf /tmp/ui-ux-pro-max-skill-main /tmp/uipro.zip
```

### 只在 Git Root 安裝一次

不要在子目錄重複安裝，Claude Code 會自動向上查找 `.claude/skills/`。

---

## 相關資源

- **GitHub Repo**: https://github.com/nextlevelbuilder/ui-ux-pro-max-skill
- **NPM Package**: `uipro-cli`（有 symlink 問題，不建議使用）
- **版本**: 2.2.0

---

## 附錄：問題診斷指令

```bash
# 檢查 symlink 狀態
ls -la .claude/skills/ui-ux-pro-max/

# 如果顯示 lrwxr-xr-x 且指向 /var/folders/.../T/...，表示是壞掉的 symlink

# 檢查 symlink 目標是否存在
readlink -f .claude/skills/ui-ux-pro-max/scripts

# 測試 Python 腳本
python3 .claude/skills/ui-ux-pro-max/scripts/search.py --help
```
