---
applyTo: "**/*.Profile.al"
description: "AL Profile patterns and best practices"
---

# Profile Rules — Full Taxonomy (NemBetaling Specific)

## 🎯 Goal
Enable the agent to identify profile patterns and enforce correct behavior.

---

# ⚠️ CRITICAL REQUIREMENTS FOR ALL PROFILES

## Naming Convention
- Profiles **MUST** follow clear naming patterns
- Use descriptive names that match the role or purpose
- Examples: `Clipper`, `Accountant`, `Sales Manager`, `Shipping Manager`

## Documentation Requirements
- **MUST** have `Caption` property
- **MUST** have `ProfileDescription` property
- **SHOULD** have `Enabled = true` (unless profile is disabled)
- **SHOULD** have `Promoted = true` for main profiles

## Profile Properties Pattern
- **MUST** have `RoleCenter` property pointing to a Role Center page
- **SHOULD** have `Enabled = true` to make profile available
- **SHOULD** have `Promoted = true` to show in profile list
- **SHOULD** have `Extensible = true` (unless there's a specific reason not to)

---

# ⭐ KINDS OF PROFILES

## ROLE CENTER PROFILE
### Role
- Defines a user profile with a specific Role Center
- Provides personalized workspace for different user roles
- Links to Role Center pages with navigation and actions

### Identification Clues
- Has `RoleCenter` property pointing to a Role Center page
- Has `Caption` and `ProfileDescription` properties
- Has `Enabled = true` and `Promoted = true`
- Located in RoleCenter folder or similar

### Critical Requirements
- **MUST** have `Caption` property
- **MUST** have `ProfileDescription` property
- **MUST** have `RoleCenter` property
- **SHOULD** have `Enabled = true`
- **SHOULD** have `Promoted = true`

### Canonical Example
```al
profile Clipper
{
    Caption = 'Clipper';
    Enabled = true;
    ProfileDescription = 'Clipper';
    Promoted = true;
    RoleCenter = "Clipper Role Center";
}
```

---

## DISABLED PROFILE
### Role
- Profile that is not currently active
- May be used for testing or future use
- Not shown in profile selection

### Identification Clues
- Has `Enabled = false`
- May have `Promoted = false`
- Still has required properties but is inactive

### Critical Requirements
- **MUST** have `Caption` property
- **MUST** have `ProfileDescription` property
- **MUST** have `RoleCenter` property
- **MUST** have `Enabled = false` (explicit)

---

# 🔍 HOW AN AGENT IDENTIFIES A PROFILE TYPE

- **Enabled property**: `true` = Active Profile, `false` = Disabled Profile
- **RoleCenter property**: Presence indicates Role Center Profile
- **Promoted property**: `true` = Main profile, `false` = Secondary profile

---

# ⭐ BEST PRACTICES

## When to Create Profiles
- When defining user roles for the application
- When providing customized workspaces
- When organizing navigation by user type
- When implementing role-based access

## Profile Naming Guidelines
- Use clear, descriptive names
- Match the role or purpose
- Avoid abbreviations unless standard
- Use consistent naming patterns

## RoleCenter Guidelines
- Link to appropriate Role Center pages
- Ensure Role Center pages are properly configured
- Provide relevant navigation and actions
- Match profile purpose to Role Center functionality

## ProfileDescription Guidelines
- Should match Caption or provide additional context
- Used in profile selection UI
- Should be clear and descriptive
- Keep concise but informative

---

This enables:

**"Create a profile for Clipper role."**  
**"Fix the profile to comply with rules."**  
**"Add Caption and ProfileDescription to this profile."**  
**"Create a profile linking to a Role Center."**
