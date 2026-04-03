---
status: complete
owner: livy
priority: critical
description: Create and maintain all user-facing documentation including READMEs, guides, and tutorials
completed: 2026-04-03
---

## Purpose

Livy's primary responsibility is to create comprehensive, user-friendly documentation. This includes README files, getting started guides, step-by-step tutorials, and all public-facing written content that helps new and existing users understand and use koad:io.

## Specification

**Scope:**
- README.md files for all repositories
- Getting started guides for new users
- Step-by-step tutorials for common workflows
- Feature explanation and concept guides
- Troubleshooting and FAQ content

**Output:**
- Markdown files in docs/ directory structure
- Rendered on kingofalldata.com
- Available in repository root or docs/ folders
- Version-controlled in git with clear commit messages

**Quality standards:**
- Clear, beginner-friendly language
- Accurate technical information (verified with Veritas)
- Complete examples and code snippets
- Links to relevant reference documentation
- Updated when features change

## Implementation

Implemented through:
- Direct editing of README.md and docs/ files in repositories
- Integration with kingofalldata.com deployment pipeline
- Review process with Veritas for accuracy
- Regular updates as features evolve

## Dependencies

- Veritas (fact-checking and accuracy review)
- Vulcan (understanding newly built features)
- Mercury (content distribution and announcements)
- Version control system (git)

## Testing

- [ ] Documentation renders correctly on kingofalldata.com
- [ ] All code examples are tested and working
- [ ] Links are functional and correct
- [ ] Veritas approves accuracy of technical claims
- [ ] New users can follow guides without errors

## Status Note

Core capability - actively maintained. All public documentation is maintained through this process.
