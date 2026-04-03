---
status: complete
owner: livy
priority: critical
description: Collaborate with Veritas to establish fact-checking and accuracy review process for all public documentation
completed: 2026-04-03
---

## Purpose

Public documentation represents the koad:io ecosystem to the world. Any inaccurate claims damage trust. Livy works with Veritas to establish and follow a rigorous fact-checking process where all technical claims, features, and capabilities are verified before publication.

## Specification

**Process:**
1. Livy drafts documentation with technical claims
2. Livy requests fact-check from Veritas (reviewer) and relevant builder (Vulcan, etc.)
3. Veritas and builder review for accuracy against implementation and specifications
4. Feedback is incorporated, claims verified
5. Documentation is published with confidence

**Scope:**
- Technical specifications and claims
- Feature capabilities and limitations
- API documentation and examples
- Integration guides and best practices
- Security and compliance statements

**Quality gates:**
- No public documentation published without review
- Technical claims verified against specs and implementation
- Edge cases and limitations clearly documented
- Examples tested and working
- Proper attributions and references

## Implementation

Implemented through:
- Documentation review process with documented checklist
- Collaboration workflow with Veritas and relevant teams
- Pull request review requirements before merge to main
- Regular sync meetings to discuss documentation accuracy

## Dependencies

- Veritas (fact-checking and accuracy review)
- Vulcan and entity builders (implementation verification)
- Vesta (specification verification)
- Git/GitHub for review workflow

## Testing

- [ ] All public documentation has been fact-checked
- [ ] Technical examples run and produce correct output
- [ ] Specifications are accurately described
- [ ] API documentation matches implementation
- [ ] Claims about features and capabilities are accurate
- [ ] Limitations and caveats are clearly stated

## Status Note

Core capability - enforced on all documentation. Fact-checking is a required gate before any documentation merge.
