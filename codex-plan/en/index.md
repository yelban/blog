# Don't Let One AI Do Everything

**Claude Code × Codex CLI**

Use `/codex-plan` to split work between two AIs: Claude asks questions, Codex writes the plan. Each plays to its strengths for better output.

**Original source:** [am.will @LLMJunky](https://x.com/LLMJunky) | [Original post →](https://x.com/LLMJunky/status/2013155739632549995)

The codex-plan.md source code in this article comes from the original post, with added deployment and usage instructions. You can copy codex-plan.md directly into your .claude/commands/ directory.

---

## Problem: Planning Phase Burns Your Tokens and Time

### 🔥 Opus is Expensive, Wasteful for Planning

Planning requires heavy reasoning. Every time Opus thinks through architecture, tokens burn fast.

### 🐛 Poor Planning = Bugs Later

Jump straight into coding: messy architecture, unclear dependencies, hard to maintain. Save planning time, pay double in debugging.

### 🔀 Tool-Switching is Annoying

Plan in ChatGPT, copy to Claude Code for implementation, paste back and forth, context breaks.

### ❓ Inconsistent Prompt Quality

Self-written planning prompts often miss things. Codex gets vague instructions, produces vague output.

> **Solution:** Use GPT-5.2 Codex's xhigh reasoning for planning—fewer bugs, more maintainable code, cleaner implementations. Let the strongest reasoner plan, let the best coder implement. Play to their strengths.

![Four Pain Points](../illustrations/codex-plan-guide/illustration-pain-points.png)

---

## What is /codex-plan?

`/codex-plan` is a Claude Code Slash Command. It lets you invoke OpenAI's Codex CLI directly from the terminal, producing detailed implementation plans with dependency tracking.

- 💬 **Claude asks questions** — Uses AskUser to clarify requirements and gather context
- 🧠 **Codex deep reasoning** — Uses xhigh reasoning to produce structured plans
- 📋 **Outputs work breakdown** — Tags dependencies, enables parallel execution

![Claude × Codex Collaboration Workflow](../illustrations/codex-plan-guide/illustration-workflow.png)

---

## Why This Approach?

### 🎯 Interaction Handled by Claude

Claude Code's `AskUser` is smoother than Codex CLI's interaction mechanism. Conversation stays conversation, computation stays computation.

### 💰 Token Cost Shifted

Opus is expensive. Let Codex handle planning with xhigh reasoning. OpenAI subscription does the heavy lifting, Anthropic quota saved for implementation.

### ⚡ No Context Switching

Everything in terminal: input command, answer questions, wait for results, start coding. No browser, no window switching.

### 🔀 Parallel Execution with Dependencies

Each Task tags Dependencies. Tasks without dependencies can run in multiple instances simultaneously. This is a work distribution table.

### ✨ Higher Prompt Quality

User-written prompts are often vague. Claude asks first, organizes, then feeds to Codex. Extra filtering layer in between, more precise output.

### 📦 Workflow Packaged into One Command

No need to remember Codex CLI parameters, no manual prompt assembly. Slash command has it packaged. Reuse cost approaches zero.

![Six Benefits](../illustrations/codex-plan-guide/illustration-benefits.png)

---

## How to Use

### 1. Install Codex CLI

```bash
npm install -g @openai/codex
export OPENAI_API_KEY="sk-..."
```

### 2. Create Slash Command File

Place in project or global directory:

```
# Project level
.claude/commands/codex-plan.md

# Global level
~/.claude/commands/codex-plan.md
```

### 3. Execute

```
/codex-plan implement user authentication system
```

![Three-Step Setup Process](../illustrations/codex-plan-guide/illustration-setup-steps.png)

---

## What is .claude/commands?

`.claude/commands/` is Claude Code's custom command directory. `.md` files placed here become executable Slash Commands.

### 📁 Storage Locations

- `.claude/commands/` — Project level, only works in that project
- `~/.claude/commands/` — Global level, works in all projects

### ⚡ Trigger Method

Filename becomes command name. `codex-plan.md` → `/codex-plan`

### What Can Commands Do?

| Feature | Description |
|---------|-------------|
| 🔧 Package complex workflows | Wrap multi-step work into one command for reuse |
| 🛠️ Specify available tools | Use `allowed-tools` to limit tools Claude can use |
| 💬 Accept arguments | `$ARGUMENTS` receives user input |
| 🤖 Invoke external CLIs | Execute any command-line tool via Bash |
| ❓ Interactive Q&A | Use `AskUser` to collect more information |
| 📝 Read/write files | Auto-generate docs, code, plans |

![Commands Six Features](../illustrations/codex-plan-guide/illustration-commands-features.png)

> 💡 **Essence:** Commands are System Prompts for Claude. You're defining Claude's behavior mode, available tools, and output format for this command.

---

## Complete codex-plan.md

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

## Line-by-Line Explanation: Why Write It This Way?

Understand the design intent of each section so you can customize it.

### Frontmatter (YAML Configuration)

```yaml
---
description: Create a detailed implementation plan using Codex with xhigh reasoning
argument-hint: "<what you want to plan>"
allowed-tools: Read, Write, Bash, AskUser
---
```

| Field | Description |
|-------|-------------|
| `description` | Command description, shows in Claude Code's command list, helps you remember what this command does |
| `argument-hint` | Parameter hint, tells users what to input. E.g., `/codex-plan implement auth system` |
| `allowed-tools` | Limits Claude to these four tools: read files, write files, execute Bash, ask user questions. This is a security boundary. |

### $ARGUMENTS Variable

```markdown
## User Request

```
$ARGUMENTS
```
```

`$ARGUMENTS` is a Claude Code built-in variable. When user inputs `/codex-plan implement user auth`, the text `implement user auth` automatically replaces it.

### AskUser Clarifying Questions

```markdown
## Step 2: Ask Clarifying Questions

**Use AskUser to ask 3-6 targeted clarifying questions** before generating the plan.
```

- **Why ask questions?** User's initial input is usually vague. "Implement auth" could be email/password, OAuth, SSO, magic links... Without clarification, Codex can only guess.
- **Why use AskUser?** Claude Code's AskUser tool is smoother than Codex CLI's interaction, can ask multiple questions at once, supports formatted display. Hand interaction to Claude, let Codex focus on reasoning.
- **Why 3-6 questions?** Too few won't clarify enough, too many annoys users. 3-6 is the sweet spot.

### Execute Codex CLI

```bash
codex exec --full-auto --skip-git-repo-check \
  -c model=gpt-5.2-codex \
  -c model_reasoning_effort=xhigh \
  --output-last-message /tmp/codex-plan-result.txt \
  "YOUR_CRAFTED_PROMPT_HERE"
```

| Parameter | Description |
|-----------|-------------|
| `--full-auto` | Full auto mode, Codex won't ask questions mid-execution, runs to completion |
| `--skip-git-repo-check` | Skip Git check, avoids errors in non-Git directories |
| `model=gpt-5.2-codex` | Specify model. GPT-5.2 Codex is currently the strongest reasoning model, specialized for code development and planning |
| `model_reasoning_effort=xhigh` | Highest reasoning intensity, makes model spend more time thinking, produces more complete plans |
| `--output-last-message` | Saves Codex's final output to file for easy reading later |

### Dependencies Annotation

```markdown
### Task 1.1: [Task Name]
- **Dependencies**: [Task IDs this depends on, e.g., "None" or "1.2, 2.1"]

## Dependency Graph
- Tasks with no dependencies: [list - these can start immediately]
- Task dependency chains: [show critical path]
```

- **Why tag dependencies?** Knowing which tasks have no prerequisites enables running multiple Claude Code instances in parallel. This is the foundation for swarm mode.
- **What's Dependency Graph for?** See the critical path at a glance, know which tasks blocking would slow overall progress.

### Key Instruction: Forbid Codex from Asking Questions

```markdown
**Critical instruction to include:** Tell Codex to NOT ask any further clarifying questions - it has all the information it needs and should just write the plan and save the file.
```

**This line is crucial.** Without it, Codex might stop and ask questions, but it's invoked through CLI with no interactive interface. Add this line to force direct output, no waiting for responses.

---

## This is the Prototype of Agent Orchestration

One Agent gathers requirements, another Agent executes specialized tasks, results returned and presented.

**Claude gathers requirements** → **Codex plans** → **Claude implements** → **Review** → **Loop**

`/codex-plan` is the minimum viable version.

![Agent Orchestration Loop](../illustrations/codex-plan-guide/illustration-agent-orchestration.png)

---

## Don't Ask Which AI is Strongest

**Ask how to make them work together.**

---

*Claude Code × Codex CLI — AI Agent Division of Labor*
