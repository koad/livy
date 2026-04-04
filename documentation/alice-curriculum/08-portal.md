# Level 8: The Portal

## Core Concept
The portal is your kingdom as a doorway. It's how others can interact with you and your work without needing direct access to your machine.

## What You Learn

Until now, you've been working on your machine. Commands run on your daemon. Skills live in your folder. But what if someone else wants to use your skills? What if you want to expose something you've built to the world?

That's where the portal comes in.

A **portal** is a public interface to your entity. It's a web endpoint (usually running on your machine or on a machine you trust) that:
- Accepts requests from the outside world
- Verifies that requests are cryptographically signed and authorized
- Executes the matching skills in your daemon
- Returns results

Here's what's important: a portal doesn't give away control. It doesn't make your keys public. It doesn't let strangers run arbitrary commands. Instead, you decide:
- Which skills are exposed via the portal
- Who's allowed to call them
- What the rate limits are
- Whether to log who's calling

The portal is a doorway to your work, but *you* control the door.

Portals can be:
- **Public** — anyone can see what skills you offer
- **Restricted** — only entities you've granted trust bonds to can call your skills
- **Private** — only you and specific trusted entities can access it

A portal is useful for:
- Sharing tools with your team
- Offering services to a peer ring
- Exposing read-only data (like a public directory)
- Building automation that external systems can trigger

## What You Do

You're going to expose one of your skills via a portal.

First, decide which skill. Let's use the `greet` skill from Level 5.

Tell your daemon to expose it:

```
livy portal create --name "greeting-service"
livy portal add --portal greeting-service --skill greet --public
```

This creates a portal and makes the `greet` skill available on it. Your daemon assigns it a URL:

```
livy portal info greeting-service
```

You'll see something like: `https://your-entity.local/portal/greeting-service`

Now test it from another machine:

```
# Call your skill through the portal
curl https://your-entity.local/portal/greeting-service/greet?name=Alice
```

Your daemon verifies the request, runs the skill, and returns the result. Congratulations — your skill is now accessible from the outside world.

If you want to restrict who can call it:

```
livy portal add --portal greeting-service --skill greet --restrict-to bob,charlie
```

Now only Bob and Charlie (if they sign their requests with their keys) can call this skill.

## What You Have at the End

- A public portal exposing your work
- Understanding how to share your skills without giving up control
- The ability to build services that others can use

## Context Bubble

**Session moments in this bubble:**
- Someone saying: "I built this tool. I want to share it. But I don't want to give away my keys."
- The portal being designed: "How do we let people use your skills without trusting them with your entity?"
- Someone creating their first portal and watching traffic come in: "People are using my skill. I didn't give them any power. They just sent a request. I verified it. I ran it."
- The realization: "I can share *anything* and stay in control."
- A developer explaining rate limits, access controls: "You decide who gets to call what. The daemon enforces it."
- Someone opening their portal and seeing it used in ways they never expected: "My work is having an impact. And I'm still sovereign."

**What you experience:**
You watch someone's private skill become a public service. You watch them realize: I can share without losing control. The internet doesn't have to mean giving away your power.

**What should click:**
Portals are how you scale your impact. You share your work with the world, but the world doesn't get your keys. You stay sovereign.
