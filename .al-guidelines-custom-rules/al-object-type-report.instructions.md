---
applyTo: "**/*.Report.al"
description: "AL Report patterns and best practices"
---

# Report Rules — Full Taxonomy (NemBetaling Specific)

## 🎯 Goal
Enable the agent to identify report patterns and enforce correct behavior.

---

# ⚠️ CRITICAL REQUIREMENTS FOR ALL REPORTS

## Naming Convention
- Reports **MUST** follow clear naming patterns based on their purpose
- Use descriptive names that indicate the report's function
- Examples: `"Payment Request Report"`, `"Import Excel to GJL"`, `"Sales Invoice Report"`

## Documentation Requirements
- **MUST** have `Caption` property
- **MUST** have `ApplicationArea = All` (unless specific area required)
- **SHOULD** have `UsageCategory` property (Reports, Tasks, Administration, etc.)
- **SHOULD** have `AboutText` and `AboutTitle` for user-facing reports

## Report Properties Pattern
- **MUST** have `ProcessingOnly` property set appropriately
  - `ProcessingOnly = true` for reports that only process data (no output)
  - `ProcessingOnly = false` (or omitted) for reports that generate output
- **SHOULD** have `UsageCategory` property
- **SHOULD** have `Extensible = true` (unless there's a specific reason not to)

---

# ⭐ KINDS OF REPORTS

## PROCESSING REPORT
### Role
- Processes data without generating visual output
- Used for batch operations, imports, data transformations
- No visual layout required

### Identification Clues
- `ProcessingOnly = true`
- Has `dataset` with `dataitem` but minimal or no `column` definitions
- Has `requestpage` for user input
- Triggers like `OnPostDataItem` contain processing logic

### Critical Requirements
- **MUST** have `ProcessingOnly = true`
- **MUST** have `Caption` property
- **MUST** have `ApplicationArea = All` (unless specific area required)
- **SHOULD** have `UsageCategory = Tasks` or `UsageCategory = Administration`

### Canonical Example
```al
report 50000 "Import Excel to GJL"
{
    ApplicationArea = All;
    Caption = 'Import Excel to GJL';
    ProcessingOnly = true;
    UsageCategory = Administration;

    dataset
    {
        dataitem(Integer; "Integer")
        {
            DataItemTableView = sorting(Number);
            
            trigger OnPostDataItem()
            begin
                // Processing logic here
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                // Request page fields
            }
        }
    }
}
```

---

## OUTPUT REPORT
### Role
- Generates visual output (print, PDF, screen)
- Used for documents, lists, analysis reports
- Has layout with columns and sections

### Identification Clues
- `ProcessingOnly = false` (or omitted)
- Has `dataset` with `dataitem` and `column` definitions
- Has `layout` section with report sections
- May have `labels` section

### Critical Requirements
- **MUST** have `Caption` property
- **MUST** have `ApplicationArea = All` (unless specific area required)
- **SHOULD** have `UsageCategory = Reports`
- **SHOULD** have `AboutText` and `AboutTitle` for user-facing reports

---

# 🔍 HOW AN AGENT IDENTIFIES A REPORT TYPE

- **ProcessingOnly property**: `true` = Processing Report, `false`/omitted = Output Report
- **Layout presence**: Has `layout` section = Output Report
- **Column definitions**: Has `column` definitions = Output Report
- **Request page**: Both types may have request pages for user input

---

# ⭐ BEST PRACTICES

## When to Use Processing Reports
- Data imports and exports
- Batch processing operations
- Data transformations
- Background tasks

## When to Use Output Reports
- Document printing (invoices, orders, etc.)
- List reports
- Analysis and summary reports
- User-facing reports

## Request Page Guidelines
- Use for user input and parameters
- Group related fields logically
- Provide clear captions and tooltips
- Use appropriate field types (Date, Code, Text, etc.)

## Dataset Guidelines
- Use appropriate dataitems (tables, integers for loops, etc.)
- Use `DataItemTableView` for default sorting
- Use triggers appropriately (`OnPreDataItem`, `OnAfterGetRecord`, `OnPostDataItem`)

---

This enables:

**"Create a processing report for importing Excel data."**  
**"Fix the report to comply with rules."**  
**"Add Caption and ApplicationArea to this report."**  
**"Create an output report for printing invoices."**
