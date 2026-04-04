# Level 5: Commands and Skills

## Core Concept
Commands are how your entity *does* things. Skills are reusable commands you've written once and use many times.

## What You Learn

Your daemon can't do anything without being told what to do. That's where commands come in.

A **command** is an instruction. You tell your entity: "Do this thing." The daemon listens, validates that it's really you asking, and does the work.

A **skill** is a command you've written and saved so you can use it over and over, or share it with other entities.

Here's the important bit: commands are *signed*. When you tell your entity to do something, you're cryptographically signing that request with your key. No one else can make commands in your name. The daemon won't accept unsigned commands or commands signed by someone it doesn't trust.

This is how you stay in control even when you delegate. You can give someone permission to run specific skills, but you always know who did what, and you can revoke that permission whenever you want.

Skills are just functions. You write them in a language you know (JavaScript, Python, Go — whatever). You put them in your entity folder. The daemon loads them, runs them when asked, and logs every execution.

## What You Do

You're going to write your first skill. Don't worry — it's simple.

Create a file in your entity:

```
# ~/.yourname/skills/hello.js

exports.run = async function(args) {
  return `Hello, ${args.name || 'world'}!`;
};
```

Tell your daemon to load it:

```
livy skill load ./skills/hello.js
```

Now run it:

```
livy call hello --name "Your Name"
```

You just executed a command that you signed, the daemon validated, and your skill ran. This is the core of how entities work.

Try building on it:

```
# ~/.yourname/skills/greet.js

exports.run = async function(args) {
  const time = new Date().getHours();
  let greeting;
  
  if (time < 12) greeting = 'Good morning';
  else if (time < 18) greeting = 'Good afternoon';
  else greeting = 'Good evening';
  
  return `${greeting}, ${args.name}!`;
};
```

Load and run this skill. You're building your kingdom's capabilities.

## What You Have at the End

- Your first skill written and running
- Understanding that you control what your entity can do
- The foundation for automation

## Context Bubble

**Session moments in this bubble:**
- Someone writing their first skill — a simple JavaScript function that returns "Hello"
- The moment they load it and run it: `livy call hello` — it works
- The realization: "Wait, I just *wrote* what my entity can do. I'm not limited by someone else's UI."
- Watching someone build on the skill, making it more complex: "I can do anything here"
- A developer explaining signed commands: "Every time you tell your entity to do something, you sign it. Your daemon verifies it's really you."
- The moment it clicks: "I can build my own tools. I can automate my own life."

**What you experience:**
You watch code become power. You watch someone write a simple function and then realize: they can write *any* function. They can make their entity do *anything*. Automation isn't something that happens to you — you make it happen.

**What should click:**
You don't wait for features. You write them. Your entity is programmable by you, controlled by you, limited only by your imagination.
