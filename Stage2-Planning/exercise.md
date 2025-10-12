# Stage 2 Exercise: Review AmuseYou Code with Generic AI

**Duration:** 15 minutes
**Goal:** Test what generic AI catches vs misses when reviewing the baseline codebase

## Your Task

Pick **one or two files** from the AmuseYou baseline code and ask AI to review them.

### Files to Review

Choose from these files with injected anti-patterns:

1. **[RentalOperations/src/BookingMgt.Codeunit.al](../AmuseYou-Apps/RentalOperations/src/BookingMgt.Codeunit.al)**
   - Booking creation and validation logic
   - Look for: error handling, text constants, telemetry

2. **[BookingCore/src/Booking.Table.al](../AmuseYou-Apps/BookingCore/src/Booking.Table.al)**
   - Core booking data structure
   - Look for: indexing, SIFT keys, field properties

3. **[RentalOperations/src/AvailabilityMgt.Codeunit.al](../AmuseYou-Apps/RentalOperations/src/AvailabilityMgt.Codeunit.al)**
   - Equipment availability checking
   - Look for: N+1 queries, commit patterns, CalcSums usage

4. **[BookingCore/src/Equipment.Table.al](../AmuseYou-Apps/BookingCore/src/Equipment.Table.al)**
   - Equipment master data
   - Look for: missing page references, field groups, tooltips

## Step 1: Basic Review (5 min)

Open your chosen file and start with a broad prompt:

```
Review this file for issues and suggest improvements
```

**Take notes:**
- What issues did AI find?
- Did it suggest specific fixes?
- Were the suggestions BC-specific or generic?

## Step 2: Targeted Prompts (7 min)

Dig deeper with specific questions:

```
Review this file for performance issues
```

```
What validation or error handling is missing?
```

```
Review this against Business Central best practices
```

```
Are there any cross-module dependencies I should be aware of?
```

## Step 3: Track Findings (3 min)

As AI reviews your file, categorize its findings:

### ✅ What AI Caught (Easy Wins - 🟢)
-
-
-

### 🤔 What AI Partially Caught (Medium - 🟡)
-
-

### ❌ What AI Missed (Hard/BC-Specific - 🔴)
Check for these common gaps:
- Object ID ranges (matching app.json)
- SIFT keys / SumIndexFields
- Cross-layer dependencies (BookingCore ↔ RentalOperations)
- BC-specific patterns (ErrorInfo, telemetry dimensions)
- Comprehensive test requirements

## What to Expect

**Generic AI's Strengths:**
- Basic validation issues
- Obvious performance problems (like CalcSums vs loops)
- General code quality issues

**Generic AI's Gaps:**
- Business Central platform patterns
- App architecture awareness (object ranges, module boundaries)
- Cross-file dependencies
- Domain-specific optimizations (SIFT, FlowFields)

## Questions to Consider

1. What percentage of issues do you think AI caught? (Estimate: 50-70% of Easy Wins)


2. What BC-specific knowledge did AI lack?


3. If you implemented AI's suggestions, would the code be production-ready?


## What's Next?

**Stage 3** introduces BC Code Intelligence specialists (Dean, Roger, Uma, Jordan) who have deep Business Central knowledge. You'll see how domain expertise dramatically improves catch rates.

---

**Save your notes - we'll compare Generic AI vs Specialist results in Stage 3!** 📊
