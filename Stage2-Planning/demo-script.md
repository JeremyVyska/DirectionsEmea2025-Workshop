# Stage 2 Demo Script: Generic AI Review of AmuseYou Code

**Duration:** 10 minutes
**Goal:** Show what generic AI catches vs misses when reviewing baseline code with anti-patterns

## Setup

- Open [RentalOperations/src/AvailabilityMgt.Codeunit.al](../../AmuseYou-Apps/RentalOperations/src/AvailabilityMgt.Codeunit.al)
- Navigate to `GetTotalRevenue()` procedure
- Screen shared with audience

## Demo Flow

### 1. Set the Stage (1 min)

**Say:**
> "Stage 1 showed us the speed of AI coding. Now let's flip it around: can AI help us improve existing code?
>
> Here's a real procedure from AmuseYou - `GetTotalRevenue()`. Let's ask generic AI to review it."

**Show the code:**
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

### 2. Basic Review Request (3 min)

**Prompt to AI:**
```
Review this GetTotalRevenue procedure for issues and suggest improvements
```

**Expected AI Response:**

Generic AI will likely suggest:
- ✅ Use `CalcSums` instead of manual loop
- ✅ Add SetLoadFields for performance
- ✅ Maybe add error handling
- ✅ Consider filtering by status (completed bookings)

**Say as AI responds:**
> "Good catches! CalcSums is way faster - that's going from O(n) loop to O(1) SQL aggregate. SetLoadFields reduces data transfer. These are **Easy Wins** that generic AI knows about."

**Show the improved version if AI suggests it:**
```al
Booking.SetRange(Status, BookingStatus::Completed);
Booking.CalcSums("Total Amount");
exit(Booking."Total Amount");
```

### 3. What Did AI Miss? (3 min)

**Say:**
> "But what did AI NOT tell us? Let me check the app structure..."

**Pull up [RentalOperations/app.json](../../AmuseYou-Apps/RentalOperations/app.json):**
```json
"idRanges": [
  {
    "from": 50200,
    "to": 50299
  }
]
```

**Point out gaps:**

**Say:**
> "AI missed Business Central-specific context:
>
> - **Object ID Range**: Did AI verify this codeunit is 50200-50299? (It should be)
> - **SIFT Keys**: Did AI check if Booking table has `SumIndexFields = "Total Amount"`? (Critical for CalcSums performance)
> - **Cross-Layer Knowledge**: This is in RentalOperations but queries BookingCore table - did AI understand that dependency?
> - **Test Generation**: Did AI suggest comprehensive tests with mock data?
> - **Telemetry**: Should we track how often this is called?"

**Try a specific follow-up:**

**Prompt:**
```
What Business Central-specific patterns should this procedure follow?
```

**Expected response:**
- Might mention some AL patterns
- Still likely misses object ID context, SIFT keys, cross-module implications

### 4. Demonstrate the Gap (2 min)

**Say:**
> "Generic AI found the obvious performance issue (~60% catch rate for Easy Wins). That's valuable!
>
> But it doesn't know:
> - Our app architecture (object ranges, module boundaries)
> - Business Central platform specifics (SIFT, FlowFields, AL patterns)
> - Cross-layer dependencies (BookingCore table needs proper indexing)
>
> This is the **knowledge gap** - generic programming knowledge vs domain expertise."

### 5. Set Up Stage 3 (1 min)

**Say:**
> "In Stage 3, we'll review this same code with BC specialists:
> - Dean (performance expert): 'Check the SIFT keys on Booking table'
> - Roger (quality expert): 'Add proper error handling and telemetry'
> - Jordan (integration expert): 'This cross-module call needs documentation'
>
> You'll see the catch rate jump from ~60% to ~95%. That's the power of knowledge engineering."

## Transition to Exercise

**Say:**
> "Now pick one of these files from AmuseYou and ask AI to review it:
> - **BookingMgt.Codeunit.al** - Booking creation logic
> - **Booking.Table.al** - Core data structure
> - **AvailabilityMgt.Codeunit.al** - Equipment availability checks
>
> Try different prompts. Track what AI catches vs what it misses. We'll compare notes in 15 minutes."

---

## Instructor Notes

- **Balance**: Show AI's strengths (CalcSums!) and limitations (BC context)
- **Concrete examples**: Use app.json to show missing context
- **Energy**: Curious and analytical, not dismissive of generic AI
- **Foreshadow Stage 3**: "Imagine if AI knew BC like a 10-year veteran..."
- **Key message**: Generic AI is useful but domain knowledge multiplies its value
