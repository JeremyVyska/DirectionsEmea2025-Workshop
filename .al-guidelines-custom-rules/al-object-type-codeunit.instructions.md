---
applyTo: "**/*.Codeunit.al"
description: "AL Codeunit object type taxonomy and patterns - identifies codeunit types (Mgt, Task, Library, Error Handler, Event Subscribers, Interface) and enforces NemBetaling patterns"
---
# Codeunit Rules — Full Taxonomy

## 🎯 Goal
Help agents **identify**, **classify**, **refactor**, and **generate** the correct kind of Codeunit.

## 📚 About Examples

The examples in this document are from **NemBetaling**, which serves as the **gold standard** and **role model** for Business Central development. NemBetaling demonstrates best practices and sets the bar for code quality, architecture, and patterns. All examples are real, production code that follows these rules perfectly. Use these examples as your reference when implementing similar patterns in your projects.

---

# ⚠️ CRITICAL REQUIREMENTS FOR ALL CODEUNITS

## Subtype Property

**Production codeunits MUST NOT have `Subtype = Test`**

- Only test codeunits (in test apps) should have `Subtype = Test`
- Production codeunits should **NOT** include `Subtype = Test`
- If a codeunit has `Subtype = Test`, it must be in a test app folder (`*.Test`)

**❌ Violation**: Production codeunit with Subtype = Test
```al
codeunit 50007 "Payment Request Mgt"
{
    Subtype = Test;  // ❌ Production codeunit cannot have Subtype = Test
    // ...
}
```

**✅ Correct**: Production codeunit without Subtype
```al
codeunit 50007 "Payment Request Mgt"
{
    Description = 'Payment Request Management';
    // ✅ No Subtype property - correct for production codeunits
    // ...
}
```

## Naming Convention
- Codeunits **MUST** follow clear naming patterns based on their type:
  - Management codeunits: End with `Mgt` (e.g., `Payment Request Mgt`)
  - Task codeunits: End with `Task` or describe the task (e.g., `Payment Request Task`, `Payment Request Send`)
  - Library codeunits: Descriptive plural names (e.g., `Encoders`, `Decoders`)
  - Error handler codeunits: End with `Error Handler` (e.g., `Payment Request Error Handler`)
  - Event subscriber codeunits: End with `Event Subscribers` (e.g., `Easy Payment Event Subscribers`, `Api Core Event Subscribers`)
  - Interface implementation codeunits: Descriptive names with `App` or `Stub` prefix (e.g., `App Environment`, `Stub Finance`)

## Namespace Organization
- Codeunits **MUST** be placed in the appropriate namespace matching their domain
- Use clear, descriptive namespaces following the pattern: `<Company>.<App>.<Domain>`
- Keep namespace hierarchy consistent with app structure
- **Example from NemBetaling**: `FinnPedersenFrance.NemBetaling.RequestPayment` follows this pattern

## Documentation Requirements
- **ALL** public and internal procedures **MUST** have XML documentation comments (`/// <summary>`, `/// <param>`, `/// <returns>`)
- Documentation should clearly describe the purpose, parameters, and return values
- Follow AL documentation conventions

---

# ⭐ KINDS OF CODEUNITS

## MANAGEMENT CODEUNIT (Mgt)
### Role
- Contains **ALL** business logic for a domain
- Pure functions only (no side effects beyond modifying passed records)
- 100% test coverage expected
- Central orchestration point for operations
- Records passed by reference (`var` parameter) to enable temporary record testing
- No global variables - all state passed through function parameters

### Identification Clues
- Name ends with `Mgt` (e.g., `Payment Request Mgt`, `Easy Payment Setup Mgt`)
- Many pure functions
- Parameters passed by `var` (by reference)
- Used by pages or task codeunits
- Functions are marked as `internal`
- No `TableNo` property
- No `trigger OnRun()` (unless it's a task codeunit)

### Implementation Pattern
- Top-level `Get()` functions retrieve records from database
- `Create()` functions initialize and insert records
- Pure query functions return values (e.g., `ResultOK()`, `ApiUrl()`)
- Business logic functions orchestrate operations
- All functions are testable with temporary records

### Example from NemBetaling (Gold Standard)

**General Rule**: Management codeunits contain all business logic, use pure functions, and pass records by reference.

**NemBetaling Implementation**:
```al
namespace FinnPedersenFrance.NemBetaling.RequestPayment;

codeunit 50007 "Payment Request Mgt"
{
    internal procedure SendRequest(
        var EasyPaymentSetup: Record "Easy Payment Setup"; 
        var PaymentRequest: Record "Payment Request"; 
        var ApiOperation: Record "Api Operation"; 
        ApiRequest: Interface IApiRequest)
    var
        ApiOperationMgt: Codeunit "Api Operation Mgt";
        EasyPaymentDecoders: Codeunit "Easy Payment Decoders";
    begin
        this.InitApiOperation(EasyPaymentSetup, PaymentRequest, ApiOperation);
        ApiRequest.Send(ApiOperation);
        ApiOperation.Modify(false);
        if ApiOperationMgt.Success(ApiOperation) then
            EasyPaymentDecoders.DecodePaymentResponse(EasyPaymentSetup, ApiOperation, PaymentRequest);
        PaymentRequest."API Operation Entry No." := ApiOperation."Entry No.";
        PaymentRequest.Modify(false);
    end;

    internal procedure InitApiOperation(
        var EasyPaymentSetup: Record "Easy Payment Setup"; 
        var PaymentRequest: Record "Payment Request"; 
        var ApiOperation: Record "Api Operation")
    begin
        ApiOperation.Init();
        ApiOperation."Api Operation Status" := Enum::"Api Operation Status"::New;
        ApiOperation.Endpoint := Enum::"Api Operation Type"::CreateLinkPayment;
        ApiOperation.Insert(true);
    end;

    internal procedure CalculatePayload(
        var EasyPaymentSetup: Record "Easy Payment Setup"; 
        var PaymentRequest: Record "Payment Request"): Text
    var
        EasyPaymentEncoders: Codeunit "Easy Payment Encoders";
        PaymentRequestPayloadJson: JsonObject;
    begin
        EasyPaymentEncoders.EncodePaymentRequestPayload(PaymentRequest, EasyPaymentSetup, PaymentRequestPayloadJson);
        exit(Format(PaymentRequestPayloadJson));
    end;
}
```


---

## TASK CODEUNIT
### Role
- Thin wrapper for Job Queue or table-based tasks
- Very little code - minimal orchestration
- Delegates work to Management codeunits
- Used for background processing or scheduled tasks

### Identification Clues
- Has `TableNo = "Job Queue Entry"` OR `TableNo = <Record>` (e.g., `TableNo = "Payment Request"`)
- Has `trigger OnRun()`
- Calls Mgt codeunits
- Minimal business logic
- Typically named with `Task` suffix or descriptive action name

### Variant: Job Queue Task Codeunit
- `TableNo = "Job Queue Entry"`
- Used for scheduled background jobs
- Orchestrates multiple operations via Mgt codeunits

### Example from NemBetaling (Gold Standard) - Job Queue Task

**General Rule**: Job Queue task codeunits are thin wrappers that delegate to Management codeunits.

**NemBetaling Implementation**:
```al
namespace FinnPedersenFrance.NemBetaling.JobQueueEntries;

codeunit 50013 "Payment Request Send"
{
    Description = 'Sends payment requests to the NemBetaling service.';
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        EasyPaymentSetup: Record "Easy Payment Setup";
        PaymentRequest: Record "Payment Request";
        EasyPaymentSetupMgt: Codeunit "Easy Payment Setup Mgt";
    begin
        EasyPaymentSetupMgt.GetSetup(EasyPaymentSetup);
        if EasyPaymentSetup."Job Scheduler on Standby" then
            exit;

        PaymentRequest.SetRange("API Operation Entry No.", 0);
        if PaymentRequest.FindSet(true) then
            repeat
                this.CreateTask(PaymentRequest);
            until PaymentRequest.Next() = 0;
    end;

    internal procedure CreateTask(PaymentRequest: Record "Payment Request")
    begin
        TaskScheduler.CreateTask(
            Codeunit::"Payment Request Task",
            Codeunit::"Payment Request Error Handler",
            true,
            CompanyName(),
            CurrentDateTime() + 200,
            PaymentRequest.RecordId());
    end;
}
```

### Variant: Record-Based Task Codeunit
- `TableNo = <Record>` (e.g., `TableNo = "Payment Request"`)
- Used for processing individual records
- Thin wrapper that delegates to Mgt codeunits

### Example from NemBetaling (Gold Standard) - Record-Based Task

**General Rule**: Record-based task codeunits are thin wrappers that delegate to Management codeunits.

**NemBetaling Implementation**:
```al
namespace FinnPedersenFrance.NemBetaling.RequestPayment;

codeunit 50021 "Payment Request Task"
{
    Description = 'Handles the creation of payment request tasks.';
    TableNo = "Payment Request";

    trigger OnRun()
    var
        ApiOperation: Record "Api Operation";
        EasyPaymentSetup: Record "Easy Payment Setup";
        AppApiRequest: Codeunit "App Api Request";
        EasyPaymentSetupMgt: Codeunit "Easy Payment Setup Mgt";
        PaymentRequestMgt: Codeunit "Payment Request Mgt";
    begin
        EasyPaymentSetupMgt.GetSetup(EasyPaymentSetup);
        PaymentRequestMgt.SendRequest(EasyPaymentSetup, Rec, ApiOperation, AppApiRequest);
    end;
}
```


---

## LIBRARY CODEUNIT
### Role
- Collection of utility functions or helper methods
- Provides reusable functionality across the application
- NOT business logic - pure utility functions
- **NOT** named with `Mgt` suffix
- Examples: Encoders, Decoders, Helpers, Utilities

### Identification Clues
- Name describes the utility purpose (e.g., `Encoders`, `Decoders`, `Helpers`)
- Does NOT end with `Mgt`
- Contains pure utility functions
- No `TableNo` property
- No `trigger OnRun()`
- Functions are typically `internal` or `procedure` (public)

### Variant: Encoders/Decoders
- Specialized library codeunits for encoding/decoding data
- Typically named `Encoders` or `Decoders` (plural)
- Contains functions for converting between formats (e.g., JSON encoding/decoding)

### Example from NemBetaling (Gold Standard) - Encoders

**General Rule**: Encoder codeunits are library codeunits that handle JSON creation, separate from business logic.

**NemBetaling Implementation**:
```al
namespace FinnPedersenFrance.NemBetaling.ApiOperation;

codeunit 50002 "Easy Payment Encoders"
{
    var
        Encoders: Codeunit FinnPedersenFrance.ApiCore.Json.Encoders;

    /// <summary>
    /// Encodes a Payment Request record into a JSON payload for API transmission.
    /// </summary>
    /// <param name="PaymentRequest">The Payment Request record to encode.</param>
    /// <param name="EasyPaymentSetup">The Easy Payment Setup record for environment-specific values.</param>
    /// <param name="PaymentRequestPayloadJson">The JSON object to populate with encoded values. Passed by reference.</param>
    procedure EncodePaymentRequestPayload(
        var PaymentRequest: Record "Payment Request"; 
        var EasyPaymentSetup: Record "Easy Payment Setup"; 
        var PaymentRequestPayloadJson: JsonObject)
    begin
        this.Encoders.EncodeText('OrderRef', PaymentRequest."Order Reference", PaymentRequestPayloadJson);
        this.Encoders.EncodeText('Name', PaymentRequest.Name, PaymentRequestPayloadJson);
        this.EncodeDecimalAsText('Amount', PaymentRequest.Amount, PaymentRequestPayloadJson);
    end;
}
```

### Example from NemBetaling (Gold Standard) - Decoders

**General Rule**: Decoder codeunits are library codeunits that handle JSON parsing, separate from business logic.

**NemBetaling Implementation**:
```al
namespace FinnPedersenFrance.NemBetaling.ApiOperation;

codeunit 50003 "Easy Payment Decoders"
{
    var
        Decoders: Codeunit FinnPedersenFrance.ApiCore.Json.Decoders;

    /// <summary>
    /// Decodes an error item from a JSON token, extracting the error text and error code.
    /// </summary>
    /// <param name="ErrorItem">The JSON token representing the error object.</param>
    /// <param name="ErrorText">The text variable where the decoded error message will be stored. Passed by reference.</param>
    /// <param name="ErrorCode">The integer variable where the decoded error code will be stored. Passed by reference.</param>
    procedure DecodeErrorArray(ErrorItem: JsonToken; var ErrorText: Text; var ErrorCode: Integer)
    begin
        if ErrorItem.IsObject() then begin
            this.Decoders.DecodeText(ErrorItem.AsObject(), 'Text', ErrorText);
            this.Decoders.DecodeInteger(ErrorItem.AsObject(), 'Code', ErrorCode);
        end;
    end;
}
```

### Variant: Core Library Codeunits
- Base library codeunits in ApiCore or shared libraries
- Provide foundational utility functions
- Used by domain-specific library codeunits

### Example from NemBetaling (Gold Standard) - Core Library

**General Rule**: Core library codeunits provide foundational utility functions used by domain-specific library codeunits.

**NemBetaling Implementation**:
```al
namespace FinnPedersenFrance.ApiCore.Json;

codeunit 52002 Encoders
{
    /// <summary>
    /// Encodes a boolean value into a JSON object.
    /// </summary>
    /// <param name="ObjectKey">The key to use in the JSON object.</param>
    /// <param name="Value">The boolean value to encode.</param>
    /// <param name="Object">The JSON object to populate. Passed by reference.</param>
    procedure EncodeBoolean(ObjectKey: Text; Value: Boolean; var Object: JsonObject)
    begin
        Object.Add(ObjectKey, Value)
    end;

    procedure EncodeDate(ObjectKey: Text; Date: Date; var Object: JsonObject)
    begin
        Object.Add(ObjectKey, Date)
    end;
}
```


---

## ERROR HANDLER CODEUNIT
### Role
- Handles errors for specific domains or operations
- Used as error handlers for Job Queue tasks
- Provides consistent error handling across the app

### Identification Clues
- Name ends with `Error Handler` (e.g., `Payment Request Error Handler`)
- Has `TableNo = <Record>` property
- Has `trigger OnRun()` for error handling logic
- Typically minimal code - may delegate to Mgt codeunits

### Example from NemBetaling (Gold Standard)

**General Rule**: Error handler codeunits handle errors for specific domains, used as error handlers for Job Queue tasks.

**NemBetaling Implementation**:
```al
namespace FinnPedersenFrance.NemBetaling.RequestPayment;

codeunit 50022 "Payment Request Error Handler"
{
    Description = 'Handles errors for payment requests.';
    TableNo = "Payment Request";

    trigger OnRun()
    begin
        // Error handling logic
        Rec.Modify(false);
    end;
}
```


---

## EVENT SUBSCRIBER CODEUNIT
### Role
- Contains event subscribers for Business Central events
- Subscribes to standard BC events or custom events
- Delegates to Management codeunits for business logic

### Identification Clues
- Name ends with `Event Subscribers` (e.g., `Easy Payment Event Subscribers`, `Api Core Event Subscribers`)
- Contains `[EventSubscriber(...)]` attributes
- Subscriber methods are typically `local procedure`
- Delegates to Mgt codeunits for actual logic
- Pattern: `<Domain> Event Subscribers` (domain name first, type identifier at the end)

### Naming Convention
- **MUST** end with `Event Subscribers` (not start with it)
- Domain/feature name comes first
- Pattern: `<Domain> Event Subscribers` (e.g., `Easy Payment Event Subscribers`, `Api Core Event Subscribers`)
- This pattern matches other codeunit naming (e.g., `Easy Payment Encoders`, `Easy Payment Decoders`)

### Example from NemBetaling (Gold Standard)

**General Rule**: Event subscriber codeunits contain event subscribers that delegate to Management codeunits for business logic.

**NemBetaling Implementation**:
```al
namespace FinnPedersenFrance.NemBetaling.ApiOperation;

codeunit 50037 "Easy Payment Event Subscribers"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Api Operation Scheduler", OnBeforeScheduleApiOperation, '', false, false)]
    local procedure OnBeforeScheduleApiOperation(var ApiOperation: Record "Api Operation")
    var
        AppApiRequest: Codeunit "App Api Request";
    begin
        if not AppApiRequest.Accepts(ApiOperation) then
            exit;

        ApiOperation."Request Handler Codeunit" := Codeunit::"Easy Payment Send Request Task";
    end;
}
```

### Variant: Standard Event Subscribers
- When event subscribers are in a dedicated `StandardEventSubscribers` namespace
- May use `Event Subscribers <Domain>` pattern (beginning) for grouping
- However, `<Domain> Event Subscribers` (end) is preferred for consistency

### Example from NemBetaling (Gold Standard) - Standard Event Subscribers

**General Rule**: Standard event subscribers are in a dedicated namespace and subscribe to standard BC events.

**NemBetaling Implementation**:
```al
namespace FinnPedersenFrance.NemBetaling.StandardEventSubscribers;

codeunit 50001 "Event Subscribers Sales"
{
    Description = 'Event Subscribers for Sales Posting';

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnAfterPostSalesDoc, '', false, false)]
    local procedure OnAfterPostSalesDoc(
        var SalesHeader: Record "Sales Header"; 
        var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; 
        SalesInvHdrNo: Code[20]; 
        SalesCrMemoHdrNo: Code[20]; 
        PreviewMode: Boolean)
    var
        SalesExtensionMgt: Codeunit "Sales Extension Mgt";
    begin
        SalesExtensionMgt.CreateEasyPaymentRequest(SalesHeader, SalesInvHdrNo, SalesCrMemoHdrNo, CustLedgerEntry, PreviewMode);
    end;
}
```

**Note**: For consistency, prefer `<Domain> Event Subscribers` pattern even in `StandardEventSubscribers` namespace, but existing code using `Event Subscribers <Domain>` is acceptable.


---

## INTERFACE IMPLEMENTATION CODEUNIT
### Role
- Implements environment or API abstraction interfaces
- Provides concrete implementation of interfaces
- Enables dependency injection and testability

### Identification Clues
- Uses `implements <InterfaceName>` syntax
- Implements IEnvironment, IApiRequest, IFinance, etc.
- Named with `App` prefix for app implementations (e.g., `App Environment`, `App Finance`)
- Named with `Stub` or `Spy` prefix for test implementations

### Example from NemBetaling (Gold Standard)

**General Rule**: Interface implementation codeunits provide concrete implementations of interfaces, enabling dependency injection and testability.

**NemBetaling Implementation**:
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

**Note**: See interface.mdc for detailed rules on interface implementations.


---

# 🔍 HOW AGENTS CAN IDENTIFY A CODEUNIT AUTOMATICALLY

Agents must use these signals:

- **Name patterns**: 
  - `Mgt` suffix = Management codeunit (e.g., `Payment Request Mgt` from NemBetaling)
  - `Task` suffix or action name = Task codeunit (e.g., `Payment Request Task` from NemBetaling)
  - `Encoders`/`Decoders`/plural utility names = Library codeunit (e.g., `Easy Payment Encoders` from NemBetaling)
  - `Error Handler` suffix = Error handler codeunit (e.g., `Payment Request Error Handler` from NemBetaling)
  - `Event Subscribers` suffix = Event subscriber codeunit (e.g., `Easy Payment Event Subscribers` from NemBetaling)
  - `App`/`Stub`/`Spy` prefix = Interface implementation codeunit (e.g., `App Environment` from NemBetaling)
- **Properties**:
  - `TableNo = "Job Queue Entry"` = Job Queue Task codeunit
  - `TableNo = <Record>` = Record-based Task or Error Handler codeunit
  - No `TableNo` = Management or Library codeunit
- **Structure**:
  - Presence of `trigger OnRun()` = Task or Error Handler codeunit
  - Pure functions with `var` parameters = Management codeunit
  - Utility functions = Library codeunit
  - `[EventSubscriber(...)]` attributes = Event subscriber codeunit
  - `implements` keyword = Interface implementation codeunit
- **Usage**:
  - Called by pages or task codeunits = Management codeunit
  - Called by Management codeunits = Library codeunit
  - Used as Job Queue error handler = Error Handler codeunit

This enables:

**"Analyze this codeunit and classify its type."**  
**"Refactor this into a valid Mgt codeunit."**  
**"Create a Task Codeunit following NemBetaling patterns."**  
**"Create a Library codeunit for JSON encoding following NemBetaling patterns."**

