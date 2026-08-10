# Git Commit Specification

This is a specification for writing standardized commit messages used in the project.

## Overview

The commit message should be structured as follows:

```txt
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

The body should be structured as composed of sections,
and each section can contain multiple items, split by empty lines:

```txt
<type>: [optional description]
[optional item lists]
...
```

E.g., a body with two sections:

```txt
feature: add new API methods
1. add method `foo` to do bar
2. add method `baz` to do qux

fix: resolve issue with connection timeout
```

The footer should be structured as a line starts with 'Request: ' and
followed by one or more issue IDs written as `#<ID>`, separated by commas:
P.S., if the commit does not relate to any issue, use `#none`.

Review information and breaking change notices are attached follow Request line,
in same format.

E.g., a footer with no related issue ID:

```txt
Request: #none
```

E.g., a footer with related issue IDs, review information, and breaking change notice:

```txt
Request: #112, #118
Reviewed-by: Github@mujiu555
```

## Header

Header consists of a type, an optional scope, and a description.
Tells the main purpose of the commit briefly.

### Type

Type identifies the category of the commit.
Which can be one of the followings:

For development-related changes:

- `feat`: a new feature
- `docs`: documentation only changes
- `refactor`: a code change that neither fixes a bug nor adds a feature
- `fix`: a bug fix
- `hotfix`: a critical fix that needs to be applied immediately
- `test`: adding missing tests or correcting existing tests

Improvements to code quality:

- `style`: changes that do not affect the meaning of the code
  (white-space, formatting, missing semi-colons, etc)
- `perf`: a code change that improves performance

Build process or auxiliary tool changes:

- `chore`: changes to the build process or auxiliary tools and libraries
  such as documentation generation
- `ci`: changes to our CI configuration files and scripts
  (example scopes: Travis, Circle, BrowserStack, SauceLabs)
- `build`: changes that affect the build system or external dependencies
  (example scopes: gulp, broccoli, npm)
- `config`: changes to configuration files
- `dep`: updates to dependencies

Repository and versioning:

- `init`: initial commit of a project
- `merge`: a merge commit
- `revert`: reverts a previous commit

Temporary and work-in-progress changes:

- `tmp`: temporary changes that will be removed later
- `wip`: work in progress changes

Type can be suffixed with `!` to indicate a breaking change.

### Scope

Scope is optional, and provides additional contextual information about
changes in the commit.
A scope is a noun describing a section of the codebase surrounded by parenthesis,
can be anything specifying the area of the code affected.

### Description

Description is a short summary of the code changes,
gives a overview of the commit.

## Body

Body is optional, and provides additional contextual information.
Body consists of one or more sections, each section starts with a title line,

### Section

Section starts with a title line, starting with a type of the section of changes.
The title line is suffixed with a colon `:`, followed by zero or more item lines.
A short description of the section can be provided in the title line after the colon.

The type of the section can be one of the followings:

Code changes:

- `feature`: new features added
- `fix`: bugs fixed
- `refactor`: code refactored
- `documentation`: documentation updated

Work progress:

- `todo`: tasks to be done
- `done`: tasks completed, declared before in todo
- `wip`: work in progress

Quality assurance:

- `issue`: issues encountered
- `bug`: bugs found

## Footer

Footer is optional, and provides metadata about the commit.
