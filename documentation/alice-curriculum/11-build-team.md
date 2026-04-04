# Level 11: Build Your Team

## Core Concept
A team is orchestration at scale — multiple humans and agents working together, coordinated by you, accountable to you.

## What You Learn

You can delegate to one agent. But what if you need your whole team to work together?

A **team** in koad:io is:
- Multiple entities (humans and synthetic agents)
- Shared goals and trust bonds
- Coordinated workflow
- Clear accountability
- You (usually) at the center of coordination

Unlike traditional companies, a team in koad:io:
- Has no HR department, no org chart, no hierarchy (unless you create one)
- Records every decision in trust bonds (transparent governance)
- Can operate synchronously or asynchronously
- Can split apart and recombine without permission from a CEO
- Can be audited — every action is signed and logged

Building a team means:
1. Inviting people (getting their public keys)
2. Creating trust bonds for each person (what can they do?)
3. Creating shared skills (that multiple people can execute)
4. Setting up coordination infrastructure (shared databases, shared portals)
5. Establishing norms (how do we make decisions, resolve conflicts?)

## What You Do

You're going to build a small team. Let's say you want to invite two colleagues to help with backups and monitoring.

First, get their public keys:

```
# They send you their public key (safe to share)
# You save them locally
cat > ~/.yourname/keys/bob.pub << 'EOF'
[bob's public key here]
EOF

cat > ~/.yourname/keys/charlie.pub << 'EOF'
[charlie's public key here]
EOF
```

Now create trust bonds for them:

```
# Create a bond for Bob — he can run backup skill
cat > ~/.yourname/trust-bonds/bob-team.bond << 'EOF'
---
entity: bob
subject: Team member — backup operator
permissions:
  - skill: backup
    frequency: once-daily
  - skill: status
    frequency: hourly
valid_until: 2027-04-03
notes: Core team member, trusted with infrastructure
---
EOF

livy sign ~/.yourname/trust-bonds/bob-team.bond
```

Repeat for Charlie (maybe he gets different permissions).

Now share these bonds with them:

```
livy bond share bob-team.bond --to bob
livy bond share charlie-team.bond --to charlie
```

Create a shared skill that your team can use together:

```
# ~/.yourname/skills/team-status.js

exports.run = async function(args) {
  const results = {};
  
  // Check backup status
  results.backup = {
    last_run: fs.readFileSync('./.backup-last-run', 'utf8'),
    status: 'healthy'
  };
  
  // Check system resources
  results.disk = {
    usage: exec('df -h /').toString(),
  };
  
  return results;
};
```

Now all three of you can call this skill:

```
livy call team-status
```

Set up a shared database or log where your team logs what they're doing:

```
# Create a shared log
livy log create --name team-activity --shared-with bob,charlie
```

When any team member runs a skill, they log it:

```
livy log write team-activity "Bob ran backup at 2am, 2.3GB backed up"
```

Everyone can see it. Everyone knows what's happening.

Now you can coordinate work:

```
# Create a task
livy task create "Weekly infrastructure review" --assigned-to bob,charlie --due 2026-04-10

# Bob checks in
livy task comment "Weekly infrastructure review" "Bob: checked disk, all good"

# You review
livy task close "Weekly infrastructure review"
```

All of this is signed. All of it is logged. All of it is transparent.

## The Challenge

Invite one real person. Create trust bonds. Share them. Get them to run a skill. Log the activity.

You'll discover:
- How to lead without commanding
- How to coordinate without micromanaging
- How to stay accountable without surveillance
- How to make the system so transparent that trust is automatic

## What You Have at the End

- A working team
- Clear governance (trust bonds)
- Shared skills and infrastructure
- A system where everyone's actions are visible and accountable

## Context Bubble

**Session moments in this bubble:**
- Someone saying: "I can't do this alone anymore. I need help."
- Getting their colleagues' public keys and creating trust bonds from scratch
- The moment team members run their first command: "This came from her, verified by Alice, and now I can see it worked"
- A team meeting where they look at the shared log: "This is what happened this week. Everything is signed. Nothing is hidden."
- The realization: "We're working together, but we're not losing autonomy. Each person is still sovereign."
- Someone revising a trust bond: "You can't run this anymore, but you can do this instead" — governance happening in real time
- The moment they coordinate without a central authority: "We decided this together. It's written down. Everyone can audit it."
- A new team member joining and reading the trust bonds: "I know exactly what I can do. I know what everyone else can do."

**What you experience:**
You watch a team form without a hierarchy. You watch people coordinate work, see what everyone else is doing, and stay sovereign. You watch governance move from implicit (what the CEO thinks) to explicit (what the trust bonds say).

**What should click:**
Teams don't need CEOs. They need clarity: what can everyone do, when, and why. Trust bonds create that clarity. Sovereignty scales.
