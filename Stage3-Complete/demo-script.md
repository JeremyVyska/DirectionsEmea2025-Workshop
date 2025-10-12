# Stage 3 Demo Script: BC Specialists Review AmuseYou Code

**Duration:** 20 minutes
**Goal:** Show dramatic improvement when BC specialists review the same code from Stage 2

## Setup

- Open [RentalOperations/src/AvailabilityMgt.Codeunit.al](../../AmuseYou-Apps/RentalOperations/src/AvailabilityMgt.Codeunit.al)
- Navigate to `GetTotalRevenue()` procedure (same one from Stage 2 demo)
- Have Stage 2 findings visible for comparison
- Screen shared with audience

## Demo Flow

### 1. Set the Stage (2 min)

**Say:**
> "In Stage 2, generic AI found the CalcSums optimization - about 60% of the Easy Wins. Good start!
>
> But it missed BC-specific patterns. Now let's see what happens when we add BC domain expertise.
>
> I'm going to ask Dean - our performance specialist - to review the exact same code."

**Show the code again:**
```al
procedure GetTotalRevenue(): Decimal
var
    Booking: Record Booking;
    Total: Decimal;
begin
    if Booking.FindSet() then
        repeat
            Total += Booking."Total Amount";
        until Booking.Next() = 0;
    exit(Total);
end;
```

### 2. Dean's Performance Review (5 min)

**Prompt to AI:**
```
Dean, review this GetTotalRevenue procedure for performance issues and BC best practices
```

**Expected Dean Response (MCP-enhanced):**

Dean should catch **everything** generic AI found PLUS:

✅ **Basic Optimizations (Generic AI found these too):**
- Replace manual loop with CalcSums
- Add SetLoadFields

✅ **BC-Specific Patterns (NEW - Generic AI missed):**
- **SIFT Keys**: "For CalcSums to be O(1) instead of O(n), the Booking table needs `SumIndexFields = "Total Amount"` on the primary key or a SIFT key"
- **Object ID Context**: "Verify this codeunit (50205) is in the correct range for RentalOperations app (50200-50299)" ✓
- **FlowField Alternative**: "Consider adding a FlowField to Equipment table for revenue aggregation if this is frequently called"
- **Telemetry**: "Add Session.LogMessage() to track slow queries and usage patterns"
- **Status Filtering**: "Should filter by BookingStatus::Completed - active bookings haven't generated revenue yet"

**Say as Dean responds:**
> "Look at the depth here! Dean isn't just suggesting CalcSums - he's checking if the underlying SIFT keys exist for it to be performant. That's cross-layer reasoning.
>
> He knows object ID ranges. He's thinking about telemetry. This is BC expertise in action."

### 3. Show the SIFT Key Issue (3 min)

**Open [BookingCore/src/Booking.Table.al](../../AmuseYou-Apps/BookingCore/src/Booking.Table.al):**

**Say:**
> "Let me check if we have the SIFT keys Dean mentioned..."

**Show the keys section:**
```al
keys
{
    key(PK; "Booking No.")
    {
        Clustered = true;
        // ❌ Missing: SumIndexFields = "Total Amount";
    }
    // ❌ No SIFT key for status-based aggregations
}
```

**Say:**
> "Dean was right - we're missing the SumIndexFields! Generic AI suggested CalcSums without checking if it would actually be fast.
>
> Dean knows to verify the foundation before recommending the solution. That's what domain expertise gives you."

### 4. Roger's Quality Review (4 min)

**Back to GetTotalRevenue procedure:**

**Prompt:**
```
Roger, review this same procedure for code quality and security issues
```

**Expected Roger Response:**

✅ **Quality Patterns (Generic AI missed most of these):**
- **Error Handling**: "No ErrorInfo pattern - what if table access fails?"
- **Text Constants**: "Consider adding descriptive error messages as Labels"
- **Return Value Context**: "Should this return 0 or error if no bookings found? Current behavior is ambiguous"
- **Security**: "Does the user have Read permission on Booking table? Add permission check or document assumption"
- **XML Documentation**: "Add /// <summary> documentation explaining this aggregates completed bookings only"

**Say:**
> "Roger covers the quality dimension. Error handling, documentation, security checks - all the stuff we skip under time pressure.
>
> Generic AI might mention 'add error handling' generically. Roger gives you the BC-specific ErrorInfo pattern with actionable recommendations."

### 5. Compare Stage 2 vs Stage 3 (3 min)

**Show side-by-side comparison on screen:**

**Stage 2 - Generic AI (~60% Easy Wins):**
- ✅ Use CalcSums
- ✅ Add SetLoadFields
- ❌ Missed SIFT keys
- ❌ Missed object ID verification
- ❌ Missed BC error patterns
- ❌ Missed telemetry requirements
- ❌ Missed security considerations

**Stage 3 - BC Specialists (~95% catch rate):**
- ✅ All Stage 2 suggestions
- ✅ SIFT key requirements
- ✅ Object ID verification
- ✅ ErrorInfo pattern
- ✅ Telemetry recommendations
- ✅ FlowField alternative
- ✅ Security documentation
- ✅ Comprehensive XML docs

**Say:**
> "This is the knowledge gap in action:
> - Stage 2: 60% catch rate, generic improvements
> - Stage 3: 95% catch rate, production-ready recommendations
>
> Same code, same amount of time, dramatically different results."

### 6. Set Up Exercise (3 min)

**Say:**
> "Now it's your turn to feel the difference.
>
> Take the files you reviewed in Stage 2 and ask BC specialists to review them:
> - **Dean** for performance
> - **Roger** for quality
> - **Uma** for user experience
> - **Jordan** for integration
>
> Compare the results. Count how many more issues the specialists find. Notice the depth and specificity of recommendations.
>
> **This is why knowledge engineering matters.** You're about to experience it firsthand."

---

## Instructor Notes

- **Make the contrast visceral**: Show the exact same code, highlight what was missed
- **Use SIFT keys as the "gotcha"**: CalcSums without SIFT is still slow!
- **Show multiple specialists**: Dean + Roger demonstrates full spectrum coverage
- **Quantify the improvement**: "60% → 95% catch rate"
- **Energy**: This should feel like a revelation, not just an incremental improvement
- **Key message**: "Domain expertise isn't nice to have - it's the difference between working code and production-ready code"

## MCP vs .al-guidelines Note

**MCP users** will see automatic knowledge retrieval - the specialists "just know" BC patterns

**Non-MCP users** can get similar results by explicitly referencing guidelines:
```
Review .al-guidelines/domains/dean-debug/ and .al-guidelines/domains/roger-reviewer/ knowledge files, then analyze this procedure
```

Both work - MCP is just more ergonomic. The knowledge content is identical.
