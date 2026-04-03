# Livy Hooks

This directory documents the hooks (event handlers) that Livy uses to automate workflows and respond to events.

## Hook Categories

- **Startup hooks**: Run when Livy session starts
- **Pre-commit hooks**: Run before committing documentation changes
- **Post-publish hooks**: Run after documentation is published
- **Scheduled hooks**: Run on regular intervals to maintain documentation freshness

## Current Hooks

- `executed-without-arguments.sh` - Default hook when Livy is invoked without arguments

## Adding New Hooks

To add a new hook, create a `.sh` file in the hooks/ directory and register it in the .env or settings configuration.
