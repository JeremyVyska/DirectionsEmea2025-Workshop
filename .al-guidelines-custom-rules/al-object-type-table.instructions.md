---
applyTo: "**/*.Table.al"
description: "AL Table object type taxonomy and patterns - identifies table types (Setup, Lookup, Cue, Normal) and enforces NemBetaling patterns"
---
# Table Rules — Full Taxonomy

## 🎯 Goal
Enable the agent to detect what kind of table this is and what rules apply.

## 📚 About Examples

The examples in this document are from **NemBetaling**, which serves as the **gold standard** and **role model** for Business Central development. NemBetaling demonstrates best practices and sets the bar for code quality, architecture, and patterns. All examples are real, production code that follows these rules perfectly. Use these examples as your reference when implementing similar patterns in your projects.

---

# ⚠️ CRITICAL REQUIREMENTS FOR ALL TABLES

## ToolTip Property
- **ToolTip is NOT a table property** - it is only a field property
- ToolTip can only be set on individual fields, not on the table object itself
- Do NOT attempt to add `ToolTip` as a property of the table object
- **ToolTips MUST be specified on fields in the table** - this is the source of truth
- ToolTips defined in the table will automatically appear on pages that display those fields
- If a ToolTip exists on a table field, it **MUST NOT** be duplicated on the page field

## Primary Key Pattern
- Tables with auto-incrementing primary key (`"Entry No."` Integer) **MUST** include an `OnInsert` trigger with a corresponding `SetPrimaryKey` local procedure
- The `OnInsert` trigger **MUST** call `SetPrimaryKey(Rec)` before any other logic
- `SetPrimaryKey` uses `FindRecordManagement.GetLastEntryIntFieldValue()` to get the next available entry number
- This pattern ensures consistent, sequential primary key assignment

## Primary Key Field Pattern
```al
field(1; "Entry No."; Integer)
{
    Caption = 'Entry No.';
    Editable = false;
    ToolTip = 'Specifies the primary key.';
}
```

## Required OnInsert Trigger Pattern
```al
trigger OnInsert()
begin
    this.SetPrimaryKey(Rec);
    // Additional initialization logic can go here
    Rec."Requested At" := CurrentDateTime();
end;

local procedure SetPrimaryKey(var <TableName>: Record "<Table Name>")
var
    FindRecordManagement: Codeunit Microsoft.Utilities."Find Record Management";
begin
    <TableName>."Entry No." := FindRecordManagement.GetLastEntryIntFieldValue(<TableName>, <TableName>.FieldNo("Entry No.")) + 1;
end;
```

**Note**: The `OnDelete` trigger (if present) is **not** part of this pattern - it's domain-specific logic.

---

# ⭐ KINDS OF TABLES

## SETUP TABLE
### Role
- Holds setup values for the app or domain
- Has exactly one record per company
- Accessed via `Get()` methods in Mgt codeunits
- **CRITICAL**: Primary Key value is **ALWAYS blank** - cannot have any other values

### Identification Clues
- Has `"Primary Key"` Code[10] as PK (not Entry No. or No.)
- **Primary Key value is always blank** - this is enforced by design
- Exactly one record pattern (single record per company)
- Contains setup/configuration fields for the app or domain
- Accessed via `Get()` methods
- Often has validation triggers calling Mgt codeunits

### Example from NemBetaling (Gold Standard)

**General Rule**: Setup tables hold setup values for the app or domain, have exactly one record per company, and use `"Primary Key"` Code[10] as PK (always blank).

**NemBetaling Implementation**:
```al
table 50000 "Easy Payment Setup"
{
    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            AllowInCustomizations = Never;
            Caption = 'Primary Key';
            DataClassification = SystemMetadata;
            Editable = false;
            NotBlank = false;
            ToolTip = 'Specifies the primary key.';
        }
        field(2; "Application State"; Enum "Application State") {}
        field(3; "API Protocol Version"; Text[10]) {}
        field(4; "Clearing Account No."; Code[20]) {}
        // ... setup fields
    }

    keys
    {
        key(PK; "Primary Key") { Clustered = true; }
    }
}
```

**Note**: Setup tables do NOT use the `SetPrimaryKey` pattern - they use a fixed Code[10] primary key that is always blank.


---

## LOOKUP TABLE
### Role
- Stores lookup values or reference data that can have multiple records
- Used for dropdowns, selections, and reference data that can be configured
- Primary key value **CANNOT be blank** - each record must have a unique code value

### Identification Clues
- Has `Code` Code[20] or similar as PK (not Entry No., not "Primary Key")
- **Primary Key value cannot be blank** (NotBlank = true)
- Multiple records pattern
- Contains lookup/reference data fields
- Often has Description field
- May have validation fields (Is Valid, Blocked, etc.)
- Used in TableRelations
- Often has `OnInsert` and `OnModify` triggers calling Mgt codeunits for validation

### Example from NemBetaling (Gold Standard)

**General Rule**: Lookup tables store lookup values or reference data with multiple records, use Code[20] as PK (cannot be blank), and have validation triggers.

**NemBetaling Implementation**:
```al
table 50002 "Easy Payment Type"
{
    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
            ToolTip = 'Specifies the primary key.';
        }
        field(2; "PaymentType Value"; Text[50]) {}
        field(3; Description; Text[100]) {}
        field(6; Blocked; Boolean) {}
        field(20; "Is Valid"; Boolean)
        {
            Editable = false;
        }
    }

    keys
    {
        key(PK; Code) { Clustered = true; }
    }

    trigger OnInsert()
    var
        EasyPaymentTypeMgt: Codeunit "Easy Payment Type Mgt";
    begin
        EasyPaymentTypeMgt.SetIsValid(Rec);
    end;

    trigger OnModify()
    var
        EasyPaymentTypeMgt: Codeunit "Easy Payment Type Mgt";
    begin
        EasyPaymentTypeMgt.SetIsValid(Rec);
    end;
}
```

**Note**: Lookup tables do NOT use the `SetPrimaryKey` pattern - they use Code-based primary keys that cannot be blank.


---

## CUE TABLE
### Role
- Used for Role Center dashboards
- Contains FlowFields for displaying aggregated data
- Single record pattern

### Identification Clues
- Has `"Primary Key"` Code[10] as PK
- Contains FlowFields (FieldClass = FlowField)
- Used in Role Center pages
- Single record pattern
- No business logic triggers

### Example from NemBetaling (Gold Standard)

**General Rule**: Cue tables are used for Role Center dashboards, contain FlowFields for aggregated data, and use `"Primary Key"` Code[10] as PK.

**NemBetaling Implementation**:
```al
table 50007 "EasyPayment Cue"
{
    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            AllowInCustomizations = Never;
            Caption = 'Primary Key';
            Editable = false;
            NotBlank = false;
            ToolTip = 'Specifies the primary key.';
        }
        field(2; Invoices; Integer)
        {
            CalcFormula = count("Sales Invoice Header" where("Payment Request Entry No." = filter(<> 0)));
            FieldClass = FlowField;
        }
        field(3; "Credit Memos"; Integer)
        {
            CalcFormula = count("Sales Cr.Memo Header" where("Refund Request Entry No." = filter(<> 0)));
            FieldClass = FlowField;
        }
        // ... more FlowFields
    }

    keys
    {
        key(PK; "Primary Key") { Clustered = true; }
    }
}
```

**Note**: Cue tables do NOT use the `SetPrimaryKey` pattern - they use a fixed Code[10] primary key.


---

## NORMAL TABLE
### Role
- Standard business tables that store operational data, documents, tracking information, or other business entities
- Uses `"Entry No."` Integer as primary key (auto-incrementing)
- **MUST** follow the `SetPrimaryKey` pattern in `OnInsert` trigger
- Can represent various business concepts: documents, operations, tracking, status, events, etc.

### Identification Clues
- Has `"Entry No."` Integer as PK (not "Primary Key" Code[10], not Code Code[20])
- **MUST** have `OnInsert` trigger calling `SetPrimaryKey(Rec)`
- Contains business data fields (Amount, Customer, Status, Description, etc.)
- May contain timestamp fields (DateTime)
- May contain status/state enums
- May have `OnDelete` trigger (domain-specific logic)
- Multiple records pattern (not single record like Setup/Cue)

### Critical Requirements
- **MUST** implement the `SetPrimaryKey` pattern in `OnInsert` trigger
- Primary key field **MUST** be `Editable = false`
- Primary key field **MUST** have `ToolTip = 'Specifies the primary key.'`

### Example from NemBetaling (Gold Standard)

**General Rule**: Normal tables store operational data, use `"Entry No."` Integer as primary key (auto-incrementing), and **MUST** follow the `SetPrimaryKey` pattern in `OnInsert` trigger.

**NemBetaling Implementation**:
```al
table 50001 "Payment Request"
{
    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            Editable = false;
            ToolTip = 'Specifies the primary key.';
        }
        field(10; "Order Reference"; Code[20]) {}
        field(11; Name; Text[100]) {}
        field(12; Amount; Decimal) {}
        field(107; "Payment Request Status"; Enum "Payment Request Status") {}
        field(113; State; Enum "Payment Request State") {}
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
        key(OrderReference; "Order Reference") { }
    }

    trigger OnInsert()
    begin
        this.SetPrimaryKey(Rec);
        // Additional initialization logic can go here
    end;

    trigger OnDelete()
    var
        ErrorInformation: ErrorInfo;
        DeleteMessageErr: Label 'You cannot delete a Payment Request.';
    begin
        ErrorInformation := ErrorInfo.Create(DeleteMessageErr);
        Error(ErrorInformation);
    end;

    local procedure SetPrimaryKey(var PaymentRequest: Record "Payment Request")
    var
        FindRecordManagement: Codeunit Microsoft.Utilities."Find Record Management";
    begin
        PaymentRequest."Entry No." := FindRecordManagement.GetLastEntryIntFieldValue(PaymentRequest, PaymentRequest.FieldNo("Entry No.")) + 1;
    end;
}
```

**Note**: All normal tables follow the same primary key pattern regardless of their specific business purpose.

**Examples of Normal Tables in NemBetaling** (for reference):
- **Document Tables**: `Payment Request`, `Refund Request`, `Data Request`
- **Operation Tables**: `Api Operation`
- **Tracking Tables**: `Payment Status`, `Order Status`, `Easy Payment Event`, `Api Notification`, `Payload`


---

# 🔍 HOW AN AGENT IDENTIFIES A TABLE TYPE

Agents must use these signals:

- **Primary Key field name**:
  - `"Entry No."` Integer = Normal table
  - `"Primary Key"` Code[10] = Setup or Cue table
  - `Code` Code[20] = Lookup table
- **Field patterns**:
  - Presence of FlowFields = Cue table
  - Presence of setup fields (single record) = Setup table
  - Presence of lookup/reference data fields (multiple records) = Lookup table
  - Has `"Entry No."` Integer PK with `SetPrimaryKey` pattern = Normal table
- **Structure**:
  - Single record pattern with `"Primary Key"` Code[10] = Setup or Cue table
  - Multiple records with `"Entry No."` Integer PK = Normal table
  - Multiple records with Code[20] PK = Lookup table
- **Usage**:
  - Referenced in Mgt codeunits via `Get()` = Setup table
  - Used in TableRelations = Lookup table
  - Used in Role Center = Cue table
  - Has `"Entry No."` Integer PK = Normal table

This enables:

**"Analyze this table and classify its type."**  
**"Create a Normal table following NemBetaling patterns."**  
**"Create a Setup table following NemBetaling patterns."**  
**"Create a Lookup table following NemBetaling patterns."**  
**"Create a Cue table for Role Center dashboard following NemBetaling patterns."**

