---
applyTo: "**/*.TableExt.al"
description: "AL TableExtension patterns and best practices"
---

# Table Extension Rules — Full Taxonomy (NemBetaling Specific)

## 🎯 Goal
Enable the agent to identify what kind of table extension this is and what rules apply.

---

# ⚠️ CRITICAL REQUIREMENTS FOR ALL TABLE EXTENSIONS

## Naming Convention
- Table extensions **MUST** follow the pattern: `"<Table Name> Ext"` (e.g., `"Sales Header Ext"`, `"Api Operation Ext"`)
- The name should clearly indicate which table is being extended
- Use descriptive names that match the base table name
- Abbreviations in base table names should be preserved (e.g., `"Sales Cr.Memo Header Ext"`)

## Namespace Organization
- Table extensions **MUST** be placed in the appropriate namespace matching their domain/app
- Use `using` statement to reference the base table namespace when extending custom tables
- Pattern: `using FinnPedersenFrance.<BaseTableNamespace>;`
- Example: `using FinnPedersenFrance.ApiCore.ApiOperation;`
- For standard BC tables, use `using Microsoft.<Domain>.<SubDomain>;` (e.g., `using Microsoft.Sales.Document;`)

## Field Numbering Pattern
- Table extension fields **MUST** use field numbers within the app's object range
- Fields should start from the app's object range (e.g., 50000 for NemBetaling, 51000 for DataHubConnector)
- Each app extends the same table with fields in its own range to avoid conflicts
- Pattern: `field(<AppRangeStart>; <FieldName>)` (e.g., `field(50000; "Payment Request Entry No.")`)
- Sequential numbering within app's range (e.g., 50000, 50001, 50002, etc.)

## Base Table Pattern Compliance
- Table extensions **MUST** follow the patterns established by the base table they extend
- **Field properties**: Follow the same property patterns as base table fields (e.g., `Editable`, `TableRelation`, `ExtendedDatatype`)
- **Data Classification**: Use appropriate `DataClassification` values consistent with base table
- **ToolTip consistency**: Follow the same ToolTip style and format as base table fields
- **Caption consistency**: Follow the same naming conventions for captions
- **TableRelation patterns**: Use appropriate `TableRelation` when referencing other tables
- **Extensible property**: Only extend tables that are extensible (standard BC tables are always extensible, custom tables must have `Extensible = true`)

## ToolTip Property
- **ToolTip is NOT a table extension property** - it is only a field property
- ToolTip can only be set on individual fields in the table extension, not on the table extension object itself
- **ToolTips MUST be specified on fields in the table extension** - this is the source of truth
- ToolTips defined in the table extension will automatically appear on pages that display those fields
- If a ToolTip exists on a table extension field, it **MUST NOT** be duplicated on the page field

---

# ⭐ KINDS OF TABLE EXTENSIONS

## STANDARD BC TABLE EXTENSION
### Role
- Extends standard Business Central tables (Microsoft tables)
- Adds app-specific fields to standard BC functionality
- Enables integration with standard BC processes
- Most common pattern in NemBetaling project

### Identification Clues
- Extends tables from `Microsoft.*` namespace
- Adds fields for app-specific functionality
- Fields typically start from app's object range (50000+)
- Often extends Sales, Purchase, or other standard BC tables
- Uses `using Microsoft.<Domain>.<SubDomain>;` statements

### Critical Requirements
- **MUST** use `using` statement for Microsoft namespace (e.g., `using Microsoft.Sales.Document;`)
- **MUST** use field numbers starting from app's object range
- **SHOULD** follow standard BC field property patterns
- **SHOULD** use appropriate `DataClassification` values
- **SHOULD** include `ToolTip` for all fields

### Canonical NemBetaling Example
```al
namespace FinnPedersenFrance.NemBetaling.StandardExtensions;

using FinnPedersenFrance.NemBetaling.PaymentStatus;
using FinnPedersenFrance.NemBetaling.RequestPayment;
using Microsoft.Sales.Document;

tableextension 50003 "Sales Header Ext" extends "Sales Header"
{
    fields
    {
        field(50000; "Payment Request Entry No."; Integer)
        {
            Caption = 'Payment Request Entry No.';
            TableRelation = "Payment Request"."Entry No." where("Customer No." = field("Sell-to Customer No."));
            ToolTip = 'Specifies the payment reference for the corresponding posted sales invoice paid by EasyPayment.';
        }
        field(50001; "Payment Request Reference"; Code[50])
        {
            Caption = 'Payment Request Reference';
            Editable = false;
            ToolTip = 'Specifies the reference of the payment request associated with the sales header.';
        }
        field(50003; "Payment Request Status"; Enum "Payment Request Status")
        {
            Caption = 'Payment Request Status';
            Editable = false;
            ToolTip = 'Specifies the status of the payment request.';
        }
    }
}
```

### Variant: Multiple Related Fields
- Extends standard BC table with multiple related fields
- Fields work together to provide complete functionality
- Example: Payment request fields + refund request fields

### Canonical NemBetaling Example (Multiple Related Fields)
```al
namespace FinnPedersenFrance.NemBetaling.StandardExtensions;

using FinnPedersenFrance.NemBetaling.RequestPayment;
using FinnPedersenFrance.NemBetaling.RequestRefund;
using Microsoft.Sales.History;

tableextension 50002 "Sales Cr.Memo Header Ext" extends "Sales Cr.Memo Header"
{
    fields
    {
        field(50000; "Payment Request Entry No."; Integer)
        {
            Caption = 'Payment Request Entry No.';
            Editable = false;
            TableRelation = "Payment Request"."Entry No." where("Customer No." = field("Sell-to Customer No."));
            ToolTip = 'Specifies the payment reference for the corresponding posted sales invoice paid by EasyPayment.';
        }
        field(50010; "Refund Request Entry No."; Integer)
        {
            Caption = 'Refund Request Entry No.';
            Editable = false;
            TableRelation = "Refund Request"."Entry No.";
            ToolTip = 'Specifies the entry number of the refund request.';
        }
    }
}
```

### Variant: Configuration Field Extension
- Extends standard BC table with configuration/lookup fields
- Links standard BC functionality to app-specific configuration
- Example: Payment Method extension with EasyPayment Type Code

### Canonical NemBetaling Example (Configuration Field)
```al
namespace FinnPedersenFrance.NemBetaling.EasyPaymentType;

using Microsoft.Bank.BankAccount;

tableextension 50000 "Payment Method Ext" extends "Payment Method"
{
    fields
    {
        field(50000; "Easy Payment Type Code"; Code[20])
        {
            Caption = 'EasyPayment Type';
            DataClassification = ToBeClassified;
            TableRelation = "Easy Payment Type".Code;
            ToolTip = 'Specifies the EasyPayment Type Code. This is what makes the payment method an EasyPayment method. If specified, a payment request will be sent to the EasyPayment provider.';
        }
    }
}
```

---

## CUSTOM TABLE EXTENSION
### Role
- Extends custom tables from other apps or the same app
- Adds app-specific fields to custom functionality
- Enables cross-app integration
- Less common pattern in NemBetaling project

### Identification Clues
- Extends tables from `FinnPedersenFrance.*` namespace
- Adds fields to custom app tables
- Fields typically start from app's object range (50000+)
- Uses `using` statement to reference base table namespace
- Example: Extending `ApiOperation` table from ApiCore app

### Critical Requirements
- **MUST** use `using` statement for base table namespace (e.g., `using FinnPedersenFrance.ApiCore.ApiOperation;`)
- **MUST** use field numbers starting from app's object range
- **SHOULD** follow base table field property patterns
- **SHOULD** use appropriate `DataClassification` values
- **SHOULD** include `ToolTip` for all fields

### Canonical NemBetaling Example
```al
namespace FinnPedersenFrance.NemBetaling.ApiOperation;

using FinnPedersenFrance.ApiCore.ApiOperation;
using FinnPedersenFrance.NemBetaling.EasyPaymentSetup;

tableextension 50006 "Api Operation Ext" extends "Api Operation"
{
    fields
    {
        field(50000; "Application State"; Enum "Application State")
        {
            Caption = 'Application State';
            ToolTip = 'Specifies the state of the Application when the Payment Request was made.', Comment = '%';
        }
    }
}
```

---

# 🔍 HOW AN AGENT IDENTIFIES A TABLE EXTENSION TYPE

- **Base table source**: Standard BC (`Microsoft.*`) vs Custom (`FinnPedersenFrance.*`)
- **Using statements**: `using Microsoft.*` for standard BC, `using FinnPedersenFrance.*` for custom
- **Field numbering**: Uses app's object range (50000+, 51000+, etc.)
- **Field purpose**: Configuration fields, tracking fields, reference fields
- **Namespace pattern**: Uses `using` to reference base table namespace
- **Naming pattern**: `"<Table Name> Ext"` format

---

# ⭐ FIELD NUMBERING GUIDELINES

## Object Range Allocation
- **NemBetaling**: 50000-50099 (extensions use 50000+)
- **NemBetalingData**: 50200-50209 (extensions use 50200+)
- **DataHubConnector**: 51000-51099 (extensions use 51000+)
- **Test Apps**: Test range + 100

## Field Number Selection
- Start from app's object range start (e.g., 50000 for NemBetaling)
- Use sequential numbering within app's range (50000, 50001, 50002, etc.)
- Avoid gaps unless intentional (e.g., 50003 skips 50002 if 50002 was removed)
- Each app's fields are independent and don't conflict
- Multiple apps can extend the same table with different field numbers

## Multi-App Extension Pattern
- Multiple apps can extend the same table
- Each app uses its own field number range
- No conflicts because ranges don't overlap
- Example: `ApiOperation` extended by NemBetaling (50000+), DataHubConnector (51000+)

---

# ⭐ FIELD PROPERTY PATTERNS

## Common Field Properties
- **Caption**: **MUST** be provided for all fields
- **ToolTip**: **SHOULD** be provided for all fields (starts with "Specifies", ends with ".")
- **Editable**: Set to `false` for calculated or system-maintained fields
- **TableRelation**: Use when field references another table
- **DataClassification**: Use appropriate classification (e.g., `ToBeClassified`, `CustomerContent`)
- **ExtendedDatatype**: Use for special field types (e.g., `URL`, `Email`)

## Field Type Patterns
- **Integer**: For entry numbers and references (e.g., `"Payment Request Entry No."`)
- **Code[20]**: For codes and references (e.g., `"Easy Payment Type Code"`)
- **Code[50]**: For longer codes and references (e.g., `"Payment Request Reference"`)
- **Text[2048]**: For URLs and long text (e.g., `"Payment Request Link"`)
- **Enum**: For status fields and selections (e.g., `"Payment Request Status"`)

## TableRelation Patterns
- Simple relation: `TableRelation = "Table Name"."Field Name";`
- Filtered relation: `TableRelation = "Table Name"."Field Name" where("Filter Field" = field("Source Field"));`
- Use filtered relations when field should only show related records

---

# ⭐ BEST PRACTICES

## When to Extend Standard BC Tables
- When adding app-specific tracking fields to standard documents
- When linking app functionality to standard BC processes
- When adding configuration fields to standard setup tables
- When adding reference fields to standard master data

## When to Extend Custom Tables
- When adding app-specific fields to shared custom tables
- When extending tables from other apps in the solution
- When adding fields that are specific to one app but reference shared tables

## Field Naming Guidelines
- Use descriptive names that clearly indicate purpose
- Follow BC naming conventions (PascalCase for field names)
- Use consistent naming patterns across related fields
- Example: `"Payment Request Entry No."`, `"Payment Request Reference"`, `"Payment Request Status"`

## ToolTip Guidelines
- Always start with "Specifies" (CodeCop rule AA0219, LC0036)
- Always end with a period "." (CodeCop rule LC0026)
- Be descriptive and helpful to users
- Explain the purpose and usage of the field

## Data Classification
- Use `ToBeClassified` for new fields that need classification
- Use `CustomerContent` for customer-specific data
- Use `SystemMetadata` for system-maintained fields
- Use `EndUserIdentifiableInformation` for personal data

---

This enables:

**"Create a table extension for Sales Header adding payment request fields."**  
**"Fix the table extension to comply with rules."**  
**"Add a field to the Payment Method table extension."**  
**"Extend ApiOperation table with application state field."**
