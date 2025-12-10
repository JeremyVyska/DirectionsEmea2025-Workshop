---
applyTo: "**/*.Enum.al"
description: "AL Enum patterns and best practices"
---
# Enum Rules — Full Taxonomy (NemBetaling Specific)

## 🎯 Goal
Enable the agent to identify what kind of enum this is and what rules apply.

---

# ⚠️ CRITICAL REQUIREMENTS FOR ALL ENUMS

## Extensible Property
- **MUST** always specify `Extensible = true` or `Extensible = false`
- Never omit the Extensible property
- This is a mandatory property for all enum objects

## Blank Value Pattern
- **ALL enums MUST** have a blank value as the first value: `value(0; " ")`
- The blank value **MUST** have `Locked = true`
- Pattern:
```al
value(0; " ")
{
    Caption = ' ', Locked = true;
}
```

## First Value Not Blank Pattern
- **IF** the first value in an enum is NOT blank (i.e., starts with a real value like `GET`, `POST`, etc.)
- **THEN** the enum **MUST** start with `#pragma warning disable LC0045` as the first line
- **AND** the enum **MUST** end with `#pragma warning restore LC0045` as the last line
- This pattern is required when the first value is not blank

---

# ⭐ KINDS OF ENUMS

## STATE/OPTION/TYPE/CONTEXT ENUM
### Role
- Tracks the current state or status of a business entity (workflow progression).
- Represents operation outcomes or results (success, failure, errors).
- Categorizes entities or operations by type or method (classification).
- Provides contextual or environmental choices (extensible options).
- Often Extensible = true, allowing extensions to add new values.

### Identification Clues
- Name might contain "Status", "State", "Result", "Type", "Method", or context-related terms
- Values represent stages in a process, operation outcomes, categories, or contextual choices
- Often Extensible = true

### Canonical NemBetaling Example
```al
enum 50001 "Payment Request State"
{
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ', Locked = true;
    }
    value(1; Created)
    {
        Caption = 'Created';
    }
    value(2; Sent)
    {
        Caption = 'Sent';
    }
    value(3; Waiting)
    {
        Caption = 'Waiting';
    }
    value(4; Paid)
    {
        Caption = 'Paid';
    }
}
```

### Canonical NemBetaling Example
```al
enum 52010 "Api Operation Result"
{
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ', Locked = true;
    }
    value(1; Success)
    {
        Caption = 'Success';
    }
    value(2; "Connection Error")
    {
        Caption = 'Connection Error';
    }
    value(3; "WebService Call Failed")
    {
        Caption = 'WebService Call Failed';
    }
}
```

### Variant: Extensible Enum with Locked Values
- When enum values come from an external API and cannot be translated
- Values are locked to prevent modification but enum remains extensible for extensions
- All non-blank values have `Locked = true`
- Example: `PaymentRequestStatus` - values locked because they match external API statuses

### Canonical NemBetaling Example (Locked Values)
```al
enum 50008 "Payment Request Status"
{
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ', Locked = true;
    }
    value(1; Waiting)
    {
        Caption = 'Waiting', Locked = true;
    }
    value(2; Paid)
    {
        Caption = 'Paid', Locked = true;
    }
    // ... more locked values from external API
}
```

### Variant: Extension-Only Enum
- Extensible enum with no core values (only blank value)
- Designed for enum extensions to provide all actual values
- Base enum is extensible but contains only the blank value
- Extensions add the real values

### Canonical NemBetaling Example (Extension-Only)
```al
enum 52002 "Api Operation Type"
{
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ', Locked = true;
    }
}
```

### Variant: First Value Not Blank (Special Case)
- When first value is not blank (e.g., HTTP methods: GET, POST, etc.)
- Requires `#pragma warning disable LC0045` at start and `#pragma warning restore LC0045` at end
- All values typically have `Locked = true` when representing fixed standards

### Canonical NemBetaling Example (First Value Not Blank)
```al
#pragma warning disable LC0045
namespace FinnPedersenFrance.ApiCore.ApiOperation;
enum 52005 "Api Method"
{
    Extensible = true;

    value(0; GET)
    {
        Caption = 'GET', Locked = true;
    }
    value(1; POST)
    {
        Caption = 'POST', Locked = true;
    }
    // ... more HTTP methods
}
#pragma warning restore LC0045
```


---

## TRI-STATE NON-EXTENSIBLE ENUM
### Role
- Represents a fixed set of mutually exclusive options (tri-state boolean-like).
- Used for configuration choices that cannot be extended.
- Typically Extensible = false.

### Identification Clues
- Name relates to configuration, environment, or choice
- Values represent a limited set of options (often 2-3 values)
- Extensible = false (closed set)
- Acts like an enhanced boolean or tri-state selector

### Canonical NemBetaling Example
```al
enum 52009 Result
{
    Extensible = false;

    value(0; " ")
    {
        Caption = ' ', Locked = true;
    }
    value(1; Failure)
    {
        Caption = 'Failure', Locked = true;
    }
    value(2; Success)
    {
        Caption = 'Success', Locked = true;
    }
}
```


### Canonical NemBetaling Example
```al
enum 51006 "Application State"
{
    Extensible = false;

    value(0; " ")
    {
        Caption = ' ', Locked = true;
    }
    value(1; Test)
    {
        Caption = 'Test';
    }
    value(2; Production)
    {
        Caption = 'Production';
    }
}
```


### Canonical NemBetaling Example
```al
enum 50004 "System Environment"
{
    Extensible = false;
    value(0; " ")
    {
        Caption = ' ', Locked = true;
    }
    value(1; Sandbox)
    {
        Caption = 'Sandbox';
    }
    value(2; Production)
    {
        Caption = 'Production';
    }
}
```

### Canonical NemBetaling Example
```al
enum 52012 "Query Direction"
{
    Extensible = false;

    value(0; " ")
    {
        Caption = ' ', Locked = true;
    }
    value(1; Request)
    {
        Caption = 'Request';
    }
    value(2; Response)
    {
        Caption = 'Response';
    }
}
```

---

## ENUM IMPLEMENTING INTERFACE
### Role
- Enum where **each enum value implements an interface**
- Each enum value provides its own implementation of interface methods
- Enables polymorphic behavior based on enum values
- Used when behavior varies by type/category represented by enum values
- **HAS** a corresponding interface where enum values implement the interface

### Identification Clues
- Enum values use `implements <InterfaceName>` syntax
- Each enum value provides different behavior for the same interface methods
- Pattern: `value(1; Card) implements IPaymentMethod`
- Interface name typically relates to the context or type (e.g., `IPaymentMethod`, `IValidationRule`)
- Used for strategy pattern where each enum value represents a different strategy

### Critical Requirements
- **Interface must exist**: The interface being implemented must be defined before the enum
- **All values implement**: Typically all non-blank enum values implement the interface (blank value usually does not)
- **Extensible = true**: Usually extensible to allow enum extensions to add new implementations
- **Value implementations**: Each enum value must provide implementation for all interface methods
- **Namespace**: Enum and interface should be in related namespaces

### Implementation Pattern
- Interface defines the contract (methods that each enum value must implement)
- Enum values implement the interface directly using `implements` keyword
- Each enum value provides its own implementation of interface methods
- Enum extensions can add new values that also implement the interface

### Canonical Example (Not Currently in Project)
```al
namespace FinnPedersenFrance.NemBetaling.PaymentMethod;

interface IPaymentMethod
{
    /// <summary>
    /// Returns the payment method name.
    /// </summary>
    /// <returns>Payment method name</returns>
    procedure GetName(): Text

    /// <summary>
    /// Checks if the payment method supports refunds.
    /// </summary>
    /// <returns>True if refunds are supported</returns>
    procedure SupportsRefund(): Boolean
}

enum 50020 "Payment Method"
{
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ', Locked = true;
    }
    value(1; Card) implements IPaymentMethod
    {
        Caption = 'Card';
    }
    value(2; MobilePay) implements IPaymentMethod
    {
        Caption = 'MobilePay';
    }
}
```

### Rules to Keep in Mind
- **Interface methods**: All methods defined in the interface must be implemented by each enum value
- **Method visibility**: Interface methods in enum value implementations are typically `internal`
- **Implementation location**: Method implementations for enum values are defined in codeunits, not in the enum itself
- **Enum extensions**: When extending an enum that implements an interface, new values can also implement the interface
- **Polymorphism**: Code can use the enum value as the interface type to call methods polymorphically
- **Blank value**: The blank value typically does NOT implement the interface (it's just a placeholder)
- **Extensible property**: Enums implementing interfaces should usually be `Extensible = true` to allow extensions
- **Naming consistency**: Interface name should relate to the enum name (e.g., `IPaymentMethod` for `"Payment Method"` enum)

### Usage Pattern
```al
// Using the enum value as interface
var
    PaymentMethod: Enum "Payment Method";
    PaymentMethodInterface: Interface IPaymentMethod;
begin
    PaymentMethod := Enum::"Payment Method"::Card;
    PaymentMethodInterface := PaymentMethod; // Enum value can be assigned to interface
    Message('Name: %1, Supports Refund: %2', PaymentMethodInterface.GetName(), PaymentMethodInterface.SupportsRefund());
end;
```

**Note**: This pattern is not currently used in the NemBetaling project but is a valid AL pattern that should be understood for future use. When implementing this pattern, ensure all enum values properly implement all interface methods.


---
# 🔍 HOW AN AGENT IDENTIFIES AN ENUM TYPE

- Name pattern (Result, Status, State, Type, Method, Environment)
- Value names (Success/Failure vs Created/Sent/Paid vs Sandbox/Production)
- Extensible property (false for tri-state non-extensible enums, true for state/option/type/context enums)
- Usage context (operation tables vs document tables vs setup tables)
- Whether it's used in Mgt codeunits for business logic
- Whether values are locked (indicates external API dependency or fixed standards)
- Whether first value is blank (determines if #pragma warning is needed)
- Whether enum values implement interfaces (indicates enum-based polymorphism pattern)
