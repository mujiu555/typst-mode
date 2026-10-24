# Git Flow Branch Naming Convention

---

## 1. 概述 | Overview

本规范定义了一种专为持续集成、专职 QA（质量保证）以及稳定生产发布设计的分支策略。
它在标准 Git Flow 基础上，引入了一个专用的 `test` 分支用于预发布环境（Staging）部署。

This specification defines a branching strategy designed for continuous integration,
dedicated QA (Quality Assurance), and stable production releases.
It extends the standard Git Flow by introducing a dedicated `test` branch
for staging environment deployments.

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

## Branches Layout

### Permanent Branches (Long-lived)

| Branch | Name | Base | Purpose |
| :--- | :--- | :--- | :--- |
| **Production** | `main` | - | Contains only production-ready, released code. Every commit on `main` is tagged with a version number. |
| **Integration** | `dev` | `main` | The main line of development. Contains the latest delivered features intended for the next release. |
| **Staging/QA** | `test` | `dev` | Reflects the current code deployed to the staging/QA environment. Used for final verification before release. |

### Supporting Branches (Short-lived)

| Branch Type | Naming | Base | Merge Target |
| :--- | :--- | :--- | :--- |
| **Feature** | `feat/*` | `dev` | First into `test` (for QA), then into `dev`. |
| **Release** | `release/v*` | `dev` | `main` (with tag) & back-merge into `dev` & `test`. |
| **Hotfix** | `hotfix/*` | `main` | `main` (with tag) & back-merge into `dev` & `test`. |

### 常驻分支（长期存在）

| 分支 | 名称 | 源分支 | 用途 |
| :--- | :--- | :--- | :--- |
| **生产分支** | `main` | - | 仅包含已发布到生产环境的、随时可部署的代码。每次提交都必须打上版本号标签。 |
| **集成开发分支** | `dev` | `main` | 主要开发线。包含所有已交付、计划用于下一个版本的功能。 |
| **测试/预发布分支** | `test` | `dev` | 反映当前部署在预发布/测试服务器上的代码。用于发布前的最终验证。 |

### 临时分支（短期存在）

| 分支类型 | 命名规则 | 源分支 | 合并目标 |
| :--- | :--- | :--- | :--- |
| **功能分支** | `feat/*` | `dev` | 先合入 `test`（用于 QA 测试），再合入 `dev`。 |
| **发布分支** | `release/v*` | `dev` | `main`（并打标签）& 回合并入 `dev` 与 `test`。 |
| **热修复分支** | `hotfix/*` | `main` | `main`（并打标签）& 回合并入 `dev` 与 `test`。 |

## Detailed Workflow

### Feature Development

1. Fork a new feature branch from `dev`:

    ```bash
    git checkout dev && git pull
    git checkout -b feat/awesome-feature
    ```

2. Develop and commit changes locally.
3. Push the feature branch to the remote repository.

### Feature Testing (QA Environment)

1. Merge the feature branch into `test` to deploy it to the staging server for QA verification:

    ```bash
    git checkout test && git pull
    git merge --no-ff feat/awesome-feature
    git push origin test
    ```

2. QA team tests the feature in isolation within the staging environment.
3. **If bugs are found:** Fix them directly on `feat/awesome-feature`,
  then re-merge into `test` and re-deploy until QA passes.

### Feature Integration (Post-Approval)

1. Once QA approves the feature, merge it into `dev`:

    ```bash
    git checkout dev && git pull
    git merge --no-ff feat/awesome-feature
    git push origin dev
    ```

2. **Critical Step (Synchronization):** To keep the `test` environment up-to-date
  with all integrated features, merge the updated `dev` back into `test`:

    ```bash
    git checkout test && git pull
    git merge --no-ff dev   # Or rebase, but merge is safer for traceability
    git push origin test
    ```

    *(Note: This ensures `test` always reflects the current state of `dev`,
    preventing "integration hell" at release time.)*
3. Delete the merged feature branch (optional but recommended):

    ```bash
    git branch -d feat/awesome-feature
    git push origin --delete feat/awesome-feature
    ```

### Release Preparation

1. When `dev` reaches a stable state ready for production, fork a release branch from `dev`:

    ```bash
    git checkout dev && git pull
    git checkout -b release/v1.2.0
    ```

2. On this branch, perform final chores (version bumps, documentation, final bug fixes).
3. Merge the release branch into `test` for a final thorough regression test in the staging environment:

    ```bash
    git checkout test && git pull
    git merge --no-ff release/v1.2.0
    git push origin test
    ```

4. After final QA passes on `test`, proceed to production.

### Production Release

1. Merge the release branch into `main` and tag the version:

    ```bash
    git checkout main && git pull
    git merge --no-ff release/v1.2.0
    git tag -a v1.2.0 -m "Release version 1.2.0"
    git push origin main --tags
    ```

2. Back-merge the release changes into `dev` to ensure version bumps are carried forward:

    ```bash
    git checkout dev && git pull
    git merge --no-ff release/v1.2.0
    git push origin dev
    ```

3. Back-merge the release changes into `test` to keep it synchronized:

    ```bash
    git checkout test && git pull
    git merge --no-ff release/v1.2.0
    git push origin test
    ```

4. Delete the release branch.

### Hotfix (Emergency Production Fix)

1. Fork from `main`:

    ```bash
    git checkout main && git pull
    git checkout -b hotfix/critical-bug
    ```

2. Fix the bug and commit.
3. Merge directly into `main` and tag:

    ```bash
    git checkout main && git merge --no-ff hotfix/critical-bug
    git tag -a v1.2.1 -m "Hotfix for critical bug"
    git push origin main --tags
    ```

4. Merge the hotfix into `dev` and `test` to ensure future releases include the fix:

    ```bash
    git checkout dev && git merge --no-ff hotfix/critical-bug && git push
    git checkout test && git merge --no-ff hotfix/critical-bug && git push
    ```

### Summary of Corrections Made / 修正点总结

1. **Synchronization (同步性修正):**
  Explicitly added the `dev` -> `test` merge step after each feature integration
  to prevent the `test` branch from becoming outdated.
  (在每次功能合入 `dev` 后，明确增加了 `dev` -> `test` 的合并步骤，防止 `test` 分支老旧过期。)
2. **Release Isolation (发布隔离):**
  Introduced `release/` branches. Merging `dev` directly into `main` is dangerous
  because `dev` might receive new features during release testing.
  The `release/` branch freezes the release candidate.
  (引入了 `release/` 分支。直接将 `dev` 合入 `main` 存在风险，因为在发布测试期间 `dev` 可能会合入新功能。发布分支锁定了发布候选版本。)
3. **Hotfix Propagation (热修复传播):**
  Added mandatory back-merges to both `dev` and `test` for hotfixes.
  (为热修复增加了强制性的回合并入 `dev` 和 `test` 的步骤。)

## Graph

```txt
Time ↓ (Top to Bottom / 自上而下)

 main     release    test      dev       feat      hotfix
  |                   |         |
  *                   |         |                        <- Initial commit
  |\                  _         |
  | `----------------'|`--------*                        <- Create dev from main
  |                   |        /|\
  |                   *-------' | \                      <- Create test from dev
  |                   |         |  \
  |                   |         |   `-----*              <- Create feat/F1 from dev
  |                   |         |         |
  |                   |         |         *              <- F1 development commits
  |                   |         _        /|
  |                   *--------'|`------' |              <- Merge F1 -> test (QA testing)
  |                   |         |        /
  |                   |         *-------'                <- Merge F1 -> dev (integration)
  |                   |        /|\
  |                   *-------' | \                      <- ⚡ Sync: merge dev -> test
  |                   |         |  \
  |                   |         |   `-----*              <- Create feat/F2 from dev
  |                   |         |         |
  |                   |         |         *              <- F2 development commits
  |                   |         _        /|
  |                   *--------'|`------' |              <- Merge F2 -> test (QA testing)
  |                   |         |        /
  |                   |         *-------'                <- Merge F2 -> dev (integration)
  |                   |        /|
  |                   *-------' |                        <- ⚡ Sync: merge dev -> test
  |                   _         |
  |         *--------'|`--------|                        <- Create release/v1.0 from dev
  |         |         |         |
  |         *         |         |                        <- release commit (version bump, docs)
  |         |\        |         |
  |         | `-------*         |                        <- Merge release -> test (final regression)
  |        /|\        |         |
  *-------' | \       |         |                        <- Merge release -> main (tag v1.0)
  |         |  \      _         |
  |          \  `----'|`--------*                        <- 🔄 Back-merge release -> dev
  |           \       |         |
  |            `------*         |                        <- 🔄 Back-merge release -> test
  |                   _         _
  |------------------'|`-------'|`------------------*    <- Create hotfix/H1 from main
  |                   _         _                   |
  | .----------------'|`-------'|`------------------*    <- H1 fix commits
  |/                  |         |                  /|
  *                   |         |                 / |    <- Merge hotfix -> main (tag v1.1)
  |                   |         |                / /
  |                   |         *---------------' /      <- 🔄 Back-merge hotfix -> dev
  |                   |         _                /
  |                   *--------'|`--------------'        <- 🔄 Back-merge hotfix -> test
  |                   |         |
  v         v         v         v         v         v
```

## 详细命名示例 | Detailed Naming Examples

假设用户名为 `alice`, 以下为完整示例：
Assuming username `alice`, here are complete examples:

| 场景 / Scenario | 分支名 / Branch Name |
| :--- | :--- |
| 新功能：用户登录 / New feature: user login | `alice@feat/user-login` |
| 发布 v1.2.0 / Release v1.2.0 | `alice@release/v1.2.0` |
| 紧急修复：支付空指针 / Hotfix: payment NPE | `alice@hotfix/payment-npe` |
| 常规修复：UI 错位 / Bugfix: UI misalignment | `alice@bugfix/ui-alignment` |

## 关键规则 | Critical Rules

### 版本标签规范 | Version Tagging

每次 `release` 或 `hotfix` 合并至 `master` 时, **必须** 创建语义化版本标签, 格式为：
When merging `release` or `hotfix` into `master`,
**must** create a semantic version tag:

```
v<major>.<minor>.<patch>
```

示例 / e.g., `v1.2.0`, `v2.0.1`.

---

### 分支生命周期 | Branch Lifecycle

- **功能/修复分支**(`feat`, `bugfix`)：合并后**立即删除**(通过 PR 合并选项或手动 `git branch -d`).
  **Feature/Bugfix branches**: **Delete immediately**
  after merging (via PR settings or `git branch -d`).
- **发布/热修分支**(`release`, `hotfix`)：合并并打标签后**立即删除**.
  **Release/Hotfix branches**: Delete immediately after merging and tagging.

---

### 受保护分支 | Protected Branches

`master` 与 `develop` 必须设为**受保护分支**, 禁止直接推送(`git push --force`).
所有变更必须通过 **Pull Request (PR)** 合并, 且需通过 CI 自动化测试.
`master` and `develop` must be **protected** -
direct pushes (especially `--force`) are forbidden.
All changes must go through **Pull Requests (PR)** and pass CI checks.

---

### 提交信息规范(建议)| Commit Message Standard (Suggested)

配合 [Conventional Commits](https://www.conventionalcommits.org/) 规范, 便于自动生成变更日志：
Use [Conventional Commits](https://www.conventionalcommits.org/) for
auto-generating changelogs:

示例 / e.g., `feat(auth): add JWT token refresh`.
