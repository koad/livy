---
status: complete
owner: livy
priority: high
description: Document how new entities are created, gestated, and brought online in the koad:io ecosystem
completed: 2026-04-03
---

## Purpose

New organizations or projects ("entities") need clear guidance on how to join the koad:io ecosystem. Livy documents the complete onboarding journey: understanding what an entity is, how to create one, how to connect with koad, and how to manage it. This enables self-service entity creation and autonomy.

## Specification

**Content:**
- Explanation of entity model and concepts
- Prerequisites and requirements
- Step-by-step entity creation guide (via Juno gestation)
- Configuration and identity setup
- First commands and integration testing
- Organizational structure and responsibilities
- Connecting to other entities (trust bonds, inter-entity communication)
- Best practices and patterns

**Output:**
- docs/entities/ directory with comprehensive guides
- Onboarding checklist and validation steps
- Troubleshooting guide for common setup issues
- Examples of entity operations

**Quality standards:**
- Complete, no missing steps
- Accurate references to gestation protocol and tools
- Working examples and test cases
- Clear explanation of entity responsibilities

## Implementation

Implemented through:
- docs/entities/ directory structure
- Collaboration with Juno for gestation process details
- Vesta specifications for entity model
- Integration with other entity documentation

## Dependencies

- Juno (gestation protocol and automation)
- Vesta (entity model specification - VESTA-SPEC-001)
- Salus (diagnostics for validating entity health)
- Veritas (accuracy of technical claims)

## Testing

- [ ] New entity can be created by following guide
- [ ] Created entity passes Argus conformance checks
- [ ] Entity can execute basic commands
- [ ] Trust bonds can be established to koad
- [ ] Inter-entity communication works as documented

## Status Note

Core capability - actively maintained as onboarding is ongoing. Updated when entity model or protocols change.
