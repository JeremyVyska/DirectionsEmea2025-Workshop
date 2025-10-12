# AmuseYou Workshop Plan v3.0

**MAJOR PIVOT:** From "Planning-First" to "Knowledge-Enhanced Review"

## Why v3.0?

Based on real-world research (https://nubimancy.com/2025/09/09/testing-github-copilot-knowledge-engineering-what-actually-works-and-what-doesnt/):
- **MCP with real-time knowledge = 74,465% performance improvement**
- **Passive knowledge approaches have limited impact**
- **AI strongest at review, not planning**
- Early BC AL adopters confirm: review workflow > planning workflow

## The New Workshop Thesis

> **"From generic autocomplete to knowledge-enhanced agentic review"**

Not teaching ideal workflow, but **demonstrating proven research findings** about AI collaboration.

---

## Core Constraints (Unchanged from v2.0)
- **Duration:** 105 minutes total
- **Title:** "Getting Started with Vibe Coding in Business Central"
- **Format:** Highly interactive with GitHub template project
- **Takeaway:** Teaching repo participants can use with their teams

## The Key Progression (CHANGED)

### Stage 1: Autocomplete Thinking (Baseline)
**What it is:** Generic Copilot autocomplete, pattern matching
**Research finding:** Limited value for specialized domains like BC
**Workshop goal:** Create technical debt that Stages 2-3 will fix

### Stage 2: Basic AI Review (Generic Knowledge)
**What it is:** "Review my code" with standard Copilot knowledge
**Research finding:** Passive approach, limited impact compared to MCP
**Workshop goal:** Show AI can find issues, but misses BC-specific patterns

### Stage 3: Knowledge-Enhanced Review (MCP - Transformative)
**What it is:** "Review my code" with MCP real-time knowledge delivery
**Research finding:** 74,465% performance improvement, transformative results
**Workshop goal:** **LIVE DEMONSTRATION of research findings** - participants feel the difference

---

## Workshop Flow: 105 Minutes

### Introduction (10 min)
- Workshop goals: **demonstrate knowledge engineering impact**
- Reference research: 74,465% improvement with knowledge-enhanced AI
- AmuseYou domain: 2-minute business context
- Architecture: Two layers, 5 apps (quick overview)
- **Key framing:** "We'll demonstrate the same research findings - live"

---

### Stage 1: Your First AI Feature (22 min)

**Goal:** Experience coding with AI - the "Hello World" moment of vibe coding

**Pedagogical Purpose:** Get participants excited about AI coding before introducing quality dimensions

**Demo (8 min): "Add Discount Field to Booking"**

Live code with AI in front of participants:

```
Prompt: "Add a discount percentage field to the Booking table"
```

**AI writes code in ~10 seconds:**
```al
field(80; "Discount %"; Decimal)
{
    Caption = 'Discount %';
    DataClassification = CustomerContent;
    MinValue = 0;
    MaxValue = 100;
}
```

**Show it compiles** (F5) → Works!

**The "Wait..." Moment (2 min):**
> "That was fast! But what did we NOT think about?
> - Should this be a percentage or fixed amount?
> - Does it apply to the pricing calculation?
> - What about validation?
>
> AI gave us working code. But working ≠ production-ready.
>
> That's okay! We just wanted to experience AI coding. ✨"

**Energy:** Keep it magical and fun - this is the hook!

**Participant Exercise (11 min):**

Pick ONE simple feature:
1. **Customer Email** - Add email field to Booking
2. **Equipment Status** - Add Available/In Use/Under Maintenance status
3. **Booking Notes** - Add internal notes field

**Simple prompt:**
```
Add a [feature] to the [table]
```

**Accept suggestions, see it work!**

**Key message:** "AI writes code fast. You just experienced 'vibe coding'!"

**Debrief (3 min):**
- "How fast was that?"
- "Did it compile?"
- "Now let's ask: What did we miss?"
- **Transition:** "Stage 2 - we'll ask AI to review what we just built"

---

### Stage 2: Review - Basic AI Collaboration (28 min)

**Goal:** Show AI catches Easy Wins (🟢) but misses BC-specific patterns

**Research Context:** Tier 1 "Generic Programming Knowledge" - 10-30% improvement expected

**Demo (10 min): "Review the Stage 1 Revenue Calculation"**

**Prompt:**
```
Review this CalculateEquipmentRevenue procedure. What's wrong? What should be improved?
```

**Generic Copilot Finds (Easy Wins 🟢):**

✅ **Optimization 1: CalcSums vs Manual Loop**
```al
// Copilot suggests:
Booking.SetRange("Equipment No.", EquipmentNo);
Booking.SetRange(Status, BookingStatus::Completed);
Booking.CalcSums("Total Amount");
exit(Booking."Total Amount");
// ~90% time reduction
```

✅ **Optimization 2: SetLoadFields**
```al
// Copilot suggests:
Booking.SetLoadFields("Total Amount");
Booking.SetRange("Equipment No.", EquipmentNo);
```

✅ **Basic Validation**
- Suggests checking for empty equipment number
- Suggests error handling

**Generic Copilot MISSES (Medium/Hard 🟡🔴):**
- ❌ Wrong object ID range (should be 50200-50299, not 50000)
- ❌ AL naming conventions violations
- ❌ No FlowField vs CalcSums context awareness
- ❌ Doesn't suggest comprehensive tests
- ❌ Misses cross-layer optimization opportunities

**Key message:** "Generic AI catches obvious performance issues (60% of Easy Wins) but lacks BC domain expertise"

**Participant Exercise (15 min): "Review Your Stage 1 Booking Summary"**

**Prompt:**
```
Review this booking summary code. What optimizations should I apply?
```

**Track Findings:**
- What did generic AI suggest? (CalcSums? SetLoadFields?)
- What did it miss? (Object IDs? AL conventions? Tests?)
- Implement the improvements AI suggested
- Note the gaps for Stage 3 comparison

**Debrief (3 min):**
- "Show of hands: Who got CalcSums suggestions?"
- "Who got SetLoadFields suggestions?"
- "Did anyone get object ID range fixes? Comprehensive test generation?"
- **Key insight:** "Generic AI finds ~60% of Easy Wins, misses Medium/Hard patterns"
- "Stage 3 shows what BC domain knowledge adds"

---

### Stage 3: Review - Knowledge-Enhanced AI (MCP Showcase) (40 min)

**Goal:** DEMONSTRATE the 74,465% improvement from knowledge engineering research

**Research Context:** Tier 4 "MCP-Enhanced Knowledge" - 500-5000%+ improvement measured

**Setup Message (2 min):**
> "Stage 2 caught Easy Wins with generic knowledge. Stage 3 uses BC Code Intelligence MCP - agentic, real-time knowledge delivery. Research showed: 74,465% performance improvement. You're about to experience why."

---

**Demo Part 1: Review with Knowledge - The Full Spectrum (15 min)**

**Scenario:** Implement "Available Equipment Query" with intentional anti-patterns

**Step 1: Quick Implementation (5 min) - Create the baseline:**

```al
procedure GetAvailableEquipment(EquipmentType: Enum EquipmentType; StartDate: Date; EndDate: Date)
var
    Equipment: Record Equipment;
    Booking: Record Booking;
    TempEquipment: Record Equipment temporary;
begin
    // BAD: Multiple anti-patterns
    Equipment.SetRange("Equipment Type", EquipmentType);
    if Equipment.FindSet() then  // No SetLoadFields
        repeat
            Booking.SetRange("Equipment No.", Equipment."No.");
            Booking.SetRange("Start Date", StartDate, EndDate);  // Needs index
            if Booking.IsEmpty() then begin
                TempEquipment := Equipment;
                TempEquipment.Insert();
            end;
        until Equipment.Next() = 0;
end;
```

**Anti-patterns included:**
- ❌ No SetLoadFields (🟢 Easy)
- ❌ N+1 query pattern (🟡 Medium)
- ❌ Missing index on Booking for date range (🔴 Hard - cross-layer)
- ❌ Wrong object ID range
- ❌ No validation

**Step 2: Review with MCP (10 min):**

**Prompt:**
```
Review this available equipment query against AL best practices.
Focus on performance, BC conventions, and cross-layer dependencies.
```

**MCP-Enhanced Review Finds ALL Patterns:**

**🟢 Easy Wins (100% catch rate):**
```al
// MCP suggests:
Equipment.SetLoadFields("No.", Description, "Equipment Type");
Equipment.SetRange("Equipment Type", EquipmentType);
```

**🟡 Medium Complexity (90% catch rate):**
```al
// MCP suggests refactoring N+1 pattern:
"This nested loop creates an N+1 query pattern. Consider:
1. Single query on Booking with date filter
2. Check availability in one pass
3. Or use EXISTS() pattern for cleaner logic"
```

**🔴 Hard Challenge - CROSS-LAYER INDEX (80% catch rate):**
```
🎯 KEY DIFFERENTIATOR:

"This query filters Booking by Start Date range repeatedly.
The Booking table needs an index for optimal performance.

Add to BookingCore/src/Booking.Table.al:

key(EquipmentDateRangeKey; "Equipment No.", "Start Date", "End Date")
{
    // Optimizes date range queries for availability checks
}

This is a cross-layer optimization: RentalOperations query
needs index in BookingCore table."
```

**BC-Specific Knowledge:**
```
• Object ID: Should be 50205 (RentalOperations range 50200-50299)
• Naming: Use 'AvailabilityMgt' codeunit, not generic names
• Error handling: Add validation for date range (EndDate >= StartDate)
• Field access: Use SetLoadFields consistently
```

**vs Stage 2 Generic Review Would Find:**
- ✅ Basic logic issues (maybe suggests loop optimization)
- ❌ Cross-layer index requirement ⭐ **MISSED**
- ❌ BC-specific object ID ranges ⭐ **MISSED**
- ❌ N+1 pattern recognition (hit or miss)
- ❌ Comprehensive testing strategy ⭐ **MISSED**

**Key message:** "MCP caught 100% of Easy, 90% of Medium, 80% of Hard patterns - including cross-layer dependencies generic AI can't see"

---

**Demo Part 2: Comprehensive Test Generation (8 min)**

**Prompt:**
```
Based on your review recommendations, generate comprehensive tests for this
available equipment query. Include performance tests and edge cases.
```

**MCP Generates (Following BC Testing Standards):**

**Performance Test:**
```al
codeunit 50305 "Availability Performance Tests"
{
    Subtype = Test;

    [Test]
    procedure TestAvailabilityQueryPerformance()
    var
        StartTime: DateTime;
        Duration: Duration;
    begin
        // [GIVEN] 1000 equipment records with bookings
        CreateTestData(1000);

        // [WHEN] Querying available equipment
        StartTime := CurrentDateTime();
        GetAvailableEquipment(EquipmentType::BounceUnit, Today(), Today() + 7);
        Duration := CurrentDateTime() - StartTime;

        // [THEN] Query completes within benchmark
        Assert.IsTrue(Duration < 5000,
            StrSubstNo('Query took %1ms, expected <5000ms', Duration));
    end;
}
```

**Unit Tests with Edge Cases:**
```al
[Test]
procedure TestAvailabilityWithNullDates()

[Test]
procedure TestAvailabilityWithOverlappingBookings()

[Test]
procedure TestAvailabilityWithBlockedEquipment()

[Test]
procedure TestAvailabilityEmptyResultSet()
```

**Key differentiator:** "MCP generates comprehensive tests we'd forget to write - performance benchmarks, edge cases, proper structure"

**Participant Exercise (15 min):**

**Two Paths Based on MCP Installation:**

**Path A: With MCP (Recommended)**
1. Implement upcoming maintenance report feature
2. Review with MCP: "Review against AL best practices"
3. Observe MCP automatically pulling BC knowledge
4. Implement improvements
5. Generate tests with MCP guidance

**Path B: Without MCP (Fallback)**
1. Implement upcoming maintenance report feature
2. Review with manual reference: "Review against AL best practices. First, read .al-guidelines/performance-patterns.md and testing-standards.md"
3. Observe file-based knowledge application
4. Implement improvements
5. Generate tests with guideline references

**Key difference participants should notice:**
- **MCP:** Automatic knowledge retrieval, seamless
- **Files:** Manual prompting required, but same content

**Debrief (3 min):**
- "Who had MCP? Did it automatically suggest BC patterns?"
- "Who used files? Did you get similar recommendations when you referenced them?"
- "This is the 74,465% improvement from research - knowledge-enhanced AI vs generic AI"

---

### Wrap-up & Next Steps (5 min)

**Key Takeaways:**
1. **Generic AI (Stage 1-2):** Limited for specialized domains
2. **Knowledge-enhanced AI (Stage 3):** Transformative, backed by research
3. **MCP is the game-changer:** Real-time knowledge delivery vs passive docs

**The Progression:**
- Stage 1: Autocomplete (baseline, limited)
- Stage 2: Basic review (finds issues, misses patterns)
- Stage 3: Knowledge-enhanced review (expert-level, comprehensive)

**Call to Action:**
- Install BC Code Intelligence MCP for ongoing work
- Use review workflow in daily development
- Apply knowledge engineering principles to your domain

---

## Architecture (Unchanged from v2.0)

### The Two-Layer Pattern (5 Apps)
```
BookingCore (Base Layer)
├── Equipment table
├── Booking table
├── Enums, Interfaces

RentalOperations (Business Logic Layer)
├── AvailabilityMgt, BookingMgt
├── Pages, API

Plus 3 Test Apps:
├── BookingCore.Test
├── RentalOperations.Test
└── Integration.Test
```

---

## Technical Specifications (Unchanged)

[Same as v2.0 - object ranges, GUIDs, dependencies]

---

## Git Branching Strategy (UPDATED)

```
main (base apps complete)
├── stage1-start (clean start)
├── stage1-solution (maintenance status with autocomplete - HAS TECHNICAL DEBT)
│
├── stage2-start (= stage1-solution - includes technical debt to fix)
├── stage2-solution (reviewed and improved with basic AI)
│
├── stage3-start (fresh feature start)
└── stage3-solution (reviewed with MCP, BC best practices applied)
```

**Key difference from v2.0:**
- Stage 2 starts from Stage 1 solution (fixes existing code)
- Stage 3 starts fresh (new feature with knowledge from start)

---

## Success Metrics

Participants leave understanding:

1. **Generic AI limitations** for specialized domains (Stage 1-2)
2. **Knowledge engineering impact** (Stage 3 vs Stage 2)
3. **MCP as transformative tool** not just "nice to have"
4. **Review workflow** as primary AI collaboration pattern
5. **Research-backed approach** to AI development

---

## What Makes v3.0 Different from v2.0?

| v2.0 | v3.0 |
|------|------|
| Stage 2: Planning-first | **Stage 2: Basic AI Review** |
| Stage 3: Cross-layer + knowledge | **Stage 3: Knowledge-Enhanced Review (MCP showcase)** |
| Teaching ideal workflow | **Demonstrating research findings** |
| "Use MCP, it's helpful" | **"MCP = 74,465% improvement (proven)"** |
| Theoretical planning value | **Practical review workflow** |
| Generic progression | **Knowledge engineering demonstration** |

---

## Why This Workshop Structure is Stronger

### 1. **Grounded in Research**
- Not theoretical - demonstrates actual findings
- Participants experience the 74,465% difference
- Live validation of knowledge engineering principles

### 2. **Matches Real Developer Behavior**
- Developers code first, review second
- Review is natural workflow (like code review)
- More likely to adopt post-workshop

### 3. **MCP Value Becomes Undeniable**
- Stage 2 vs Stage 3 comparison is stark
- Not "same content, different delivery" but "generic vs expert"
- Clear ROI on MCP installation

### 4. **Stronger Demonstration**
- Stage 1: See the problem (autocomplete limitations)
- Stage 2: Partial solution (basic review)
- Stage 3: Complete solution (knowledge-enhanced review)
- Escalating value, not parallel approaches

---

## Risk Mitigation

**"What if participants don't have MCP?"**
- File-based fallback still works
- But **be honest:** MCP is better, files are fallback
- Encourages post-workshop MCP adoption

**"Is review too passive?"**
- No - asking AI to review is active collaboration
- More active than autocomplete
- Shows AI as expert consultant, not just autocomplete

**"Does this lose planning value?"**
- Planning can be part of review: "Review and suggest improvements"
- AI plans improvements during review
- More natural than "plan before coding"

---

## Next Steps (Implementation)

1. **Review knowledge engineering test repo** (Jeremy to clone)
2. **Validate v3.0 approach** against research findings
3. **Update Stage 2 docs** (Planning → Basic Review)
4. **Update Stage 3 docs** (emphasize knowledge enhancement)
5. **Create new exercises** matching review workflow
6. **Update branch strategy** (Stage 2 fixes Stage 1, Stage 3 fresh feature)
7. **Update all supporting docs** (README, SETUP, FACILITATOR-GUIDE)

---

**This workshop becomes a live demonstration of knowledge engineering research - not just teaching AI collaboration, but proving its transformative impact.**
