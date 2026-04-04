# Level 9: Build Your First Real Command

## Core Concept
By now you know the pieces. This level is about building something real — a skill that solves an actual problem in your life.

## What You Learn

You've built toy skills (`hello`, `greet`). Now we're going to build something that matters.

A real skill:
- Solves a problem you actually have
- Uses files, networks, or data you care about
- Is complex enough to teach you something
- Is something you'd use more than once

The goal isn't perfection. It's to discover what you can build. Once you've built one real thing, you'll realize: "I can automate anything I want."

Here are some real examples:
- **Backup**: List all your files, compress them, encrypt them with your key
- **Journal**: Create a timestamped, encrypted journal entry
- **Sync**: Copy files from one peer to another, with verification
- **Monitor**: Check if a website is up, log the result, alert if it's down
- **Summarize**: Read a file and summarize it using an LLM (your own API key)

Each of these is real work that would normally take minutes every time you do it. A skill does it in seconds.

## What You Do

Choose a problem. Something you do repeatedly. Something that wastes your time.

Write a skill to solve it. Here's a template — a backup skill:

```
# ~/.yourname/skills/backup.js

const fs = require('fs');
const path = require('path');
const zlib = require('zlib');

exports.run = async function(args) {
  const sourceDir = args.source || process.env.HOME;
  const backupDir = args.backupDir || `${process.env.HOME}/.backups`;
  
  // Create backup directory if it doesn't exist
  if (!fs.existsSync(backupDir)) {
    fs.mkdirSync(backupDir, { recursive: true });
  }
  
  // Create timestamped backup filename
  const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
  const backupFile = path.join(backupDir, `backup-${timestamp}.tar.gz`);
  
  // Use tar to create backup (simplified)
  const { execSync } = require('child_process');
  try {
    execSync(`tar -czf ${backupFile} -C ${sourceDir} .`, {
      stdio: 'inherit'
    });
    
    return {
      success: true,
      message: `Backup created: ${backupFile}`,
      size: fs.statSync(backupFile).size,
      timestamp: timestamp
    };
  } catch (error) {
    return {
      success: false,
      error: error.message
    };
  }
};
```

Load it:

```
livy skill load ./skills/backup.js
```

Test it:

```
livy call backup --source ~/Documents
```

Now you have a backup skill. You can:
- Run it manually whenever you need
- Schedule it to run daily
- Share it with your peer ring
- Export it as a service via your portal

## The Challenge

Now your challenge: build one. Don't overthink it. It doesn't need to be production-ready. It just needs to:
1. Solve something you actually care about
2. Use real files or data
3. Return something useful
4. Be runnable in under a second

Push yourself. What's something you do every week that could be a skill?

## What You Have at the End

- A real, working skill that solves an actual problem
- Proof you can build for your own sovereignty
- The knowledge that anything you do repeatedly can be automated

## Context Bubble

**Session moments in this bubble:**
- Someone describing a problem they face every week (backups, data processing, monitoring)
- Watching them realize: "I could automate this. I could write a skill."
- The moment they finish writing a skill and test it: "It works. It actually works."
- The time saved, multiplied: they run it daily, then weekly, saving hours
- Someone discovering a skill someone else wrote: "I can use this too?"
- A peer ring discovering shared skills: "We all have this problem. One person wrote it. Now we all benefit."
- The moment it clicks: "This is how you take your power back. You automate the things that were automating you."

**What you experience:**
You watch someone solve their own problem. You watch their autonomy increase as automation increases. You watch them realize: they can keep doing this, building more, solving more, forever.

**What should click:**
Real skills solve real problems. They're the difference between doing things to you and doing things for yourself.
