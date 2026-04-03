---
status: complete
owner: livy
priority: high
description: Commit documentation changes with clear, informative commit messages
completed: 2026-04-03
---

## Purpose

Livy frequently updates documentation in git repositories. The commit command ensures that all documentation changes are tracked with clear, contextual commit messages that explain what changed and why. This maintains a readable project history.

## Interface

**Command:** `livy commit self`

**Arguments:** None - operates on current repository

**Output:** Commit confirmation with summary

**Example:**
```bash
livy commit self
# Creates commit with message explaining documentation changes
```

## Specification

**Behavior:**
- Stage all modified documentation files
- Generate appropriate commit message based on changes
- Use clear, imperative language in commit messages
- Include context about why the documentation changed
- Follow commit message best practices

**Commit message format:**
- Subject: max 72 characters, imperative mood
- Body: explain the "why" and business impact
- Reference projects or issues when relevant

## Implementation

Implemented in `commands/commit/self/command.sh`. Uses Claude to generate context-aware commit messages.

## Dependencies

- Git for version control
- Claude AI for message generation
- Proper file staging before commit

## Testing

- [ ] Creates valid git commits
- [ ] Commit messages are clear and informative
- [ ] History is readable and trackable
- [ ] Commits appear properly in git log

## Status Note

Production-ready. Used for all documentation commits in Livy's work.
