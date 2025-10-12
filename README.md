# Getting Started with Vibe Coding in Business Central

**Directions EMEA 2025 Workshop**
Duration: 105 minutes
Level: All skill levels welcome

## What You'll Learn

This workshop teaches you to collaborate with AI agents progressively, moving from **autocomplete thinking** to **agentic thinking**.

### The Journey

**Stage 1: Autocomplete thinking (22 min)**
Experience how autocomplete creates technical debt through pattern matching without reasoning.

**Stage 2: Basic AI Review (28 min)**
Discover what generic AI catches when reviewing code (common issues, but misses BC-specific patterns).

**Stage 3: Knowledge-Enhanced Review (40 min)**
See the power of BC-specific knowledge with MCP specialists (significantly higher catch rate across all quality dimensions).

### Key Insight

> **Agentic AI isn't about replacing developers—it's about being stronger and faster in areas where developers are weak or don't have time.**

The development workflow includes: scoping, architecture, coding, performance, security, UX, UI design, documentation, extensibility, error handling, telemetry, and metrics.

Most developers focus on **coding** because that's where they're strongest. But production-quality software requires excellence across all dimensions. This workshop demonstrates how agentic AI excels at **review** across the full software lifecycle—catching performance issues, security gaps, UX problems, missing documentation, and extensibility concerns that developers often miss or skip due to time pressure.

**The proof:** Generic AI catches common issues. Knowledge-enhanced AI with BC specialists catches significantly more—demonstrating substantial improvement through domain expertise across performance, security, UX, and extensibility dimensions.

---

## Workshop Setup

**Before starting:** Complete setup from [SETUP.md](SETUP.md)

**Required:**
- VS Code with AL Language extension
- GitHub Copilot (or other AI coding assistant)
- BC sandbox connection
- Repository cloned locally

---

## The AmuseYou System

You'll work on a rental management system for AmuseYou, a company that rents:
- **Bounce Units** (bouncy castles, inflatable slides)
- **Go-Kart Experiences** (track rentals, time trials)

### Architecture: Two-Layer Pattern

```
BookingCore (Base Layer)
├── Equipment table
├── Booking table
├── Enums (EquipmentType, BookingStatus)
└── Interfaces (IBookingProvider, IAvailabilityCheck)

RentalOperations (Business Logic Layer)
├── AvailabilityMgt codeunit
├── BookingMgt codeunit
├── Pages (Equipment List/Card, Booking List/Card)
└── Webhook API

Plus 3 Test Apps:
├── BookingCore.Test (unit tests)
├── RentalOperations.Test (unit + performance tests)
└── Integration.Test (end-to-end workflows)
```

**Why this matters:** Stage 3 showcases how AI agents reason across app boundaries - suggesting indexes in BookingCore to optimize queries in RentalOperations.

---

## Workshop Flow

### Stage 1: Your First AI Feature (22 min)

**Goal:** Experience coding with AI - just make it work!

**What You'll Do:** Pick a simple feature (Customer Email, Equipment Status, or Booking Notes), ask AI to add it, and see it compile.

**What You'll Learn:**
- AI writes code fast
- Simple prompts get you working code quickly
- This is the "vibe" of AI coding

**The catch:** Working code isn't always production-ready code. We'll explore that in Stage 2!

**Branch:** Start from main/clean state

📖 [Stage 1 Details](Stage1-Baseline/README.md)

---

### Stage 2: Basic AI Review (28 min)

**Goal:** Discover what generic AI catches without BC knowledge

**Exercise:** Ask generic GitHub Copilot to review the codebase
**What You'll See:**
- ✅ Catches common issues (easy wins like BEGIN..END, naming conventions)
- ❌ Misses BC-specific patterns (SIFT keys, permission sets, Role Centers)
- ❌ No cross-layer analysis or performance reasoning

**Demonstrates:** File-based grounding has significant limitations with domain-specific knowledge

**Branch:** Stage 1 solution code

📖 [Stage 2 Details](Stage2-Planning/README.md)

---

### Stage 3: Knowledge-Enhanced Review (40 min)

**Goal:** Experience the power of BC-specific knowledge with MCP

**Exercise:** Ask MCP specialists (Dean, Roger, Uma, Jordan) to review
**What You'll See:**
- ✅ Catches significantly more issues across all difficulty levels
- ✅ Identifies BC-specific anti-patterns (SIFT keys, permission models)
- ✅ Provides detailed recommendations with code examples
- ✅ Cross-layer performance analysis

**Demonstrates:** Substantial improvement with knowledge-enhanced agentic review across all quality dimensions

**Branch:** Stage 1 solution code

📖 [Stage 3 Details](Stage3-Complete/README.md)

---

## What Makes This Different

### Progressive Learning Arc

Most AI workshops show "cool demos." This workshop demonstrates **research-backed evidence** of AI's strength in review.

- **Stage 1:** Create realistic technical debt (autocomplete baseline)
- **Stage 2:** Test generic AI review capabilities (~44% catch rate)
- **Stage 3:** Experience knowledge-enhanced review power (~95% catch rate)

### Real BC Patterns

- Multi-app architecture (base + operations layers)
- Proper namespaces (not prefixes)
- Interface-based design
- Performance optimization with indexes
- Comprehensive testing (unit + performance + integration)

### Teaching Repository

After the workshop, you can use this repository to:
- Run the workshop with your own team
- Practice agentic collaboration skills
- Reference AL best practices
- Share BC AI collaboration patterns

---

## Resources in This Repository

### For Participants

- **Stage folders:** README, demo scripts, exercises for each stage
- **.al-guidelines/:** AL best practices (performance, naming, error handling, testing) converted from [AL Guidelines](https://github.com/microsoft/alGuidelines) to agentic markdown files
- **SETUP.md:** Environment setup instructions
- **FACILITATOR-GUIDE.md:** How to run this workshop yourself

### For Facilitators

- **demo-script.md** in each stage folder (instructor notes)
- **FACILITATOR-GUIDE.md:** Detailed facilitation guide
- **TROUBLESHOOTING.md:** Common issues and solutions
- **.docs/plan-v2.0.md:** Full workshop design

---

## Key Takeaways

By the end of this workshop, you'll be able to:

✅ **Distinguish** autocomplete vs agentic thinking
✅ **Apply** planning-first workflow with AI
✅ **Leverage** cross-layer reasoning for multi-app scenarios
✅ **Use** knowledge application (MCP or guidelines) for better quality
✅ **Generate** comprehensive tests with AI collaboration
✅ **Teach** these patterns to your team using this repository

---

## Quick Start

1. **Clone repository with submodules:**
   ```bash
   git clone --recurse-submodules https://github.com/JeremyVyska/DirectionsEmea2025-Workshop.git
   cd DirectionsEmea2025-Workshop/workshop
   ```
2. **Complete setup:** [SETUP.md](SETUP.md)
3. **Checkout starting branch:**
   ```bash
   git checkout stage1-start
   ```
4. **Read Stage 1 README:** [Stage1-Baseline/README.md](Stage1-Baseline/README.md)
5. **Wait for workshop to begin**

---

## The Progression at a Glance

| Stage | Approach | Catch Rate | Key Learning |
|-------|----------|------------|--------------|
| **Stage 1: Autocomplete** | Pattern matching without reasoning | N/A (creates baseline) | Technical debt accumulates quickly |
| **Stage 2: Generic Review** | File-based grounding, no BC knowledge | Lower (common issues only) | Misses BC-specific patterns |
| **Stage 3: MCP Review** | Agentic knowledge retrieval + BC experts | Significantly Higher (most issues) | Substantial improvement with domain expertise |

---

## After the Workshop

### Continue Learning

- Use this repo for practice and reference
- Run the workshop with your team
- Explore `.al-guidelines/` for BC patterns
- (Optional) Install BC Code Intelligence MCP for your regular use

### Share Your Experience

- Blog about your agentic collaboration journey
- Share workshop repo with BC community
- Contribute AL best practices to guidelines

---

## Credits

**Workshop Design:** Jeremy Vyska
**Event:** Directions EMEA 2025
**Duration:** 105 minutes
**License:** [To be determined - open for community use]

---

## Questions?

- **During workshop:** Raise hand or ask in chat
- **After workshop:** Create issue in repository

---

**Ready to transform your AI collaboration from autocomplete to agentic?**

**Let's get started! 🚀**
