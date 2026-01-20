# 別讓一個 AI 做所有事

**Claude Code × Codex CLI**

用 `/codex-plan` 把工作拆給兩個 AI：Claude 問問題，Codex 寫計劃。各司其職，產出更強。

**原始碼出處：** [am.will @LLMJunky](https://x.com/LLMJunky) | [原帖連結 →](https://x.com/LLMJunky/status/2013155739632549995)

本文 codex-plan.md 原始碼來自原帖內容，並加入實際部署與使用的步驟說明。你可以直接複製 codex-plan.md，放進自己的 .claude/commands/ 目錄使用。

---

## 問題：規劃階段吃掉你的 Token 和時間

### 🔥 Opus 貴，用來規劃太浪費

規劃需要大量推理。每次讓 Opus 想清楚架構，token 就燒掉一大截。

### 🐛 沒規劃好，後面全是 Bug

直接開寫，架構混亂、依賴不清、維護困難。省了規劃時間，debug 時間加倍奉還。

### 🔀 切換工具很煩

用 ChatGPT 規劃，複製到 Claude Code 實作，來回貼上，上下文斷裂。

### ❓ Prompt 品質不穩定

自己寫的規劃 prompt 常常漏東漏西，Codex 收到模糊指令，產出也模糊。

> **解法：** 用 GPT-5.2 Codex 的 xhigh reasoning 做規劃，產出 fewer bugs、more maintainable code、cleaner implementations。規劃交給推理最強的，實作交給 coding 最擅長的。各取所長。

![四大痛點](./illustrations/codex-plan-guide/illustration-pain-points.png)

---

## 什麼是 /codex-plan？

`/codex-plan` 是一個 Claude Code 的 Slash Command。它讓你在終端機裡直接調用 OpenAI 的 Codex CLI，產出帶有依賴關係的詳細實作計劃。

- 💬 **Claude 問問題** — 用 AskUser 釐清需求、收集上下文
- 🧠 **Codex 深度推理** — 用 xhigh reasoning 產出結構化計劃
- 📋 **輸出工作分配表** — 標註依賴關係，可平行執行

![Claude × Codex 協作流程](./illustrations/codex-plan-guide/illustration-workflow.png)

---

## 為什麼這樣做？

### 🎯 互動交給 Claude

Claude Code 的 `AskUser` 比 Codex CLI 的互動機制更流暢。對話歸對話，運算歸運算。

### 💰 Token 成本轉嫁

Opus 貴。讓 Codex 用 xhigh reasoning 扛規劃。OpenAI 訂閱吃重活，Anthropic 額度留給實作。

### ⚡ 不切環境

全程在終端機：輸入指令、回答問題、等結果、開始寫 code。不開瀏覽器，不跳視窗。

### 🔀 平行執行有依據

每個 Task 標註 Dependencies。沒依賴的任務，開多個 instance 同時跑。這是工作分配表。

### ✨ Prompt 品質拉高

用戶寫 prompt 常常含糊。Claude 先問、先整理，再餵給 Codex。中間多一層過濾，產出更精準。

### 📦 流程封裝成一條指令

不用記 Codex CLI 參數，不用手組 prompt。Slash command 包好了。重複使用成本趨近零。

![六大優勢](./illustrations/codex-plan-guide/illustration-benefits.png)

---

## 如何使用

### 1. 安裝 Codex CLI

```bash
npm install -g @openai/codex
export OPENAI_API_KEY="sk-..."
```

### 2. 建立 Slash Command 檔案

放在專案或全域目錄：

```
# 專案層級
.claude/commands/codex-plan.md

# 全域層級
~/.claude/commands/codex-plan.md
```

### 3. 執行

```
/codex-plan 實作用戶認證系統
```

![三步驟安裝流程](./illustrations/codex-plan-guide/illustration-setup-steps.png)

---

## 什麼是 .claude/commands？

`.claude/commands/` 是 Claude Code 的自訂指令目錄。放在這裡的 `.md` 檔案會變成可執行的 Slash Command。

### 📁 存放位置

- `.claude/commands/` — 專案層級，只在該專案生效
- `~/.claude/commands/` — 全域層級，所有專案都能用

### ⚡ 觸發方式

檔名就是指令名。`codex-plan.md` → `/codex-plan`

### Commands 能做什麼？

| 功能 | 說明 |
|------|------|
| 🔧 封裝複雜流程 | 把多步驟工作包成一條指令，重複使用 |
| 🛠️ 指定可用工具 | 用 `allowed-tools` 限制 Claude 能用的工具 |
| 💬 接收參數 | `$ARGUMENTS` 接收使用者輸入 |
| 🤖 調用外部 CLI | 透過 Bash 執行任何命令列工具 |
| ❓ 互動問答 | 用 `AskUser` 收集更多資訊 |
| 📝 讀寫檔案 | 自動產生文件、程式碼、計劃 |

![Commands 六大功能](./illustrations/codex-plan-guide/illustration-commands-features.png)

> 💡 **本質：** Commands 是給 Claude 的 System Prompt。你在定義 Claude 在這個指令下的行為模式、可用工具、輸出格式。

---

## 完整 codex-plan.md

```markdown
---
description: Create a detailed implementation plan using Codex with xhigh reasoning
argument-hint: "<what you want to plan>"
allowed-tools: Read, Write, Bash, AskUser
---

# Codex Plan Command

You are being asked to create a detailed implementation plan using a Codex subagent. Your job is to:
1. Understand the user's planning request
2. Ask clarifying questions using AskUser to improve plan quality
3. Craft an excellent, detailed prompt for Codex
4. Execute Codex to generate and save the plan

**Always uses:** `gpt-5.2-codex` with `xhigh` reasoning

## User Request

```
$ARGUMENTS
```

## Step 1: Analyze the Request

Look at what the user wants to plan. Identify:
- What is the core goal?
- What technology/domain is involved?
- What aspects are ambiguous or underspecified?
- What decisions would significantly impact the plan?

## Step 2: Ask Clarifying Questions

**Use AskUser to ask 3-6 targeted clarifying questions** before generating the plan.

Good clarifying questions:
- Narrow down scope and requirements
- Clarify technology choices
- Understand constraints (time, budget, team size)
- Identify must-haves vs nice-to-haves
- Uncover integration requirements
- Determine security/compliance needs

### Example Question Patterns

**For "implement auth":**
- What authentication methods do you need? (email/password, OAuth providers like Google/GitHub, SSO, magic links)
- Do you need role-based access control (RBAC) or just authenticated/unauthenticated?
- What's your backend stack? (Node/Express, Python/Django, etc.)
- Where will you store user credentials/sessions? (Database, Redis, JWT stateless)
- Do you need features like: password reset, email verification, 2FA?
- Any compliance requirements? (SOC2, GDPR, HIPAA)

**For "build an API":**
- What resources/entities does this API need to manage?
- REST or GraphQL?
- What authentication will the API use?
- Expected scale/traffic?
- Do you need rate limiting, caching, versioning?

**For "migrate to microservices":**
- Which parts of the monolith are you migrating first?
- What's your deployment target? (K8s, ECS, etc.)
- How will services communicate? (REST, gRPC, message queues)
- What's your timeline and team capacity?

**For "add testing":**
- What testing levels do you need? (unit, integration, e2e)
- What's your current test coverage?
- What frameworks do you prefer or already use?
- What's the most critical functionality to test first?

## Step 3: Gather Context

After getting answers, also gather relevant context:
- Read key files in the codebase if applicable
- Check existing architecture/patterns
- Note any existing plans or documentation

## Step 4: Craft the Codex Prompt

Create a detailed prompt that includes:
1. **Clear objective** - What plan needs to be created
2. **All requirements** - Everything learned from clarifying questions
3. **Constraints** - Technology choices, timeline, team size
4. **Context** - Relevant codebase info, existing patterns
5. **Plan structure** - What sections the plan should include
6. **Output instructions** - Write to `codex-plan.md` in current directory

**Critical instruction to include:** Tell Codex to NOT ask any further clarifying questions - it has all the information it needs and should just write the plan and save the file.

## Step 5: Execute Codex

```bash
codex exec --full-auto --skip-git-repo-check \
  -c model=gpt-5.2-codex \
  -c model_reasoning_effort=xhigh \
  --output-last-message /tmp/codex-plan-result.txt \
  "YOUR_CRAFTED_PROMPT_HERE"
```

Then show the results:
```bash
cat /tmp/codex-plan-result.txt
```

## Plan Output Structure

The generated plan should follow this template:

```markdown
# Plan: [Task Name]

**Generated**: [Date]
**Estimated Complexity**: [Low/Medium/High]

## Overview
[Brief summary of what needs to be done and the general approach, including recommended libraries/tools]

## Prerequisites
- [Dependencies or requirements that must be met first]
- [Tools, libraries, or access needed]

## Phase 1: [Phase Name]
**Goal**: [What this phase accomplishes]

### Task 1.1: [Task Name]
- **Location**: [File paths or components involved]
- **Description**: [What needs to be done]
- **Dependencies**: [Task IDs this depends on, e.g., "None" or "1.2, 2.1"]
- **Complexity**: [1-10]
- **Test-First Approach**:
  - [Test to write before implementation]
  - [What the test should verify]
- **Acceptance Criteria**:
  - [Specific, testable criteria]

### Task 1.2: [Task Name]
[Same structure...]

## Phase 2: [Phase Name]
[...]

## Testing Strategy
- **Unit Tests**: [What to unit test, frameworks to use]
- **Integration Tests**: [API/service integration tests]
- **E2E Tests**: [Critical user flows to test end-to-end]
- **Test Coverage Goals**: [Target coverage percentage]

## Dependency Graph
[Show which tasks can run in parallel vs which must be sequential]
- Tasks with no dependencies: [list - these can start immediately]
- Task dependency chains: [show critical path]

## Potential Risks
- [Things that could go wrong]
- [Mitigation strategies]

## Rollback Plan
- [How to undo changes if needed]
```

### Task Guidelines
Each task must:
- Be specific and actionable (not vague)
- Have clear inputs and outputs
- Be independently testable
- Include file paths and specific code locations
- Include dependencies so parallel execution is possible
- Include complexity score (1-10)

Break large tasks into smaller ones:
- ✗ Bad: "Implement Google OAuth"
- ✓ Good:
  - "Add Google OAuth config to environment variables"
  - "Install and configure passport-google-oauth20 package"
  - "Create OAuth callback route handler in src/routes/auth.ts"
  - "Add Google sign-in button to login UI"
  - "Write integration tests for OAuth flow"

## Important Notes

- **Always ask clarifying questions first** - Don't skip this step
- **Use AskUser tool** - This is interactive planning
- **Tell Codex not to ask questions** - It should just execute
- **Output file:** `codex-plan.md` in current working directory
- **Use --full-auto** for autonomous execution

Now analyze the user's planning request above, ask your clarifying questions, and then generate and execute the Codex plan.
```

---

## 逐行解析：為什麼這樣寫？

理解每一段指令的設計意圖，方便你自訂修改。

### Frontmatter（YAML 設定區）

```yaml
---
description: Create a detailed implementation plan using Codex with xhigh reasoning
argument-hint: "<what you want to plan>"
allowed-tools: Read, Write, Bash, AskUser
---
```

| 欄位 | 說明 |
|------|------|
| `description` | 指令說明，會顯示在 Claude Code 的指令列表中，幫助你記住這個指令的用途 |
| `argument-hint` | 參數提示，告訴使用者要輸入什麼。例如 `/codex-plan 實作認證系統` |
| `allowed-tools` | 限制 Claude 只能用這四個工具：讀檔、寫檔、執行 Bash、問用戶問題。這是安全邊界。 |

### $ARGUMENTS 變數

```markdown
## User Request

```
$ARGUMENTS
```
```

`$ARGUMENTS` 是 Claude Code 的內建變數。使用者輸入 `/codex-plan 實作用戶認證` 時，`實作用戶認證` 這段文字會自動替換進來。

### AskUser 釐清問題

```markdown
## Step 2: Ask Clarifying Questions

**Use AskUser to ask 3-6 targeted clarifying questions** before generating the plan.
```

- **為什麼要問問題？** 用戶的初始輸入通常很模糊。「實作認證」可以是 email/password、OAuth、SSO、magic link⋯⋯不問清楚，Codex 只能猜。
- **為什麼用 AskUser？** Claude Code 的 AskUser 工具比 Codex CLI 的互動更流暢，能一次問多題、支援格式化顯示。把互動環節交給 Claude，Codex 專心做推理。
- **為什麼 3-6 題？** 太少問不清楚，太多用戶會煩。3-6 題是經驗值。

### 執行 Codex CLI

```bash
codex exec --full-auto --skip-git-repo-check \
  -c model=gpt-5.2-codex \
  -c model_reasoning_effort=xhigh \
  --output-last-message /tmp/codex-plan-result.txt \
  "YOUR_CRAFTED_PROMPT_HERE"
```

| 參數 | 說明 |
|------|------|
| `--full-auto` | 全自動模式，Codex 不會中途問你問題，直接跑完 |
| `--skip-git-repo-check` | 跳過 Git 檢查，避免在非 Git 目錄報錯 |
| `model=gpt-5.2-codex` | 指定模型。GPT-5.2 Codex 是目前推理能力最強的模型，專門用於程式碼開發與規劃 |
| `model_reasoning_effort=xhigh` | 最高推理強度，讓模型花更多時間思考，產出更完整的計劃 |
| `--output-last-message` | 把 Codex 的最後輸出存到檔案，方便後續讀取顯示 |

### Dependencies 依賴標註

```markdown
### Task 1.1: [Task Name]
- **Dependencies**: [Task IDs this depends on, e.g., "None" or "1.2, 2.1"]

## Dependency Graph
- Tasks with no dependencies: [list - these can start immediately]
- Task dependency chains: [show critical path]
```

- **為什麼要標依賴？** 知道哪些任務沒有前置依賴，就能同時開多個 Claude Code instance 平行執行。這是 swarm 模式的基礎。
- **Dependency Graph 的作用？** 一眼看出關鍵路徑（critical path），知道哪些任務卡住會拖慢整體進度。

### 關鍵指令：禁止 Codex 問問題

```markdown
**Critical instruction to include:** Tell Codex to NOT ask any further clarifying questions - it has all the information it needs and should just write the plan and save the file.
```

**這行很重要。** 如果不加，Codex 可能會停下來問你問題，但它是透過 CLI 被調用的，根本沒有互動介面。加上這行，強制它直接輸出，不要等待回應。

---

## 這是 Agent 編排的雛形

一個 Agent 收需求，另一個 Agent 執行專業任務，結果回傳呈現。

**Claude 收需求** → **Codex 規劃** → **Claude 實作** → **Review** → **循環**

`/codex-plan` 是最小可行版本。

![Agent 編排循環](./illustrations/codex-plan-guide/illustration-agent-orchestration.png)

---

## 不要問哪個 AI 最強

**問怎麼讓它們配合。**

---

*Claude Code × Codex CLI — AI Agent 分工模式*
