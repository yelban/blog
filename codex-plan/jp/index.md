# 一つのAIにすべてを任せるな

**Claude Code × Codex CLI**

`/codex-plan` を使って作業を2つのAIに分担：Claudeが質問し、Codexが計画を書く。それぞれの強みを活かして、より良いアウトプットを。

**オリジナルソース:** [am.will @LLMJunky](https://x.com/LLMJunky) | [元の投稿 →](https://x.com/LLMJunky/status/2013155739632549995)

この記事の codex-plan.md ソースコードは元の投稿からのもので、デプロイと使用方法の説明を追加しています。codex-plan.md を直接 .claude/commands/ ディレクトリにコピーできます。

---

## 問題：計画フェーズがトークンと時間を消費する

### 🔥 Opusは高価、計画には無駄

計画には重い推論が必要。Opusがアーキテクチャを考えるたびに、トークンが急速に消費される。

### 🐛 計画不足 = 後でバグ

いきなりコーディング：混乱したアーキテクチャ、不明確な依存関係、メンテナンスしにくい。計画時間を節約して、デバッグで倍返し。

### 🔀 ツール切り替えが面倒

ChatGPTで計画、Claude Codeで実装、コピペの往復、コンテキストが途切れる。

### ❓ プロンプト品質が不安定

自作の計画プロンプトは漏れが多い。Codexが曖昧な指示を受け取ると、曖昧なアウトプットになる。

> **解決策:** GPT-5.2 Codexのxhigh推論を計画に使う—バグが少なく、メンテナンスしやすいコード、クリーンな実装。最強の推論者に計画させ、最高のコーダーに実装させる。それぞれの強みを活かす。

![4つの課題](./illustrations/codex-plan-guide/illustration-pain-points.png)

---

## /codex-plan とは？

`/codex-plan` はClaude Codeのスラッシュコマンド。ターミナルから直接OpenAIのCodex CLIを呼び出し、依存関係を追跡した詳細な実装計画を作成できる。

- 💬 **Claudeが質問** — AskUserを使って要件を明確化し、コンテキストを収集
- 🧠 **Codexの深い推論** — xhigh推論で構造化された計画を作成
- 📋 **作業分解を出力** — 依存関係をタグ付け、並列実行を可能に

![Claude × Codex コラボレーションワークフロー](./illustrations/codex-plan-guide/illustration-workflow.png)

---

## なぜこのアプローチ？

### 🎯 対話はClaudeが担当

Claude Codeの`AskUser`はCodex CLIの対話メカニズムよりスムーズ。会話は会話のまま、計算は計算のまま。

### 💰 トークンコストをシフト

Opusは高価。Codexにxhigh推論で計画を任せる。OpenAIサブスクリプションが重い処理を担当、Anthropicの枠は実装に温存。

### ⚡ コンテキスト切り替えなし

すべてターミナルで完結：コマンド入力、質問に回答、結果を待つ、コーディング開始。ブラウザもウィンドウ切り替えも不要。

### 🔀 依存関係付き並列実行

各タスクに依存関係をタグ付け。依存関係のないタスクは複数インスタンスで同時実行可能。これは作業分配表。

### ✨ より高いプロンプト品質

ユーザーが書くプロンプトは曖昧になりがち。Claudeが先に質問し、整理してからCodexに渡す。間にフィルタリング層を入れて、より精密なアウトプット。

### 📦 ワークフローを1コマンドにパッケージ化

Codex CLIのパラメータを覚える必要なし、手動でプロンプトを組み立てる必要なし。スラッシュコマンドにパッケージ済み。再利用コストはほぼゼロ。

![6つのメリット](./illustrations/codex-plan-guide/illustration-benefits.png)

---

## 使い方

### 1. Codex CLIをインストール

```bash
npm install -g @openai/codex
export OPENAI_API_KEY="sk-..."
```

### 2. スラッシュコマンドファイルを作成

プロジェクトまたはグローバルディレクトリに配置：

```
# プロジェクトレベル
.claude/commands/codex-plan.md

# グローバルレベル
~/.claude/commands/codex-plan.md
```

### 3. 実行

```
/codex-plan implement user authentication system
```

![3ステップのセットアッププロセス](./illustrations/codex-plan-guide/illustration-setup-steps.png)

---

## .claude/commands とは？

`.claude/commands/` はClaude Codeのカスタムコマンドディレクトリ。ここに配置した `.md` ファイルは実行可能なスラッシュコマンドになる。

### 📁 保存場所

- `.claude/commands/` — プロジェクトレベル、そのプロジェクトでのみ動作
- `~/.claude/commands/` — グローバルレベル、すべてのプロジェクトで動作

### ⚡ トリガー方法

ファイル名がコマンド名になる。`codex-plan.md` → `/codex-plan`

### コマンドでできること

| 機能 | 説明 |
|---------|-------------|
| 🔧 複雑なワークフローをパッケージ化 | 複数ステップの作業を1コマンドにまとめて再利用 |
| 🛠️ 利用可能なツールを指定 | `allowed-tools` でClaudeが使えるツールを制限 |
| 💬 引数を受け取る | `$ARGUMENTS` でユーザー入力を受け取る |
| 🤖 外部CLIを呼び出す | Bash経由で任意のコマンドラインツールを実行 |
| ❓ インタラクティブQ&A | `AskUser` を使ってより多くの情報を収集 |
| 📝 ファイルの読み書き | ドキュメント、コード、計画を自動生成 |

![コマンドの6つの機能](./illustrations/codex-plan-guide/illustration-commands-features.png)

> 💡 **本質:** コマンドはClaudeのシステムプロンプト。このコマンドにおけるClaudeの動作モード、利用可能なツール、出力形式を定義している。

---

## 完全な codex-plan.md

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

## 行ごとの解説：なぜこう書くのか？

各セクションの設計意図を理解して、カスタマイズできるようにしよう。

### フロントマター（YAML設定）

```yaml
---
description: Create a detailed implementation plan using Codex with xhigh reasoning
argument-hint: "<what you want to plan>"
allowed-tools: Read, Write, Bash, AskUser
---
```

| フィールド | 説明 |
|-------|-------------|
| `description` | コマンドの説明、Claude Codeのコマンドリストに表示、このコマンドが何をするか覚えやすくする |
| `argument-hint` | パラメータのヒント、ユーザーに何を入力すべきか伝える。例: `/codex-plan implement auth system` |
| `allowed-tools` | Claudeをこの4つのツールに制限：ファイル読み込み、ファイル書き込み、Bash実行、ユーザーへの質問。これはセキュリティ境界。 |

### $ARGUMENTS 変数

```markdown
## User Request

```
$ARGUMENTS
```
```

`$ARGUMENTS` はClaude Code組み込み変数。ユーザーが `/codex-plan implement user auth` と入力すると、テキスト `implement user auth` が自動的に置き換えられる。

### AskUser による確認質問

```markdown
## Step 2: Ask Clarifying Questions

**Use AskUser to ask 3-6 targeted clarifying questions** before generating the plan.
```

- **なぜ質問するのか？** ユーザーの初期入力は通常曖昧。「認証を実装」はメール/パスワード、OAuth、SSO、マジックリンク...。確認なしでは、Codexは推測するしかない。
- **なぜAskUserを使うのか？** Claude CodeのAskUserツールはCodex CLIの対話よりスムーズで、複数の質問を一度に聞け、フォーマット表示をサポート。対話はClaudeに任せ、Codexは推論に集中。
- **なぜ3-6問？** 少なすぎると明確にならず、多すぎるとユーザーを困らせる。3-6がスイートスポット。

### Codex CLIの実行

```bash
codex exec --full-auto --skip-git-repo-check \
  -c model=gpt-5.2-codex \
  -c model_reasoning_effort=xhigh \
  --output-last-message /tmp/codex-plan-result.txt \
  "YOUR_CRAFTED_PROMPT_HERE"
```

| パラメータ | 説明 |
|-----------|-------------|
| `--full-auto` | フルオートモード、Codexは実行中に質問せず、完了まで実行 |
| `--skip-git-repo-check` | Gitチェックをスキップ、非Gitディレクトリでのエラーを回避 |
| `model=gpt-5.2-codex` | モデルを指定。GPT-5.2 Codexは現在最強の推論モデル、コード開発と計画に特化 |
| `model_reasoning_effort=xhigh` | 最高の推論強度、モデルにより多くの思考時間を与え、より完全な計画を作成 |
| `--output-last-message` | Codexの最終出力をファイルに保存、後で読みやすく |

### 依存関係のアノテーション

```markdown
### Task 1.1: [Task Name]
- **Dependencies**: [Task IDs this depends on, e.g., "None" or "1.2, 2.1"]

## Dependency Graph
- Tasks with no dependencies: [list - these can start immediately]
- Task dependency chains: [show critical path]
```

- **なぜ依存関係をタグ付けするのか？** 前提条件のないタスクを把握することで、複数のClaude Codeインスタンスを並列実行できる。これがスウォームモードの基盤。
- **Dependency Graphは何のため？** クリティカルパスを一目で把握、どのタスクがブロックすると全体の進行が遅れるかがわかる。

### 重要な指示：Codexに質問を禁止する

```markdown
**Critical instruction to include:** Tell Codex to NOT ask any further clarifying questions - it has all the information it needs and should just write the plan and save the file.
```

**この行は極めて重要。** これがないと、Codexは途中で質問するかもしれないが、CLIから呼び出されているので対話インターフェースがない。この行を追加して強制的に直接出力させ、応答を待たないようにする。

---

## これはエージェントオーケストレーションのプロトタイプ

1つのエージェントが要件を収集し、別のエージェントが専門タスクを実行、結果を返して提示。

**Claudeが要件収集** → **Codexが計画** → **Claudeが実装** → **レビュー** → **ループ**

`/codex-plan` は最小限の実用版。

![エージェントオーケストレーションループ](./illustrations/codex-plan-guide/illustration-agent-orchestration.png)

---

## どのAIが最強かを聞くな

**どうやって協力させるかを聞け。**

---

*Claude Code × Codex CLI — AIエージェントの分業*
