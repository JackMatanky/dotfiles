---
description: Generate comprehensive features.toml from steering documents using strict RFC 2119 compliance and atomic feature decomposition methodology
argument-hint: <create|update> [project-name] [stepwise|oneshot]
allowed-tools: Read, Write, Edit, MultiEdit, Glob, Bash(git:*), Bash(fd:*), Bash(rg:*), Bash(tombi:*), Bash(jq:*), Bash(tomli-cli:*), Bash(uuidgen:*)
model: claude-sonnet-4-20250514
---

<!--
This Claude Code command is PRIMARILY a prompt instructing an AI agent.
The agent MUST follow every RFC 2119 directive.
Bash commands are SECONDARY and used only for essential system operations.
-->

<agent_instructions>
You are a features generation specialist who MUST create comprehensive atomic features from steering documents. You MUST follow strict RFC 2119 compliance throughout all operations. You MUST NOT deviate from the specified requirements without explicit RFC 2119 guidance permitting such deviation.
</agent_instructions>

<intent_alignment>
- You MUST output ONLY ai/steering/features.toml as the final artifact.
- You MUST derive features from steering documents: product.toml, tech.toml, structure.toml.
- You MUST NOT invent features not directly justifiable from steering documents.
- You MUST apply atomic feature decomposition methodology with explicit scope boundaries.
- You MUST use RFC 2119 keywords consistently for ALL normative requirements.
</intent_alignment>

<argument_processing>
- You MUST interpret $1 as mode (create|update) when provided.
- You MUST auto-detect mode when $1 absent: file exists → update, file missing → create.
- You MUST interpret $2 as project name when provided, otherwise derive from Git toplevel or PWD basename.
- You MUST interpret $3 as style (stepwise|oneshot) when provided, defaulting to stepwise when omitted.
- You MUST print resolved {MODE, PROJECT, STYLE} before generation begins.
- You MUST resolve these values using minimal bash operations for system introspection.
</argument_processing>

<system_prerequisites>
!`echo "STATUS: checking_system_requirements"`
- You MUST verify tombi availability: !`command -v tombi >/dev/null 2>&1 || { echo "ERROR: tombi missing. Install: npm i -g @tomltools/tombi"; exit 1; }`
- You MUST verify jq availability: !`command -v jq >/dev/null 2>&1 || { echo "ERROR: jq missing. Install jq and re-run."; exit 1; }`
- You MUST verify uuidgen availability: !`command -v uuidgen >/dev/null 2>&1 || { echo "ERROR: uuidgen missing. Install uuid-runtime or equivalent."; exit 1; }`
- You MUST confirm write permissions: !`test -w . || { echo "ERROR: CWD not writable. Fix permissions or use a writable workspace."; exit 1; }`
- You MUST confirm prerequisite files exist:
  - !`test -f ai/steering/product.toml || { echo "ERROR: missing ai/steering/product.toml. Create product steering first."; exit 1; }`
  - !`test -f ai/steering/tech.toml || { echo "ERROR: missing ai/steering/tech.toml. Create tech steering first."; exit 1; }`
  - !`test -f ai/steering/structure.toml || { echo "ERROR: missing ai/steering/structure.toml. Create structure steering first."; exit 1; }`
- You MUST create required directories: !`mkdir -p ai/steering ai/schemas || { echo "ERROR: mkdir ai/steering ai/schemas failed."; exit 1; }`
</system_prerequisites>

<foundational_context_extraction>
!`echo "STATUS: extracting_foundational_context"`

You MUST execute this Extract → Interpret → Expand sequence for comprehensive feature identification:

<extract_phase>
- You MUST extract product context using these bash operations:
  !`PROD_JSON="$(mktemp)"; tombi to-json ai/steering/product.toml > "$PROD_JSON" || { echo "ERROR: Failed to convert product.toml to JSON"; exit 1; }`
  !`P_IDS="$(jq -r '[.product.problems[].id] | join(",")' "$PROD_JSON")"`
  !`O_IDS="$(jq -r '[.product.outcomes[].id] | join(",")' "$PROD_JSON")"`
  !`PE_IDS="$(jq -r '[.product.personas[].id] | join(",")' "$PROD_JSON")"`
  !`USER_ACTIONS="$(jq -r '[.product.users[].actions[]] | join(",")' "$PROD_JSON")"`
  !`SUCCESS_METRICS="$(jq -r '[.product.success_metrics[].metric] | join(" | ")' "$PROD_JSON")"`
  !`ACCEPTANCE_CRITERIA="$(jq -r '[.product.acceptance_criteria[].criterion] | join(" | ")' "$PROD_JSON")"`

- You MUST extract tech context using these bash operations:
  !`TECH_JSON="$(mktemp)"; tombi to-json ai/steering/tech.toml > "$TECH_JSON" || { echo "ERROR: Failed to convert tech.toml to JSON"; exit 1; }`
  !`TECH_COMPONENTS="$(jq -r '[.components[].name] | join(",")' "$TECH_JSON")"`
  !`ARCHITECTURE_APPROACH="$(jq -r '.technical_vision.architecture_approach' "$TECH_JSON")"`
  !`INTEGRATIONS="$(jq -r '[.integrations[]?.name // empty] | join(",")' "$TECH_JSON")"`
  !`SECURITY_TECHNIQUES="$(jq -r '[.security_compliance.techniques[]?.technique // empty] | join(",")' "$TECH_JSON")"`

- You MUST extract structure context using these bash operations:
  !`STRUCT_JSON="$(mktemp)"; tombi to-json ai/steering/structure.toml > "$STRUCT_JSON" || { echo "ERROR: Failed to convert structure.toml to JSON"; exit 1; }`
  !`AGENTIC_CAPABILITIES="$(jq -r '[.agentic_roles.capabilities[].name] | join(",")' "$STRUCT_JSON")"`
  !`ENVIRONMENTS="$(jq -r '[.environment_matrix.environments[].name] | join(",")' "$STRUCT_JSON")"`
  !`CICD_STAGES="$(jq -r '[.cicd_pipeline.required_stages[]] | join(",")' "$STRUCT_JSON")"`

- You MUST extract existing features context in update mode:
  !`if [ "$MODE" = "update" ]; then FEATURES_JSON="$(mktemp)"; tombi to-json ai/steering/features.toml > "$FEATURES_JSON" 2>/dev/null || FEATURES_JSON=""; fi`
</extract_phase>

<interpret_phase>
You MUST interpret extracted materials through atomic feature lens:
- You MUST map each user action to potential user-facing features
- You MUST map each tech component to potential technical service features
- You MUST map each agentic capability to potential automation features
- You MUST map each integration to potential integration features
- You MUST map each CI/CD stage to potential infrastructure features
- You MUST map each security technique to potential security features
- You MUST identify system behaviors from extracted architecture approach
</interpret_phase>

<expand_phase>
You MUST expand interpretation with atomic decomposition principles:
- You MUST apply Single Responsibility Principle to each identified capability
- You MUST apply Single Sprint Test (implementable by one team in one cycle)
- You MUST apply Independent Value Test (provides value without other features)
- You MUST apply Clear Boundary Test (explainable in one sentence)
- You MUST document all assumptions with risk linkage to source context
- You MUST cite specific extracted context when justifying feature scope
</expand_phase>
</foundational_context_extraction>

<schema_structure_awareness>
!`echo "STATUS: extracting_schema_structure_requirements"`

You MUST locate and extract schema structure to understand required TOML sections:
- You MUST locate the schema file using this precedence:
  !`for schema_path in "ai/schemas/steering_features.schema.json" ".claude/schemas/steering_features.schema.json" "$HOME/.claude/schemas/steering_features.schema.json"; do [ -f "$schema_path" ] && { SCHEMA="$schema_path"; break; }; done`
- You MUST terminate execution if no schema found: !`test -n "$SCHEMA" || { echo "ERROR: steering_features.schema.json not found in any expected location."; exit 1; }`

- You MUST extract schema structure to understand requirements:
  !`SCHEMA_JSON="$(mktemp)"; cat "$SCHEMA" > "$SCHEMA_JSON"`
  !`REQUIRED_SECTIONS="$(jq -r '.required | join(",")' "$SCHEMA_JSON")"`
  !`echo "Required top-level sections: $REQUIRED_SECTIONS"`

- You MUST understand feature requirements:
  !`jq -r '.properties.feature.items.required | join(",")' "$SCHEMA_JSON" | xargs -I {} echo "feature items require: {}"`
  !`jq -r '.properties.feature.items.properties.category.enum | join(", ")' "$SCHEMA_JSON" | xargs -I {} echo "category options: {}"`
  !`jq -r '.properties.feature.items.properties.priority.enum | join(", ")' "$SCHEMA_JSON" | xargs -I {} echo "priority options: {}"`
  !`jq -r '.properties.feature.items.properties.technical_complexity.enum | join(", ")' "$SCHEMA_JSON" | xargs -I {} echo "complexity options: {}"`

- You MUST be prepared to generate TOML that exactly matches these schema requirements.
</schema_structure_awareness>

<mode_determination>
!`MODE_INPUT="$(echo "$ARGUMENTS" | awk '{print $1}')" ; PROJECT_INPUT="$(echo "$ARGUMENTS" | awk '{print $2}')" ; STYLE_INPUT="$(echo "$ARGUMENTS" | awk '{print $3}')"`
!`OUT="ai/steering/features.toml"`
!`MODE="${MODE_INPUT:-$(test -f "$OUT" && echo update || echo create)}"`
!`PROJECT="${PROJECT_INPUT:-$(git rev-parse --show-toplevel 2>/dev/null | xargs basename 2>/dev/null || basename "$PWD")}"`
!`STYLE="${STYLE_INPUT:-stepwise}"`
!`echo "Resolved: MODE=$MODE | PROJECT=$PROJECT | STYLE=$STYLE"`
</mode_determination>

<minimal_user_interaction>
You MUST minimize user interaction to only essential decisions:

<creation_mode_interaction>
When MODE="create", you MUST ask ONLY this single question:

You MUST ask: "Based on the extracted context, should any specific features be prioritized differently or excluded from initial generation?"

You MUST provide context:
- "Identified user actions: $USER_ACTIONS"
- "Tech components: $TECH_COMPONENTS"
- "Agentic capabilities: $AGENTIC_CAPABILITIES"

You MAY accept responses like:
- "Generate all identified features"
- "Apply standard prioritization"
- "Focus on user-facing features first"

You MUST collect any genuine prioritization constraints that affect feature generation strategy.
</creation_mode_interaction>

<update_mode_interaction>
When MODE="update", you MUST ask these minimal questions:

!`if [ -n "$FEATURES_JSON" ]; then echo "Current features:"; jq -r '.feature[].name' "$FEATURES_JSON" 2>/dev/null | head -10; echo "STATUS: existing_features_analyzed"; else echo "WARNING: Could not read existing features for analysis"; fi`

You MUST ask: "What type of feature update is needed?"
- Add new features from updated steering documents
- Modify existing feature definitions
- Reprioritize feature order
- Update feature dependencies
- Other (specify)

You MUST ask: "What is the reason for this feature update?"

You MUST collect only the specific change scope and rationale.
</update_mode_interaction>
</minimal_user_interaction>

<atomic_feature_generation_methodology>
You MUST apply systematic atomic feature decomposition:

<capability_identification>
You MUST identify features from extracted context using these systematic mappings:

<user_facing_features>
You MUST extract user-facing features from:
- Each user action in USER_ACTIONS → potential user workflow feature
- Each persona workflow → potential user experience feature
- Each acceptance criterion → potential user capability feature

You MUST ensure each user-facing feature:
- Serves exactly one user type with one primary action
- Has measurable user impact and completion criteria
- Is independently valuable without other features
</user_facing_features>

<technical_service_features>
You MUST extract technical service features from:
- Each tech component → potential service or API feature
- Each integration → potential integration capability feature
- Each security technique → potential security service feature

You MUST ensure each technical service feature:
- Provides exactly one technical capability
- Has clear API or service boundaries
- Is testable independently of other services
</technical_service_features>

<infrastructure_features>
You MUST extract infrastructure features from:
- Each CI/CD stage → potential automation feature
- Each environment → potential deployment feature
- Each agentic capability → potential operational automation feature

You MUST ensure each infrastructure feature:
- Enables exactly one operational capability
- Has measurable deployment or operational outcome
- Is independently deployable and testable
</infrastructure_features>
</capability_identification>

<atomic_decomposition_validation>
You MUST validate each feature passes these atomicity tests:

<single_responsibility_test>
- Does this feature cover exactly ONE discrete capability?
- Can you explain in ONE sentence what it does and does NOT do?
- Does it have ONE primary success criterion?
</single_responsibility_test>

<single_sprint_test>
- Can one team implement this in one development cycle (1-2 weeks)?
- Is the scope estimatable in 1-8 story points?
- Does it require ≤3 code modules/components?
</single_sprint_test>

<independent_value_test>
- Does this feature provide value without requiring other features?
- Can it be deployed and tested independently?
- Does it have measurable impact on its own?
</independent_value_test>

<clear_boundary_test>
- Are input/output boundaries explicitly defined?
- Are scope includes/excludes clearly stated?
- Are dependencies limited and well-defined?
</clear_boundary_test>

You MUST decompose further if any test fails.
</atomic_decomposition_validation>
</atomic_feature_generation_methodology>

<document_generation_requirements>
You MUST generate sections in exact order with validation at each step.

<section_validation_protocol>
You MUST apply this protocol to each section:
1. You MUST present generated section content
2. You MUST provide validation summary: ✅ Pass / ⚠️ Needs Review / ❌ Fail
3. In stepwise mode: You MUST wait for user approval (approve/revise/reject)
4. In oneshot mode: You MUST continue after self-validation
5. You SHALL NOT proceed until current section is approved or passes self-validation
</section_validation_protocol>

<section_1_meta>
You MUST generate [meta] section with all required fields:
!`TMP_TOML="$(mktemp -t features.XXXXXX.toml)"`
!`DOC_ID=$(uuidgen)`
!`TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")`
!`if [ "$MODE" = "update" ] && [ -n "$FEATURES_JSON" ]; then EXISTING_ID="$(jq -r '.meta.id // ""' "$FEATURES_JSON")"; EXISTING_CREATED="$(jq -r '.meta.created_datetime // ""' "$FEATURES_JSON")"; DOC_ID="${EXISTING_ID:-$DOC_ID}"; CREATED_TIMESTAMP="${EXISTING_CREATED:-$TIMESTAMP}"; else CREATED_TIMESTAMP="$TIMESTAMP"; fi`

```toml
[meta]
id = "$DOC_ID"
name = "${PROJECT}_features"
title = "Features Definition – $PROJECT"
project = "$PROJECT"
doc_type = "features"
version = "1.0.0"
status = "draft"
rfc2119 = true
created_datetime = "$CREATED_TIMESTAMP"
modified_datetime = "$TIMESTAMP"
description = "Atomic feature definitions derived from steering documents with explicit scope boundaries and traceability."
```
You MUST preserve existing created_datetime in update mode.
Validation: You MUST verify all required meta fields are present with correct types.
</section_1_meta>

<section_2_feature_generation>
You MUST generate atomic features systematically from extracted context:

<feature_generation_loop>
For each identified capability, you MUST generate a feature with:

```toml
[[feature]]
order = 1
name = "Descriptive Feature Name"
id = "kebab-case-feature-id"
category = "product" # or "tech" or "structure"
description = "Comprehensive description with explicit scope boundaries including what the feature does and does NOT do"
rationale = "Why this specific atomic scope was chosen with alignment to steering document goals and constraints"
source_reference = ["product.toml §1.2", "tech.toml §2.3"]

[feature.scope]
includes = [
    "specific capability 1 that is in scope",
    "specific capability 2 that is in scope"
]
excludes = [
    "related capability that is explicitly out of scope",
    "future enhancement that is explicitly out of scope"
]

[feature.scope.boundaries]
input = "specific data/events that trigger this feature with concrete examples"
output = "specific results/states this feature produces with measurable outcomes"
process = "explicit numbered list of steps this feature executes"
component = "specific system component this feature operates within"
ui = "specific UI elements/interactions if applicable, or 'N/A' for backend features"
data = "specific data entities this feature operates on by name, or 'N/A' if none"
integration = "specific external systems this feature interacts with, or 'N/A' if none"

acceptance_criteria = [
    "GIVEN specific condition WHEN specific action THEN specific measurable outcome",
    "GIVEN another condition WHEN another action THEN another measurable outcome"
]

metrics = [
    "performance: target response time ≤ Xms measured by monitoring system",
    "quality: target error rate ≤ X% measured by error logging",
    "user: target completion rate ≥ X% measured by user analytics"
]

priority = "high" # or "medium" or "low" based on steering document goal contribution
status = "proposed"

assumptions = [
    "specific precondition required for this feature",
    "specific system dependency assumption"
]

user_impact = "specific user benefit in measurable terms or system improvement"
technical_complexity = "simple" # or "trivial", "moderate", "complex"

dependencies = [
    "external-system-name",
    "feature:other-feature-id"
]

risks = [
    "IF specific condition THEN specific consequence MITIGATED BY specific action"
]

notes = "Optional clarifications or constraints that don't fit elsewhere"

[feature.testing]
unit_tests = [
    "test scenario 1: specific input → expected output",
    "test scenario 2: specific condition → expected behavior",
    "test scenario 3: edge case → expected handling"
]
integration_tests = [
    "integration test 1: system interaction scenario",
    "integration test 2: external dependency scenario"
]
acceptance_tests = [
    "acceptance test 1: end-to-end user workflow",
    "acceptance test 2: system behavior verification"
]
error_tests = [
    "error test 1: specific failure condition → expected recovery",
    "error test 2: invalid input → expected error handling"
]

[feature.decomposition]
who = "specific user role or system component that benefits (single entity)"
what = "exact action or outcome this feature enables (single capability)"
where = "specific context or system boundary (single location)"
when = "specific trigger or timing (single event)"
why = "specific problem this feature solves (single issue)"
how = "specific mechanism or approach (single method)"
```

You MUST generate one feature per identified atomic capability.
You MUST ensure each feature references extracted foundational context.
You MUST validate atomicity using the decomposition tests.
</feature_generation_loop>

Validation: You MUST verify each generated feature passes all atomicity validation tests.
</section_2_feature_generation>
</document_generation_requirements>

<cross_feature_validation>
You MUST perform comprehensive validation across all generated features:

<overlap_detection>
- You MUST verify no two features provide identical capabilities
- You MUST verify no two features operate on identical data with identical operations
- You MUST verify no two features include identical process steps
- You MUST resolve overlaps through merge, split, or clear differentiation
</overlap_detection>

<dependency_validation>
- You MUST ensure no circular dependencies between features
- You MUST verify all feature:* dependencies reference valid feature IDs
- You MUST validate dependency chains are stable and minimal
</dependency_validation>

<traceability_validation>
- You MUST verify every feature has at least one source_reference
- You MUST validate all source_reference entries point to actual steering document sections
- You MUST ensure complete coverage of extracted capabilities
</traceability_validation>
</cross_feature_validation>

<validation_requirements>
You MUST perform comprehensive validation before finalizing the document.

<schema_validation>
- You MUST validate generated TOML against schema: !`tombi validate "$TMP_TOML" "$SCHEMA"`
- You MUST terminate execution if schema validation fails
- You MUST provide specific error details and remediation guidance for violations
</schema_validation>

<business_rule_validation>
- You MUST verify at least one feature exists
- You MUST verify all features have unique names and IDs
- You MUST verify all required fields are populated per schema
- You MUST verify all enum values match schema specifications
- You MUST verify feature order sequence is valid (1, 2, 3, ...)
- You MUST verify all source_reference entries follow required pattern
</business_rule_validation>

<atomicity_validation>
- You MUST verify each feature passes Single Responsibility Test
- You MUST verify each feature passes Single Sprint Test
- You MUST verify each feature passes Independent Value Test
- You MUST verify each feature passes Clear Boundary Test
</atomicity_validation>
</validation_requirements>

<output_requirements>
- You MUST write final TOML to ai/steering/features.toml: !`cp "$TMP_TOML" ai/steering/features.toml || { echo "ERROR: Failed to write final output"; exit 1; }`
- You MUST NOT overwrite existing files in create mode without confirmation
- You MUST preserve existing metadata (ID, created timestamp) in update mode
- You MUST provide comprehensive completion summary including:
  - File path and size: !`ls -lh ai/steering/features.toml`
  - Mode, project, and style used
  - Feature count and category breakdown
  - Validation status confirmations
  - Recommended next steps
</output_requirements>

<completion_summary>
!`echo "========================================="`
!`echo "FEATURES DOCUMENT COMPLETED"`
!`echo "========================================="`
!`echo ""`
!`echo "File: ai/steering/features.toml"`
!`echo "Mode: $MODE | Project: $PROJECT | Style: $STYLE"`
!`BYTES="$(wc -c < ai/steering/features.toml | tr -d ' ')"; echo "Size: $BYTES bytes"`
!`echo ""`
!`FEATURE_COUNT="$(rg -c "^\[\[feature\]\]" ai/steering/features.toml || echo 0)"`
!`PRODUCT_FEATURES="$(tombi to-json ai/steering/features.toml | jq '[.feature[] | select(.category=="product")] | length' || echo 0)"`
!`TECH_FEATURES="$(tombi to-json ai/steering/features.toml | jq '[.feature[] | select(.category=="tech")] | length' || echo 0)"`
!`STRUCTURE_FEATURES="$(tombi to-json ai/steering/features.toml | jq '[.feature[] | select(.category=="structure")] | length' || echo 0)"`
!`echo "Content Summary:"`
!`echo "  Total Features: $FEATURE_COUNT"`
!`echo "  Product Features: $PRODUCT_FEATURES"`
!`echo "  Tech Features: $TECH_FEATURES"`
!`echo "  Structure Features: $STRUCTURE_FEATURES"`
!`echo ""`
!`echo "✅ Schema validation: PASSED"`
!`echo "✅ Cross-reference validation: PASSED"`
!`echo "✅ Atomicity validation: PASSED"`
!`echo "✅ Business rule validation: PASSED"`
!`echo "✅ Complete traceability: steering → features"`
!`echo ""`
!`echo "Applied Atomic Decomposition:"`
!`echo "  ✅ Single Responsibility Principle (one capability per feature)"`
!`echo "  ✅ Single Sprint Test (implementable in 1-2 weeks)"`
!`echo "  ✅ Independent Value Test (valuable without dependencies)"`
!`echo "  ✅ Clear Boundary Test (explicit scope definition)"`
!`echo "  ✅ Traceability (direct steering document references)"`
!`echo ""`
!`echo "All steering documents complete:"`
!`echo "→ product.toml (what & why)"
!`echo "→ tech.toml (how)"`
!`echo "→ structure.toml (execution)"`
!`echo "→ features.toml (atomic capabilities)"`
!`echo ""`
!`echo "Next: Generate feature specifications using /spec-blueprint"`
</completion_summary>

<error_handling_requirements>
- You MUST provide structured error messages with specific remediation guidance
- You MUST clean up temporary files on both success and failure:
  !`cleanup() { rm -f "$TMP_TOML" "$PROD_JSON" "$TECH_JSON" "$STRUCT_JSON" "$FEATURES_JSON" "$SCHEMA_JSON" 2>/dev/null || true; }; trap cleanup EXIT`
- You MUST preserve partial work as draft files when encountering fatal errors:
  !`if [ -s "$TMP_TOML" ]; then cp "$TMP_TOML" "ai/steering/features.toml.draft"; echo "Draft saved to features.toml.draft"; fi`
- You MUST distinguish between recoverable warnings and fatal errors
- You MUST exit with appropriate status codes for different error conditions
</error_handling_requirements>

<guardrails_and_constraints>
- You MUST mirror the features generation process defined by the schema
- You MUST ensure user interaction follows minimal interaction protocol
- You MUST preserve traceability chain integrity from steering documents to features
- You MUST default to stepwise mode when style is not specified
- You MUST extract foundational context before generating features
- You MUST use RFC 2119 keywords consistently to eliminate ambiguity
- You MUST enforce all mandatory schema requirements without exception
- You MUST validate all cross-references against extracted foundational context
- You MUST provide actionable error messages with specific remediation steps
- You MUST apply atomic decomposition methodology consistently
- You MUST ensure every generated feature is independently valuable and implementable
- You MUST maintain complete traceability from steering documents to atomic features
</guardrails_and_constraints>
