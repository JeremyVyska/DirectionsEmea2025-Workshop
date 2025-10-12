# Optimization Patterns Mapping: bc-aiknowledge-test → AmuseYou Workshop

**Purpose:** Map proven optimization patterns from research to workshop exercises

---

## Pattern Classification (From Research)

### 🟢 Easy Wins
**Definition:** Basic optimizations any AI should catch
**Stage:** Should appear in Stage 2 (Basic AI Review)

### 🟡 Medium Complexity
**Definition:** Requires BC-specific knowledge (FlowFields, SIFT, N+1 patterns)
**Stage:** Should appear in Stage 3 (Knowledge-Enhanced Review)

### 🔴 Hard Challenges
**Definition:** Requires deep BC architectural knowledge (cross-layer, SIFT keys, advanced patterns)
**Stage:** Should appear in Stage 3 (MCP-enhanced only)

---

## AmuseYou Implementation Strategy

### Stage 1: Autocomplete (Creates Problems)

**Intentionally create code with these issues:**

1. **Manual Loops Instead of CalcSums** (🟢 Easy)
   ```al
   // BAD (Autocomplete might generate this)
   TotalAmount := 0;
   if Booking.FindSet() then
       repeat
           TotalAmount += Booking."Total Amount";
       until Booking.Next() = 0;
   ```

2. **No SetLoadFields** (🟢 Easy)
   ```al
   // BAD (Autocomplete won't add this)
   Equipment.SetRange("Equipment Type", EquipmentType::BounceUnit);
   if Equipment.FindSet() then
       repeat
           // Uses all fields, not just what's needed
       until Equipment.Next() = 0;
   ```

3. **N+1 Query Pattern** (🟡 Medium)
   ```al
   // BAD (Nested loops)
   if Equipment.FindSet() then
       repeat
           Booking.SetRange("Equipment No.", Equipment."No.");
           Booking.SetRange("Start Date", StartDate, EndDate);
           if Booking.FindSet() then
               repeat
                   ProcessBooking(Booking);
               until Booking.Next() = 0;
       until Equipment.Next() = 0;
   ```

4. **Missing Indexes for Queries** (🔴 Hard)
   ```al
   // Query in RentalOperations that needs index in BookingCore
   Equipment.SetRange("Last Maintenance Date",
       CalcDate('<-90D>', Today()), Today());
   // Missing: Index on Last Maintenance Date in BookingCore.Equipment
   ```

---

## Stage 2: Basic AI Review (Generic Copilot)

**What generic Copilot SHOULD catch:**

### ✅ Easy Wins (60-90% catch rate)

1. **CalcSums Opportunities**
   ```al
   // Generic AI suggests:
   Booking.CalcSums("Total Amount");
   TotalAmount := Booking."Total Amount";
   ```

2. **SetLoadFields**
   ```al
   // Generic AI suggests:
   Equipment.SetLoadFields("No.", Description, "Equipment Type");
   Equipment.FindSet();
   ```

**What generic Copilot WILL MISS:**

### ❌ Medium Complexity (Most missed)

1. **FlowField vs CalcSums Context**
   - Generic AI doesn't know when FlowFields are inefficient
   - Misses N+1 query patterns
   - Doesn't suggest proper BC aggregation patterns

2. **BC-Specific Patterns**
   - Object ID ranges
   - AL naming conventions
   - Error handling patterns

### ❌ Hard Challenges (All missed)

1. **Cross-Layer Dependencies**
   - Won't suggest indexes in different apps
   - Won't identify SIFT key opportunities
   - Won't propose architectural improvements

---

## Stage 3: Knowledge-Enhanced Review (MCP)

**What MCP SHOULD catch (based on research):**

### ✅ All Easy Wins (100% catch rate)
- CalcSums vs loops
- SetLoadFields
- Red herrings (won't change already-optimized code)

### ✅ Most Medium Complexity (80-90% catch rate)

1. **FlowField Usage Patterns**
   ```al
   // MCP knows context:
   // Single record: Use FlowField
   Equipment.CalcFields("Total Revenue");

   // Bulk aggregation: Use CalcSums
   RentalLedger.SetRange("Equipment No.", EquipmentNo);
   RentalLedger.CalcSums("Total Amount");
   ```

2. **N+1 Pattern Detection**
   ```al
   // MCP suggests refactoring nested loops to:
   Booking.SetRange("Start Date", StartDate, EndDate);
   if Booking.FindSet() then
       repeat
           // Process all bookings in one query
       until Booking.Next() = 0;
   ```

3. **BC Naming Conventions**
   - Suggests proper object IDs (50000-50099 range)
   - Fixes namespace issues
   - Applies AL naming standards

### ✅ Hard Challenges (60-80% catch rate)

1. **Cross-Layer Index Suggestions** ⭐ **KEY DIFFERENTIATOR**
   ```al
   // MCP reviewing RentalOperations query:
   "This query on Equipment by Last Maintenance Date would benefit
   from an index. Add this to BookingCore.Equipment table:

   key(MaintenanceDateKey; "Last Maintenance Date") { }"
   ```

2. **SIFT Key Optimization**
   ```al
   // MCP suggests:
   key(DateSumKey; "Booking Date")
   {
       SumIndexFields = "Total Amount";
   }
   ```

3. **Performance Testing**
   ```al
   // MCP generates:
   - Performance test with 1000+ records
   - Benchmark assertions
   - Edge case coverage
   ```

---

## Workshop Exercise Mapping

### Stage 1 Exercise: "Add Discount to Bookings"

**Autocomplete creates:**
- ❌ Discount as plain Decimal field (no enum)
- ❌ No validation
- ❌ Doesn't update pricing calculation
- ❌ Wrong object ID (autocomplete guesses)

### Stage 2 Exercise: "Review Stage 1 Discount Code"

**Prompt:** "Review this discount implementation. What's wrong?"

**Generic Copilot finds:**
- ✅ Should use enum for discount type
- ✅ Missing validation (0-100% range)
- ✅ Not integrated with pricing calculation
- ❌ Misses object ID range issue
- ❌ Misses AL naming conventions
- ❌ Doesn't suggest comprehensive tests

**Result:** Better, but incomplete

### Stage 3 Exercise: "Implement Maintenance Report with Review"

**Part 1: Quick Implementation (create problems)**
```al
procedure GetUpcomingMaintenance()
var
    Equipment: Record Equipment;
begin
    // Intentionally inefficient:
    Equipment.FindSet();  // No SetLoadFields
    repeat
        if (Equipment."Last Maintenance Date" + 90) <= (Today() + 30) then
            // Process
    until Equipment.Next() = 0;
end;
```

**Part 2: Review with MCP**

**Prompt:** "Review this maintenance report against AL best practices"

**MCP finds:**
- ✅ Missing SetLoadFields
- ✅ Should filter by date range first
- ✅ **Needs index on BookingCore.Equipment.LastMaintenanceDate** ⭐
- ✅ Should handle null maintenance dates
- ✅ Violates AL naming (procedure name)
- ✅ Wrong object ID range
- ✅ **Needs comprehensive tests (unit + performance)** ⭐
- ✅ Suggests proper error handling

**vs Generic Copilot:**
- ✅ Basic optimization (SetLoadFields)
- ❌ Misses cross-layer index
- ❌ Misses AL conventions
- ❌ Doesn't suggest comprehensive tests

---

## Key Demonstration Moments

### Stage 2 → Stage 3 Comparison

**Show side-by-side:**

| Pattern | Generic AI (Stage 2) | MCP (Stage 3) |
|---------|---------------------|---------------|
| CalcSums | ✅ Finds | ✅ Finds |
| SetLoadFields | ✅ Finds | ✅ Finds |
| FlowField Context | ❌ Misses | ✅ Finds |
| Cross-Layer Index | ❌ Misses | ⭐ **FINDS** |
| AL Conventions | ❌ Misses | ✅ Finds |
| Comprehensive Tests | ❌ Misses | ⭐ **GENERATES** |

**This is the 74,465% improvement visualization**

---

## Red Herrings (Already Optimized Code)

Include in exercises to test if AI recognizes optimal code:

```al
// This is already optimized - should NOT be changed
procedure GetBookingSummary(BookingNo: Code[20]): Decimal
var
    Booking: Record Booking;
begin
    Booking.SetLoadFields("Total Amount");
    if Booking.Get(BookingNo) then
        exit(Booking."Total Amount");
end;
```

**Generic AI:** Might suggest unnecessary changes
**MCP:** Should recognize this is already optimal

---

## Implementation Checklist

### Stage 1 Code (Autocomplete)
- [ ] Manual loop instead of CalcSums
- [ ] No SetLoadFields
- [ ] N+1 query pattern (nested loops)
- [ ] Missing index for planned query
- [ ] Wrong object IDs
- [ ] No validation
- [ ] Plain field instead of enum

### Stage 2 Expected Catches (Generic)
- [ ] CalcSums opportunity
- [ ] SetLoadFields opportunity
- [ ] Basic validation
- [ ] Enum suggestion

### Stage 3 Expected Catches (MCP)
- [ ] All Stage 2 items
- [ ] Cross-layer index suggestion ⭐
- [ ] FlowField vs CalcSums context
- [ ] AL naming conventions
- [ ] Proper object ID ranges
- [ ] Comprehensive test generation ⭐
- [ ] Performance test with benchmarks ⭐

---

## Success Metrics for Workshop

**Stage 2 Participants Should:**
- See basic improvements (CalcSums, SetLoadFields)
- Notice AI missed some issues
- Feel "helpful but incomplete"

**Stage 3 Participants Should:**
- See dramatic difference with MCP
- Experience "AI as BC expert" moment
- Understand the 74,465% improvement claim
- Want to install MCP immediately

---

**Next Step:** Implement these patterns in AmuseYou-Apps code structure
