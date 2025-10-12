# Workshop Setup Guide

Get your environment ready for the "Getting Started with Vibe Coding in Business Central" workshop.

## Prerequisites

Install these before the workshop:

### 1. Visual Studio Code
- Download: https://code.visualstudio.com/
- Version: Latest stable release

### 2. AL Language Extension
- Open VS Code
- Extensions → Search "AL Language"
- Install "AL Language" by Microsoft

### 3. GitHub Copilot (Recommended)
- GitHub Copilot subscription required
- Install in VS Code: Extensions → "GitHub Copilot"
- Install "GitHub Copilot Chat"
- Sign in with your GitHub account
- Verify Copilot icon appears in bottom-right status bar

**Note:** Workshop works with any AI coding assistant (Claude Code, Cursor, etc.), but examples will use GitHub Copilot Chat.

### 4. Node.js
- Download: https://nodejs.org/ (LTS version)
- Required for AL development tooling
- Verify: `node --version` (should show v18+ or v20+)

### 5. Business Central Sandbox (Bring Your Own)
- BC Online Sandbox, Docker container, or local BC installation
- AL development access configured
- Object IDs 50000-50499 available for workshop apps
- Already connected and working in VS Code

---

## Setup Steps

### 1. Clone Repository

```bash
git clone --recurse-submodules https://github.com/JeremyVyska/DirectionsEmea2025-Workshop.git
cd DirectionsEmea2025-Workshop/workshop
```

**Important:** Use `--recurse-submodules` to include the `.al-guidelines` folder (git submodule).

**If you already cloned without submodules:**
```bash
git submodule update --init --recursive
```

### 2. Configure Your BC Connection

Create `.vscode/launch.json` with your BC sandbox connection details.

**Your configuration will vary based on your BC environment:**
- BC Online Sandbox: Use server, tenant, environmentName
- Local Docker: Use server with local URL
- On-premises: Use server with your BC URL

**Example for BC Online:**
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Your BC Sandbox",
      "type": "al",
      "request": "launch",
      "environmentType": "Sandbox",
      "environmentName": "YourEnvironment",
      "startupObjectId": 50200,
      "startupObjectType": "Page",
      "breakOnError": true,
      "launchBrowser": true
    }
  ]
}
```

**Important:** Use your own working BC connection - the workshop assumes you already have a functioning BC AL development setup.

### 3. Verify Connection

1. Open workspace in VS Code
2. Press `F5` or "Run" → "Start Debugging"
3. Should compile and launch BC web client
4. If this doesn't work, fix your BC connection before the workshop

### 4. Checkout Starting Branch

```bash
git checkout stage1-start
```

---

## Optional (But Highly Recommended): BC Code Intelligence MCP

MCP provides **automatic, agentic** AL best practice retrieval for your AI assistant.

### What is MCP?

Model Context Protocol server that automatically supplies AL guidelines to AI tools like GitHub Copilot, Claude Code, and Cursor.

**Why it's better than file-based guidelines:**
- Agentic knowledge retrieval (AI pulls what it needs, when it needs it)
- Automatic context without manual prompting
- Designed for AI collaboration, not just documentation
- Real-time best practice application

### Installation (Recommended)

1. **Install BC Code Intelligence MCP:**
   - Repository: https://github.com/JeremyVyska/bc-code-intelligence-mcp
   - Follow README installation steps
or:
   - One-click install for VS Code: [![Install with NPX in VS Code](https://img.shields.io/badge/Install%20with%20NPX-VS%20Code-blue?style=for-the-badge&logo=visual-studio-code)](https://vscode.dev/redirect/mcp/install?name=bc-code-intel&config=%7B%22type%22%3A%22stdio%22%2C%22command%22%3A%22npx%22%2C%22args%22%3A%5B%22bc-code-intelligence-mcp%22%5D%7D)

2. **Verify Installation:**
   - Ask your AI assistant: "Which specialists are available for BC?"
   - If MCP works, agent retrieves patterns automatically

3. **Workshop Usage:**
   - Stage 1: Not needed (creating baseline with autocomplete)
   - Stage 2: Not needed (testing generic AI limits)
   - Stage 3: **Essential** - MCP specialists demonstrate knowledge-enhanced review

### Fallback: `.al-guidelines/` Folder

**If you can't install MCP:**
- Workshop includes `.al-guidelines/` folder with BC best practices
- Manually reference in prompts: "Review .al-guidelines/performance-patterns.md then..."
- Works, but requires explicit prompting vs automatic retrieval
- File-based grounding vs agentic knowledge application

---

## Verification Checklist

Before workshop starts, verify:

- [ ] VS Code installed with AL Language extension
- [ ] GitHub Copilot + Copilot Chat extensions installed and signed in
- [ ] Node.js installed (`node --version` works)
- [ ] Git installed and configured
- [ ] Repository cloned locally
- [ ] BC sandbox connection configured
- [ ] Can compile AL code (F5 launches BC client)
- [ ] Checked out `stage1-start` branch
- [ ] (Recommended) BC Code Intelligence MCP installed

---

## Workshop Structure

Once setup complete, you'll work through 3 stages:

### Stage 1: Baseline (Autocomplete Thinking)
- Branch: `stage1-start` → `stage1-solution`
- Create baseline code with realistic anti-patterns using autocomplete

### Stage 2: Basic AI Review (Generic Copilot)
- Branch: Stage 1 solution code (no branch change)
- Ask generic AI to review code - observe it catches common issues but misses BC patterns

### Stage 3: Knowledge-Enhanced Review (MCP Specialists)
- Branch: Stage 1 solution code (no branch change)
- Ask MCP specialists to review code - observe significantly higher catch rate
- Demonstrates substantial improvement with knowledge engineering

Each stage has:
- README.md (overview and goals)
- demo-script.md (instructor notes)
- exercise.md (your hands-on task)

---

## Getting Help

### During Workshop
- Raise your hand for facilitator assistance
- Check TROUBLESHOOTING.md in repository
- Ask in workshop chat/discussion

### After Workshop
- Review FACILITATOR-GUIDE.md for self-paced learning
- Check `.docs/` folder for detailed architecture
- Post issues to workshop GitHub repository

---

## Ready to Start?

✅ Setup complete? → See [README.md](README.md) for workshop overview

✅ Questions? → Ask facilitator before workshop begins

✅ Excited? → Get ready for "Vibe Coding in Business Central"! 🚀
