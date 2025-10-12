# AmuseYou Workshop Plan v2.0

## Core Constraints (From Approved Pitch)
- **Duration:** 105 minutes total
- **Title:** "Getting Started with Vibe Coding in Business Central"
- **Format:** Highly interactive with GitHub template project
- **Goal:** Progressive AI collaboration skills - autocomplete thinking → agentic thinking
- **Takeaway:** Teaching repo participants can use with their teams

## The Key Insight: Autocomplete vs Agentic

**Autocomplete thinking:** "Fill in what's missing based on patterns"
- Predicts next token/line/function
- Copies nearby code structure
- No reasoning about what *should* exist

**Agentic thinking:** "Reason about desired outcomes and plan solutions"
- Understands cross-file dependencies
- Plans before implementing
- Identifies performance implications before code exists
- Suggests architecture improvements

## Simplified Architecture: 5 Apps Total

### The Two-Layer Pattern (Your Favorite)
```
AmuseYou-Apps/
├── BookingCore/                    # Base layer: data model, interfaces
│   ├── app.json
│   └── src/
│       ├── Tables/                 # Equipment, Bookings (needs indexing)
│       ├── Interfaces/             # IBookingProvider, IAvailabilityCheck
│       └── Enums/                  # Equipment types, booking status
│
├── BookingCore.Test/               # Unit tests for base layer
│   ├── app.json
│   └── src/
│
├── RentalOperations/               # Upper layer: business logic consuming BookingCore
│   ├── app.json                    # Depends on: BookingCore
│   └── src/
│       ├── Codeunits/              # Availability checks, pricing logic
│       ├── Pages/                  # UI for bookings
│       └── API/                    # Webhook simulation endpoint
│
├── RentalOperations.Test/          # Unit + performance tests (combined)
│   ├── app.json
│   └── src/
│       ├── UnitTests/              # Standard test coverage
│       └── PerformanceTests/       # Benchmark scenarios
│
└── Integration.Test/               # End-to-end workflow tests
    ├── app.json
    └── src/
```

### Why This Works
- **Two-layer dependency** shows agents reasoning across app boundaries
- **Index scenario:** Table in BookingCore needs index, RentalOperations query reveals why
- **Testing integrated:** Unit + performance tests in same app (simpler structure)
- **Simpler scope:** 5 apps, easier to explain in 105 minutes
- **Real BC patterns:** Still multi-app, DI, testing - just streamlined

## Business Domain: AmuseYou

AmuseYou rents entertainment equipment:
- **Bounce Units** (bouncy castles, inflatable slides)
- **Go-Kart Experiences** (track rentals, time trials)

System manages:
- Equipment inventory and availability
- Customer bookings/reservations
- Webhook integration (simulated external booking platform)
- Safety checks and maintenance tracking
- Pricing and rental periods

**Simple enough to grasp in 5 minutes, complex enough for meaningful AI collaboration.**

## Technical Specifications

### Publisher
**Directions EMEA 2025**

### Application Details

| App Name | GUID | Object Range | Purpose |
|----------|------|--------------|---------|
| BookingCore | 4beb0468-0ebf-424c-856d-f341c7d5edf9 | 50000-50099 | Base data model and interfaces |
| BookingCore.Test | 9ed4ce5b-5728-4bc5-9aea-65c8e5d73f57 | 50100-50199 | Unit tests for BookingCore |
| RentalOperations | eb6f285d-6f6e-4351-b9f3-bbf3c9d47491 | 50200-50299 | Business logic layer |
| RentalOperations.Test | 9ef5dc45-9fae-4e83-b47e-21f1eff55a3d | 50300-50399 | Unit + performance tests |
| Integration.Test | ea0db4ad-8360-4cc6-ae50-3055720b3356 | 50400-50499 | End-to-end tests |

### Dependencies
```
BookingCore (no dependencies)
└── BookingCore.Test (depends on: BookingCore)

RentalOperations (depends on: BookingCore)
├── RentalOperations.Test (depends on: RentalOperations, BookingCore)
└── Integration.Test (depends on: BookingCore, RentalOperations)
```

## Workshop Flow: 105 Minutes

### Pre-Workshop Setup (CRITICAL)

**Required Setup (sent via email 3-5 days before):**
1. VS Code with AL Language extension
2. Node.js (required for BC development)
3. Clone workshop repository
4. BC sandbox/container connection

**Optional but Recommended:**
5. **BC Code Intelligence MCP** (one-click install for VS Code)
   - Provides automatic best practices retrieval
   - Not required - fallback `.al-guidelines/` folder included
   - Installation guide: [link to your MCP repo]

**Setup Guide:**
- BC sandbox connection details
- AL extension tools
- Git clone instructions
- Optional MCP installation

**Setup verification:** First 5 minutes of workshop is "can everyone see the repo?"

### Introduction (10 min)
- Workshop goals: autocomplete → agentic thinking
- AmuseYou domain: 2-minute business context
- **Architecture reveal:** "Two layers, base + operations, plus testing apps"
  - Don't dump all details, just conceptual map
- **Setup check:**
  - "Everyone has the repo open?" (required)
  - "Who installed BC Code Intelligence MCP?" (show of hands, acknowledge, move on)
  - "If not, you'll use `.al-guidelines/` folder - same knowledge, works great"

### Stage 1: Baseline - Autocomplete Thinking (22 min)
**Goal:** Show what AI does with minimal guidance (autocomplete mode)

**Demo (8 min):**
- "Add a discount field to bookings"
- Watch AI make predictable mistakes:
  - Hardcoded discount % instead of enum
  - No validation logic
  - Missing from related queries
  - Wrong object ID range
- **Key callout:** "Notice how AI filled in what's *nearby*, not what *should exist*"

**Participant Exercise (11 min):**
- Add "equipment maintenance status" field
- Observe similar autocomplete patterns

**Debrief (3 min):**
- "This is autocomplete thinking - pattern matching, not reasoning"
- Sets baseline technical debt for later stages

### Stage 2: Planning - Agentic Collaboration (28 min)
**Goal:** AI as planning partner BEFORE code

**Demo (10 min):**
- Same discount feature, but with planning conversation:
  - "What are the ways discounts could be applied?"
  - "What validation do we need?"
  - "Where else in the codebase will this impact?"
- AI reveals: needs enum, validation codeunit, affects pricing calculations
- THEN implement with refined instructions
- **Key callout:** "Agent thought about what *should* exist, not just what's missing"

**Participant Exercise (15 min):**
- Fix their Stage 1 maintenance status field using planning approach
- Template provided:
  1. Ask AI: "What considerations for maintenance status tracking?"
  2. Review AI's plan
  3. Refine instructions based on plan
  4. Implement

**Debrief (3 min):**
- Compare Stage 1 (autocomplete) vs Stage 2 (agentic planning)
- Show side-by-side code quality difference

### Stage 3: Cross-Layer Reasoning + Knowledge + Testing (40 min)
**Goal:** Agents understand dependencies, performance, apply best practices, AND generate comprehensive tests

**Your Favorite Scenario - The Complete Index + Test Story:**

**Demo Part 1: Cross-Layer + Knowledge (12 min):**
- "We need to query available equipment for date range in RentalOperations"
- Agent with cross-layer thinking:
  1. Analyzes query in RentalOperations layer
  2. Realizes BookingCore table needs index
  3. **KNOWLEDGE MOMENT:** "Let me check AL performance best practices..."
     - **With MCP:** Agent automatically retrieves BC Code Intelligence guidelines
     - **Without MCP:** "Review `.al-guidelines/performance-patterns.md` first"
  4. Suggests: "Add index to BookingCore.Equipment table on EquipmentType, AvailabilityDate per AL guidelines"
  5. Implements efficient query pattern following best practices
- **Key callout:** "Agent reasoned across app boundaries AND applied external knowledge - autocomplete does neither"

**MCP Introduction (integrated, not separate):**
- "Some of you have BC Code Intelligence MCP installed - your agent just retrieved best practices automatically"
- "Others using `.al-guidelines/` folder - same knowledge, manual reference"
- "Both paths work. MCP automates the retrieval. Let's keep moving."
- **No troubleshooting, no deep dive - just acknowledge it works**

**Demo Part 2: Testing That Query (8 min):**
- "Now create performance test to verify the index helps"
- Agent generates:
  - Test data setup (1000+ equipment records)
  - Benchmark with/without index scenario
  - Performance assertions
  - Unit tests for edge cases (date boundaries, no results, etc.)
- **Key callout:** "Agent created tests we'd forget to write - this is where they excel"

**Participant Exercise (17 min):**
- Implement "upcoming maintenance report" feature
- Prompt: "Apply AL best practices for performance and create comprehensive tests"
  - (MCP users: automatic retrieval)
  - (Others: "Review .al-guidelines/performance-patterns.md and testing-standards.md first")
- Agent should suggest:
  - Index on maintenance date in BookingCore
  - Efficient query pattern in RentalOperations
  - Unit tests for query logic
  - Performance test to verify index effectiveness
- **Focus on outcomes, not which path they used**

**Debrief (3 min):**
- "Who got index suggestions? Performance tests? Unit test edge cases?"
- "This is full agentic collaboration: cross-layer reasoning + knowledge application + thorough testing"
- "MCP vs file-based - same knowledge application, different delivery"

### Wrap-up & Next Steps (5 min)
- **Key takeaway:** Autocomplete fills patterns, agents reason about outcomes
- **Teaching repo:** "Use this with your team - exercises are reusable"
- **Progression path:**
  - Start: Use AI for autocomplete (it's fine for simple tasks)
  - Grow: Plan with AI before implementing
  - Master: Let AI reason about architecture, performance, testing
- Resources: Link to community best practices repos
- Q&A buffer

## Repository Structure

```
DirectionsEmea2025-Workshop/
├── README.md                       # Landing page, setup instructions
├── SETUP.md                        # Detailed environment setup (includes MCP)
├── .devcontainer/                  # Codespace configuration (MCP pre-installed)
│   └── devcontainer.json
├── .al-guidelines/                 # Fallback best practices (file-based)
│   ├── performance-patterns.md     # Query optimization, indexing strategies
│   ├── naming-conventions.md       # AL naming standards
│   ├── error-handling.md           # Exception patterns
│   └── testing-standards.md        # Test structure and coverage
├── AmuseYou-Apps/                  # The 5-app ecosystem
│   ├── BookingCore/
│   ├── BookingCore.Test/
│   ├── RentalOperations/
│   ├── RentalOperations.Test/      # Unit + performance tests combined
│   └── Integration.Test/
├── Stage1-Baseline/
│   ├── README.md                   # "Autocomplete Thinking"
│   ├── demo-script.md              # Presenter notes
│   └── exercise.md                 # Participant task
├── Stage2-Planning/
│   ├── README.md                   # "Agentic Planning"
│   ├── demo-script.md
│   ├── exercise.md
│   └── planning-template.md        # Conversation starter for participants
├── Stage3-Complete/
│   ├── README.md                   # "Cross-Layer + Knowledge + Testing"
│   ├── demo-script.md              # Full demo: index scenario through testing
│   ├── exercise.md
│   └── mcp-vs-files.md             # Quick reference for both approaches
├── Solutions/                      # Released AFTER workshop or password-protected
│   ├── Stage1-complete/
│   ├── Stage2-complete/
│   └── Stage3-complete/
├── FACILITATOR-GUIDE.md            # How to run this workshop for your team
├── TROUBLESHOOTING.md              # Common setup/runtime issues (includes MCP)
├── .docs/
│   ├── seed.md                     # Original pitch
│   ├── architecture-plan.md        # v1 (deprecated)
│   └── plan-v2.0.md                # This file
└── .github/
    └── copilot-instructions.md     # AI collaboration guidance
```

## Git Branching Strategy

Participants work on branches, not main:

```
main (read-only starting point)
├── stage1-start (starting code for Stage 1)
├── stage1-solution (completed Stage 1, with "technical debt")
├── stage2-start (same as stage1-solution)
├── stage2-solution (improved with planning)
├── stage3-start (same as stage2-solution)
└── stage3-solution (cross-layer + knowledge + testing - complete)
```

**Participant workflow:**
1. Checkout `stage1-start`
2. Work on it, commit locally
3. Compare to `stage1-solution` in debrief
4. Checkout `stage2-start` (fresh slate from solution)
5. Work, compare to `stage2-solution`
6. Checkout `stage3-start` (ready for final stage)
7. Complete the full agentic workflow

**Prevents:** Spoilers, confusion, "I broke it and can't recover"

## Knowledge-Rich Collaboration Strategy

**Two-Path Approach (introduced in Stage 3):**

### Path 1: BC Code Intelligence MCP (Recommended)
- One-click install for VS Code
- **Agentic knowledge retrieval:** AI pulls what it needs automatically
- No manual prompting required
- Real-time best practice application
- **Superior approach:** Designed for AI collaboration, not just documentation

### Path 2: `.al-guidelines/` Folder (Fallback)
- Pre-loaded in repository
- Participant prompts: "Review .al-guidelines/performance-patterns.md first"
- Agent reads file, applies patterns
- File-based grounding vs agentic retrieval
- **Always works:** No dependencies, universal compatibility

### Knowledge Content
Both paths provide the same BC best practices content:
- Performance optimization patterns (indexing, query efficiency)
- Naming conventions (AL standards)
- Error handling strategies
- Testing best practices

**But delivery differs:** MCP = agentic retrieval, Files = manual grounding

### Workshop Philosophy
- **MCP is recommended but optional:** If installed, better experience. If not, fallback works.
- **Focus on outcomes:** "Did agent apply best practices?" regardless of path
- **Be honest about differences:** MCP is better, but don't gate workshop on it
- **Post-workshop:** Encourage MCP adoption for those who saw the value

**Pre-loaded in repo:**
- `.github/copilot-instructions.md` with AL best practices
- Links to:
  - freddydk/bcsamples patterns
  - Microsoft bctech repo standards
  - Community testing patterns
  - BC Code Intelligence MCP repository

## Success Metrics

Participants leave understanding:

1. **Autocomplete vs Agentic distinction** (can explain difference)
2. **Planning-first workflow** (collaborate before implementing)
3. **Cross-boundary reasoning** (agents analyze dependencies)
4. **Testing/Performance leverage** (where agents excel)
5. **Reusable teaching patterns** (can run workshop internally)

## What Makes This Different from v1

| v1 (architecture-plan.md) | v2.0 (this plan) |
|---------------------------|------------------|
| 12 apps (overwhelming) | **5 apps (streamlined)** |
| 105 min but planned for 120 | **105 min (correct timing)** |
| Bridge pattern complexity | Two-layer dependency (simpler) |
| 4 generic stages | **3 focused stages (baseline → planning → complete agentic)** |
| Personas split participants | Progressive exercises for all |
| Vague "knowledge-rich" stage | **MCP + file-based knowledge integrated (Stage 3)** |
| Testing as separate stage | **Testing integrated with cross-layer demo (Stage 3)** |
| No setup safety net | BYOB (bring your own BC sandbox) |
| Solutions visible from start | Solutions protected/released later |
| Missing facilitator guide | FACILITATOR-GUIDE.md for reuse |
| Index scenario buried | **Index scenario + knowledge + testing featured (Stage 3 showcase)** |
| Generic best practices | **Your BC Code Intelligence MCP + .al-guidelines/ fallback** |

## Complexity Opportunities

### Stage 1: What Autocomplete Gets Wrong
- Hardcoded values (no enums)
- Missing validation
- Incomplete implementations (field added, but not in queries)
- Wrong object ID ranges
- No error handling
- Pattern duplication

### Stages 2-3: What Agentic Thinking Fixes
- **Stage 2 - Planning:** Enums, validation, impact analysis
- **Stage 3 - Complete Agentic:**
  - Cross-layer reasoning (index suggestions, dependency awareness)
  - Knowledge application (best practices retrieval)
  - Testing excellence (comprehensive coverage, edge cases, performance benchmarks)
  - Quality (DRY, proper abstractions, documentation)

## Risk Mitigation

**Setup fails:** Codespace fallback ready

**Timing overruns:** Each stage has "core demo" (must do) + "extended exercise" (skip if needed)

**Mixed experience levels:** Exercises have "basic" and "advanced" versions in same doc

**Participant stuck:** Solutions available to facilitator, can be shared selectively

**Post-workshop questions:** FACILITATOR-GUIDE.md has FAQ, troubleshooting, "what next"

## Why This Works for a 105-Minute Workshop

- **5 apps not 12:** Cognitive load manageable, quick to understand
- **3-stage progression:** Clean arc from autocomplete → planning → complete agentic
- **Stage 3 showcase:** Your favorite index scenario + knowledge retrieval + testing in one cohesive demo
- **Explicit contrast:** Autocomplete vs agentic called out repeatedly
- **Hands-on focus:** 75+ minutes of participant work time
- **Dual-path knowledge:** MCP showcase + file-based fallback (inclusive, low-risk)
- **Reusable artifact:** Teaching repo with complete facilitator materials
- **Your strengths:** Storytelling (AmuseYou domain), real context (index scenario), BC expertise (layered architecture), community tool (MCP)

---

**Next Steps:**
1. Validate this plan aligns with your vision
2. Build initial 6-app scaffold
3. Create Stage 1 demo script + exercise
4. Develop Codespace configuration
5. Write FACILITATOR-GUIDE.md
