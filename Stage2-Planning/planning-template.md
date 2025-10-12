# Planning Template for Agentic Collaboration

Use this template structure when collaborating with AI on new features.

## General Feature Planning

```
I need to implement [FEATURE NAME].

Before writing code, help me plan:

1. What are the main considerations for this feature?
2. What data structures or enums should we use?
3. What validation and error handling do we need?
4. Where in the codebase will this feature impact?
5. What AL best practices are relevant here?
6. Are there any performance implications?
```

## Planning for Data Model Changes

```
I need to add [FIELD/TABLE] to support [BUSINESS REQUIREMENT].

Before implementing, analyze:

1. Should this be a field, enum, or separate table?
2. What's the appropriate data type and validation?
3. What relationships or dependencies exist?
4. What queries or filters will use this data?
5. Do we need indexes for performance?
6. Which pages and codeunits need updates?
```

## Planning for Business Logic

```
I need to implement [BUSINESS RULE/LOGIC].

Help me think through:

1. Where should this logic live (table, codeunit, page)?
2. What are the edge cases and error conditions?
3. What validation do we need before executing this logic?
4. How does this interact with existing features?
5. What should happen if the operation fails?
6. Do we need interface abstraction for extensibility?
```

## Planning for Performance Features

```
I need to optimize [QUERY/OPERATION] that handles [DATA VOLUME].

Before making changes:

1. What's the current performance bottleneck?
2. What indexes would help this query?
3. Should we use SetLoadFields or temporary tables?
4. How can we minimize database roundtrips?
5. What performance tests should we add?
6. Are there AL best practices for this scenario?
```

## Planning for Testing

```
I need to test [FEATURE/COMPONENT].

Help me design test coverage:

1. What are the main scenarios to test (happy path)?
2. What edge cases and error conditions exist?
3. What test data setup do we need?
4. Should we test performance/scalability?
5. What assertions prove the feature works correctly?
6. Are there integration points that need end-to-end tests?
```

## Example: Stage 2 Exercise Template

```
I need to improve the maintenance status implementation in the Equipment table.

Current implementation: [describe what exists from Stage 1]

Before making changes, help me plan:

1. What considerations should we have for tracking equipment maintenance status?
2. What's the best way to model this in AL (enum, fields, validation)?
3. How should maintenance status affect equipment availability for bookings?
4. Where else in the codebase will this impact (AvailabilityMgt, pages, etc.)?
5. What AL best practices should we follow for this feature?
```

---

## Tips for Effective Planning Conversations

### Do:
✅ Ask open-ended questions about considerations and implications
✅ Request the AI to identify edge cases and validation needs
✅ Ask where in the codebase the change will impact
✅ Seek AL best practice recommendations
✅ Review and refine the plan before implementing

### Don't:
❌ Jump straight to implementation without discussion
❌ Accept the first suggestion without exploring alternatives
❌ Skip asking about validation and error handling
❌ Ignore cross-file and cross-layer dependencies
❌ Forget to ask about performance implications

---

## Progression

**Autocomplete Mode:**
> "Add a discount field to bookings"

**Planning Mode:**
> "I need to support discounts on bookings. What are the different ways discounts could be applied, and what validation would we need?"

**Complete Agentic Mode (Stage 3):**
> "I need to support discounts on bookings. Review the AL performance patterns and best practices, then suggest an implementation that follows BC standards and includes comprehensive tests."

---

Use this template as a starting point - adapt it to your specific context and domain.
