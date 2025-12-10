---
applyTo: "**/*.PageExt.al"
description: "AL PageExtension patterns and best practices"
---

# Page Extension Rules — Full Taxonomy

## 🎯 Goal
Enable the agent to identify what kind of page extension this is and what rules apply.

## 📚 About Examples

The examples in this document are from **NemBetaling**, which serves as the **gold standard** and **role model** for Business Central development. NemBetaling demonstrates best practices and sets the bar for code quality, architecture, and patterns. All examples are real, production code that follows these rules perfectly. Use these examples as your reference when implementing similar patterns in your projects.

---

# ⚠️ CRITICAL REQUIREMENTS FOR ALL PAGE EXTENSIONS

## Naming Convention
- Page extensions **MUST** follow the pattern: `"<Page Name> Ext"` (e.g., `"Sales Invoice Ext"`, `"Api Operation Card Ext"`)
- The name should clearly indicate which page is being extended
- Use descriptive names that match the base page name
- Abbreviations in base page names should be preserved (e.g., `"Sales Cr.Memo Ext"`)

## Namespace Organization
- Page extensions **MUST** be placed in the appropriate namespace matching their domain/app
- Use `using` statement to reference the base page namespace when extending custom pages
- Pattern: `using <Company>.<BasePageNamespace>;`
- For standard BC pages, use `using Microsoft.<Domain>.<SubDomain>;` (e.g., `using Microsoft.Sales.Document;`)
- **Example from NemBetaling**: `using FinnPedersenFrance.ApiCore.ApiOperation;` follows this pattern

## Base Page Pattern Compliance
- Page extensions **MUST** follow the patterns established by the base page they extend
- **Layout patterns**: Follow the same layout structure and grouping as base page
- **Action patterns**: Follow the same action organization as base page
- **Field properties**: Follow the same property patterns as base page fields (e.g., `ApplicationArea`, `Editable`, `ToolTip`)
- **ToolTip consistency**: Follow the same ToolTip style and format as base page fields
- **Caption consistency**: Follow the same naming conventions for captions
- **Extensible property**: Only extend pages that are extensible (standard BC pages are always extensible, custom pages must have `Extensible = true`)

## ToolTip Property
- **ToolTips are specified on fields in the table or table extension** - the table is the source of truth
- ToolTips defined in the table/table extension will automatically appear on pages that display those fields
- **MUST NOT** duplicate ToolTips on page extension fields if they already exist on the table field
- If a ToolTip is needed for a table field and doesn't exist, it **MUST** be added to the table/table extension field first, not on the page extension
- Only add ToolTip to a page extension field if the field is a local variable or calculated field that doesn't exist in the table

## Pragma Warnings
- **MAY** use `#pragma warning disable AA0248` and `#pragma warning restore AA0248` for standard BC page extensions
- This suppresses warnings about accessing base page fields that may not exist in all BC versions
- Pattern: Wrap entire page extension in pragma warnings
- Example:
```al
#pragma warning disable AA0248
pageextension 50006 "Sales Invoice Ext" extends "Sales Invoice"
{
    // ... extension content ...
}
#pragma warning restore AA0248
```

---

# ⭐ KINDS OF PAGE EXTENSIONS

## STANDARD BC PAGE EXTENSION
### Role
- Extends standard Business Central pages (Microsoft pages)
- Adds app-specific fields, groups, or actions to standard BC functionality
- Enables integration with standard BC user interface
- Common pattern for extending standard BC pages

### Identification Clues
- Extends pages from `Microsoft.*` namespace
- Adds fields, groups, or actions for app-specific functionality
- Uses `using Microsoft.<Domain>.<SubDomain>;` statements
- Often extends Sales, Purchase, or other standard BC pages
- May use `#pragma warning disable AA0248` for version compatibility

### Critical Requirements
- **MUST** use `using` statement for Microsoft namespace (e.g., `using Microsoft.Sales.Document;`)
- **SHOULD** use `#pragma warning disable AA0248` when accessing base page fields
- **SHOULD** follow standard BC field property patterns
- **SHOULD** include `ApplicationArea` for all fields
- **SHOULD** include `ToolTip` for all fields

### Example from NemBetaling (Gold Standard) - Layout Extension

**General Rule**: Standard BC page extensions add app-specific fields, groups, or actions to standard BC functionality, using `using Microsoft.*` statements and `#pragma warning disable AA0248` for version compatibility.

**NemBetaling Implementation**:
```al
#pragma warning disable AA0248
namespace FinnPedersenFrance.NemBetaling.StandardExtensions;

using FinnPedersenFrance.NemBetaling.EasyPaymentType;
using Microsoft.Sales.Document;

pageextension 50006 "Sales Invoice Ext" extends "Sales Invoice"
{
    layout
    {
        addafter("Payment Method Code")
        {
            group(EasyPayment)
            {
                Caption = 'EasyPayment';
                Visible = EasyPaymentVisible;

                field(IsSetupForEasyPayment; CustomerEasyPaymentErrorMsg)
                {
                    ApplicationArea = All;
                    Caption = 'Is ready for EasyPayment';
                    Editable = false;
                    ToolTip = 'Specifies whether the Payment Method is setup to enable an EasyPayment request. Look at the documentation for more information.';
                }
                field(CustomerEasyPaymentTypeEasyPaymentType; CustomerEasyPaymentType.Code)
                {
                    ApplicationArea = All;
                    Caption = 'EasyPayment Type';
                    Editable = false;
                    TableRelation = "Easy Payment Type".Code;
                    ToolTip = 'Specifies the EasyPayment Type code that is used for this customer.';
                }
            }
        }
    }

    var
        CustomerEasyPaymentType: Record "Easy Payment Type";
        EasyPaymentVisible: Boolean;
        CustomerEasyPaymentErrorMsg: Text;

    trigger OnAfterGetCurrRecord()
    var
        SalesExtensionMgt: Codeunit "Sales Extension Mgt";
    begin
        SalesExtensionMgt.CheckEasyPaymentSetup(Rec, CustomerEasyPaymentType, CustomerEasyPaymentErrorMsg, EasyPaymentVisible);
    end;
}
#pragma warning restore AA0248
```

### Variant: Actions Extension
- Extends standard BC page with app-specific actions
- Adds actions to existing action areas
- Example: Adding setup actions to Role Center pages

### Example from NemBetaling (Gold Standard) - Actions Extension

**General Rule**: Actions extensions add app-specific actions to existing action areas on standard BC pages.

**NemBetaling Implementation**:
```al
namespace FinnPedersenFrance.NemBetaling.StandardExtensions;

using Microsoft.Sales.Document;

pageextension 50005 "Sales Credit Memo Ext" extends "Sales Credit Memo"
{
    actions
    {
        addfirst(Processing)
        {
            action("EasyPayment Setup")
            {
                ApplicationArea = All;
                Caption = 'EasyPayment Setup';
                Image = Setup;
                RunObject = page "Easy Payment Setup";
                ToolTip = 'Setup the EasyPayment solution to start using it.';
            }
        }
    }
}
```

### Variant: Role Center Extension
- Extends Role Center pages with app-specific parts and actions
- Adds Cue parts, FactBoxes, or actions to Role Centers
- Example: Adding EasyPayment Cues to Account Receivables Role Center

### Example from NemBetaling (Gold Standard) - Role Center Extension

**General Rule**: Role Center extensions add Cue parts, FactBoxes, or actions to Role Centers, extending standard BC Role Center pages.

**NemBetaling Implementation**:
```al
namespace FinnPedersenFrance.NemBetaling.RoleCenter;

using FinnPedersenFrance.NemBetaling.EasyPaymentSetup;
using Microsoft.Finance.RoleCenters;

pageextension 50004 "Account Receivables Ext" extends "Account Receivables"
{
    layout
    {
        addfirst(RoleCenter)
        {
            part(EasyPaymentCues; "EasyPayment Invoice Cues")
            {
                ApplicationArea = All;
                Caption = 'EasyPayment Payment Requests';
            }
        }
    }

    actions
    {
        addfirst(Processing)
        {
            action("EasyPayment Setup")
            {
                ApplicationArea = All;
                Caption = 'EasyPayment Setup';
                Image = Setup;
                RunObject = page "Easy Payment Setup";
                ToolTip = 'Setup the EasyPayment solution to start using it.';
            }
        }
    }
}
```

---

## CUSTOM PAGE EXTENSION
### Role
- Extends custom pages from other apps or the same app
- Adds app-specific fields or actions to custom functionality
- Enables cross-app integration
- Less common pattern for extending custom pages

### Identification Clues
- Extends pages from `FinnPedersenFrance.*` namespace
- Adds fields or actions to custom app pages
- Uses `using` statement to reference base page namespace
- Example: Extending `ApiOperationCard` page from ApiCore app

### Critical Requirements
- **MUST** use `using` statement for base page namespace (e.g., `using FinnPedersenFrance.ApiCore.ApiOperation;`)
- **SHOULD** follow base page field property patterns
- **SHOULD** include `ApplicationArea` for all fields
- **SHOULD** include `ToolTip` for all fields

### Example from NemBetaling (Gold Standard)

**General Rule**: Custom page extensions extend pages from other apps or the same app, using `using` statements to reference the base page namespace.

**NemBetaling Implementation**:
```al
namespace FinnPedersenFrance.NemBetaling.ApiOperation;

using FinnPedersenFrance.ApiCore.ApiOperation;

pageextension 50016 "Api Operation Card Ext" extends "Api Operation Card"
{
    layout
    {
        addafter(Description)
        {
            field("Application State"; Rec."Application State")
            {
                ApplicationArea = All;
                Importance = Additional;
            }
        }
    }
}
```

---

## TEST TOOL EXTENSION
### Role
- Extends test tool pages for development/testing purposes
- Adds app-specific filters or functionality to test tools
- Used in test apps for filtering test results
- Example: Extending AL Code Coverage page

### Identification Clues
- Extends pages from `System.*` namespace (test tools)
- Adds filters or simple functionality
- Located in test apps
- Uses `using System.*` statements

### Critical Requirements
- **MUST** use `using` statement for System namespace (e.g., `using System.TestTools.CodeCoverage;`)
- **SHOULD** be simple and focused on filtering or test-specific functionality
- **SHOULD** be in test app namespace

### Example from NemBetaling (Gold Standard)

**General Rule**: Test tool extensions extend test tool pages for development/testing purposes, using `using System.*` statements.

**NemBetaling Implementation**:
```al
namespace FinnPedersenFrance.NemBetaling.Test.TestToolExtension;

using System.TestTools.CodeCoverage;

pageextension 50100 "AL Code Coverage Ext" extends "AL Code Coverage"
{
    trigger OnOpenPage()
    begin
        Rec.SetFilter("Object ID", '50000..50299');
    end;
}
```

---

# 🔍 HOW AN AGENT IDENTIFIES A PAGE EXTENSION TYPE

- **Base page source**: Standard BC (`Microsoft.*`) vs Custom (`<Company>.*`) vs Test Tools (`System.*`)
- **Using statements**: `using Microsoft.*` for standard BC, `using <Company>.*` for custom (e.g., `FinnPedersenFrance.*` in NemBetaling), `using System.*` for test tools
- **Extension content**: Layout (fields/groups), Actions, Parts (Cues/FactBoxes), Triggers
- **Namespace pattern**: Uses `using` to reference base page namespace
- **Naming pattern**: `"<Page Name> Ext"` format
- **Pragma warnings**: Presence of `#pragma warning disable AA0248` indicates standard BC page extension

---

# ⭐ LAYOUT EXTENSION PATTERNS

## Layout Modification Methods
- **addafter**: Add fields/groups after a specific control
- **addbefore**: Add fields/groups before a specific control
- **addfirst**: Add fields/groups at the beginning of a container
- **addlast**: Add fields/groups at the end of a container
- **modify**: Modify existing controls (less common, use with caution)

## Group Patterns
- Create groups with `Caption` to organize related fields
- Use `Visible` property to show/hide groups conditionally
- Group names should be descriptive (e.g., `EasyPayment`, `EasyPaymentTerms`)

## Field Patterns
- Reference base table fields: `Rec."Field Name"`
- Reference local variables: `VariableName`
- Use `ApplicationArea = All` for all fields
- Use `Editable = false` for calculated or system-maintained fields
- Use `ToolTip` for all fields (starts with "Specifies", ends with ".")
- Use `Importance = Additional` for less important fields

---

# ⭐ ACTION EXTENSION PATTERNS

## Action Modification Methods
- **addfirst**: Add actions at the beginning of an action area
- **addlast**: Add actions at the end of an action area
- **addafter**: Add actions after a specific action
- **addbefore**: Add actions before a specific action
- **modify**: Modify existing actions (less common, use with caution)

## Action Properties
- **ApplicationArea**: **MUST** be set (typically `All`)
- **Caption**: **MUST** be provided
- **Image**: **SHOULD** be provided for visual consistency
- **RunObject**: Use for actions that open pages or run reports
- **ToolTip**: **SHOULD** be provided for user guidance

## Common Action Patterns
- Setup actions: `RunObject = page "Setup Page";`
- List actions: `RunObject = page "List Page";`
- Card actions: `RunObject = page "Card Page";`

---

# ⭐ TRIGGER PATTERNS

## Common Triggers
- **OnOpenPage()**: Initialize filters or set default values
- **OnAfterGetCurrRecord()**: Update variables or perform calculations when record changes
- **OnModifyRecord()**: Validate or process data when record is modified
- **OnNewRecord()**: Initialize fields when creating new record

## Trigger Best Practices
- Keep triggers simple and delegate to Mgt codeunits when possible
- Use triggers for UI-specific logic (visibility, calculations)
- Avoid business logic in triggers (delegate to Mgt codeunits)

---

# ⭐ VARIABLE PATTERNS

## Variable Types
- **Record variables**: For table lookups and relations (e.g., `CustomerEasyPaymentType: Record "Easy Payment Type";`)
- **Boolean variables**: For visibility and state (e.g., `EasyPaymentVisible: Boolean;`)
- **Text variables**: For messages and calculations (e.g., `CustomerEasyPaymentErrorMsg: Text;`)

## Variable Naming
- Use descriptive names that indicate purpose
- Follow BC naming conventions (PascalCase)
- Use consistent naming patterns across related variables

---

# ⭐ BEST PRACTICES

## When to Extend Standard BC Pages
- When adding app-specific fields to standard documents
- When adding app-specific actions to standard pages
- When adding app-specific parts to Role Centers
- When integrating app functionality with standard BC processes

## When to Extend Custom Pages
- When adding app-specific fields to shared custom pages
- When extending pages from other apps in the solution
- When adding fields that are specific to one app but reference shared pages

## Field Naming Guidelines
- Use descriptive names that clearly indicate purpose
- Follow BC naming conventions (PascalCase for field names)
- Use consistent naming patterns across related fields
- Reference base table fields using `Rec."Field Name"`

## ToolTip Guidelines
- Always start with "Specifies" (CodeCop rule AA0219, LC0036)
- Always end with a period "." (CodeCop rule LC0026)
- Be descriptive and helpful to users
- Explain the purpose and usage of the field

## ApplicationArea Guidelines
- Use `ApplicationArea = All` for most fields
- Use specific application areas only when field is truly specific to that area
- Ensure consistency with base page application areas

## Visibility Patterns
- Use `Visible` property to show/hide groups conditionally
- Base visibility on record state or setup configuration
- Update visibility in triggers like `OnAfterGetCurrRecord()`

---

This enables:

**"Create a page extension for Sales Invoice following NemBetaling patterns."**  
**"Fix the page extension to comply with rules."**  
**"Add an action to the Role Center page extension following NemBetaling patterns."**  
**"Extend a custom page following NemBetaling patterns."**
