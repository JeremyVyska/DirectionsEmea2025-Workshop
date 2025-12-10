---
applyTo: "**/*.Page.al"
description: "AL Page object type taxonomy and patterns - identifies page types (Card, List, CardPart, ListPart, API, About) and enforces NemBetaling patterns"
---

# Page Rules — Full Taxonomy (NemBetaling Specific)

## 🎯 Goal
Enable the agent to identify the page type and enforce correct behavior.

---

# ⚠️ CRITICAL REQUIREMENTS FOR ALL PAGES

## Naming Convention
- Pages **MUST** follow clear naming patterns based on their type:
  - Card pages: End with `Card` (e.g., `Payment Request Card`, `Easy Payment Setup`)
  - List pages: Plural form or end with `List` (e.g., `Payment Requests`, `Easy Payment Types`, `Payment Status List`)
  - CardPart pages: End with `Cues` or descriptive name (e.g., `EasyPayment Invoice Cues`, `API Log Json Viewer`)
  - ListPart pages: End with `List Part` (e.g., `Refund Request List Part`, `Payment Status List Part`)
  - API pages: Descriptive name (e.g., `Api Notification`)
  - About pages: End with `About` (e.g., `Easy Payment About`)

## Documentation Requirements
- **MUST** have `AboutText` and `AboutTitle` properties
- **MUST** have `HelpLink` property pointing to documentation
- **MUST** have `Caption` property
- **MUST** have `ApplicationArea = All` (unless specific area required)

## ToolTip Property
- **ToolTips are specified on fields in the table** - the table is the source of truth
- ToolTips defined in the table will automatically appear on pages that display those fields
- **MUST NOT** duplicate ToolTips on page fields if they already exist on the table field
- If a ToolTip is needed and doesn't exist in the table, it **MUST** be added to the table field first, not on the page
- Only add ToolTip to a page field if the field is a local variable or calculated field that doesn't exist in the table

## Page Properties Pattern
- **MUST** have `Extensible = true` (unless there's a specific reason not to)
- **MUST** have `UsageCategory` property (Documents, Lists, Administration, History, etc.)
- DeleteAllowed, InsertAllowed, ModifyAllowed should be set appropriately based on business logic

---

# ⭐ KINDS OF PAGES

## CARD PAGE
### Role
- Displays a single record from a table
- Usually includes actions calling Mgt codeunits
- Used for viewing and managing individual records

### Identification Clues
- `PageType = Card`
- `SourceTable` property pointing to a table
- Has fields grouped under `area(Content)` with `group()` sections
- Has `actions` area with Processing/Navigation actions
- Often has `CardPageId` referenced from List pages
- May have `OnOpenPage`, `OnModifyRecord` triggers

### Critical Requirements
- **MUST** have `SourceTable` property
- **MUST** have layout with `area(Content)` containing fields
- Actions **SHOULD** delegate to Mgt codeunits (not contain business logic)
- **SHOULD** have `CardPageId` referenced from corresponding List page

### Canonical NemBetaling Example
```al
page 50002 "Payment Request Card"
{
    AboutText = 'This page allows you to view and manage payment requests...';
    AboutTitle = 'About Payment Request Card';
    ApplicationArea = All;
    Caption = 'Payment Request';
    DeleteAllowed = false;
    Editable = false;
    Extensible = true;
    HelpLink = 'https://github.com/...';
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = "Payment Request";
    UsageCategory = Documents;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field(Status; Rec."Payment Request Status") { }
                field(State; Rec.State) { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(SendRequest)
            {
                Caption = 'Send Payment Request';
                trigger OnAction()
                var
                    PaymentRequestTask: Codeunit "Payment Request Task";
                begin
                    PaymentRequestTask.Run(Rec);
                end;
            }
        }
    }
}
```

---

## LIST PAGE
### Role
- Displays a list of records from a table
- Provides navigation to Card pages
- Used for browsing and filtering multiple records

### Identification Clues
- `PageType = List`
- `SourceTable` property pointing to a table
- Has `repeater()` control in layout
- Has `CardPageId` property pointing to corresponding Card page
- Often has `SourceTableView` for default sorting
- May have `ShowFilter = true` for filter visibility

### Critical Requirements
- **MUST** have `SourceTable` property
- **MUST** have `repeater()` control in layout
- **SHOULD** have `CardPageId` property
- **SHOULD** have `SourceTableView` for default sorting

### Canonical NemBetaling Example
```al
page 50001 "Payment Requests"
{
    AboutText = 'This page displays a list of payment requests...';
    AboutTitle = 'About Payment Requests';
    ApplicationArea = All;
    Caption = 'Payment Requests';
    CardPageId = "Payment Request Card";
    DeleteAllowed = false;
    Editable = false;
    Extensible = true;
    HelpLink = 'https://github.com/...';
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    RefreshOnActivate = true;
    ShowFilter = true;
    SourceTable = "Payment Request";
    SourceTableView = order(descending);
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.") { }
                field(Status; Rec."Payment Request Status") { }
                field(Amount; Rec.Amount) { }
            }
        }
    }
}
```

---

## CARDPART PAGE
### Role
- Used as parts in Role Centers or embedded in other pages
- Displays Cue tables or FactBoxes
- Provides dashboard-like functionality

### Identification Clues
- `PageType = CardPart`
- `SourceTable` property (often Cue table)
- Has `cuegroup()` controls for Cue tables
- Often has `OnOpenPage` trigger to initialize record and set FlowFields
- Used in Role Center page extensions via `part()` control

### Critical Requirements
- **MUST** have `PageType = CardPart`
- **MUST** have `SourceTable` property
- **SHOULD** have `OnOpenPage` trigger if using Cue table with single record pattern
- For Cue tables: **MUST** call `SetAutoCalcFields()` in `OnOpenPage` to calculate FlowFields

### Canonical NemBetaling Example (Cue Page)
```al
page 50012 "EasyPayment Invoice Cues"
{
    AboutText = 'This page displays EasyPayment Invoices and Payment Requests cues...';
    AboutTitle = 'About EasyPayment Cues';
    ApplicationArea = All;
    Caption = 'EasyPayment Cues';
    Extensible = false;
    HelpLink = 'https://github.com/...';
    PageType = CardPart;
    SourceTable = "EasyPayment Cue";

    layout
    {
        area(Content)
        {
            cuegroup(InvoicesGroup)
            {
                Caption = 'Invoices';
                field(Invoices; Rec.Invoices) { }
                field("Invoices Waiting"; Rec."Invoices Waiting") { }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.Get() then begin
            Clear(Rec);
            Rec.Insert(false);
        end;
        Rec.SetAutoCalcFields(Invoices, "Credit Memos", "Payment Requests Total");
    end;
}
```

---

## LISTPART PAGE
### Role
- Used as subpages/parts within Card pages
- Displays related records filtered by parent record
- Provides drill-down functionality

### Identification Clues
- `PageType = ListPart`
- `SourceTable` property
- Has `repeater()` control in layout
- Used in Card pages via `part()` control with `SubPageLink`
- Often has `DeleteAllowed = true` for cleanup actions

### Critical Requirements
- **MUST** have `PageType = ListPart`
- **MUST** have `SourceTable` property
- **MUST** have `repeater()` control in layout
- **SHOULD** be referenced from Card page with `SubPageLink` property

### Canonical NemBetaling Example
```al
page 50008 "Refund Request List Part"
{
    AboutText = 'This page displays refund requests made by customers.';
    AboutTitle = 'About Refund Requests';
    ApplicationArea = All;
    Caption = 'Refunds';
    CardPageId = "Refund Request Card";
    DeleteAllowed = false;
    Editable = false;
    Extensible = true;
    HelpLink = 'https://github.com/...';
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Refund Request";
    SourceTableView = order(descending);
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.") { }
                field("Refund Amount"; Rec."Refund Amount") { }
                field(State; Rec.State) { }
            }
        }
    }
}
```

**Usage in Card Page:**
```al
part(RefundRequestsListPart; "Refund Request List Part")
{
    SubPageLink = "Payment Request Entry No." = field("Entry No.");
}
```

---

## API PAGE
### Role
- Exposes table data via OData API
- Used for external integrations
- Provides REST API endpoints

### Identification Clues
- `PageType = API`
- Has `EntityName` and `EntitySetName` properties
- Has `APIGroup`, `APIPublisher`, `APIVersion` properties
- Uses `repeater()` control (similar to List page)
- Fields use lowercase names for API compatibility

### Critical Requirements
- **MUST** have `PageType = API`
- **MUST** have `EntityName` and `EntitySetName` properties
- **MUST** have `APIGroup`, `APIPublisher`, `APIVersion` properties
- **MUST** have `SourceTable` property
- Field captions **SHOULD** use lowercase for API compatibility
- **SHOULD** include `SystemId` and `SystemModifiedAt` fields for OData compliance

### Canonical NemBetaling Example
```al
page 51003 "Api Notification"
{
    APIGroup = 'datahub';
    APIPublisher = 'finnpedersenfrance';
    APIVersion = 'v1.0';
    Caption = 'apiNotification';
    DelayedInsert = true;
    EntityName = 'apiNotification';
    EntitySetName = 'apiNotifications';
    PageType = API;
    SourceTable = "Api Notification";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(id; Rec.SystemId)
                {
                    Caption = 'id';
                    Editable = false;
                }
                field(entryNo; Rec."Entry No.")
                {
                    Caption = 'Entry No.';
                }
                field("event"; Rec."Event")
                {
                    Caption = 'Event';
                }
            }
        }
    }
}
```

---

## ABOUT PAGE
### Role
- Special variant of Card page
- Displays version, copyright, and license information
- Usually read-only informational page

### Identification Clues
- `PageType = Card`
- Name ends with `About`
- `Editable = false`
- `SourceTable` usually points to Setup table
- Contains version, copyright, license information fields
- Minimal or no actions

### Critical Requirements
- **MUST** have `PageType = Card`
- **MUST** have `Editable = false`
- **SHOULD** have `SourceTable` pointing to Setup table
- **SHOULD** display version and copyright information

### Canonical NemBetaling Example
```al
page 50015 "Easy Payment About"
{
    AboutText = 'This page provides information about the EasyPayment module...';
    AboutTitle = 'About EasyPayment';
    ApplicationArea = All;
    Caption = 'About EasyPayment';
    Editable = false;
    Extensible = true;
    HelpLink = 'https://github.com/...';
    PageType = Card;
    SourceTable = "Easy Payment Setup";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            field(VersionLbl; this.VersionTok)
            {
                Caption = 'Version:';
            }
            field(CopyrightLbl; this.CopyrightLbl)
            {
                Caption = 'Copyright:';
            }
            field(LicenseeLbl; Rec.Licensee) { }
        }
    }

    var
        CopyrightLbl: Label 'Copyright © 2025 FinnPedersenFrance A/S. All rights reserved.';
        VersionTok: Label 'NemBetaling 26.2.0.0', Locked = true;
}
```

---

# 🔍 HOW AN AGENT IDENTIFIES A PAGE TYPE

Agents must use these signals:

- **PageType property**:
  - `Card` = Card page or About page (check name ending)
  - `List` = List page
  - `CardPart` = CardPart page (Cue or FactBox)
  - `ListPart` = ListPart page (subpage)
  - `API` = API page
- **Structure patterns**:
  - Presence of `repeater()` = List page, ListPart page, or API page
  - Presence of `cuegroup()` = CardPart page (Cue)
  - Presence of `part()` controls = Card page with subpages
  - Presence of `EntityName`/`EntitySetName` = API page
- **Naming patterns**:
  - Ends with `Card` = Card page
  - Ends with `List` or plural form = List page
  - Ends with `List Part` = ListPart page
  - Ends with `Cues` = CardPart page (Cue)
  - Ends with `About` = About page
- **Usage**:
  - Referenced via `CardPageId` = Card page
  - Used in Role Center = CardPart page
  - Used via `part()` with `SubPageLink` = ListPart page
  - Exposed via OData = API page

This enables:

**"Analyze this page and classify its type."**  
**"Create a Card page for Payment Request."**  
**"Create a List page for Payment Requests."**  
**"Create a CardPart page for Role Center cues."**  
**"Create a ListPart page for related records."**  
**"Create an API page for external integration."**
