# Level 3: Keys and Identity

## Core Concept
Your keys are you. In the digital world, your keys are your word, your signature, your proof. Protect them like you'd protect your life.

## What You Learn

Here's a simple truth: if someone has your private key, they can pretend to be you perfectly. No way to prove they're not you. No way to dispute it.

Your public key is the opposite — it's safe to share with everyone. It's like your fingerprint printed in a phone book. When you sign something with your private key, anyone with your public key can verify it really came from you.

In your entity folder, you'll find:
- **Public keys** — safe to give out, live on the network, prove who you are
- **Private keys** — stay locked on your machine, never shared, never sent anywhere
- **Key agent** — a small program that lets you use your keys without typing passwords constantly

The key agent is your relationship with your own keys. It's running on your machine, in your control. You authenticate to your key agent (password, biometric), and then it handles signing things on your behalf.

This is the difference between koad:io and centralized systems: *you hold your keys. No one else. Ever.*

## What You Do

You're going to meet your key agent. This is the small program that lives on your machine and protects your keys.

```
# Start your key agent
livy daemon start
```

Now verify it's running:

```
# List your keys
livy keys list
```

You should see your public keys. These are safe to look at. Your private keys are protected — the agent won't show them, and neither will you show them to anyone.

Try signing something:

```
# Create a small message
echo "I control my own keys" > message.txt

# Sign it with your key
livy sign message.txt
```

The signature is verifiable proof that you created that file, in that moment, with your keys. No one can forge it.

## What You Have at the End

- A running key agent on your machine
- Understanding that your keys are *you* — and they're safe
- A signed message as proof you can use your identity

## Context Bubble

**Session moments in this bubble:**
- A cryptographer explaining why private keys are so powerful: "This key is you. If someone has it, they are you."
- Someone's first realization about centralized platforms: "Wait, they hold MY keys? They could pretend to be me?"
- The moment someone signs their first message and verifies it — the aha: "This signature *proves* I created this. And no one else can forge it."
- A developer explaining the key agent: "Your keys stay on your machine. I never see them. You control them."

**What you experience:**
You watch the power of cryptographic identity sink in. You watch someone realize: my private key is truly *mine*. It's the difference between trusting a company and trusting math.

**What should click:**
Cryptography is how you prove you're you, permanently and without intermediaries. Your keys are the most important thing you own.
