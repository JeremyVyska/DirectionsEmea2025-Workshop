# Stage 3 Exercise: BC Specialists Review

**Duration:** 17 minutes
**Goal:** Experience the dramatic improvement when BC specialists review your Stage 2 files

## Your Task

Take the **same files** you reviewed in Stage 2 and ask BC specialists to review them. Compare the results.

## Step 1: Pick Your Specialist (2 min)

Choose the specialist that matches what you care about:

- 🔧 **Dean Debug** - Performance optimization, SIFT keys, indexing, telemetry
- ✅ **Roger Reviewer** - Code quality, security, error handling, AL conventions
- 🎨 **Uma UX** - User experience, page design, field visibility, tooltips
- 🔌 **Jordan Bridge** - Integration patterns, extensibility, API design

Start with **one** specialist and dig deep. If you have time, try others.

## Step 2: Ask for Specialist Review (7 min)

Open the file you reviewed in Stage 2 and ask your chosen specialist:

**For MCP users:**
```
Dean, review this file for performance issues and BC best practices
```

```
Roger, review this file for code quality and security issues
```

```
Uma, review the user experience in this file
```

```
Jordan, analyze integration and extensibility patterns
```

**For non-MCP users:**
```
Review knowledge files in .al-guidelines/domains/dean-debug/ then analyze this file for performance issues following BC best practices
```

(Adjust the domain folder to match your specialist: dean-debug, roger-reviewer, uma-ux, or jordan-bridge)

## Step 3: Compare Stage 2 vs Stage 3 (5 min)

As the specialist reviews your code, track the differences:

### What Generic AI Found (Stage 2)
List what generic AI caught:
-
-
-

### What Specialist Found (Stage 3)
List **additional** issues the specialist caught:
-
-
-

### Depth & Specificity
- Are recommendations more actionable?
- Does specialist reference BC-specific patterns?
- Does specialist check cross-layer dependencies?

## Step 4: Try Multiple Specialists (3 min - if time)

Each specialist covers a different quality dimension. Try 2-3 to see comprehensive coverage:

**File:** _______________________

**Specialists tried:**
- [ ] Dean (performance)
- [ ] Roger (quality)
- [ ] Uma (UX)
- [ ] Jordan (integration)

**Total issues found across all specialists:** _______

**Total issues generic AI found:** _______

**Improvement:** _______%

## What to Look For

**BC Specialists should catch:**
- ✅ SIFT keys / SumIndexFields requirements
- ✅ Object ID range validation
- ✅ BC-specific error patterns (ErrorInfo)
- ✅ Telemetry with custom dimensions
- ✅ Cross-layer dependencies (BookingCore ↔ RentalOperations)
- ✅ Permission set requirements
- ✅ FlowField alternatives
- ✅ FieldGroups for Brick/Tile views
- ✅ Page action placement and design
- ✅ Integration events vs direct coupling

**Generic AI typically missed:**
- ❌ Most of the above!

## Questions to Consider

1. How much better was the specialist catch rate? (Estimate: 90-95% vs 50-70%)


2. What specific BC patterns did the specialist reference?


3. Would you feel confident shipping code after specialist review?


4. Which specialist was most valuable for your work?


## The Big Insight

**This is augmentation in action:**
- You're great at coding (Stage 1 - fast!)
- Generic AI catches obvious issues (Stage 2 - helpful!)
- BC Specialists catch production-readiness gaps (Stage 3 - comprehensive!)

Time pressure means you skip dimensions like:
- Performance tuning
- Security hardening
- UX polish
- Integration planning
- Error handling
- Telemetry
- Documentation

**Specialists cover all dimensions** - you ship higher quality code without spending weeks on manual review.

## Take This Back to Work

Your new workflow:
1. **Code** - you're fast and good at this
2. **Review with specialists** - they catch what you miss
3. **Ship production-ready code** - higher quality, less technical debt

---

**Save your comparison notes - we'll debrief as a group!** 🚀
