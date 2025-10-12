# AmuseYou Anti-Pattern File Mapping
**Created:** 2025-10-12
**Purpose:** Map extracted BC anti-patterns to specific AmuseYou files for Stage 1 implementation
**Workshop:** Getting Started with Vibe Coding in BC (Directions EMEA 2025)

---

## Implementation Strategy

Each anti-pattern from [bc-antipatterns-extraction.md](bc-antipatterns-extraction.md) is mapped to specific AmuseYou files. This creates a realistic Stage 1 baseline with intentional technical debt that:
- Stage 2 (Basic AI Review) catches ~44% of issues
- Stage 3 (MCP + BC Intelligence) catches ~95% of issues

---

## BookingCore App (Base Layer)

### File: [BookingCore/src/Equipment.Table.al](../AmuseYou-Apps/BookingCore/src/Equipment.Table.al)

**Anti-Patterns to Inject:**

1. **#10: Missing LookupPageId/DrillDownPageId** (Roger - 🔴 Hard)
   ```al
   table 50000 Equipment
   {
       Caption = 'Equipment';
       DataClassification = CustomerContent;
       // ❌ Add comment: Missing LookupPageId = "Equipment List";
       // ❌ Add comment: Missing DrillDownPageId = "Equipment List";
   ```

2. **#23: No FieldGroups for Brick/DropDown** (Uma - 🟡 Medium)
   ```al
   // ❌ Add comment at end of table:
   // Missing fieldgroups for Tile and Lookup customization
   ```

3. **#22: Missing Field Tooltips** (Uma - 🟢 Easy)
   ```al
   field(20; "Daily Rental Rate"; Decimal)
   {
       Caption = 'Daily Rental Rate';
       // ❌ Remove ToolTip property if exists
   }
   ```

---

### File: [BookingCore/src/Booking.Table.al](../AmuseYou-Apps/BookingCore/src/Booking.Table.al)

**Anti-Patterns to Inject:**

1. **#1: Missing SIFT Keys** (Dean - 🔴 Hard)
   ```al
   keys
   {
       key(PK; "Booking No.")
       {
           Clustered = true;
       }
       // ❌ Comment out or don't create:
       // key(EquipmentDate; "Equipment No.", "Start Date") { }
       // key(StatusDate; Status, "Start Date") { }
   }
   ```

2. **#2: No SumIndexFields for Aggregations** (Dean - 🟡 Medium)
   ```al
   key(PK; "Booking No.")
   {
       Clustered = true;
       // ❌ Missing: SumIndexFields = "Total Amount";
   }
   ```

3. **#6: Calculated Field Storage** (Dean - 🟢 Easy)
   ```al
   field(60; "Days Until Start"; Integer)
   {
       Caption = 'Days Until Start';
       // ❌ Create as stored field instead of procedure
   }

   field(10; "Start Date"; Date)
   {
       trigger OnValidate()
       begin
           "Days Until Start" := "Start Date" - Today;
           Modify();  // ❌ Unnecessary write
       end;
   }
   ```

4. **#24: Missing Editable Properties** (Uma - 🟡 Medium)
   ```al
   field(50; "Total Amount"; Decimal)
   {
       Caption = 'Total Amount';
       // ❌ Missing: Editable = false;
       // This is calculated but users can overwrite!
   }
   ```

---

### File: [BookingCore/src/BookingStatusEnum.Enum.al](../AmuseYou-Apps/BookingCore/src/BookingStatusEnum.Enum.al)

**Anti-Patterns to Inject:**

1. **#12: XML Documentation Errors** (Roger - 🟡 Medium)
   ```al
   /// <summary>
   /// Booking Status: Pending (<24 hours), Confirmed (>24 hours), Active (in progress)
   /// </summary>
   // ❌ Use literal < and > instead of &lt; and &gt;
   ```

---

## RentalOperations App (Business Logic Layer)

### File: [RentalOperations/src/BookingMgt.Codeunit.al](../AmuseYou-Apps/RentalOperations/src/BookingMgt.Codeunit.al)

**Anti-Patterns to Inject:**

1. **#7: Missing Performance Telemetry** (Dean - 🟡 Medium)
   ```al
   procedure ProcessDailyBookings()
   var
       Booking: Record Booking;
       ProcessedCount: Integer;
   begin
       // ❌ No StartTime tracking
       if Booking.FindSet() then
           repeat
               ProcessBooking(Booking);
               ProcessedCount += 1;
           until Booking.Next() = 0;

       // ❌ No telemetry with duration
       Message('Processed %1 bookings', ProcessedCount);
   end;
   ```

2. **#11: Unnecessary BEGIN..END Blocks** (Roger - 🟢 Easy)
   ```al
   procedure GetBooking(BookingNo: Code[20])
   var
       Booking: Record Booking;
   begin
       if Booking.Get(BookingNo) then begin  // ❌ Unnecessary BEGIN
           Page.Run(Page::"Booking Card", Booking);
       end;
   end;
   ```

3. **#13: Text Constant Violations** (Roger - 🟡 Medium)
   ```al
   procedure CreateBooking()
   var
       Message: Text;
   begin
       // ❌ Literal string instead of Label
       Message := StrSubstNo('Booking created: %1 for customer %2',
           BookingNo, CustomerName);
   end;
   ```

4. **#14: Missing ErrorInfo Pattern** (Roger - 🟡 Medium)
   ```al
   procedure ValidateBooking()
   begin
       if not Equipment.Get("Equipment No.") then
           Error('Equipment %1 not found', "Equipment No.");  // ❌ No user action
   end;
   ```

5. **#29: No Structured Error Handling** (Jordan - 🟡 Medium)
   ```al
   procedure CreateBooking(): Boolean
   begin
       if not ValidateEquipment() then
           exit(false);  // ❌ No error context

       if not CallExternalApi() then
           exit(false);  // ❌ Was this transient? Should retry?
   end;
   ```

6. **#30: Missing Custom Telemetry Dimensions** (Jordan - 🟡 Medium)
   ```al
   procedure ProcessBooking()
   begin
       // ❌ No telemetry with CustomDimensions
       CreateBookingRecord();
       NotifyCustomer();
       UpdateInventory();
   end;
   ```

---

### File: [RentalOperations/src/AvailabilityMgt.Codeunit.al](../AmuseYou-Apps/RentalOperations/src/AvailabilityMgt.Codeunit.al)

**Anti-Patterns to Inject:**

1. **#4: Commit Anti-Pattern in Loops** (Dean - 🔴 Hard)
   ```al
   procedure UpdateMaintenanceStatus()
   var
       Equipment: Record Equipment;
   begin
       if Equipment.FindSet(true) then
           repeat
               if Equipment."Last Maintenance Date" < CalcDate('<-6M>', Today) then begin
                   Equipment.Blocked := true;
                   Equipment.Modify();
                   Commit();  // ❌ CRITICAL: Commit after EVERY record
               end;
           until Equipment.Next() = 0;
   end;
   ```

2. **#8: N+1 Query Pattern** (Dean - 🟡 Medium)
   ```al
   procedure GetAvailableEquipment(StartDate: Date): List of [Code[20]]
   var
       Equipment: Record Equipment;
       Booking: Record Booking;
       AvailableList: List of [Code[20]];
   begin
       if Equipment.FindSet() then
           repeat
               // ❌ N+1: Nested query for EVERY equipment
               Booking.SetRange("Equipment No.", Equipment."No.");
               Booking.SetRange("Start Date", StartDate);
               if Booking.IsEmpty then
                   AvailableList.Add(Equipment."No.");
           until Equipment.Next() = 0;
   end;
   ```

3. **#2: Manual Summation Instead of CalcSums** (Dean - 🟡 Medium)
   ```al
   procedure GetTotalRevenue(): Decimal
   var
       Booking: Record Booking;
       Total: Decimal;
   begin
       // ❌ O(n) iteration instead of O(1) CalcSums
       if Booking.FindSet() then
           repeat
               Total += Booking."Total Amount";
           until Booking.Next() = 0;
       exit(Total);
   end;
   ```

---

### File: [RentalOperations/src/MaintenanceLog.Table.al](../AmuseYou-Apps/RentalOperations/src/MaintenanceLog.Table.al) (NEW)

**Create this table with anti-pattern:**

1. **#3: Blob Fields Auto-Loading** (Dean - 🟡 Medium)
   ```al
   table 50205 "Maintenance Log"
   {
       fields
       {
           field(1; "Entry No."; Integer) { }
           field(10; "Equipment No."; Code[20]) { }
           field(20; "Maintenance Notes"; Blob)
           {
               Caption = 'Maintenance Notes';
               // ❌ No CalcFields pattern - loads automatically
           }
           field(21; "Inspection Photo"; Blob)
           {
               Caption = 'Inspection Photo';
               // ❌ Same issue
           }
       }

       keys
       {
           key(PK; "Entry No.") { Clustered = true; }
       }

       // ❌ Missing helper procedures:
       // procedure GetMaintenanceNotesText(): Text
       // procedure GetInspectionPhotoStream(var InStr: InStream)
   }
   ```

---

### File: [RentalOperations/src/WeatherApiClient.Codeunit.al](../AmuseYou-Apps/RentalOperations/src/WeatherApiClient.Codeunit.al) (NEW)

**Create this codeunit with multiple anti-patterns:**

1. **#25: No HttpClient Implementation** (Jordan - 🔴 Hard)
   ```al
   codeunit 50210 "Weather API Client"
   {
       // ❌ NOT SingleInstance = true

       procedure GetWeatherForecast(Location: Text): Text
       begin
           // ❌ PLACEHOLDER
           Error('GetWeatherForecast not yet implemented');
       end;
   }
   ```

2. **#5: No HttpClient Reuse** (Dean - 🟡 Medium)
   ```al
   procedure GetWeatherForecast(Location: Text): Text
   var
       Client: HttpClient;  // ❌ New instance every call
       Response: HttpResponseMessage;
   begin
       Client.Get('https://weather.api/forecast?loc=' + Location, Response);
       // ❌ Creates new TCP connection every time
   end;
   ```

3. **#26: No Retry Logic** (Jordan - 🔴 Hard)
   ```al
   procedure CallWeatherApi(): Boolean
   var
       Client: HttpClient;
       Response: HttpResponseMessage;
   begin
       // ❌ No retry on transient failures
       if not Client.Get('https://weather.api/forecast', Response) then
           exit(false);  // Gives up immediately!
   end;
   ```

4. **#28: No API Versioning Strategy** (Jordan - 🔴 Hard)
   ```al
   procedure GetWeatherForecast(): Text
   var
       Url: Text;
   begin
       // ❌ Hardcoded API version
       Url := 'https://weather.api/v1/forecast';
       // ❌ No version negotiation
   end;
   ```

---

### File: [RentalOperations/src/BookingCard.Page.al](../AmuseYou-Apps/RentalOperations/src/BookingCard.Page.al)

**Anti-Patterns to Inject:**

1. **#18: No FactBox Integration** (Uma - 🟡 Medium)
   ```al
   page 50201 "Booking Card"
   {
       layout
       {
           area(Content) { /* fields */ }
           // ❌ MISSING: area(FactBoxes) { }
       }
   }
   ```

2. **#19: Missing PromotedActionCategories** (Uma - 🟢 Easy)
   ```al
   page 50201 "Booking Card"
   {
       // ❌ MISSING: PromotedActionCategories = 'New,Process,Report,Navigate';

       actions
       {
           area(Processing)
           {
               action(ConfirmBooking)
               {
                   Caption = 'Confirm Booking';
                   Promoted = true;
                   // ❌ MISSING: PromotedCategory = Process;
                   // ❌ MISSING: PromotedIsBig = true;
               }
           }
       }
   }
   ```

3. **#21: Inefficient Field Organization** (Uma - 🟡 Medium)
   ```al
   layout
   {
       area(Content)
       {
           // ❌ Fields not grouped logically
           field("Booking No."; Rec."Booking No.") { }
           field("Total Amount"; Rec."Total Amount") { }  // Financial mixed with header
           field("Customer Name"; Rec."Customer Name") { }
           field("Equipment No."; Rec."Equipment No.") { }
           field("Start Date"; Rec."Start Date") { }
           field("Discount %"; Rec."Discount %") { }  // Financial scattered
       }
   }
   ```

---

### File: [RentalOperations/src/BookingList.Page.al](../AmuseYou-Apps/RentalOperations/src/BookingList.Page.al)

**Anti-Patterns to Inject:**

1. **#20: Actions Not Promoted** (Uma - 🟢 Easy)
   ```al
   actions
   {
       action(CreateNewBooking)
       {
           Caption = 'New Booking';
           // ❌ MISSING: Promoted = true;
           // ❌ MISSING: PromotedCategory = New;
       }
   }
   ```

---

## Missing Files (Critical Anti-Patterns)

### File: [RentalOperations/RoleCenter.Page.al](../AmuseYou-Apps/RentalOperations/RoleCenter.Page.al) (MISSING)

**Anti-Pattern:**

1. **#17: Missing Role Center** (Uma - 🔴 Hard)
   ```al
   // ❌ NO FILE EXISTS
   // Result: Users have nowhere to start, no navigation hub
   ```

---

### File: [BookingCore/.permissions/](../AmuseYou-Apps/BookingCore/.permissions/) (EMPTY)

**Anti-Pattern:**

1. **#9: Missing Permission Sets** (Roger - 🔴 Hard)
   ```al
   // ❌ FOLDER IS EMPTY
   // Result: All objects show "not covered by any permission set" errors
   ```

---

## BookingCore.Test App

### File: [BookingCore.Test/src/BookingTests.Codeunit.al](../AmuseYou-Apps/BookingCore.Test/src/BookingTests.Codeunit.al)

**Anti-Pattern to Inject:**

1. **#16: Missing Test Coverage** (Roger - 🟡 Medium)
   ```al
   codeunit 50105 "Booking Tests"
   {
       // ✅ Has: Basic CRUD tests
       // ❌ MISSING: Edge case tests
       // ❌ MISSING: Validation error tests
       // ❌ MISSING: Permission tests
   }
   ```

---

### File: [BookingCore.Test/src/EquipmentTests.Codeunit.al](../AmuseYou-Apps/BookingCore.Test/src/EquipmentTests.Codeunit.al)

**Anti-Pattern to Inject:**

1. **#15: Inconsistent Naming Conventions** (Roger - 🟢 Easy)
   ```al
   var
       bookingNo: Code[20];  // ❌ camelCase
       CustomerName: Text[100];  // ✅ PascalCase
       equipment_no: Code[20];  // ❌ snake_case
   ```

---

## Integration Events (Missing)

### File: [BookingCore/src/BookingEvents.Codeunit.al](../AmuseYou-Apps/BookingCore/src/BookingEvents.Codeunit.al) (MISSING)

**Anti-Pattern:**

1. **#27: Limited Integration Events** (Jordan - 🟡 Medium)
   ```al
   // ❌ NO FILE EXISTS
   // Result: No OnBeforeInsertBooking, OnAfterInsertBooking events
   // Extensions can't inject logic
   ```

---

## Summary: Anti-Pattern Distribution by File

| File | Anti-Patterns | 🟢 Easy | 🟡 Medium | 🔴 Hard |
|------|---------------|---------|-----------|---------|
| Equipment.Table.al | 3 | 1 | 1 | 1 |
| Booking.Table.al | 4 | 1 | 2 | 1 |
| BookingStatusEnum.Enum.al | 1 | 0 | 1 | 0 |
| BookingMgt.Codeunit.al | 6 | 1 | 4 | 0 |
| AvailabilityMgt.Codeunit.al | 3 | 0 | 2 | 1 |
| MaintenanceLog.Table.al (NEW) | 1 | 0 | 1 | 0 |
| WeatherApiClient.Codeunit.al (NEW) | 4 | 0 | 1 | 3 |
| BookingCard.Page.al | 3 | 1 | 2 | 0 |
| BookingList.Page.al | 1 | 1 | 0 | 0 |
| RoleCenter.Page.al (MISSING) | 1 | 0 | 0 | 1 |
| .permissions/ (EMPTY) | 1 | 0 | 0 | 1 |
| BookingTests.Codeunit.al | 1 | 0 | 1 | 0 |
| EquipmentTests.Codeunit.al | 1 | 1 | 0 | 0 |
| BookingEvents.Codeunit.al (MISSING) | 1 | 0 | 1 | 0 |
| **TOTAL** | **30** | **6** | **16** | **8** |

---

## Implementation Checklist

### Stage 1 Baseline (stage1-solution branch)

- [ ] Inject 30 anti-patterns into existing/new files
- [ ] Ensure code compiles (but with technical debt)
- [ ] Add comments marking each anti-pattern location
- [ ] Test that app runs but performs poorly

### Stage 2 Expected Results (stage2-solution branch)

Generic Copilot should catch:
- [ ] ~90% of 🟢 Easy issues (5/6)
- [ ] ~43% of 🟡 Medium issues (7/16)
- [ ] ~13% of 🔴 Hard issues (1/8)
- **Total: ~44% (13/30)**

### Stage 3 Expected Results (stage3-solution branch)

MCP + BC Intelligence should catch:
- [ ] 100% of 🟢 Easy issues (6/6)
- [ ] ~95% of 🟡 Medium issues (15/16)
- [ ] ~90% of 🔴 Hard issues (7/8)
- **Total: ~93% (28/30)**

---

## Advanced Exercises

For students who complete early or want to practice at home:

1. **Ask Dean**: "Review this app for performance issues and create a markdown file with your recommendations"
   - Expected findings: Issues #1-8

2. **Ask Roger**: "Review this app for code quality issues and create a markdown file with your recommendations"
   - Expected findings: Issues #9-16

3. **Ask Uma**: "Review this app for UX issues and create a markdown file with your recommendations"
   - Expected findings: Issues #17-24

4. **Ask Jordan**: "Review this app for integration issues and create a markdown file with your recommendations"
   - Expected findings: Issues #25-30

---

*Ready to implement anti-patterns in AmuseYou baseline! 🎯*
