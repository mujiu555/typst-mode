# Git Flow Branch Naming Convention

---

## 1. 概述 | Overview

本文档定义了本仓库的 Git 分支标准结构, 旨在规范开发, 测试与发布流程.
This document defines the standard branching structure for this repository to
streamline development, testing, and release processes.

**核心语法 | Core Syntax:**

```
<user>@<branch-type>[/<branch-info>]
```

- `<user>`: 分支创建者的用户名(**强制前缀**, 便于追溯).
  (Mandatory prefix for traceability).
- `<branch-type>`: 分支类型(见下表).
  (Branch type, see table below).
- `<branch-info>`: 具体描述(如功能名, 版本号, 问题ID).
  (Specific description: feature name, version number, issue ID).

---

## 2. 分支类型与规则 | Branch Types & Rules

| 类型 / Type | 缩写 / Alias | 来源 / Source | 合并目标 / Merge Target | 用途 / Purpose |
| :--- | :--- | :--- | :--- | :--- |
| **master** | - | - | - | 生产环境稳定版, 仅接受 release 与 hotfix 合并. <br> Stable production code. Only accepts merges from release & hotfix. |
| **develop** | `dev` | - | - | 集成分支, 所有功能与修复的最终汇集地. <br> Integration branch for all features and fixes. |
| **feature** | `feat` | `develop` | `develop` | 新功能开发. <br> New feature development. |
| **release** | - | `develop` | `master` + `develop` | 发布准备, 最终测试与版本号更新. <br> Release preparation, final testing, and version bump. |
| **hotfix** | - | `master` | `master` + `develop` | 生产环境紧急补丁. <br> Emergency patch for production. |
| **bugfix** | `fix` | `develop` | `develop` | 常规非紧急缺陷修复. <br> Regular (non-urgent) bug fixes. |

---

## 3. ASCII 流程图 | ASCII Workflow Graph

下图展示了各分支的衍生与合并关系(时间轴从左至右).
The graph below shows the branching and merging relationships
(timeline left to right).

```
master        ●─────────────────●─────────────────●─────────────────●
              │                 │                 │                 │
              │                 │  release/v1.0   │                 │  hotfix/v1.0.1
              │                 ○───────○         │                 ○──────○
              │                /        \         │                /       \
develop       ●───────────────●──────────●────────●───────────────●────────●
              │               │          │        │               │        │
              │  feat/login   │          │        │               │        │
              ○───────○       │          │        │               │        │
             /        \       │          │        │               │        │
time ────── ○──────────○──────●          │        │               │        │
```

**图例 | Legend:**

- `●` : 主干提交 / Mainline commit.
- `○` : 分支提交 / Branch commit.
- `feat/login` : 从 `develop` 切出, 最终合并回 `develop`.
  (Branches from `develop`, merges back to `develop`).
- `release/v1.0` : 从 `develop` 切出, 合并到 `master`(打标签)与 `develop`.
  (Branches from `develop`, merges to `master` (tagged) and `develop`).
- `hotfix/v1.0.1` : 从 `master` 切出, 合并到 `master`(打标签)与 `develop`.
  (Branches from `master`, merges to `master` (tagged) and `develop`).

---

## 4. 详细命名示例 | Detailed Naming Examples

假设用户名为 `alice`, 以下为完整示例：
Assuming username `alice`, here are complete examples:

| 场景 / Scenario | 分支名 / Branch Name |
| :--- | :--- |
| 新功能：用户登录 / New feature: user login | `alice@feat/user-login` |
| 发布 v1.2.0 / Release v1.2.0 | `alice@release/v1.2.0` |
| 紧急修复：支付空指针 / Hotfix: payment NPE | `alice@hotfix/payment-npe` |
| 常规修复：UI 错位 / Bugfix: UI misalignment | `alice@bugfix/ui-alignment` |

---

## 5. 关键规则 | Critical Rules

### 5.1 版本标签规范 | Version Tagging

每次 `release` 或 `hotfix` 合并至 `master` 时, **必须** 创建语义化版本标签, 格式为：
When merging `release` or `hotfix` into `master`,
**must** create a semantic version tag:

```
v<major>.<minor>.<patch>
```

示例 / e.g., `v1.2.0`, `v2.0.1`.

---

### 5.2 分支生命周期 | Branch Lifecycle

- **功能/修复分支**(`feat`, `bugfix`)：合并后**立即删除**(通过 PR 合并选项或手动 `git branch -d`).
  **Feature/Bugfix branches**: **Delete immediately**
  after merging (via PR settings or `git branch -d`).
- **发布/热修分支**(`release`, `hotfix`)：合并并打标签后**立即删除**.
  **Release/Hotfix branches**: Delete immediately after merging and tagging.

---

### 5.3 受保护分支 | Protected Branches

`master` 与 `develop` 必须设为**受保护分支**, 禁止直接推送(`git push --force`).
所有变更必须通过 **Pull Request (PR)** 合并, 且需通过 CI 自动化测试.
`master` and `develop` must be **protected** -
direct pushes (especially `--force`) are forbidden.
All changes must go through **Pull Requests (PR)** and pass CI checks.

---

### 5.4 提交信息规范(建议)| Commit Message Standard (Suggested)

配合 [Conventional Commits](https://www.conventionalcommits.org/) 规范, 便于自动生成变更日志：
Use [Conventional Commits](https://www.conventionalcommits.org/) for
auto-generating changelogs:

示例 / e.g., `feat(auth): add JWT token refresh`.
