# AmuseYou Workshop Architecture Plan

## Overview
This workshop teaches progressive AI collaboration skills through a realistic Business Central multi-app ecosystem for "AmuseYou" - a company that rents entertainment equipment and facilities.

## Workshop Philosophy
**Single ecosystem, progressive improvement** - Participants work with the SAME codebase across all 4 stages, learning how better AI collaboration techniques produce better results on identical tasks.

## The 4 Stages of AI Collaboration

### Stage 1: Baseline
**What happens when you use AI with minimal guidance**
- Establish baseline by asking AI to add features with basic prompts
- Demonstrates common pitfalls: inconsistent patterns, missing error handling, hardcoded values
- Creates "technical debt" that later stages will improve

### Stage 2: Planning
**AI as a planning partner**
- Collaborate on approach BEFORE writing code
- Learn to refine instructions iteratively based on what works
- Fix issues from Stage 1 using better planning techniques

### Stage 3: Personas
**Role-based AI collaboration**
- "Diagnostics" mode for experienced developers (deep code analysis)
- "Rookie Onboarding" mode for BC newcomers (guided learning)
- AI spots inconsistencies and suggests architectural improvements

### Stage 4: Knowledge-Rich
**Community-powered AI interactions**
- Use Best Practices repositories as shared context
- AI makes enterprise-grade improvements
- Complete refactoring with testing and performance optimization

## Business Domain: AmuseYou

AmuseYou rents entertainment equipment and facilities:
- **Bounce Units** (bouncy castles, slides, inflatable obstacles)
- **Go-Kart Tracks** (racing experiences, time trials, team events)

The system manages:
- Equipment inventory and availability
- Customer bookings and reservations
- Integration with external booking platforms (via webhook simulation)
- Safety checks and maintenance schedules
- Pricing and rental periods

## Application Architecture

### Total: 12 Applications

```
AmuseYou-Apps/
├── BookingManagement/              # Core booking framework
├── BookingManagement.Test/         # Unit tests for Booking
├── BookingManagement.Performance/  # Performance tests for Booking
├── BounceUnits/                    # First amusement type
├── BounceUnits.Test/               # Unit tests for BounceUnits
├── BounceUnits.Performance/        # Performance tests for BounceUnits
├── BounceUnits.Bridge/             # DI adapter: BounceUnits → BookingManagement
├── GoKarts/                        # Second amusement type
├── GoKarts.Test/                   # Unit tests for GoKarts
├── GoKarts.Performance/            # Performance tests for GoKarts
├── GoKarts.Bridge/                 # DI adapter: GoKarts → BookingManagement
└── Integration.Test/               # End-to-end workflow tests (includes bridges)
```

### Architecture Patterns

**SOLID Principles in Action:**
- Each amusement type is a separate app (Single Responsibility)
- BookingManagement defines interfaces (Dependency Inversion)
- Bridge apps adapt amusement types to booking system (Adapter Pattern)
- Dependency Injection for loose coupling

**Testing Strategy:**
- **Unit Tests**: Individual app testing (*.Test apps)
- **Performance Tests**: Each main app has performance testing (*.Performance apps)
- **Integration Tests**: End-to-end workflows including bridge testing

## Technical Specifications

### Publisher
**Directions EMEA 2025**

### Application Details

| App Name | GUID | Object Range | Purpose |
|----------|------|--------------|---------|
| BookingManagement | 4beb0468-0ebf-424c-856d-f341c7d5edf9 | 50000-50099 | Core booking framework with interfaces |
| BookingManagement.Test | 9ed4ce5b-5728-4bc5-9aea-65c8e5d73f57 | 50100-50199 | Unit tests for BookingManagement |
| BookingManagement.Performance | f98551e1-dde6-4d6f-bbdf-5096691c94e2 | 50200-50299 | Performance tests for BookingManagement |
| BounceUnits | eb6f285d-6f6e-4351-b9f3-bbf3c9d47491 | 50300-50399 | Bounce house/inflatable management |
| BounceUnits.Test | 9ef5dc45-9fae-4e83-b47e-21f1eff55a3d | 50400-50499 | Unit tests for BounceUnits |
| BounceUnits.Performance | 5954a8c7-5ab4-423a-885a-68bf00796bb1 | 50500-50599 | Performance tests for BounceUnits |
| BounceUnits.Bridge | ea0db4ad-8360-4cc6-ae50-3055720b3356 | 50600-50699 | DI adapter: BounceUnits → BookingManagement |
| GoKarts | da8c6721-8f70-41ea-89c3-e74a4cb4f022 | 50700-50799 | Go-kart track management |
| GoKarts.Test | 8e0e73d0-c8fe-4728-8df5-cfe013f42c27 | 50800-50899 | Unit tests for GoKarts |
| GoKarts.Performance | 8528122a-180a-48fd-ad2f-73e9d1e6d038 | 50900-50999 | Performance tests for GoKarts |
| GoKarts.Bridge | 4efbd0f3-bdca-42a8-9655-f69b19746ea2 | 51000-51099 | DI adapter: GoKarts → BookingManagement |
| Integration.Test | ee4f1651-246e-4a13-b316-3a5d61c3c5d1 | 51100-51199 | End-to-end workflow and bridge tests |

### App Dependencies

```
BookingManagement (no dependencies - defines interfaces)
├── BookingManagement.Test (depends on: BookingManagement)
├── BookingManagement.Performance (depends on: BookingManagement)

BounceUnits (no dependencies)
├── BounceUnits.Test (depends on: BounceUnits)
├── BounceUnits.Performance (depends on: BounceUnits)
├── BounceUnits.Bridge (depends on: BookingManagement, BounceUnits)

GoKarts (no dependencies)
├── GoKarts.Test (depends on: GoKarts)
├── GoKarts.Performance (depends on: GoKarts)
├── GoKarts.Bridge (depends on: BookingManagement, GoKarts)

Integration.Test (depends on: BookingManagement, BounceUnits, BounceUnits.Bridge, GoKarts, GoKarts.Bridge)
```

## Repository Structure

```
DirectionsEmea2025-Workshop/
├── README.md                           # Main landing page with workshop overview
├── AmuseYou-Apps/                      # THE ecosystem (all 12 apps)
│   ├── BookingManagement/
│   │   ├── app.json
│   │   └── src/
│   ├── BookingManagement.Test/
│   │   ├── app.json
│   │   └── src/
│   ├── BookingManagement.Performance/
│   │   ├── app.json
│   │   └── src/
│   ├── BounceUnits/
│   │   ├── app.json
│   │   └── src/
│   ├── BounceUnits.Test/
│   │   ├── app.json
│   │   └── src/
│   ├── BounceUnits.Performance/
│   │   ├── app.json
│   │   └── src/
│   ├── BounceUnits.Bridge/
│   │   ├── app.json
│   │   └── src/
│   ├── GoKarts/
│   │   ├── app.json
│   │   └── src/
│   ├── GoKarts.Test/
│   │   ├── app.json
│   │   └── src/
│   ├── GoKarts.Performance/
│   │   ├── app.json
│   │   └── src/
│   ├── GoKarts.Bridge/
│   │   ├── app.json
│   │   └── src/
│   └── Integration.Test/
│       ├── app.json
│       └── src/
├── Stage1-Baseline/
│   ├── README.md                       # Stage 1 learning objectives
│   └── exercises/                      # Guided exercises
│       ├── exercise1.md
│       ├── exercise2.md
│       └── ...
├── Stage2-Planning/
│   ├── README.md                       # Stage 2 learning objectives
│   └── exercises/
├── Stage3-Personas/
│   ├── README.md                       # Stage 3 learning objectives
│   └── exercises/
│       ├── diagnostics/                # Exercises for experienced devs
│       └── rookie/                     # Exercises for BC newcomers
├── Stage4-KnowledgeRich/
│   ├── README.md                       # Stage 4 learning objectives
│   ├── exercises/
│   └── best-practices-references.md    # Links to community best practice repos
├── Solutions/                          # Completed state after each stage
│   ├── Stage1/                         # Full app ecosystem after Stage 1
│   ├── Stage2/                         # Full app ecosystem after Stage 2
│   ├── Stage3/                         # Full app ecosystem after Stage 3
│   └── Stage4/                         # Full app ecosystem after Stage 4
├── .docs/
│   ├── seed.md                         # Original workshop concept
│   └── architecture-plan.md            # This file
└── .github/
    └── copilot-instructions.md         # AI collaboration guidance for the repo
```

## Workshop Flow (105 minutes)

### Pre-Workshop (Participants prepare)
- Clone repository
- Set up BC development environment
- Review README for overview

### Introduction (10 min)
- Workshop goals and progression
- AmuseYou business domain overview
- Quick tour of the 12-app ecosystem

### Stage 1: Baseline (20 min)
- Demo: Ask AI to add a feature with minimal guidance
- Observe common mistakes
- Participants try similar task
- Discuss what went wrong

### Stage 2: Planning (25 min)
- Demo: Plan first, then ask AI to implement
- Show iterative refinement of instructions
- Participants try with better prompting
- Compare results to Stage 1

### Stage 3: Personas (25 min)
- Demo: "Diagnostics" mode for experienced devs
- Demo: "Rookie Onboarding" mode for newcomers
- Participants choose their persona
- Work through exercises with AI assistance

### Stage 4: Knowledge-Rich (20 min)
- Demo: Using best practices repos as context
- Show how specialized instructions improve results
- Participants refactor earlier work
- Compare final result to Stage 1 baseline

### Wrap-up (5 min)
- Key takeaways
- How to continue learning with the repo
- Resources and community links

## Complexity Opportunities

### For AI to Get Wrong (Stage 1)
- Inconsistent naming across apps
- Hardcoded values instead of enums
- Missing interface implementations
- No error handling
- Code duplication across similar patterns
- Missing test coverage
- Performance anti-patterns (N+1 queries)
- Incorrect object ID ranges
- Missing documentation

### For AI to Fix (Stages 2-4)
- Establish consistent patterns
- Refactor to use proper abstractions
- Implement interfaces correctly
- Add comprehensive error handling
- DRY up duplicated code
- Add full test coverage
- Performance optimization
- Proper documentation
- Best practice alignment

## Success Metrics

Participants will leave able to:
1. Use AI as a planning partner before coding
2. Craft effective prompts that improve iteratively
3. Choose appropriate AI personas for their experience level
4. Integrate community best practices into AI collaboration
5. Debug and improve AI-generated code systematically
6. Build sustainable AI adoption patterns for their teams

## Teaching Repository Benefits

- **Self-paced learning**: Work through stages at own speed
- **Reusable**: Take back to team as teaching tool
- **Real BC patterns**: Multi-app architecture, DI, testing
- **Progressive complexity**: Each stage builds on previous
- **Visible improvement**: Same task, better results with better AI collaboration
