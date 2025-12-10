---
applyTo: "**/*.PermissionSet.al"
description: "AL PermissionSet patterns and best practices"
---

# Permission Set Rules — Full Taxonomy (NemBetaling Specific)

## 🎯 Goal
Enable the agent to identify permission set patterns and enforce correct behavior.

---

# ⚠️ CRITICAL REQUIREMENTS FOR ALL PERMISSION SETS

## File Location
- **MUST** be placed in a `Permissions` folder
- File path pattern: `<App>/src/Permissions/<Name>.permissionset.al`
- **MUST NOT** use `<Domain>Permissions` folder pattern (e.g., `EasyPaymentPermissions`, `OrderStatusPermissions`)

## Naming Convention
- Permission set name should match the app/domain name (e.g., `ApiCore`, `EasyPayment`, `DataHub`)
- File name should match permission set name (case-sensitive)
- Can use `.permissionset.al` or `.PermissionSet.al` extension (both are valid)

## Caption Property
- **MUST** have `Caption` property
- **MUST** have `MaxLength = 30` (mandatory requirement)
- Pattern: `Caption = '<Name>', MaxLength = 30;`
- Caption should be descriptive and match the permission set purpose

## Assignable Property
- **MUST** have `Assignable = true` to allow assignment to users

## Generation Pattern
- Permission sets are **normally generated** by running the command: `al.generatePermissionSetForExtensionObjects`
- After generation, **MUST** add `Caption = '<Name>', MaxLength = 30;` manually
- After generation, verify `Assignable = true` is set

---

# ⭐ KINDS OF PERMISSION SETS

## APP PERMISSION SET
### Role
- Grants permissions for all objects in an app/extension
- Main permission set for the application
- Used for production deployments

### Identification Clues
- Name matches app name (e.g., `ApiCore`, `EasyPayment`, `DataHub`)
- Contains permissions for all app objects (tables, codeunits, pages)
- Includes both table permissions (`table "Table Name" = X`) and tabledata permissions (`tabledata "Table Name" = RIMD`)
- Located in `Permissions` folder

### Critical Requirements
- **MUST** have `Caption = '<App Name>', MaxLength = 30;`
- **MUST** have `Assignable = true`
- **SHOULD** include permissions for all app objects
- **SHOULD** use `using` statements for namespace organization

### Canonical NemBetaling Example
```al
namespace FinnPedersenFrance.ApiCore.Permissions;

using FinnPedersenFrance.ApiCore.ApiOperation;
using FinnPedersenFrance.ApiCore.Json;
using FinnPedersenFrance.ApiCore.ScheduledTasks;

permissionset 52000 ApiCore
{
    Assignable = true;
    Caption = 'API Core', MaxLength = 30;
    Permissions = table "Api Operation" = X,
        tabledata "Api Operation" = RIMD,
        codeunit "Api Operation Mgt" = X,
        codeunit "Api Operation Scheduler" = X,
        page "Api Operation Card" = X,
        page "Api Operation List" = X,
        page "Scheduled Task Card" = X,
        page "Scheduled Tasks List" = X;
}
```

---

## TEST PERMISSION SET
### Role
- Grants permissions for test codeunits and helpers
- Used in test apps for running tests
- Typically only includes codeunit permissions

### Identification Clues
- Name contains "Test" (e.g., `ApiCoreTest`, `TestPermission`)
- Located in test app (`*.Test` namespace)
- Primarily contains codeunit permissions for test objects
- May include helper codeunits and stubs

### Critical Requirements
- **MUST** have `Caption = '<Name>', MaxLength = 30;`
- **MUST** have `Assignable = true`
- **SHOULD** only include test-related objects
- **SHOULD** be in test app namespace

### Canonical NemBetaling Example
```al
namespace FinnPedersenFrance.ApiCore.Test.Permissions;

using FinnPedersenFrance.ApiCore.Test.ApiOperation;
using FinnPedersenFrance.ApiCore.Test.Helpers;

permissionset 52100 ApiCoreTest
{
    Assignable = true;
    Caption = 'Api Core Test', MaxLength = 30;
    Permissions = codeunit "Test Api Operation" = X,
        codeunit "Test Api Operation Mgt" = X,
        codeunit "Test Helper" = X;
}
```

---

# 🔍 HOW AN AGENT IDENTIFIES A PERMISSION SET TYPE

Agents must use these signals:

- **Name pattern**:
  - Matches app name = App Permission Set
  - Contains "Test" = Test Permission Set
- **Location**:
  - In `Permissions` folder = App Permission Set
  - In test app = Test Permission Set
- **Content**:
  - Includes tables, pages, codeunits = App Permission Set
  - Primarily codeunits (test helpers) = Test Permission Set
- **Namespace**:
  - Main app namespace = App Permission Set
  - Test app namespace (`*.Test`) = Test Permission Set

---

# 📋 PERMISSION SET PATTERNS

## Permission Syntax
- **Table permissions**: `table "Table Name" = X` (Execute permission)
- **Tabledata permissions**: `tabledata "Table Name" = RIMD` (Read, Insert, Modify, Delete)
- **Codeunit permissions**: `codeunit "Codeunit Name" = X` (Execute permission)
- **Page permissions**: `page "Page Name" = X` (Execute permission)

## Using Statements
- **SHOULD** use `using` statements to organize permissions by namespace
- Groups related objects together for readability
- Example:
```al
using FinnPedersenFrance.ApiCore.ApiOperation;
using FinnPedersenFrance.ApiCore.Json;
```

## Permission Set Numbering
- App permission sets typically use app-specific number ranges
- Test permission sets typically use number ranges above app ranges
- Examples:
  - `ApiCore`: 52000
  - `ApiCoreTest`: 52100
  - `EasyPayment`: 50000
  - `TestPermission`: 50100

---

# ⚠️ COMMON VIOLATIONS TO WATCH FOR

1. **Missing MaxLength**: `Caption = 'Name';` without `MaxLength = 30;`
2. **Wrong MaxLength**: `MaxLength = 50;` instead of `MaxLength = 30;`
3. **Missing Caption**: No `Caption` property at all
4. **Missing Assignable**: `Assignable = true` not set
5. **Wrong folder**: Not in `Permissions` folder (e.g., using `<Domain>Permissions` folder instead)
6. **Missing using statements**: Permissions not organized by namespace

---

This enables:

**"Create a permission set for ApiCore app."**  
**"Fix the permission set to comply with rules."**  
**"Add Caption with MaxLength = 30 to this permission set."**  
**"Generate permission set for extension objects and add required properties."**
