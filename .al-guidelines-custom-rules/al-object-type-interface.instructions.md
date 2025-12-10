---
applyTo: "**/*.Interface.al"
description: "AL Interface patterns and best practices"
---
# Interface Rules — Full Taxonomy (NemBetaling Specific)

## 🎯 Goal
Enable the agent to identify what kind of interface this is and what rules apply.

---

# ⚠️ CRITICAL REQUIREMENTS FOR ALL INTERFACES

## Naming Convention
- **ALL** interfaces **MUST** start with a capital "I" followed by PascalCase name
- Pattern: `interface I<Name>` (e.g., `interface IEnvironment`, `interface IFinance`, `interface IApiRequest`)
- This is a mandatory AL/BC naming convention (likely enforced by CodeCop rules)
- Examples: ✅ `interface IEnvironment`, ✅ `interface IFinance`, ❌ `interface Environment`, ❌ `interface Finance`

## Namespace Organization
- Interfaces **MUST** be placed in the appropriate namespace matching their domain
- Use clear, descriptive namespaces (e.g., `FinnPedersenFrance.NemBetaling.EasyPaymentSetup`)

## Documentation Requirements
- **ALL** interface methods **MUST** have XML documentation comments (`/// <summary>`, `/// <param>`, `/// <returns>`)
- Documentation should clearly describe the purpose, parameters, and return values
- Follow AL documentation conventions

## Implementation Pattern
- Interfaces are implemented by codeunits using `implements` keyword
- Implementation codeunits should be named descriptively (e.g., `AppEnvironment`, `StubTestEnvironment`)
- All interface methods must be marked as `internal` in implementations

---

# ⭐ KINDS OF INTERFACES

## ENVIRONMENT INTERFACE
### Role
- Abstracts environmental and system-level behavior
- Provides access to system environment information (Production/Sandbox/Test)
- Returns enum values representing system state
- Enables testing by allowing stub implementations for different environments
- **DOES NOT** have a corresponding enum - instead **USES** enums as return types

### Identification Clues
- Name typically contains "Environment" (e.g., `IEnvironment`)
- Methods return enum values (e.g., `SystemEnvironment(): Enum "System Environment"`)
- Methods provide system-level information (company name, evaluation status, environment type)
- Used for dependency injection to enable testability

### Implementation Pattern
- **ONE** implementation in the main app (e.g., `AppEnvironment`)
- **MULTIPLE** implementations in test apps (e.g., `StubTestEnvironment`, `StubProductionEnvironment`)
- Test implementations return fixed values for predictable testing

### Canonical NemBetaling Example
```al
namespace FinnPedersenFrance.NemBetaling.EasyPaymentSetup;

interface IEnvironment
{
    /// <summary>
    /// Returns the state of the current system environment. That is either Production, Sandbox or empty.
    /// </summary>
    /// <param></param>
    /// <returns>System Environment</returns>
    procedure SystemEnvironment(): Enum "System Environment"

    /// <summary>
    /// Returns the name of the current company.
    /// </summary>
    /// <param></param>
    /// <returns>Company Name</returns>
    procedure CurrentCompanyName(): Text[30]

    /// <summary>
    /// Returns the state of the current company. That is either Production or Evaluation.
    /// </summary>
    /// <param></param>
    /// <returns>False if Production Company. True if Evaluation Company.</returns>
    procedure IsEvaluationCompany(): Boolean
}
```

### Canonical NemBetaling Example (Implementation - App)
```al
namespace FinnPedersenFrance.NemBetaling.EasyPaymentSetup;

codeunit 50010 "App Environment" implements IEnvironment
{
    internal procedure SystemEnvironment(): Enum "System Environment"
    var
        EnvironmentInformation: Codeunit System.Environment."Environment Information";
    begin
        if EnvironmentInformation.IsProduction() then
            exit(Enum::"System Environment"::Production);
        if EnvironmentInformation.IsSandbox() then
            exit(Enum::"System Environment"::Sandbox);
        exit(Enum::"System Environment"::" ");
    end;

    internal procedure CurrentCompanyName(): Text[30]
    begin
        exit(Text.CopyStr(CompanyName(), 1, 30));
    end;

    internal procedure IsEvaluationCompany(): Boolean
    var
        Company: Record System.Environment.Company;
    begin
        if Company.Get(CompanyName()) then
            exit(Company."Evaluation Company")
        else
            exit(true);
    end;
}
```

### Canonical NemBetaling Example (Implementation - Test Stub)
```al
namespace FinnPedersenFrance.NemBetaling.Test.Helpers;

using FinnPedersenFrance.NemBetaling.EasyPaymentSetup;

codeunit 50103 "Stub Test Environment" implements IEnvironment
{
    Description = 'Stub Test Environment';

    internal procedure SystemEnvironment(): Enum "System Environment"
    begin
        exit(Enum::"System Environment"::Sandbox);
    end;

    internal procedure CurrentCompanyName(): Text[30]
    begin
        exit('Test Company Name');
    end;

    internal procedure IsEvaluationCompany(): Boolean
    begin
        exit(true);
    end;
}
```


---

## SERVICE INTERFACE
### Role
- Abstracts business operations or external service interactions
- Encapsulates domain-specific functionality (e.g., finance operations, API requests)
- Enables dependency injection for testability
- May have single or multiple implementations depending on the pattern

### Identification Clues
- Name describes a service or operation (e.g., `IFinance`, `IApiRequest`)
- Methods perform business operations or interact with external systems
- May use strategy pattern with `Accepts()` method for multiple implementations

### Variant: Single Implementation Service
- **ONE** implementation in the main app
- **ONE** implementation in test apps (stub)
- Used for straightforward service abstractions

### Canonical NemBetaling Example (Single Implementation)
```al
namespace FinnPedersenFrance.NemBetaling.Finance;

interface IFinance
{
    /// <summary>
    /// Creates a payment line in the general journal based on the provided payment request and setup.
    /// </summary>
    /// <param name="PaymentRequest">The payment request record containing payment details.</param>
    /// <param name="EasyPaymentSetup">The payment setup record with configuration for payment processing.</param>
    /// <param name="GenJournalBatch">The general journal batch record where the line will be created.</param>
    /// <param name="GenJournalLine">The general journal line record to be populated.</param>
    /// <param name="GenJournalTemplate">The general journal template record used for the journal line.</param>
    /// <param name="PostedSalesInvoiceHeader">The posted sales invoice header related to the payment.</param>
    procedure CreatePaymentLine(
        var PaymentRequest: Record "Payment Request";
        var EasyPaymentSetup: Record "Easy Payment Setup";
        var GenJournalBatch: Record "Gen. Journal Batch";
        var GenJournalLine: Record "Gen. Journal Line";
        var GenJournalTemplate: Record "Gen. Journal Template";
        var PostedSalesInvoiceHeader: Record "Sales Invoice Header")

    /// <summary>
    /// Creates a refund line in the general journal based on the provided refund request and setup.
    /// </summary>
    /// <param name="RefundRequest">The refund request record containing refund details.</param>
    /// <param name="EasyPaymentSetup">The payment setup record with configuration for refund processing.</param>
    /// <param name="GenJournalBatch">The general journal batch record where the line will be created.</param>
    /// <param name="GenJournalLine">The general journal line record to be populated.</param>
    /// <param name="GenJournalTemplate">The general journal template record used for the journal line.</param>
    /// <param name="SalesCrMemoHeader">The sales credit memo header related to the refund.</param>
    procedure CreateRefundLine(
        var RefundRequest: Record "Refund Request";
        var EasyPaymentSetup: Record "Easy Payment Setup";
        var GenJournalBatch: Record "Gen. Journal Batch";
        var GenJournalLine: Record "Gen. Journal Line";
        var GenJournalTemplate: Record "Gen. Journal Template";
        var SalesCrMemoHeader: Record "Sales Cr.Memo Header")
}
```

### Variant: Multiple Implementation Service (Strategy Pattern)
- **MULTIPLE** implementations in the main app (different strategies)
- **MULTIPLE** implementations in test apps (stubs, spies)
- Uses `Accepts()` method to determine which implementation handles which operation
- Each implementation checks if it can handle a specific operation type

### Canonical NemBetaling Example (Strategy Pattern)
```al
namespace FinnPedersenFrance.ApiCore.ApiOperation;

interface IApiRequest
{
    /// <summary>
    /// Sends an HTTP request to a specified URL using the specified method and payload.
    /// </summary>
    /// <param name="ApiOperation">The operation to be send</param>
    procedure Send(var ApiOperation: Record "Api Operation")

    /// <summary>
    /// Checks if the API operation is accepted by the implementation.
    /// </summary>
    /// <param name="ApiOperation"></param>
    /// <returns>True if Yes and False if No</returns>
    procedure Accepts(ApiOperation: Record "Api Operation"): Boolean
}
```

### Canonical NemBetaling Example (Strategy Implementation)
```al
namespace FinnPedersenFrance.NemBetaling.ApiOperation;

codeunit 50011 "App Api Request" implements IApiRequest
{
    local procedure IsMyEndpoint(ApiOperation: Record "Api Operation"): Boolean
    begin
        exit(ApiOperation.Endpoint in [Enum::"Api Operation Type"::VerifySetup,
                                    Enum::"Api Operation Type"::CreateLinkPayment,
                                    Enum::"Api Operation Type"::Status2,
                                    Enum::"Api Operation Type"::Refund,
                                    Enum::"Api Operation Type"::DeletePayment]);
    end;

    local procedure IsMyImplementation(ApiOperation: Record "Api Operation"): Boolean
    begin
        exit(ApiOperation."Request Handler Codeunit" = Codeunit::"Easy Payment Send Request");
    end;

    internal procedure Accepts(ApiOperation: Record "Api Operation"): Boolean
    begin
        exit(this.IsMyImplementation(ApiOperation) and this.IsMyEndpoint(ApiOperation));
    end;

    internal procedure Send(var ApiOperation: Record "Api Operation")
    begin
        if not this.Accepts(ApiOperation) then
            exit;
        // ... implementation
    end;
}
```


---

## CONTEXT INTERFACE (Enum-Based)
### Role
- Interface where **each enum value implements the interface**
- Each enum value provides its own implementation of interface methods
- Enables polymorphic behavior based on enum values
- **HAS** a corresponding enum where enum values implement the interface

### Identification Clues
- Interface name relates to a context or type that varies by enum value
- Enum extension or enum values implement the interface
- Each enum value provides different behavior for the same interface methods
- Pattern: `enum "Payment Method"` with values Card, MobilePay, etc., each implementing `IPaymentMethod`

### Implementation Pattern
- Enum values implement the interface directly
- Each enum value provides its own implementation
- Used when behavior varies by type/category represented by enum values

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

enumextension 50021 "Payment Method Ext" extends "Payment Method"
{
    value(50003; BS) implements IPaymentMethod
    {
        Caption = 'BS';
    }
}
```

**Note**: This pattern is not currently used in the NemBetaling project but is a valid AL pattern that should be understood for future use.


---

# 🔍 HOW AN AGENT IDENTIFIES AN INTERFACE TYPE

- **Name pattern**: Environment (IEnvironment), Service (IFinance, IApiRequest), Context (IPaymentMethod)
- **Return types**: Environment interfaces return enums; Service interfaces return business data
- **Implementation count**: Environment = 1 app + multiple test; Service = 1 or multiple app + test stubs
- **Method patterns**: `Accepts()` indicates strategy pattern; enum return types indicate environment interface
- **Usage context**: Environment = system-level; Service = business operations; Context = enum-based polymorphism
- **Corresponding enum**: Environment interfaces USE enums but don't have corresponding enums; Context interfaces HAVE corresponding enums where values implement the interface

---

# ⭐ IMPLEMENTATION CODEUNITS

## Naming Conventions
- **App implementations**: `App<InterfaceName>` (e.g., `AppEnvironment`, `AppFinance`, `AppApiRequest`)
- **Test stubs**: `Stub<Description>` (e.g., `StubTestEnvironment`, `StubFinance`, `StubApiRequest`)
- **Test spies**: `Spy<InterfaceName>` (e.g., `SpyApiRequest` - captures calls for verification)

## Implementation Requirements
- All interface methods **MUST** be marked as `internal`
- Implementations should be in appropriate namespaces matching the interface namespace
- Test implementations should be in test app namespaces (e.g., `FinnPedersenFrance.NemBetaling.Test.Helpers`)

## Strategy Pattern Implementation
- When multiple implementations exist, use `Accepts()` method pattern
- Each implementation checks if it can handle the specific operation/context
- Caller iterates through implementations to find one that accepts the operation
