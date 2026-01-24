# Plan: Raw News Viewer with TTS

**Generated**: January 24, 2026
**Estimated Complexity**: Medium-High

## Overview
Build `./raw/index.html` as a static, no-build Markdown report viewer that mirrors `../news/index.html` styling and full TTS capabilities, but uses a three-level selector (YYYY-MM / DD / HH:MM) and a flexible filename parser to support multiple report naming patterns.

## Prerequisites
- `marked.js` via CDN (same as news implementation)
- `./raw/reports.json` index file (cache-busted) containing available report filenames
- Browser supports Web Speech API for default TTS fallback

## Phase 1: Core HTML Structure
### Task 1.1: Create base HTML
- **Location**: `./raw/index.html`
- **Description**: Scaffold HTML document structure with header, selectors, nav buttons, TTS controls, main content area, footer, autoplay overlay, and TTS settings modal (ported from `../news/index.html`).
- **Dependencies**: None
- **Complexity**: 2
- **Acceptance Criteria**: Page loads in browser with all major UI regions rendered, no JS errors.

### Task 1.2: Add 3-level selector UI
- **Location**: `./raw/index.html`
- **Description**: Replace the month/day selector with three `<select>` elements: `month-select` (YYYY-MM), `day-select` (DD), `time-select` (HH:MM), plus prev/next buttons in the same header row.
- **Dependencies**: Task 1.1
- **Complexity**: 2
- **Acceptance Criteria**: Three dropdowns exist with proper `aria-label`s and are visually aligned with nav buttons.

## Phase 2: CSS Styling (Port from news)
### Task 2.1: Port base theme and layout styles
- **Location**: `./raw/index.html` (inline `<style>`)
- **Description**: Copy CSS variables, typography, header/main/footer, and content styles from `../news/index.html` to ensure identical look and dark mode support.
- **Dependencies**: Task 1.1
- **Complexity**: 2
- **Acceptance Criteria**: UI matches the news page visual style, including light/dark modes and responsive layout.

### Task 2.2: Extend selector styling for time dropdown
- **Location**: `./raw/index.html`
- **Description**: Add styling for the new time selector, including hover/focus states and small-screen layout tweaks.
- **Dependencies**: Task 2.1
- **Complexity**: 1
- **Acceptance Criteria**: All three selects look consistent; layout remains usable on mobile.

### Task 2.3: Port TTS styles
- **Location**: `./raw/index.html`
- **Description**: Copy all TTS button, modal, overlay, and status indicator styles.
- **Dependencies**: Task 2.1
- **Complexity**: 2
- **Acceptance Criteria**: TTS buttons and modal match the reference implementation.

## Phase 3: File Detection & Selection Logic
### Task 3.1: Define report parsing with extensible filename patterns
- **Location**: `./raw/index.html` (script)
- **Description**: Implement a parser that accepts multiple filename patterns and extracts date/time components. Use a prioritized regex list to allow future expansion.
- **Dependencies**: Task 1.2
- **Complexity**: 3
- **Acceptance Criteria**: Parser returns `{ baseName, yyyy, mm, dd, hh, min, dateKey, timeKey, sortKey }` for supported patterns; unsupported names are ignored.

Example parsing structure:
```js
const patterns = [
  {
    // global_scan_20260124_1542
    regex: /^(?<prefix>.+)_(?<ymd>\d{8})_(?<hm>\d{4})$/,
    map: (m) => ({ ymd: m.groups.ymd, hm: m.groups.hm })
  },
  {
    // 20260124_1542_anything
    regex: /^(?<ymd>\d{8})_(?<hm>\d{4})_(?<suffix>.+)$/,
    map: (m) => ({ ymd: m.groups.ymd, hm: m.groups.hm })
  },
  {
    // 20260124-1542 or 20260124-1542-report
    regex: /^(?<ymd>\d{8})-(?<hm>\d{4})(?:-.+)?$/,
    map: (m) => ({ ymd: m.groups.ymd, hm: m.groups.hm })
  }
];
```

### Task 3.2: Load `reports.json` with cache-busting
- **Location**: `./raw/index.html`
- **Description**: Fetch `reports.json?v=...` and normalize its contents into a list of base filenames (no `.md`). Support either `{"reports":["name", ...]}` or `[{"file":"name"}]` shapes.
- **Dependencies**: Task 3.1
- **Complexity**: 3
- **Acceptance Criteria**: When `reports.json` exists, the app lists all valid reports without console errors.

### Task 3.3: Implement fallback detection when `reports.json` is missing
- **Location**: `./raw/index.html`
- **Description**: If `reports.json` fails to load, fall back to:
  1) If `?file=` is present, attempt to load it and include it in the list.
  2) Probe a small recent window (e.g., last 48 hours, every 30 minutes) for known patterns via `HEAD` to build a minimal list.
- **Dependencies**: Task 3.2
- **Complexity**: 4
- **Acceptance Criteria**: App still loads at least one report when `reports.json` is missing and a valid `?file=` is provided.

### Task 3.4: Build cascading dropdowns
- **Location**: `./raw/index.html`
- **Description**: Use parsed report metadata to populate and cascade the three selectors:
  - Year-Month → Day → Time
  - Changing Year-Month repopulates Day and Time
  - Changing Day repopulates Time
- **Dependencies**: Task 3.2
- **Complexity**: 3
- **Acceptance Criteria**: Selecting a month/day/time always maps to a valid file and triggers loading.

### Task 3.5: Maintain sorted report list for navigation
- **Location**: `./raw/index.html`
- **Description**: Sort reports by `sortKey` descending (newest first) and keep a flat `reportsList` for prev/next navigation.
- **Dependencies**: Task 3.4
- **Complexity**: 2
- **Acceptance Criteria**: Prev/Next buttons step through chronological order correctly across months/days.

## Phase 4: Markdown Loading & Rendering
### Task 4.1: Fetch and render Markdown
- **Location**: `./raw/index.html`
- **Description**: Implement `loadReport(baseName)` to fetch `./${baseName}.md` with cache-buster, show loading state, render via `marked.parse`, and inject into `<article class="content">`.
- **Dependencies**: Task 3.4
- **Complexity**: 2
- **Acceptance Criteria**: Markdown renders correctly; loading and error states are visible when needed.

### Task 4.2: Post-render hooks
- **Location**: `./raw/index.html`
- **Description**: After rendering, scroll to top, update page title (optional), and trigger TTS button injection.
- **Dependencies**: Task 4.1
- **Complexity**: 1
- **Acceptance Criteria**: Content appears with heading hierarchy intact and TTS buttons appear on headings.

## Phase 5: TTS System (Full Port)
### Task 5.1: Port TTS UI and config management
- **Location**: `./raw/index.html`
- **Description**: Copy TTS controls, settings modal, localStorage config logic, and status indicator from `../news/index.html`.
- **Dependencies**: Task 1.1
- **Complexity**: 3
- **Acceptance Criteria**: Modal opens/closes, settings persist, status indicator updates.

### Task 5.2: Port TTS engines and fallback behavior
- **Location**: `./raw/index.html`
- **Description**: Copy Web Speech, Azure, Google, Gemini, Fish Audio implementations and keep the same fallback-to-Web behavior.
- **Dependencies**: Task 5.1
- **Complexity**: 4
- **Acceptance Criteria**: All engines can be selected; failures automatically degrade to Web Speech.

### Task 5.3: Add per-item play buttons for h2/h3
- **Location**: `./raw/index.html`
- **Description**: Extend section discovery to include both `h2` and `h3` headings, add play buttons to each, and adapt `extractNewsContent` to read the corresponding section block.
- **Dependencies**: Task 4.2
- **Complexity**: 3
- **Acceptance Criteria**: Each `h2` and `h3` has a play button; individual play works without breaking “Play All”.

### Task 5.4: Auto-play overlay
- **Location**: `./raw/index.html`
- **Description**: Port the autoplay overlay and user-gesture requirement flow verbatim.
- **Dependencies**: Task 5.1
- **Complexity**: 2
- **Acceptance Criteria**: When auto-play is enabled, overlay appears and audio starts after user click.

## Phase 6: Navigation & History
### Task 6.1: Prev/Next button behavior
- **Location**: `./raw/index.html`
- **Description**: Implement prev/next navigation using the sorted report list, updating selectors and loading the chosen report.
- **Dependencies**: Task 3.5
- **Complexity**: 2
- **Acceptance Criteria**: Prev/Next moves chronologically, buttons disable at ends.

### Task 6.2: URL query param + popstate support
- **Location**: `./raw/index.html`
- **Description**: Read `?file=` on load, pushState on selection changes, and handle browser back/forward with `popstate`.
- **Dependencies**: Task 6.1
- **Complexity**: 3
- **Acceptance Criteria**: Navigating with browser history restores correct dropdown values and content.

## Testing Strategy
- Open `./raw/index.html` locally and on GitHub Pages to confirm static behavior.
- Verify selector cascading (month → day → time) for multiple files.
- Test `?file=` deep-linking and browser back/forward.
- Validate Markdown rendering (headings, lists, code, tables).
- Exercise TTS: Web Speech, Azure (proxy), Google, Gemini, Fish; confirm fallback behavior when keys are missing.
- Check auto-play overlay requires user gesture.
- Verify dark mode styling and mobile responsiveness.

## Dependency Graph
- Phase 1 → Phase 2 → Phase 3 → Phase 4 → Phase 5 → Phase 6
- Phase 5 depends on Phase 4 for heading injection
- Phase 6 depends on Phase 3 sorting

## Potential Risks
- **No directory listing**: `reports.json` missing may limit discovery; fallback probing might miss files.
- **Filename mismatch**: New patterns not covered by regex list could be skipped.
- **CORS/API limits**: Azure/Google/Gemini/Fish calls may fail without keys or due to browser CORS.
- **Large reports**: Long Markdown files could affect render time and TTS sequencing.
- **Web Speech voice availability**: Voice names vary by browser and OS.

## Rollback Plan
- If issues arise, remove `./raw/index.html` or revert to a previous version from git history.
- Keep any existing `reports.json` unchanged to avoid breaking the news index.

---

## Implementation Notes (2026-01-25)

### Completed
- [x] Phase 1-6 all tasks implemented
- [x] `./raw/index.html` created with full functionality
- [x] `./raw/reports.json` index file created

### TTS Content Extraction Logic

Based on the `global_scan_*.md` report structure, TTS content is extracted differently per section:

| Section | Content to Read |
|---------|-----------------|
| **頭條精選 (Top 10)** | Title + Description + Core Insight + Inspiration |
| **歐美科技動態 (🇺🇸)** | Table "中文摘要" column |
| **日本技術圈 (🇯🇵)** | Table "中文摘要" column |
| **台灣科技新聞 (🇹🇼)** | Title only |
| **中國科技/社會動態 (🇨🇳)** | Title only |
| **統計區塊** | Not played |

### Key Functions Added

```js
getSectionType(h2Text)        // Detect section type by h2 heading
extractTopNewsContent(section) // Extract Top 10 item: title + desc + insights
extractTableContent(section, type) // Extract table rows based on type
processH2Section(h2, elements, type, sections) // Process each h2 block
```

### Report Markdown Structure

```markdown
## 🔥 頭條精選 (Top 10)
### 1. [Title](url)
📊 **Source** | **Metric** | Time

Description paragraph...

- 🎯 **核心觀點**：...
- 💡 **啟發**：...
- 🏷️ `#tag1` `#tag2`

---

## 🇺🇸 歐美科技動態
| 標題 | 來源 | 時間 | 中文摘要 |
|------|------|------|----------|
| [Title](url) | Source | Time | Summary to read |

## 🇹🇼 台灣科技新聞
| 標題 | 來源 | 時間 | 熱度 |
|------|------|------|------|
| [Title](url) | Source | Time | - |
```
