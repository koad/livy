# Level 6: Trust Bonds

## Core Concept
A trust bond is a cryptographic relationship. It says: "I trust this entity to do these specific things." Trust bonds live on disk, signed, permanent, and revocable.

## What You Learn

Until now, you've been alone. You control everything. You run commands. Your daemon listens to you.

But what happens when you want to work with someone else? Or let a bot act on your behalf? Or give your friend permission to run a specific skill?

That's where trust bonds come in.

A **trust bond** is a file you create and sign that says something like: "I, Alice, trust Bob to execute the `backup` skill. This permission is valid until 2026-12-31. I reserve the right to revoke this bond."

The trust bond is:
- Cryptographically signed by you (with your key)
- Stored in a file on disk
- Machine-readable and human-readable
- Revocable at any time
- Verifiable by anyone

When Bob tries to run that skill, your daemon checks: "Does Bob have a valid trust bond from Alice? Is it still active? Is the signature real?" If yes on all counts, Bob can run it.

Here's the power: trust bonds are *specific*. You don't grant blanket access. You say exactly what each entity can do. You can create a bond that says "run the backup skill once per day" or "read files in /data but only on Mondays" or "I trust you completely until 2027."

Trust bonds are your governance system. They're how you stay sovereign while working with others.

## What You Do

You're going to invite someone to your kingdom and create a trust bond.

First, get their public key. They share it with you (it's safe to share):

```
# Create a trust bond
# (This is a template — you'll customize it)

cat > ~/.yourname/trust-bonds/bob-backup.bond << 'EOF'
---
entity: bob
subject: Execute the 'backup' skill
permission: EXECUTE
skill: backup
valid_from: 2026-04-03
valid_until: 2027-04-03
---
EOF
```

Now sign it with your key:

```
livy sign ~/.yourname/trust-bonds/bob-backup.bond
```

Your daemon will save the signature. Now publish (send) that bond to Bob:

```
livy bond share bob-backup.bond --to bob
```

Bob receives it. He verifies it's really from you (using your public key). He loads it into his daemon. Now he can run the backup skill.

If you ever want to revoke it:

```
livy bond revoke bob-backup.bond
```

The bond is still on disk, but it's marked as revoked. Bob's daemon will refuse to use it.

Congratulations — you've just built your first governance system.

## What You Have at the End

- A trust bond granting specific permissions
- Understanding of how to work with others while staying in control
- A governance mechanism that's transparent, cryptographic, and revocable
