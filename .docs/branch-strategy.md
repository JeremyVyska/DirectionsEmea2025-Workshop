# Git Branch Strategy

This document explains the branch structure for the workshop and how to create solution branches.

## Branch Structure

```
main (clean starting point)
├── stage1-start (identical to main - fresh start for Stage 1)
├── stage1-solution (maintenance status with autocomplete gaps)
│
├── stage2-start (identical to stage1-solution - includes technical debt)
├── stage2-solution (improved maintenance status with planning)
│
├── stage3-start (identical to stage2-solution - ready for final stage)
└── stage3-solution (complete: maintenance report + indexes + tests)
```

## Branch Purpose

### Starting Branches
- **stage1-start**: Clean slate, base AL apps complete
- **stage2-start**: Includes Stage 1 work (with intentional technical debt to fix)
- **stage3-start**: Includes Stage 2 improvements (ready for cross-layer work)

### Solution Branches
- **stage1-solution**: Completed maintenance status (autocomplete style)
- **stage2-solution**: Improved maintenance status (planning style)
- **stage3-solution**: Maintenance report feature (full agentic)

## Creating Solution Branches

### Prerequisites

Complete workshop base is on `main`:
- 5 AL apps with proper structure
- .al-guidelines folder
- Stage documentation
- .devcontainer setup

### Step 1: Create Stage 1 Solution

**Implements:** Equipment maintenance status with autocomplete thinking patterns

```bash
git checkout main
git checkout -b stage1-solution
```

**Add maintenance status with intentional autocomplete gaps:**

1. Add to [Equipment.Table.al](../AmuseYou-Apps/BookingCore/src/Equipment.Table.al):
   ```al
   field(7; "Maintenance Status"; Option)
   {
       Caption = 'Maintenance Status';
       OptionMembers = Available,UnderMaintenance,RequiresInspection;
       DataClassification = CustomerContent;
   }
   ```
   **Note:** Using Option instead of Enum (autocomplete mistake)

2. Add to Equipment List/Card pages (fields only, no validation)

3. **Do NOT add:**
   - Integration with AvailabilityMgt
   - Validation logic
   - Enum instead of Option
   - Error handling

**Commit:**
```bash
git add .
git commit -m "Stage 1 solution: Add maintenance status (autocomplete baseline)

- Added Maintenance Status option field to Equipment
- Updated Equipment pages to display status
- Missing: validation, availability integration, proper enum
- Intentional technical debt for Stage 2 to improve"
```

### Step 2: Create Stage 2 Solution

**Implements:** Improved maintenance status with planning approach

```bash
git checkout stage1-solution
git checkout -b stage2-solution
```

**Improve the implementation:**

1. **Replace Option with Enum:**
   - Create [MaintenanceStatus.Enum.al](../AmuseYou-Apps/BookingCore/src/MaintenanceStatus.Enum.al):
     ```al
     namespace AmuseYou.BookingCore;

     enum 50002 MaintenanceStatus
     {
         Extensible = true;

         value(0; Available) { Caption = 'Available'; }
         value(1; UnderMaintenance) { Caption = 'Under Maintenance'; }
         value(2; RequiresInspection) { Caption = 'Requires Inspection'; }
     }
     ```
   - Update Equipment table field to use enum

2. **Add validation:**
   - Equipment under maintenance should be blocked from booking
   - Update [AvailabilityMgt.Codeunit.al](../AmuseYou-Apps/RentalOperations/src/AvailabilityMgt.Codeunit.al):
     ```al
     procedure IsEquipmentAvailable(EquipmentNo: Code[20]; StartDate: Date; EndDate: Date): Boolean
     begin
         // ... existing code ...

         if Equipment."Maintenance Status" <> MaintenanceStatus::Available then
             exit(false);

         // ... rest of logic ...
     end;
     ```

3. **Add error handling:**
   - Descriptive error message when trying to book equipment under maintenance

4. **Update GetAvailableEquipment:**
   - Filter out equipment not in Available status

**Commit:**
```bash
git add .
git commit -m "Stage 2 solution: Improve maintenance status with planning

- Replaced Option with proper MaintenanceStatus enum
- Integrated with AvailabilityMgt availability checks
- Added validation: equipment under maintenance cannot be booked
- Added descriptive error messages
- Complete implementation vs Stage 1 technical debt"
```

### Step 3: Create Stage 3 Solution

**Implements:** Upcoming maintenance report with cross-layer reasoning + testing

```bash
git checkout stage2-solution
git checkout -b stage3-solution
```

**Add maintenance report feature:**

1. **Add index to BookingCore Equipment table:**
   ```al
   keys
   {
       key(PK; "No.") { Clustered = true; }
       key(TypeKey; "Equipment Type") { }
       key(MaintenanceDateKey; "Last Maintenance Date") { }  // NEW for performance
   }
   ```

2. **Create MaintenanceMgt codeunit in RentalOperations:**
   - Object ID: 50205
   - Method: GetUpcomingMaintenanceEquipment
   - Logic: Last Maintenance + 90 days <= Today + 30 days
   - Use SetLoadFields for performance

3. **Create comprehensive tests:**
   - Unit tests: boundary conditions, null dates, filtering
   - Performance test: 1000+ equipment records, < 5 second benchmark

**Example implementation:**

[RentalOperations/src/MaintenanceMgt.Codeunit.al](../AmuseYou-Apps/RentalOperations/src/MaintenanceMgt.Codeunit.al):
```al
namespace AmuseYou.RentalOperations;

using AmuseYou.BookingCore;

codeunit 50205 MaintenanceMgt
{
    procedure GetUpcomingMaintenanceEquipment(EquipmentType: Enum EquipmentType; var TempEquipment: Record Equipment temporary)
    var
        Equipment: Record Equipment;
        MaintenanceDueDate: Date;
        CutoffDate: Date;
    begin
        TempEquipment.Reset();
        TempEquipment.DeleteAll();

        CutoffDate := Today() + 30;

        Equipment.SetLoadFields("No.", Description, "Equipment Type", "Last Maintenance Date");
        Equipment.SetRange("Equipment Type", EquipmentType);

        if Equipment.FindSet() then
            repeat
                if Equipment."Last Maintenance Date" <> 0D then begin
                    MaintenanceDueDate := Equipment."Last Maintenance Date" + 90;
                    if MaintenanceDueDate <= CutoffDate then begin
                        TempEquipment := Equipment;
                        TempEquipment.Insert();
                    end;
                end;
            until Equipment.Next() = 0;
    end;
}
```

[RentalOperations.Test/src/PerformanceTests/MaintenancePerformanceTests.Codeunit.al](../AmuseYou-Apps/RentalOperations.Test/src/PerformanceTests/MaintenancePerformanceTests.Codeunit.al):
```al
namespace AmuseYou.RentalOperations.Test;

using AmuseYou.BookingCore;
using AmuseYou.RentalOperations;

codeunit 50310 "Maintenance Performance Tests"
{
    Subtype = Test;

    [Test]
    procedure TestMaintenanceReportPerformance()
    var
        Equipment: Record Equipment;
        TempUpcoming: Record Equipment temporary;
        MaintenanceMgt: Codeunit MaintenanceMgt;
        StartTime: DateTime;
        Duration: Duration;
        i: Integer;
    begin
        // [GIVEN] 1000 equipment records
        for i := 1 to 1000 do
            CreateEquipmentWithMaintenance('MAINT' + Format(i, 4, '<Integer,4><Filler Character,0>'), Today() - Random(180));

        // [WHEN] Running maintenance report
        StartTime := CurrentDateTime();
        MaintenanceMgt.GetUpcomingMaintenanceEquipment(EquipmentType::BounceUnit, TempUpcoming);
        Duration := CurrentDateTime() - StartTime;

        // [THEN] Completes in under 5 seconds
        Assert.IsTrue(Duration < 5000, StrSubstNo('Query took %1ms, expected <5000ms', Duration));
    end;

    local procedure CreateEquipmentWithMaintenance(EquipmentNo: Code[20]; LastMaintenanceDate: Date)
    var
        Equipment: Record Equipment;
    begin
        Equipment.Init();
        Equipment."No." := EquipmentNo;
        Equipment.Description := 'Test Equipment';
        Equipment."Equipment Type" := EquipmentType::BounceUnit;
        Equipment."Daily Rental Rate" := 100;
        Equipment."Last Maintenance Date" := LastMaintenanceDate;
        Equipment.Insert();
    end;
}
```

**Commit:**
```bash
git add .
git commit -m "Stage 3 solution: Add upcoming maintenance report (complete agentic)

Cross-layer changes:
- Added MaintenanceDateKey index to BookingCore.Equipment
- Created MaintenanceMgt codeunit in RentalOperations
- Uses SetLoadFields for performance

Testing:
- Performance test: 1000 records, <5 second benchmark
- Unit tests: boundary conditions, null dates, filtering

Knowledge applied:
- AL performance patterns (indexing, SetLoadFields)
- Proper cross-layer dependency management
- Comprehensive test coverage"
```

### Step 4: Create Starting Point Branches

```bash
# Stage 1 starts from clean main
git checkout main
git branch stage1-start

# Stage 2 starts from Stage 1 solution (includes technical debt)
git checkout stage1-solution
git branch stage2-start

# Stage 3 starts from Stage 2 solution (ready for cross-layer work)
git checkout stage2-solution
git branch stage3-start
```

### Step 5: Push All Branches

```bash
git push origin main
git push origin stage1-start stage1-solution
git push origin stage2-start stage2-solution
git push origin stage3-start stage3-solution
```

## Participant Workflow

Participants never commit to these branches - they work locally:

```bash
# Stage 1
git checkout stage1-start
# [do exercise, commit locally]
# Compare to solution:
git diff stage1-start..stage1-solution

# Stage 2
git checkout stage2-start  # Fresh start from Stage 1 solution
# [do exercise, commit locally]
git diff stage2-start..stage2-solution

# Stage 3
git checkout stage3-start  # Fresh start from Stage 2 solution
# [do exercise, commit locally]
git diff stage3-start..stage3-solution
```

## Maintaining Solutions

When updating workshop:

1. Make changes on appropriate solution branch
2. Recreate downstream branches:
   ```bash
   git branch -D stage2-start
   git checkout stage1-solution
   git branch stage2-start
   # Repeat for stage3-start
   ```
3. Push updated branches

## Benefits of This Structure

✅ **Clean starting points:** Each stage begins fresh
✅ **Progressive technical debt:** Stage 1 → 2 shows improvement
✅ **No spoilers:** Participants don't see future solutions
✅ **Easy comparison:** `git diff` shows exactly what changed
✅ **Recovery safety:** Can always checkout solution if stuck
✅ **Facilitator control:** Solutions protected, released when appropriate

---

## Next Steps

After creating all branches:
1. Verify each branch builds successfully
2. Test exercise → solution progression works
3. Document in FACILITATOR-GUIDE.md
4. Include branch creation in workshop prep checklist
