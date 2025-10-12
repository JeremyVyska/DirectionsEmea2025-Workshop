# BC Anti-Patterns Extraction for AmuseYou Baseline
**Created:** 2025-10-12
**Purpose:** Extract real BC anti-patterns from ExampleISVApp MCP analyses for Stage 1 baseline code
**Workshop:** Getting Started with Vibe Coding in BC (Directions EMEA 2025)

---

## Strategy

From the 4 MCP specialist analyses of ExampleISVApp app, extract **4-8 concrete anti-patterns per specialist** that can be embedded into AmuseYou Stage 1 baseline code. These will demonstrate:
- Stage 1: Autocomplete creates anti-patterns (intentional technical debt)
- Stage 2: Basic AI Review catches ~60% (Easy Wins - CalcSums, SetLoadFields)
- Stage 3: MCP-enhanced Review catches 80-100% (Cross-layer, BC-specific patterns)

---

## Dean Debug - Performance Anti-Patterns (8 selected)

### 1. Missing SIFT Keys (CRITICAL - 🔴 Hard)
**ExampleISVApp Issue #28**: BusinessEntity table has ZERO secondary keys causing full table scans

**AmuseYou Implementation**:
```al
// File: AmuseYou-Apps/BookingCore/src/Booking.Table.al
table 50001 Booking
{
    keys
    {
        key(PK; "Booking No.")
        {
            Clustered = true;
        }
        // ❌ MISSING: key(EquipmentDate; "Equipment No.", "Start Date")
        // ❌ MISSING: key(StatusDate; Status, "Start Date")
        // Result: Availability queries = full table scan
    }
}
```

**Performance Impact**: 10-100x slower filtered queries
**Stage 2 Catch Rate**: 20% (generic AI won't know BC SIFT patterns)
**Stage 3 Catch Rate**: 95% (Dean knows exact key patterns needed)

---

### 2. No SumIndexFields for Aggregations (CRITICAL - 🟡 Medium)
**ExampleISVApp Issue #30**: APICallLedger missing SumIndexFields causing O(n) summations

**AmuseYou Implementation**:
```al
// File: AmuseYou-Apps/BookingCore/src/Booking.Table.al
table 50001 Booking
{
    fields
    {
        field(50; "Total Amount"; Decimal) { }
    }

    keys
    {
        key(PK; "Booking No.")
        {
            Clustered = true;
            // ❌ MISSING: SumIndexFields = "Total Amount";
        }
    }
}

// Usage - inefficient manual summation
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

**Performance Impact**: 30-120x slower as data grows
**Stage 2 Catch Rate**: 60% (generic AI knows CalcSums better than iteration)
**Stage 3 Catch Rate**: 100% (Dean recommends exact SumIndexFields placement)

---

### 3. Blob Fields Auto-Loading (MEDIUM - 🟡 Medium)
**ExampleISVApp Issue #31**: RequestJson/ResponseJson blobs load on list pages causing 90% slower performance

**AmuseYou Implementation**:
```al
// File: AmuseYou-Apps/RentalOperations/src/MaintenanceLog.Table.al
table 50205 "Maintenance Log"
{
    fields
    {
        field(20; "Maintenance Notes"; Blob)
        {
            // ❌ No CalcFields pattern - loads automatically
            // List page showing 100 logs = 100 blobs loaded
        }
        field(21; "Inspection Photo"; Blob)
        {
            // ❌ Same issue - auto-loads 5MB photos on list page
        }
    }
}

// Missing helper procedure
// ❌ Should have: procedure GetMaintenanceNotesText(): Text
```

**Performance Impact**: 90% slower list page loads
**Stage 2 Catch Rate**: 30% (generic AI might not catch BC blob auto-loading)
**Stage 3 Catch Rate**: 90% (Dean explains CalcFields pattern for blobs)

---

### 4. Commit Anti-Pattern in Loops (CRITICAL - 🔴 Hard)
**ExampleISVApp Issue #32**: Commit before EVERY entity update causing 90% transaction overhead

**AmuseYou Implementation**:
```al
// File: AmuseYou-Apps/RentalOperations/src/AvailabilityMgt.Codeunit.al
procedure UpdateMaintenanceStatus()
var
    Equipment: Record Equipment;
begin
    if Equipment.FindSet(true) then
        repeat
            if Equipment."Last Maintenance Date" < CalcDate('<-6M>', Today) then begin
                Equipment.Blocked := true;
                Equipment.Modify();
                // ❌ CRITICAL: Commit after EVERY record
                Commit();  // 1000 records = 1000 SQL transactions!
            end;
        until Equipment.Next() = 0;
end;
```

**Performance Impact**: 90% wasted transaction overhead
**Stage 2 Catch Rate**: 15% (generic AI unlikely to catch commit batching)
**Stage 3 Catch Rate**: 95% (Dean explains batch commit pattern)

---

### 5. No HttpClient Reuse (MEDIUM - 🟡 Medium)
**ExampleISVApp Issue #33**: New HttpClient per call causing 4-20x slower API operations

**AmuseYou Implementation**:
```al
// File: AmuseYou-Apps/Integration.Test/src/WeatherApiClient.Codeunit.al
// ❌ NOT SingleInstance = true

procedure GetWeatherForecast(Location: Text): Text
var
    Client: HttpClient;  // ❌ New instance every call
    Response: HttpResponseMessage;
begin
    // ❌ Creates new TCP connection, SSL handshake every time
    Client.Get('https://weather.api/forecast?loc=' + Location, Response);
    // Result: 200ms connection setup vs 5ms with reuse
end;
```

**Performance Impact**: 4-20x slower after warmup
**Stage 2 Catch Rate**: 40% (generic AI might suggest reuse)
**Stage 3 Catch Rate**: 100% (Dean explains SingleInstance pattern)

---

### 6. Calculated Field Storage (MEDIUM - 🟢 Easy)
**ExampleISVApp Issue #34**: NextFetchDate stored causing unnecessary writes

**AmuseYou Implementation**:
```al
// File: AmuseYou-Apps/BookingCore/src/Booking.Table.al
field(60; "Days Until Start"; Integer)
{
    // ❌ Stored field that could be calculated
    // Triggers write on every Start Date change
}

field(10; "Start Date"; Date)
{
    trigger OnValidate()
    begin
        "Days Until Start" := "Start Date" - Today;  // ❌ Unnecessary DB write
        Modify();
    end;
}

// ✅ Should be: procedure GetDaysUntilStart(): Integer
```

**Performance Impact**: Minor write overhead
**Stage 2 Catch Rate**: 70% (generic AI might catch this)
**Stage 3 Catch Rate**: 100% (Dean recommends lazy evaluation)

---

### 7. Missing Performance Telemetry (MEDIUM - 🟡 Medium)
**ExampleISVApp Issue #35**: No duration tracking on operations

**AmuseYou Implementation**:
```al
// File: AmuseYou-Apps/RentalOperations/src/BookingMgt.Codeunit.al
procedure ProcessDailyBookings()
var
    Booking: Record Booking;
    ProcessedCount: Integer;
begin
    // ❌ No StartTime tracking
    // ❌ No duration measurement
    // ❌ No per-record timing

    if Booking.FindSet() then
        repeat
            ProcessBooking(Booking);
            ProcessedCount += 1;
        until Booking.Next() = 0;

    // ❌ No telemetry: How long did this take?
    Message('Processed %1 bookings', ProcessedCount);
end;
```

**Performance Impact**: No metrics = blind to performance issues
**Stage 2 Catch Rate**: 25% (generic AI might mention logging)
**Stage 3 Catch Rate**: 90% (Dean provides exact telemetry pattern)

---

### 8. N+1 Query Pattern (MEDIUM - 🟡 Medium)
**ExampleISVApp Issue**: Implicit in missing keys and filter patterns

**AmuseYou Implementation**:
```al
// File: AmuseYou-Apps/RentalOperations/src/BookingMgt.Codeunit.al
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
    // Result: 100 equipment = 100 separate queries
end;
```

**Performance Impact**: 10-50x slower than single query
**Stage 2 Catch Rate**: 50% (generic AI might catch obvious N+1)
**Stage 3 Catch Rate**: 95% (Dean explains proper filter strategy)

---

## Roger Reviewer - Code Quality Anti-Patterns (8 selected)

### 9. Missing Permission Sets (CRITICAL - 🔴 Hard)
**ExampleISVApp Issue #1**: Zero permission sets = 96 compile errors + AppSource blocker

**AmuseYou Implementation**:
```al
// File: AmuseYou-Apps/BookingCore/.permissions/
// ❌ FOLDER IS EMPTY
// Result: All objects show "not covered by any permission set" errors
```

**Impact**: AppSource certification FAIL
**Stage 2 Catch Rate**: 5% (generic AI won't know AppSource requirements)
**Stage 3 Catch Rate**: 100% (Roger enforces 3-tier permission model)

---

### 10. Missing LookupPageId/DrillDownPageId (CRITICAL - 🔴 Hard)
**ExampleISVApp Issue #2**: Tables missing page properties

**AmuseYou Implementation**:
```al
// File: AmuseYou-Apps/BookingCore/src/Equipment.Table.al
table 50000 Equipment
{
    Caption = 'Equipment';
    DataClassification = CustomerContent;
    // ❌ MISSING: LookupPageId = "Equipment List";
    // ❌ MISSING: DrillDownPageId = "Equipment List";
    // Result: Lookup fields won't work properly
}
```

**Impact**: Lookup controls fail, poor UX
**Stage 2 Catch Rate**: 15% (generic AI might not catch BC table properties)
**Stage 3 Catch Rate**: 100% (Roger knows exact BC table requirements)

---

### 11. Unnecessary BEGIN..END Blocks (HIGH - 🟢 Easy)
**ExampleISVApp Issue #3**: 8 occurrences of BEGIN..END around single statements

**AmuseYou Implementation**:
```al
// File: AmuseYou-Apps/RentalOperations/src/BookingMgt.Codeunit.al
if Booking.Get("Booking No.") then begin  // ❌ Unnecessary BEGIN
    Page.Run(Page::"Booking Card", Booking);
end;

// ✅ Should be:
if Booking.Get("Booking No.") then
    Page.Run(Page::"Booking Card", Booking);
```

**Impact**: Code analyzer warnings
**Stage 2 Catch Rate**: 90% (generic AI catches this easily)
**Stage 3 Catch Rate**: 100% (Roger enforces BC style guide)

---

### 12. XML Documentation Errors (HIGH - 🟡 Medium)
**ExampleISVApp Issue #4**: Unescaped `<` and `>` in XML comments break IntelliSense

**AmuseYou Implementation**:
```al
// File: AmuseYou-Apps/BookingCore/src/BookingStatusEnum.Enum.al
/// <summary>
/// Booking Status: Pending (<24 hours), Confirmed (>24 hours), Active (in progress)
/// </summary>
// ❌ XML parser breaks on < and >
// ✅ Should use: &lt; and &gt;
```

**Impact**: IntelliSense breaks, doc generation fails
**Stage 2 Catch Rate**: 50% (generic AI might catch XML issues)
**Stage 3 Catch Rate**: 100% (Roger knows BC XML doc requirements)

---

### 13. Text Constant Violations (HIGH - 🟡 Medium)
**ExampleISVApp Issue #5**: StrSubstNo using literal strings

**AmuseYou Implementation**:
```al
// File: AmuseYou-Apps/RentalOperations/src/BookingMgt.Codeunit.al
procedure CreateBooking()
begin
    // ❌ Literal string - not translatable
    Message := StrSubstNo('Booking created: %1 for customer %2',
        BookingNo, CustomerName);

    // ✅ Should use: Label 'Booking created: %1 for customer %2', Comment = '%1 = Booking No., %2 = Customer Name';
end;
```

**Impact**: Not translatable, fails AppSource review
**Stage 2 Catch Rate**: 65% (generic AI knows about i18n)
**Stage 3 Catch Rate**: 100% (Roger enforces BC Label pattern)

---

### 14. Missing ErrorInfo Pattern (HIGH - 🟡 Medium)
**ExampleISVApp Issue**: Error handling without user actions

**AmuseYou Implementation**:
```al
// File: AmuseYou-Apps/RentalOperations/src/BookingMgt.Codeunit.al
procedure ValidateBooking()
begin
    if not Equipment.Get("Equipment No.") then
        Error('Equipment %1 not found', "Equipment No.");  // ❌ No user action

    // ✅ Should use ErrorInfo with AddNavigateAction(), AddAction()
end;
```

**Impact**: Poor error UX, no recovery options
**Stage 2 Catch Rate**: 20% (generic AI won't know BC ErrorInfo)
**Stage 3 Catch Rate**: 95% (Roger demonstrates ErrorInfo pattern)

---

### 15. Inconsistent Naming Conventions (MEDIUM - 🟢 Easy)
**ExampleISVApp Issue**: Mixed naming patterns

**AmuseYou Implementation**:
```al
// File: AmuseYou-Apps/RentalOperations/src/BookingMgt.Codeunit.al
var
    bookingNo: Code[20];  // ❌ camelCase
    CustomerName: Text[100];  // ✅ PascalCase
    equipment_no: Code[20];  // ❌ snake_case
```

**Impact**: Code readability, maintainability
**Stage 2 Catch Rate**: 85% (generic AI knows naming conventions)
**Stage 3 Catch Rate**: 100% (Roger enforces BC naming standards)

---

### 16. Missing Test Coverage (MEDIUM - 🟡 Medium)
**ExampleISVApp Issue**: Positive observation - tests exist but could be more comprehensive

**AmuseYou Implementation**:
```al
// File: AmuseYou-Apps/BookingCore.Test/src/BookingTests.Codeunit.al
// ✅ Has: Basic CRUD tests
// ❌ MISSING: Edge case tests
// ❌ MISSING: Validation error tests
// ❌ MISSING: Permission tests
```

**Impact**: Bugs reach production
**Stage 2 Catch Rate**: 40% (generic AI might suggest more tests)
**Stage 3 Catch Rate**: 90% (Roger provides BC test patterns)

---

## Uma UX - User Experience Anti-Patterns (8 selected)

### 17. Missing Role Center (CRITICAL - 🔴 Hard)
**ExampleISVApp Issue #36**: No Role Center = users can't navigate app

**AmuseYou Implementation**:
```al
// File: AmuseYou-Apps/RentalOperations/
// ❌ NO RoleCenter.Page.al file exists
// Result: Users have nowhere to start, no navigation hub
```

**Impact**: Zero discoverability, unusable app
**Stage 2 Catch Rate**: 10% (generic AI won't know BC navigation patterns)
**Stage 3 Catch Rate**: 100% (Uma insists on Role Center)

---

### 18. No FactBox Integration (CRITICAL - 🟡 Medium)
**ExampleISVApp Issue #37**: No FactBox on Customer/Vendor cards

**AmuseYou Implementation**:
```al
// File: AmuseYou-Apps/RentalOperations/src/BookingCard.Page.al
page 50201 "Booking Card"
{
    layout
    {
        area(Content) { /* fields */ }
        // ❌ MISSING: area(FactBoxes) { }
        // No related equipment details
        // No customer booking history
        // No revenue summary
    }
}
```

**Impact**: Users must navigate away for context
**Stage 2 Catch Rate**: 25% (generic AI might not know FactBox pattern)
**Stage 3 Catch Rate**: 95% (Uma demonstrates FactBox value)

---

### 19. Missing PromotedActionCategories (HIGH - 🟢 Easy)
**ExampleISVApp Issue #38**: Actions not organized in ribbon

**AmuseYou Implementation**:
```al
// File: AmuseYou-Apps/RentalOperations/src/BookingCard.Page.al
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

**Impact**: Actions scattered, hard to find
**Stage 2 Catch Rate**: 70% (generic AI knows UI organization)
**Stage 3 Catch Rate**: 100% (Uma knows BC action promotion)

---

### 20. Actions Not Promoted (HIGH - 🟢 Easy)
**ExampleISVApp Issue #39**: Important actions buried in menus

**AmuseYou Implementation**:
```al
// File: AmuseYou-Apps/RentalOperations/src/BookingList.Page.al
actions
{
    action(CreateNewBooking)
    {
        Caption = 'New Booking';
        // ❌ MISSING: Promoted = true;
        // ❌ MISSING: PromotedCategory = New;
        // Result: Hidden in Actions menu instead of ribbon
    }
}
```

**Impact**: Extra clicks, poor discoverability
**Stage 2 Catch Rate**: 80% (generic AI understands prominent actions)
**Stage 3 Catch Rate**: 100% (Uma enforces BC promotion pattern)

---

### 21. Inefficient Field Organization (MEDIUM - 🟡 Medium)
**ExampleISVApp Issue #40**: Fields not grouped logically

**AmuseYou Implementation**:
```al
// File: AmuseYou-Apps/RentalOperations/src/BookingCard.Page.al
layout
{
    area(Content)
    {
        field("Booking No."; Rec."Booking No.") { }
        field("Total Amount"; Rec."Total Amount") { }  // ❌ Financial mixed with header
        field("Customer Name"; Rec."Customer Name") { }
        field("Equipment No."; Rec."Equipment No.") { }
        field("Start Date"; Rec."Start Date") { }
        field("Discount %"; Rec."Discount %") { }  // ❌ Financial scattered

        // ✅ Should use groups: Header, Dates, Equipment, Financial
    }
}
```

**Impact**: Cognitive load, slower data entry
**Stage 2 Catch Rate**: 60% (generic AI knows grouping)
**Stage 3 Catch Rate**: 95% (Uma demonstrates BC FastTab patterns)

---

### 22. Missing Field Tooltips (MEDIUM - 🟢 Easy)
**ExampleISVApp Issue**: Fields lack ToolTip property

**AmuseYou Implementation**:
```al
// File: AmuseYou-Apps/BookingCore/src/Booking.Table.al
field(15; "Equipment Type"; Enum "Equipment Type")
{
    Caption = 'Equipment Type';
    // ❌ MISSING: ToolTip = 'Specifies the type of equipment for this booking';
}
```

**Impact**: Users confused by field purpose
**Stage 2 Catch Rate**: 75% (generic AI knows tooltips help)
**Stage 3 Catch Rate**: 100% (Uma enforces ToolTip on all fields)

---

### 23. No Page Customization Support (MEDIUM - 🟡 Medium)
**ExampleISVApp Issue**: Tables missing FieldGroups for Brick/DropDown

**AmuseYou Implementation**:
```al
// File: AmuseYou-Apps/BookingCore/src/Equipment.Table.al
table 50000 Equipment
{
    fields { /* ... */ }

    // ❌ MISSING:
    // fieldgroups
    // {
    //     fieldgroup(DropDown; "No.", Description, "Equipment Type") { }
    //     fieldgroup(Brick; "No.", Description, "Daily Rental Rate", "Equipment Type") { }
    // }
}
```

**Impact**: Tiles and lookups show wrong fields
**Stage 2 Catch Rate**: 20% (generic AI won't know BC FieldGroups)
**Stage 3 Catch Rate**: 95% (Uma explains Brick/DropDown patterns)

---

### 24. Missing Editable Properties (HIGH - 🟡 Medium)
**ExampleISVApp Issue**: Calculated fields not marked non-editable

**AmuseYou Implementation**:
```al
// File: AmuseYou-Apps/BookingCore/src/Booking.Table.al
field(50; "Total Amount"; Decimal)
{
    Caption = 'Total Amount';
    // ❌ MISSING: Editable = false;
    // This is calculated from Daily Rate × Days
    // But users can overwrite it!
}
```

**Impact**: Data corruption, calculation inconsistency
**Stage 2 Catch Rate**: 65% (generic AI knows readonly concepts)
**Stage 3 Catch Rate**: 100% (Uma enforces Editable = false pattern)

---

## Jordan Bridge - Integration Anti-Patterns (6 selected)

### 25. No HttpClient Implementation (CRITICAL - 🔴 Hard)
**ExampleISVApp Issue #1.1**: API Client is complete placeholder

**AmuseYou Implementation**:
```al
// File: AmuseYou-Apps/RentalOperations/src/WeatherApiClient.Codeunit.al
procedure GetWeatherForecast(Location: Text): Text
begin
    // ❌ PLACEHOLDER
    Error('GetWeatherForecast not yet implemented');
end;

// Result: Job queue fails, no integration possible
```

**Impact**: Integration completely non-functional
**Stage 2 Catch Rate**: 30% (generic AI might suggest HttpClient)
**Stage 3 Catch Rate**: 100% (Jordan provides complete HttpClient pattern)

---

### 26. No Retry Logic (CRITICAL - 🔴 Hard)
**ExampleISVApp Issue #1.4**: No resilience patterns for API calls

**AmuseYou Implementation**:
```al
// File: AmuseYou-Apps/RentalOperations/src/WeatherApiClient.Codeunit.al
procedure CallWeatherApi(): Boolean
var
    Client: HttpClient;
    Response: HttpResponseMessage;
begin
    // ❌ No retry on transient failures
    if not Client.Get('https://weather.api/forecast', Response) then
        exit(false);  // Gives up immediately!

    // ✅ Should implement: Exponential backoff, 3 retries, Circuit breaker
end;
```

**Impact**: Transient failures cause permanent errors
**Stage 2 Catch Rate**: 20% (generic AI might mention retry)
**Stage 3 Catch Rate**: 95% (Jordan implements Polly-style resilience)

---

### 27. Limited Integration Events (HIGH - 🟡 Medium)
**ExampleISVApp Issue #2.1**: Only 3 events defined, insufficient extensibility

**AmuseYou Implementation**:
```al
// File: AmuseYou-Apps/BookingCore/src/Booking.Table.al
table 50001 Booking
{
    trigger OnInsert()
    begin
        // ❌ No OnBeforeInsertBooking event
        // ❌ No OnAfterInsertBooking event
        // Extensions can't inject logic!
    end;
}

// ❌ MISSING: BookingEvents.Codeunit.al with proper integration events
```

**Impact**: App not extensible by partners/customers
**Stage 2 Catch Rate**: 25% (generic AI might not know BC event pattern)
**Stage 3 Catch Rate**: 90% (Jordan demonstrates event publisher pattern)

---

### 28. No API Versioning Strategy (HIGH - 🔴 Hard)
**ExampleISVApp Issue #3.1**: No handling for external API version changes

**AmuseYou Implementation**:
```al
// File: AmuseYou-Apps/RentalOperations/src/WeatherApiClient.Codeunit.al
procedure GetWeatherForecast(): Text
var
    Url: Text;
begin
    // ❌ Hardcoded API version
    Url := 'https://weather.api/v1/forecast';

    // ❌ No version negotiation
    // ❌ No fallback to v2 if v1 deprecated
    // ❌ No version header in requests
end;
```

**Impact**: API changes break integration silently
**Stage 2 Catch Rate**: 15% (generic AI won't know API versioning patterns)
**Stage 3 Catch Rate**: 85% (Jordan explains version negotiation)

---

### 29. No Structured Error Handling (HIGH - 🟡 Medium)
**ExampleISVApp Issue #4.1**: Errors not categorized (Transient vs Permanent)

**AmuseYou Implementation**:
```al
// File: AmuseYou-Apps/RentalOperations/src/BookingMgt.Codeunit.al
procedure CreateBooking(): Boolean
begin
    if not ValidateEquipment() then
        exit(false);  // ❌ No error context

    if not CallExternalApi() then
        exit(false);  // ❌ Was this transient? Should retry?

    // ❌ No error categorization
    // ❌ No LastError capture
    // ❌ No telemetry
end;
```

**Impact**: Can't distinguish retryable vs permanent errors
**Stage 2 Catch Rate**: 35% (generic AI knows error categories)
**Stage 3 Catch Rate**: 90% (Jordan demonstrates BC error patterns)

---

### 30. Missing Custom Telemetry Dimensions (MEDIUM - 🟡 Medium)
**ExampleISVApp Issue #5.1**: Telemetry lacks context (Operation, Duration, Entity info)

**AmuseYou Implementation**:
```al
// File: AmuseYou-Apps/RentalOperations/src/BookingMgt.Codeunit.al
procedure ProcessBooking()
begin
    // ❌ No telemetry at all
    CreateBookingRecord();
    NotifyCustomer();
    UpdateInventory();

    // ✅ Should emit:
    // - Operation: ProcessBooking
    // - Duration: 234ms
    // - BookingNo: B0001
    // - EquipmentType: GoKart
    // - Success: true
end;
```

**Impact**: Can't diagnose production issues
**Stage 2 Catch Rate**: 45% (generic AI knows logging)
**Stage 3 Catch Rate**: 95% (Jordan provides Session.LogMessage with CustomDimensions)

---

## Summary: Anti-Pattern Distribution

| Specialist | Selected | 🟢 Easy | 🟡 Medium | 🔴 Hard |
|------------|----------|---------|-----------|---------|
| Dean Debug (Perf) | 8 | 2 | 4 | 2 |
| Roger Reviewer (Quality) | 8 | 3 | 4 | 1 |
| Uma UX (Experience) | 8 | 4 | 3 | 1 |
| Jordan Bridge (Integration) | 6 | 0 | 4 | 2 |
| **TOTAL** | **30** | **9 (30%)** | **15 (50%)** | **6 (20%)** |

### Expected Catch Rates by Stage

| Difficulty | Stage 2 (Generic AI) | Stage 3 (MCP + BC Intel) | Improvement |
|------------|---------------------|--------------------------|-------------|
| 🟢 Easy | 75% avg | 100% | +33% |
| 🟡 Medium | 43% avg | 95% avg | +121% |
| 🔴 Hard | 13% avg | 92% avg | +608% |
| **Overall** | **44% avg** | **95% avg** | **+116%** |

---

## Next Steps

1. **Map to AmuseYou Files**: Assign each anti-pattern to specific files
2. **Create Stage 1 Branches**: Implement anti-patterns in stage1-solution
3. **Document Advanced Exercises**: "Ask Dean/Roger/Uma/Jordan to review your code"
4. **Create Answer Keys**: What each specialist will find and recommend

---

*Ready to inject real BC anti-patterns into workshop baseline! 🎯*
