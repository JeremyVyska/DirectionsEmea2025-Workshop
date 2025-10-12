# Missing Files Summary - AmuseYou Anti-Patterns
**Created:** 2025-10-12
**Purpose:** Document critical files that are intentionally missing as anti-patterns

---

## Critical Missing Files (Anti-Patterns)

### 1. Role Center (Anti-Pattern #17 - Uma UX)
**File:** `AmuseYou-Apps/RentalOperations/src/RentalRoleCenter.Page.al`
**Status:** ❌ MISSING
**Severity:** 🔴 CRITICAL - Hard to detect

**Impact:**
- Users have no navigation hub
- Zero discoverability of app features
- No way to organize pages, reports, cues
- Violates BC app structure best practices

**Stage 2 Catch Rate:** 10%
**Stage 3 Catch Rate:** 100% (Uma insists on Role Center)

**Expected Uma Recommendation:**
```al
page 50250 "Rental Role Center"
{
    PageType = RoleCenter;
    Caption = 'Rental Management';

    layout
    {
        area(RoleCenter)
        {
            group(Control1)
            {
                part(Activities; "Rental Activities")
                {
                    ApplicationArea = All;
                }
                part(BookingList; "Booking List")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Sections)
        {
            group(Bookings)
            {
                action(BookingListAction)
                {
                    RunObject = Page "Booking List";
                }
                action(EquipmentListAction)
                {
                    RunObject = Page "Equipment List";
                }
            }
        }
    }
}
```

---

### 2. Integration Events (Anti-Pattern #27 - Jordan Integration)
**File:** `AmuseYou-Apps/BookingCore/src/BookingEvents.Codeunit.al`
**Status:** ❌ MISSING
**Severity:** 🟡 MEDIUM

**Impact:**
- App is not extensible by partners/customers
- No way to inject logic before/after key operations
- Violates BC extensibility patterns
- Cannot build add-ons without modifying base code

**Stage 2 Catch Rate:** 25%
**Stage 3 Catch Rate:** 90% (Jordan demonstrates event publisher pattern)

**Expected Jordan Recommendation:**
```al
codeunit 50050 "Booking Events"
{
    [IntegrationEvent(false, false)]
    procedure OnBeforeInsertBooking(var Booking: Record Booking; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterInsertBooking(var Booking: Record Booking)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnBeforeUpdateBookingStatus(var Booking: Record Booking; NewStatus: Enum BookingStatus; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterUpdateBookingStatus(var Booking: Record Booking; OldStatus: Enum BookingStatus)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnBeforeCalculateBookingAmount(var Booking: Record Booking; var Amount: Decimal; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterCalculateBookingAmount(var Booking: Record Booking; Amount: Decimal)
    begin
    end;
}
```

---

### 3. Permission Sets (Anti-Pattern #9 - Roger Code Quality)
**Folder:** `AmuseYou-Apps/BookingCore/.permissions/`
**Status:** ❌ EMPTY FOLDER
**Severity:** 🔴 CRITICAL - Hard to detect

**Impact:**
- AppSource certification will FAIL immediately
- 96+ compile errors about objects not covered by permission sets
- App is unusable in production without proper security
- All tables, pages, codeunits show "not covered" errors

**Stage 2 Catch Rate:** 5%
**Stage 3 Catch Rate:** 100% (Roger enforces 3-tier permission model)

**Expected Roger Recommendation:**

**File 1:** `BookingCore/.permissions/BookingRead.PermissionSet.al`
```al
permissionset 50000 "Booking READ"
{
    Caption = 'Booking - Read';
    Assignable = true;

    Permissions =
        tabledata Equipment = R,
        tabledata Booking = R,
        table Equipment = X,
        table Booking = X,
        page "Equipment List" = X,
        page "Equipment Card" = X,
        page "Booking List" = X,
        page "Booking Card" = X,
        codeunit AvailabilityMgt = X;
}
```

**File 2:** `BookingCore/.permissions/BookingCreate.PermissionSet.al`
```al
permissionset 50001 "Booking REQUEST"
{
    Caption = 'Booking - Request';
    Assignable = true;

    IncludedPermissionSets = "Booking READ";

    Permissions =
        tabledata Equipment = R,
        tabledata Booking = RIM,
        codeunit BookingMgt = X;
}
```

**File 3:** `BookingCore/.permissions/BookingManage.PermissionSet.al`
```al
permissionset 50002 "Booking MANAGER"
{
    Caption = 'Booking - Manage';
    Assignable = true;

    IncludedPermissionSets = "Booking REQUEST";

    Permissions =
        tabledata Equipment = RIMD,
        tabledata Booking = RIMD,
        codeunit BookingMgt = X,
        codeunit AvailabilityMgt = X;
}
```

---

### 4. FactBox Area (Anti-Pattern #18 - Uma UX)
**Location:** `AmuseYou-Apps/RentalOperations/src/BookingCard.Page.al`
**Status:** ❌ MISSING area(FactBoxes) section
**Severity:** 🟡 MEDIUM

**Impact:**
- Users must navigate away from card for related information
- No quick view of equipment details
- No customer booking history at a glance
- Reduced productivity - extra clicks required

**Stage 2 Catch Rate:** 25%
**Stage 3 Catch Rate:** 95% (Uma demonstrates FactBox value)

**Expected Uma Recommendation:**
Add to BookingCard.Page.al:
```al
layout
{
    area(Content) { /* existing fields */ }

    area(FactBoxes)
    {
        part(EquipmentDetails; "Equipment FactBox")
        {
            ApplicationArea = All;
            SubPageLink = "No." = field("Equipment No.");
        }
        part(CustomerHistory; "Customer Booking History")
        {
            ApplicationArea = All;
            SubPageLink = "Customer Name" = field("Customer Name");
        }
        systempart(Notes; Notes)
        {
            ApplicationArea = All;
        }
        systempart(Links; Links)
        {
            ApplicationArea = All;
        }
    }
}
```

---

## Summary: Missing Anti-Patterns

| Missing Item | Severity | Stage 2 | Stage 3 | Owner |
|-------------|----------|---------|---------|-------|
| Role Center | 🔴 Critical | 10% | 100% | Uma |
| Permission Sets | 🔴 Critical | 5% | 100% | Roger |
| Integration Events | 🟡 Medium | 25% | 90% | Jordan |
| FactBox Area | 🟡 Medium | 25% | 95% | Uma |

**Total Missing Elements:** 4
**Critical Missing:** 2
**Medium Missing:** 2

---

## Advanced Exercise Guidance

When students ask MCP specialists to review the code:

### Roger's Review Will Find:
1. **Permission sets completely missing** - "CRITICAL: No permission sets defined. AppSource certification will fail."
2. **Missing LookupPageId/DrillDownPageId** - "Tables need page properties for proper lookup functionality"
3. Other code quality issues (#10-16)

### Uma's Review Will Find:
1. **No Role Center** - "CRITICAL: App has no navigation hub. Users won't know where to start."
2. **No FactBox integration** - "Add FactBoxes to card pages for better context"
3. **Actions not promoted** - "Important actions hidden in menus"
4. Other UX issues (#17-24)

### Jordan's Review Will Find:
1. **No integration events** - "App not extensible. Add OnBefore/OnAfter events for key operations."
2. **No HttpClient implementation** - "WeatherApiClient is placeholder code"
3. Other integration issues (#25-30)

### Dean's Review Will Find:
1. **Missing SIFT keys** - "Booking table will have full table scans on filtered queries"
2. **Commit anti-pattern** - "UpdateMaintenanceStatus commits after every record - 90% overhead"
3. Other performance issues (#1-8)

---

## Implementation Note

These missing files/sections are **intentionally omitted** to demonstrate:
- How BC-specific patterns are hard for generic AI to detect
- How MCP specialists catch critical architectural issues
- The value of knowledge-enhanced review over basic AI review

Stage 3 students will discover these by asking MCP specialists for comprehensive reviews.

---

*Missing files documented for Stage 3 advanced exercises! 🎯*
