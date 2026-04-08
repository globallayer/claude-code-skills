## Standup - {{DATE}}

### Completed
{{#each completed}}
- {{this}}
{{/each}}
{{#unless completed}}
- No completed items
{{/unless}}

### In Progress
{{#each in_progress}}
- {{this}}
{{/each}}
{{#unless in_progress}}
- No items in progress
{{/unless}}

### Blocked / Needs Input
{{#each blocked}}
- {{this}}
{{/each}}
{{#unless blocked}}
- None
{{/unless}}

### Next Up
{{#each next}}
- {{this}}
{{/each}}
{{#unless next}}
- To be determined
{{/unless}}

---
*Activity: {{commits}} commits, {{prs}} PRs, {{issues}} issues*
*Generated: {{timestamp}}*
