---
applyTo: "**/*.EnumExt.al"
description: "AL EnumExtension patterns and best practices"
---
# Enum Extension Rules — Full Taxonomy (NemBetaling Specific)

## 🎯 Goal
Enable the agent to identify what kind of enum extension this is and what rules apply.

---

# ⚠️ CRITICAL REQUIREMENTS FOR ALL ENUM EXTENSIONS

## Naming Convention
- Enum extensions **MUST** follow the pattern: `"<Enum Name> Ext"` (e.g., `"Api Operation Type Ext"`)
- The name should clearly indicate which enum is being extended
- Use descriptive names that match the base enum name

## Namespace Organization
- Enum extensions **MUST** be placed in the appropriate namespace matching their domain/app
- Use `using` statement to reference the base enum namespace
- Pattern: `using FinnPedersenFrance.<BaseEnumNamespace>;`
- Example: `using FinnPedersenFrance.ApiCore.ApiOperation;`

## Value Numbering Pattern
- Enum extension values **MUST** use value numbers within the app's object range
- Values should start from the app's object range (e.g., 50001 for NemBetaling, 51001 for DataHubConnector)
- Each app extends the same enum with values in its own range to avoid conflicts
- Pattern: `value(<AppRangeStart>; <ValueName>)` (e.g., `value(50001; VerifySetup)`)

## Locked Property Pattern
- Values **MAY** have `Locked = true` when they represent external API values or fixed standards
- Values **MAY** omit `Locked` when they are app-specific and can be modified
- Pattern for locked values: `Caption = '<Value>', Locked = true;`
- Pattern for unlocked values: `Caption = '<Value>';`

## Caption Property
- **ALL** enum extension values **MUST** have a `Caption` property
- Caption should match the value name (PascalCase) unless representing external API values
- External API values may use lowercase or exact API naming (e.g., `Caption = 'up'`)

## Base Enum Pattern Compliance
- Enum extensions **MUST** follow the patterns established by the base enum they extend
- **Locked property consistency**: If the base enum has locked values, extensions should typically follow the same pattern (locked for external API values, unlocked for app-specific)
- **Caption consistency**: Follow the caption naming convention of the base enum (PascalCase vs lowercase/exact API naming)
- **Value structure**: Do not duplicate patterns that exist in the base enum (e.g., don't add another blank value if base enum already has one)
- **Extensible property**: Only extend enums that have `Extensible = true` in the base enum
- **Naming conventions**: Follow the same naming style as the base enum values
- **Example**: If base enum `"Api Operation Type"` has only a blank value with `Locked = true`, extensions should add values that match the intended pattern (locked for external API, unlocked for app-specific)

---

# ⭐ KINDS OF ENUM EXTENSIONS

## EXTENSION-ONLY ENUM EXTENSION
### Role
- Extends an enum that has no core values (only blank value in base enum)
- Provides the actual values for an extension-only enum pattern
- Each app adds its own values to the shared base enum
- Enables multiple apps to extend the same enum without conflicts

### Identification Clues
- Base enum is extensible but contains only blank value
- Extension adds real values starting from app's object range
- Values represent app-specific operations or types
- Example: `ApiOperationType` enum extensions

### Implementation Pattern
- Base enum: `enum "Api Operation Type"` with only blank value
- Each app extends with values in its own range:
  - NemBetaling: values 50001-50099
  - DataHubConnector: values 51001-51099
  - NemBetalingData: values 50200-50209
  - Test apps: values in test range

### Canonical NemBetaling Example
```al
namespace FinnPedersenFrance.NemBetaling.ApiOperation;

using FinnPedersenFrance.ApiCore.ApiOperation;

enumextension 50002 "Api Operation Type Ext" extends "Api Operation Type"
{
    value(50001; VerifySetup)
    {
        Caption = 'VerifySetup', Locked = true;
    }
    value(50002; CreateLinkPayment)
    {
        Caption = 'CreateLinkPayment', Locked = true;
    }
    value(50004; Status2)
    {
        Caption = 'Status2', Locked = true;
    }
    value(50005; Refund)
    {
        Caption = 'Refund', Locked = true;
    }
    value(50006; DeletePayment)
    {
        Caption = 'DeletePayment', Locked = true;
    }
}
```

### Variant: Locked Values (External API)
- Values are locked when they match external API specifications
- Prevents modification of values that must match external systems
- All values have `Locked = true`

### Canonical NemBetaling Example (Locked Values)
```al
namespace FinnPedersenFrance.DataHubConnector.ApiOperation;

using FinnPedersenFrance.ApiCore.ApiOperation;

enumextension 51002 "Api Operation Type Ext" extends "Api Operation Type"
{
    value(51001; Up)
    {
        Caption = 'up', Locked = true;
    }
    value(51002; Payloads)
    {
        Caption = 'payloads', Locked = true;
    }
    value(51003; Raw)
    {
        Caption = 'raw', Locked = true;
    }
}
```

### Variant: Unlocked Values (App-Specific)
- Values are not locked when they are app-specific and can be modified
- Used for values that don't need to match external systems exactly
- Values may omit `Locked` property

### Canonical NemBetaling Example (Unlocked Values)
```al
namespace FinnPedersenFrance.NemBetalingData.ApiOperation;

using FinnPedersenFrance.ApiCore.ApiOperation;

enumextension 50200 "Api Operation Type Ext" extends "Api Operation Type"
{
    value(50200; Data)
    {
        Caption = 'Data';
    }
}
```

### Variant: Test Extension
- Test apps extend enums with test-specific values
- Values use test app's object range
- Typically unlocked for flexibility in testing

### Canonical NemBetaling Example (Test Extension)
```al
namespace FinnPedersenFrance.ApiCore.Test.ApiOperation;

using FinnPedersenFrance.ApiCore.ApiOperation;

enumextension 52100 "Api Operation Type Ext" extends "Api Operation Type"
{
    value(52100; Test)
    {
        Caption = 'Test';
    }
}
```


---

## STANDARD ENUM EXTENSION
### Role
- Extends an enum that already has core values
- Adds additional values to an existing extensible enum
- Used when base enum has values but needs app-specific additions
- Less common pattern in NemBetaling project

### Identification Clues
- Base enum has core values (not just blank)
- Extension adds values beyond the base enum's values
- Values follow the same numbering pattern (app's object range)

### Implementation Pattern
- Base enum has existing values (e.g., 1, 2, 3)
- Extension adds values starting from app's range (e.g., 50001+)
- Values may be locked or unlocked depending on source

### Canonical Example (Not Currently in Project)
```al
namespace FinnPedersenFrance.NemBetaling.PaymentStatus;

using FinnPedersenFrance.NemBetaling.PaymentStatus;

enumextension 50009 "Payment Request Status Ext" extends "Payment Request Status"
{
    value(50015; "Custom Status")
    {
        Caption = 'Custom Status', Locked = true;
    }
}
```

**Note**: This pattern is not currently used in the NemBetaling project but is a valid AL pattern that should be understood for future use.


---

# 🔍 HOW AN AGENT IDENTIFIES AN ENUM EXTENSION TYPE

- **Base enum pattern**: Extension-only (only blank value) vs Standard (has core values)
- **Value numbering**: Uses app's object range (50001+, 51001+, etc.)
- **Locked property**: Locked = true for external API values, omitted for app-specific values
- **Caption pattern**: PascalCase for app values, lowercase/exact match for external API values
- **Namespace pattern**: Uses `using` to reference base enum namespace
- **Naming pattern**: `"<Enum Name> Ext"` format

---

# ⭐ VALUE NUMBERING GUIDELINES

## Object Range Allocation
- **NemBetaling**: 50000-50099 (extensions use 50001+)
- **NemBetalingData**: 50200-50209 (extensions use 50200+)
- **DataHubConnector**: 51000-51099 (extensions use 51001+)
- **Test Apps**: Test range + 100 (e.g., 52100+ for ApiCore.Test)

## Value Number Selection
- Start from app's object range start (e.g., 50001 for NemBetaling)
- Use sequential numbering within app's range
- Avoid gaps unless intentional (e.g., 50004 skips 50003)
- Each app's values are independent and don't conflict

## Multi-App Extension Pattern
- Multiple apps can extend the same enum
- Each app uses its own value number range
- No conflicts because ranges don't overlap
- Example: `ApiOperationType` extended by NemBetaling (50001+), DataHubConnector (51001+), NemBetalingData (50200+)

---

# ⭐ BEST PRACTICES

## When to Use Locked = true
- Values that match external API specifications
- Values that must remain constant for integration purposes
- Values that represent fixed standards or protocols

## When to Omit Locked
- App-specific values that may need modification
- Test values that need flexibility
- Values that don't have external dependencies

## Caption Guidelines
- Use PascalCase for app-defined values (e.g., `VerifySetup`, `CreateLinkPayment`)
- Use exact external API naming when required (e.g., `'up'`, `'payloads'`, `'raw'`)
- Keep captions descriptive and clear

## Namespace Organization
- Place enum extensions in the same namespace as the app that uses them
- Use `using` statement to reference base enum namespace
- Keep namespace hierarchy consistent with app structure
