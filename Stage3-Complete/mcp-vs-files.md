# Knowledge Application: MCP vs File-Based

Both paths provide the **same BC best practices content** - but the delivery method and experience differ significantly.

## Path 1: BC Code Intelligence MCP (Recommended)

### What It Is
Model Context Protocol server that automatically provides AL best practices to your AI agent.

### How It Works
- One-click install in VS Code
- **Agentic knowledge retrieval:** Agent automatically pulls what it needs, when it needs it
- No manual prompting needed for best practices
- Designed for AI collaboration, not just documentation
- Seamless integration with GitHub Copilot, Claude Code, Cursor, and other AI tools

### Example Interaction

**Your prompt:**
```
I need to optimize this query that handles 1000+ equipment records
```

**What happens behind the scenes:**
- MCP automatically provides performance-patterns.md to agent
- Agent applies BC indexing strategies without you asking
- Suggests SetLoadFields, proper key structure, efficient filtering

**Agent response:**
```
Based on AL performance best practices, I recommend:
1. Add index on Equipment: key(TypeDateKey; "Equipment Type", "Last Maintenance Date")
2. Use SetLoadFields to minimize data transfer
3. Filter order: most selective filter first
[implementation follows...]
```

### Why It's Better
- **Agentic vs manual:** AI decides what knowledge it needs
- **Automatic context:** No need to guess which guideline file to reference
- **Real-time application:** Best practices applied as you work
- **Superior collaboration:** Designed for AI agents, not human reading

### When to Use
- You have MCP installed and configured (recommended for all BC AL work)
- Want the best AI collaboration experience
- Working on complex BC projects regularly

---

## Path 2: `.al-guidelines/` Folder (Fallback)

### What It Is
Pre-loaded markdown files in workshop repository containing AL best practices.

### How It Works
- Guidelines are already in `.al-guidelines/` folder
- **You must explicitly prompt** agent to review relevant file
- Agent reads file and applies patterns (file-based grounding)
- Same content as MCP, but requires manual activation

### Example Interaction

**Your prompt:**
```
I need to optimize this query that handles 1000+ equipment records.
Review .al-guidelines/domains/dean-debug/ knowledge files for performance optimization guidance.
```

**What happens:**
- Agent reads relevant performance knowledge files from Dean's domain
- Agent applies patterns to your scenario
- Suggests same optimizations as MCP path

**Agent response:**
```
After reviewing AL performance patterns, I recommend:
1. Add index on Equipment: key(TypeDateKey; "Equipment Type", "Last Maintenance Date")
2. Use SetLoadFields to minimize data transfer
3. Filter order: most selective filter first
[implementation follows...]
```

### Limitations vs MCP
- **Manual prompting required:** You must remember to reference guidelines
- **Static file-based:** Not designed for dynamic AI retrieval
- **Less agentic:** AI doesn't choose which knowledge it needs
- **Works but not optimal:** Functional fallback, not ideal experience

### When to Use
- MCP installation not possible in your environment
- You need the workshop to work without dependencies
- Temporary fallback while setting up MCP

---

## Knowledge Content Comparison

Both paths provide the **same BC best practices content** from AL Guidelines repository:

### Dean (Performance) - `.al-guidelines/domains/dean-debug/`
- SetLoadFields optimization patterns
- SIFT technology fundamentals
- Table key requirements
- OData query optimization
- Telemetry performance considerations
- No Series implementation patterns
- Custom dimensions best practices

### Roger (Quality) - `.al-guidelines/domains/roger-reviewer/`
- Code quality standards
- AL coding conventions
- Error handling patterns
- Security best practices
- Code review guidelines

### Uma (UX) - `.al-guidelines/domains/uma-ux/`
- Page design patterns
- Field organization
- Action placement
- Role Center design
- FactBox usage
- User experience guidelines

### Jordan (Integration) - `.al-guidelines/domains/jordan-bridge/`
- Integration event patterns
- API design standards
- Extensibility patterns
- Error handling for integrations
- Retry logic implementation

---

## Workshop Philosophy

### MCP is Recommended, Not Required

**For the workshop:**
- MCP provides superior experience but isn't mandatory
- File-based fallback ensures everyone can participate
- Focus on learning agentic collaboration patterns
- Encourage MCP installation post-workshop

**We care about outcomes:**
- ✅ Did agent suggest proper indexes?
- ✅ Did agent apply AL best practices?
- ✅ Did agent create comprehensive tests?
- ✅ Is the code production-ready?

**Be honest about differences:**
- MCP = Better AI collaboration experience (agentic retrieval)
- Files = Functional fallback (manual grounding)
- Both teach the same patterns, different delivery quality

---

## Post-Workshop: Installing MCP (Optional)

If you saw MCP value during the workshop and want to install it:

### Installation Steps

1. **Install BC Code Intelligence MCP**
   - Repository: https://github.com/microsoft/bc-code-intel-server
   - One-click install for VS Code
   - Configuration guide in repo README

2. **Verify Installation**
   ```
   Ask your AI: "What AL performance best practices should I know?"
   If MCP is working, agent will retrieve patterns automatically.
   ```

3. **Use It**
   - No prompt changes needed
   - Agent automatically accesses guidelines
   - Works with Claude Code, GitHub Copilot, Cursor, etc.

### Benefits After Installation

- Faster workflow (no manual file references)
- Always up-to-date best practices
- Works across all BC projects
- Automatic retrieval when agent needs context

---

## Comparison Table

| Aspect | MCP (Recommended) | File-Based (Fallback) |
|--------|-------------------|----------------------|
| **Knowledge Content** | ✅ Same content | ✅ Same content |
| **Delivery Method** | Agentic retrieval | File-based grounding |
| **Setup Required** | MCP installation | None (files in repo) |
| **Activation** | Automatic | Manual prompt required |
| **Prompt Style** | "Optimize this query" | "Review .al-guidelines/domains/dean-debug/ then optimize" |
| **AI Experience** | Designed for agents | Designed for humans |
| **Reliability** | Depends on MCP connection | Always works |
| **Best For** | All BC AL development | Fallback when MCP unavailable |
| **Post-Workshop** | Install for ongoing work | Use until MCP installed |

---

## Bottom Line

**Both paths teach the same agentic collaboration skills.**

The workshop demonstrates:
- Planning-first approach
- Cross-layer reasoning
- Knowledge application (however delivered)
- Comprehensive testing

Whether you use MCP or file-based references, you're learning to collaborate with AI at the agentic level.

---

**Choose the path that works for you.** The skills transfer regardless of how knowledge is delivered.
