# Git Commit Specification (中英双语完整版)

> 本规范基于 [Conventional Commits](https://www.conventionalcommits.org/) v1.0.0,
> 并强制要求 Body 由结构化节组成.
> 节类型可任意选用(包括状态标记).
>
> This specification is based on
> [Conventional Commits](https://www.conventionalcommits.org/) v1.0.0
> and mandates that the Body consist of structured sections.
> Section types are flexible (including status marks).

---

The Conventional Commits specification is a lightweight convention,
on top of commit messages.
It provides an easy set of rules for creating an explicit commit history;
which makes it easier to write automated tools on top of.
This convention dovetails with [SemVer](https://semver.org),
by describing the features, fixes, and breaking changes made in commit messages.

## Overall Structure

提交信息由三部分组成：**Header(头部)**, **Body(正文)** 和 **Footer(脚注)**.
A commit message consists of three parts: **Header**, **Body**, and **Footer**.

```txt
<type>[optional scope][optional !]: <subject>

[optional body(s)]

[optional footer(s)]
```

- Header **必须** 存在.
  Header is **REQUIRED**.
- Body **可选**, 但如果提供, **必须** 由结构化节组成.
  Body is **OPTIONAL**, but if present, it **MUST** consist of structured sections.
- Footer **可选**.
  Footer is **OPTIONAL**.

**基本格式约束** | **Basic formatting constraints**:

- Header 与 Body 之间 **必须** 有一个空行.
  There **MUST** be a blank line between Header and Body.
- Body 与 Footer 之间 **必须** 有一个空行.
  There **MUST** be a blank line between Body and Footer.
- Header 长度 **应当** 不超过 **50 个字符**.
  Header length **SHOULD** not exceed **50 characters**.
- Body 中每行(除列表项缩进外) **应当** 不超过 **72 个字符**.
  Each line in the Body (except list indentation) **SHOULD** not exceed **72 characters**.

---

## Header Specification

格式：`<type>[scope][!]: <subject>`
Format: `<type>[scope][!]: <subject>`

### 2.1 Type(类型) - **必须** | Type - **REQUIRED**

类型是名词, 推荐使用以下类型(但不限于)：
The type is a noun. The following types are RECOMMENDED (but not limited to):

| Type | 中文说明 | English Description | SemVer impact |
| :--- | :------- | :------------------ | :------------ |
| `feat` | 新增功能 | A new feature | **MINOR** |
| `fix` | 修复 Bug | A bug fix | **PATCH** |
| `docs` | 仅文档变更 | Documentation only | / |
| `style` | 代码格式(不影响逻辑) | Code style (formatting, whitespace) | / |
| `refactor` | 代码重构 | Code refactoring | / |
| `perf` | 性能优化 | Performance improvement | **PATCH** |
| `test` | 测试相关 | Adding/modifying tests | / |
| `build` | 构建系统或外部依赖变更 | Build system or dependencies | / |
| `ci` | CI 配置变更 | CI configuration changes | / |
| `chore` | 杂项(不修改 src 或 test) | Other changes (no src/test modification) | / |
| `revert` | 回滚之前的提交 | Revert a previous commit | 视情况 (Depends) |

- `feat` **必须** 用于新增功能; `fix` **必须** 用于 Bug 修复.
  `feat` **MUST** be used for new features; `fix` **MUST** be used for bug fixes.
- 其他类型 **可以** 自由使用, 但除非包含破坏性变更, 否则不影响语义化版本.
  Other types **MAY** be used freely, but they do not affect SemVer
  unless they include a breaking change.

### 2.2 Scope(范围) - **可选** | Scope - **OPTIONAL**

**必须** 是描述代码库某部分的名词, 并用括号包裹, 如 `feat(parser):`.
**MUST** be a noun describing a section of the codebase,
enclosed in parentheses, e.g., `feat(parser):`.

### 2.3 破坏性变更标记 `!` - **可选** | Breaking change marker `!` - **OPTIONAL**

- **必须** 紧跟在 type/scope 之后, 冒号之前, 如 `feat(api)!:`.
  **MUST** be placed immediately after the type/scope and before the colon,
  e.g., `feat(api)!:`.
- 也可在 Footer 中以 `BREAKING CHANGE:` 声明(见第 5 节).
  May also be declared in the Footer as `BREAKING CHANGE:` (see Section 5).

### 2.4 Subject(标题) - **必须** | Subject - **REQUIRED**

- **必须** 使用 **祈使句现在时**(如 `add` 而非 `added` 或 `adds`).
  **MUST** use the **imperative mood** (e.g., `add`, not `added` or `adds`).
- **必须** 以 **大写字母** 开头.
  **MUST** start with a **capital letter**.
- **禁止** 以句号 `.` 结尾.
  **MUST NOT** end with a period `.`.
- **应当** 不超过 **50 个字符**.
  **SHOULD** not exceed **50 characters**.

> ✅ 正确 (Correct): `feat: Add user authentication middleware`  
> ❌ 错误 (Incorrect): `feat: added auth.`

---

## 3. Body(正文)规范 - **强制结构化节** | Body Specification - **Mandatory Structured Sections**

如果 Body 存在, 则 **必须** 由一个或多个 **节(sections)** 组成.
**严禁** 使用无标题的自由格式段落.
If the Body is present, it **MUST** consist of one or more **sections**.
**Free‑form paragraphs without headers are PROHIBITED.**

### 3.1 节的格式(Section Format)

每个节包含两部分：
Each section consists of two parts:

1. **节标题(Section Header)**：单独一行, 格式为 `<Type>: <Description>`.
   **Section Header**: a single line in the format `<Type>: <Description>`.
   - `<Type>` 可以是 **任意标识符**(字母, 数字, 连字符, 下划线), **大小写不敏感**(但建议首字母大写).  
     `<Type>` can be **any identifier** (letters, digits, hyphens, underscores),
     **case‑insensitive** (but capitalising the first letter is recommended).
   - 允许的示例(非强制)：
     Allowed examples (not mandatory):
     - 与 Header 类型相同
       Same as Header types
       (e.g., `feat`, `fix`, `docs`).
     - 状态标记
       Status marks
       (e.g., `TODO`, `WIP`, `OK`, `DONE`, `FIXME`, `HACK`).
     - 描述性名词
       Descriptive nouns
       (e.g., `Documentation`, `Config`, `Security`,
       `Performance`, `Impact`, `Why`, `How`).
   - `<Description>` 是对该节内容的简短说明(建议提供, 但非强制).
     `<Description>` is a short explanation of the section’s content
     (recommended but not required).
   - 冒号 `:` 后 **必须** 跟一个空格.
     There **MUST** be a space after the colon `:`.

2. **节内容(Section Content)**：标题之后的一行或多行, **必须** 为 **列表项**(无序或有序).
   **Section Content**: one or more lines following the header,
   **MUST** be **list items** (unordered or ordered).
   - **无序列表**：以 `-`, `*` 或 `+` 开头.
     **Unordered lists**: start with `-`, `*`, or `+`.
   - **有序列表**：以数字加 `.` 开头(如 `1.`, `2.`).
     **Ordered lists**: start with a number followed by a dot (e.g., `1.`, `2.`).
   - 每个列表项占一行, 可包含子段落(需缩进, 通常 2 或 4 个空格).
     Each list item occupies one line and may contain sub‑paragraphs
     (indented, typically 2 or 4 spaces).
   - 每行建议不超过 72 字符, 若因缩进而超长, 可适当放宽.
     Lines are recommended to be ≤72 characters,
     but may be longer if indentation requires it.

3. **节分隔**：不同节之间 **必须** 用 **一个空行** 分隔.
   **Section separation**: different sections
   **MUST** be separated by **a blank line**.

### 3.2 解析规则(Parsing Rules)

- Body 的第一行 **必须** 是一个节标题(即符合 `<Type>: <Description>` 格式).
  The first line of the Body **MUST** be a section header (matching `<Type>: <Description>`).
- 解析器 **应当** 识别节标题的正则模式：`^[A-Za-z0-9_-]+: .+$`.
  Parsers **SHOULD** recognise the section header pattern: `^[A-Za-z0-9_-]+: .+$`.
- 空行用于分隔节; 连续的节标题行之间必须有空行.
  Blank lines separate sections;
  consecutive headers must have a blank line between them.
- 如果某行不以列表项标记开头(但属于上一个列表项的子内容), 应将其视为上一列表项的延续(需有缩进).
  If a line does not start with a list marker but belongs to the previous
  list item, it should be treated as a continuation (with indentation).
- 如果 Body 不符合上述结构化要求, 解析器 **可以** 发出警告, 但不应阻止提交(除非团队工具强制).
  If the Body does not conform to the above structure,
  parsers **MAY** issue a warning but should not block the commit
  (unless enforced by team tooling).

---

## 4. Footer(脚注)规范 | Footer Specification

Footer **可选**, 用于补充元信息.每个条目格式为：`<token><separator><value>`
Footer is **OPTIONAL** and used for metadata. Each entry has the format: `<token><separator><value>`

- **分隔符** **必须** 为 `:<space>`(冒号+空格)或 `<space>#`(空格+#).  
  The **separator** **MUST** be `:<space>` (colon + space) or `<space>#` (space + hash).
- Token 中的空格 **必须** 用连字符 `-` 代替(如 `Acked-by`), 但 `BREAKING CHANGE` 例外.  
  Spaces in the token **MUST** be replaced by hyphens `-` (e.g., `Acked-by`), except for `BREAKING CHANGE`.
- `BREAKING-CHANGE`(带连字符)与 `BREAKING CHANGE` **完全同义**.  
  `BREAKING-CHANGE` (with hyphen) is **synonymous** with `BREAKING CHANGE`.

**推荐的 Issue 关联 Token** | **Recommended Issue‑reference tokens**:

| Token   | 说明 (Description)                | 示例 (Example)     |
|---------|-----------------------------------|--------------------|
| `Closes`| 关闭 Issue (Closes an issue)      | `Closes #123`      |
| `Fixes` | 修复 Issue (Fixes an issue)       | `Fixes #456`       |
| `Refs`  | 关联 Issue(不关闭)(References, does not close) | `Refs #789` |
| `Request` | 请求 Issue(不关闭)(Requests, does not close) | `Request #101` |

---

## 5. 破坏性变更(Breaking Changes)- **必须标记** | Breaking Changes - **MUST be marked**

破坏性变更 **必须** 至少通过以下一种方式标记：
A breaking change **MUST** be indicated by at least one of the following:

1. **在 Header 中使用 `!`**：如 `feat(api)!:`, 此时可省略 Footer 声明.
   **Use `!` in the Header**: e.g., `feat(api)!:`.
  In this case, the Footer declaration may be omitted.
2. **在 Footer 中声明**：`BREAKING CHANGE: <description>` 或 `BREAKING-CHANGE: <description>`.
   **Declare in the Footer**:
  `BREAKING CHANGE: <description>` or `BREAKING-CHANGE: <description>`.

两种方式可同时使用, 描述应保持一致.
Both methods may be used together, and the descriptions should be consistent.

---

## 6. RFC 2119 关键词速查 | RFC 2119 Keywords Summary

| Keyword | 中文 | Applicable scenarios |
| :------ | :--- | :------------------- |
| **MUST** | 必须 | Header 基本格式, `!` 位置, 节间空行, Body 若存在则必须为结构化节<br>Header format, `!` placement, section blank lines, Body if present MUST be structured |
| **MUST NOT** | 禁止 | Subject 以句号结尾, Token 含空格(除外), Body 中使用自由格式<br>Subject ending with period, spaces in token (except), free‑form Body |
| **SHOULD** | 应当 | 50/72 字符限制, 列表项格式, 解析器识别节标题<br>50/72 char limits, list format, parser recognising section headers |
| **MAY** | 可以 | 使用其他类型, Scope, Footer, 任意节类型(包括状态标记)<br>Using other types, Scope, Footer, any section type (including status marks) |
| **OPTIONAL** | 可选 | Scope, Body, Footer, 节类型选择<br>Scope, Body, Footer, section type selection |

---

## 7. 完整示例(中英对照)| Complete Examples (Bilingual)

### 示例 1 - 含多种节类型(状态标记 + 描述性节)

**Example 1 - Multiple section types (status marks + descriptive)**

```
docs: Enhance git commit spec

Documentation: update the spec for git commit convention
1. add "body" spec
2. add Ch-Eng comp
3. allow custom section types

TODO: add examples for revert commits
- need to cover edge cases

WIP: integrate with commitlint
- still testing custom rules

Closes #42
```

**中文说明**：docs 类型的提交, Body 包含三个节：Documentation(描述具体更新内容), TODO(待办事项), WIP(进行中工作), 最后 Footer 关联 Issue #42.

**English explanation**: A `docs` commit with three Body sections: `Documentation` (describes the updates), `TODO` (to‑do items), `WIP` (work in progress), and a Footer referencing Issue #42.

---

### 示例 2 - 标准 What/Why/How 节(无状态标记)

**Example 2 - Standard What/Why/How sections (no status marks)**

```
feat: Add config file hot-reload

What: The config watcher now detects file changes and reloads
      settings without restarting the application.

Why: This reduces downtime during configuration updates and
      improves the developer experience.

How: Implemented using `fs.watch` with debouncing. The old config
      remains active until the new one is fully validated.

Impact: Minimal performance overhead (~5% CPU increase during
        watch). No breaking changes to existing config format.
```

**中文说明**：feat 提交, Body 中使用了 What(变更内容), Why(动机), How(实现方式), Impact(影响范围)四个节.

**English explanation**: A `feat` commit with four sections: `What` (what changed), `Why` (motivation), `How` (implementation), `Impact` (scope of effect).

---

### 示例 3 - 节类型与 Header 类型相同

**Example 3 - Section types matching Header types**

```
refactor: Simplify error handling logic

refactor: Consolidated duplicated try/catch blocks
- replaced multiple handlers with a single centralized function
- removed redundant error logging

feat: Added new error code mapping for client errors
- maps HTTP 400-499 to specific error types

Note: This change requires updating the monitoring dashboard.
```

**中文说明**：refactor 提交, Body 中包含 refactor 节(描述重构细节), feat 节(描述附带的新功能), Note 节(附加注意事项).

**English explanation**: A `refactor` commit with sections: `refactor` (details of refactoring), `feat` (additional new feature), and `Note` (extra notes).

---

### 示例 4 - 含破坏性变更的 Header 和 Footer

**Example 4 - Breaking change in Header and Footer**

```
feat(config)!: Change default cache directory

What: The default cache path now points to `~/.app/cache` instead
      of `/tmp/app_cache`.

Why: Storing cache in `/tmp` caused data loss on system reboot.
      User-specific directories ensure persistence.

How: Updated the configuration defaults and added a migration
      script for existing installations.

BREAKING CHANGE: Existing users must move their cache manually or
run the migration script. The old path is no longer supported.
```

**中文说明**：Header 中使用了 `!` 标记破坏性变更, Body 包含 What/Why/How 节, Footer 中重复声明 BREAKING CHANGE.

**English explanation**: The Header uses `!` to mark a breaking change; the Body has What/Why/How sections; the Footer repeats the `BREAKING CHANGE` declaration.

---

### 示例 5 - 最简单的 Body(只有一个节)

**Example 5 - Simplest Body (single section)**

```
fix: Correct off-by-one error in JWT validation

What: Changed `exp < now` to `exp <= now` to match library behavior.

Note: This fixes intermittent 401 errors.
```

**中文说明**：fix 提交, 仅包含一个 What 节和一个 Note 节.

**English explanation**: A `fix` commit with only a `What` section and a `Note` section.

---

### 示例 6 - 无 Body(只有 Header)

**Example 6 - No Body (only Header)**

```
docs: Update installation guide for Windows
```

**中文说明**：只有 Header, 无 Body, 无 Footer.

**English explanation**: Only a Header, no Body, no Footer.

---

## 9. 总结 | Summary

本规范的核心要求：

- **Header** 遵循 Conventional Commits 官方标准.
- **Body(如果存在)必须全部由结构化节组成**, 每个节以 `<Type>: <Description>` 标题开始, 内容为列表项.
- **节类型完全自由**, 可使用任何标识符(包括状态标记如 `TODO`/`WIP`/`OK` 等).
- **Footer** 用于元信息和破坏性变更声明.
- **格式化约束**(祈使句, 大写, 无句号, 50/72 字符)保证提交信息清晰美观.

Key requirements of this specification:

- **Header** follows the official Conventional Commits standard.
- **Body (if present) MUST consist entirely of structured sections**,
  each starting with a `<Type>: <Description>` header and containing list items.
- **Section types are completely free** - any identifier is allowed
  (including status marks like `TODO`/`WIP`/`OK`).
- **Footer** is for metadata and breaking change declarations.
- **Formatting constraints**
  (imperative mood, capitalisation, no period, 50/72 char limits)
  ensure clarity and consistency.
