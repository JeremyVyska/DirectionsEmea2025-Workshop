---
applyTo: "**/*.XMLport.al"
description: "AL XmlPort patterns and best practices"
---

# XMLport Rules — Full Taxonomy (NemBetaling Specific)

## 🎯 Goal
Enable the agent to identify XMLport patterns and enforce correct behavior.

---

# ⚠️ CRITICAL REQUIREMENTS FOR ALL XMLPORTS

## Naming Convention
- XMLports **MUST** follow clear naming patterns based on their purpose
- Use descriptive names that indicate the XMLport's function
- Examples: `"Import Exch. Rate"`, `"Export Payment Data"`, `"Import Customer Data"`

## Documentation Requirements
- **MUST** have `Caption` property
- **SHOULD** have `ApplicationArea = All` (unless specific area required)
- **SHOULD** have `UsageCategory` property (Tasks, Administration, etc.)

## XMLport Properties Pattern
- **SHOULD** have `Direction` property (`Import`, `Export`, or `Both`)
- **SHOULD** have `Format` property (`Xml`, `Variable Text`, `Fixed Text`)
- **SHOULD** have `Extensible = true` (unless there's a specific reason not to)

---

# ⭐ KINDS OF XMLPORTS

## IMPORT XMLPORT
### Role
- Imports data from external files (XML, CSV, etc.) into Business Central
- Processes incoming data and inserts/updates records
- Used for data migration, integration, batch imports

### Identification Clues
- `Direction = Import` (or omitted, defaults to Import)
- Has `schema` section with `textelement` and `tableelement` definitions
- Has `OnAfterAssignVariable` triggers for data processing
- Has `OnPostXmlPort` trigger for final processing

### Critical Requirements
- **MUST** have `Caption` property
- **SHOULD** have `Direction = Import` (explicit)
- **SHOULD** have `ApplicationArea = All` (unless specific area required)
- **SHOULD** have `UsageCategory = Tasks` or `UsageCategory = Administration`

### Canonical Example
```al
xmlport 50003 "Import Exch. Rate"
{
    ApplicationArea = All;
    Caption = 'Import Exch. Rate';
    Direction = Import;
    Format = Xml;
    UsageCategory = Tasks;

    schema
    {
        textelement(exchangerates)
        {
            XmlName = 'exchangerates';
            tableelement(CurrencyExchRate; "Currency Exchange Rate")
            {
                XmlName = 'currencyexchrate';
                fieldelement(CurrencyCode; CurrencyExchRate."Currency Code") { }
                fieldelement(StartingDate; CurrencyExchRate."Starting Date") { }
                fieldelement(ExchangeRateAmount; CurrencyExchRate."Exchange Rate Amount") { }
            }
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

    trigger OnPostXmlPort()
    begin
        // Final processing logic
    end;
}
```

---

## EXPORT XMLPORT
### Role
- Exports data from Business Central to external files (XML, CSV, etc.)
- Generates files for external systems
- Used for data export, integration, reporting

### Identification Clues
- `Direction = Export`
- Has `schema` section with `tableelement` definitions
- Has `OnPreXmlPort` trigger for initialization
- May have `OnAfterGetRecord` triggers for data transformation

### Critical Requirements
- **MUST** have `Caption` property
- **MUST** have `Direction = Export`
- **SHOULD** have `ApplicationArea = All` (unless specific area required)
- **SHOULD** have `UsageCategory = Tasks` or `UsageCategory = Administration`

---

## BOTH XMLPORT
### Role
- Supports both import and export operations
- Used when the same structure is used for both directions
- Less common pattern

### Identification Clues
- `Direction = Both`
- Has triggers for both import and export operations
- Schema supports bidirectional data flow

### Critical Requirements
- **MUST** have `Caption` property
- **MUST** have `Direction = Both`
- **SHOULD** have `ApplicationArea = All` (unless specific area required)

---

# 🔍 HOW AN AGENT IDENTIFIES AN XMLPORT TYPE

- **Direction property**: `Import` = Import XMLport, `Export` = Export XMLport, `Both` = Both XMLport
- **Schema structure**: `tableelement` with `fieldelement` = typically Import/Export, `textelement` = typically Import
- **Trigger patterns**: `OnPostXmlPort` = Import, `OnPreXmlPort` = Export

---

# ⭐ BEST PRACTICES

## When to Use Import XMLports
- Data migration from external systems
- Regular data imports (exchange rates, customer data, etc.)
- Integration with external services
- Batch data loading

## When to Use Export XMLports
- Data export for external systems
- Integration feeds
- Reporting to external formats
- Data backup operations

## Schema Guidelines
- Use clear, descriptive element names
- Use `XmlName` to map to external XML structure
- Use `tableelement` for database records
- Use `textelement` for XML structure
- Use `fieldelement` for field mapping

## Request Page Guidelines
- Use for import/export parameters
- Provide file selection for imports
- Provide file path/name for exports
- Group related fields logically

## Trigger Guidelines
- `OnPreXmlPort`: Initialize variables, validate setup
- `OnPostXmlPort`: Final processing, cleanup, validation
- `OnAfterAssignVariable`: Process individual field values
- `OnAfterGetRecord`: Transform data before export

---

This enables:

**"Create an import XMLport for exchange rates."**  
**"Fix the XMLport to comply with rules."**  
**"Add Caption and Direction to this XMLport."**  
**"Create an export XMLport for payment data."**
