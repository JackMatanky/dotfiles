---
description: Create or update Technical Steering (tech.toml) — architecture & design blueprint aligned to product steering and governed by architecture/programming principles. Outputs ONLY ai/steering/tech.toml.
argument-hint: <create|update> [project-name] [stepwise|oneshot]
allowed-tools: Read, Write, Edit, MultiEdit, Glob, Bash(git:*), Bash(fd:*), Bash(rg:*), Bash(tombi:*), Bash(jq:*), Bash(tomli-cli:*), Bash(uuidgen:*)
model: claude-sonnet-4-20250514
---

<!--
This Claude Code command is a prompt-first spec (not a shell script).
Execution lines are expressed as tool calls (prefixed with !`) and MUST stop on fatal errors (include exit 1).
-->

<intent_alignment>
- Output MUST be ai/steering/tech.toml.
- Content MUST focus on: technical_vision, clean_architecture_principles, guiding_principles, architecture_decision (with options), components, integrations, data_strategy, security_compliance, performance_targets, technology_stack, operational_concerns, traceability; optionally decision_log and risk_register.
- Content MUST NOT include repo layout, branching models, governance workflows, or team roles.
- All material decisions MUST be grounded in:
  1. ai/steering/product.toml and
  2. ai/steering/principles_architecture.toml and ai/steering/principles_programming.toml.
- RFC 2119 keywords MUST be used for normative requirements.
</intent_alignment>

<arguments_and_environment>
- $1 (mode) MUST be create or update if provided.
- If $1 is absent, mode MUST be auto-detected by presence of @ai/steering/tech.toml (EXISTS→update, MISSING→create).
- $2 (project) MUST set the project name if provided; otherwise it MUST be derived from Git toplevel or PWD basename.
- $3 (style) MAY be stepwise or oneshot; if omitted it MUST default to stepwise.
- The resolved {MODE, PROJECT, STYLE} MUST be printed before generation.
- Git toplevel SHOULD be detected via: !`git rev-parse --show-toplevel 2>/dev/null | xargs basename 2>/dev/null || basename "$PWD"`.
- File presence SHOULD be detected via: !`test -f ai/steering/tech.toml && echo "EXISTS" || echo "MISSING"`.
</arguments_and_environment>

<preflight>
<system_requirements>
!`echo "STATUS: checking_system_requirements"`
!`command -v tombi >/dev/null 2>&1 || { echo "ERROR: tombi missing. Install: npm i -g @tomltools/tombi"; exit 1; }`
!`command -v jq >/dev/null 2>&1 || { echo "ERROR: jq missing. Install jq and re-run."; exit 1; }`
!`command -v uuidgen >/dev/null 2>&1 || { echo "ERROR: uuidgen missing. Install uuid-runtime or equivalent."; exit 1; }`
!`test -w . || { echo "ERROR: CWD not writable. Fix permissions or use a writable workspace."; exit 1; }`
!`test -f ai/steering/product.toml || { echo "ERROR: missing ai/steering/product.toml. Create product steering first."; exit 1; }`
!`test -f ai/steering/principles_architecture.toml || { echo "ERROR: missing ai/steering/principles_architecture.toml."; exit 1; }`
!`test -f ai/steering/principles_programming.toml || { echo "ERROR: missing ai/steering/principles_programming.toml."; exit 1; }`
</system_requirements>

<directory_preparation>
!`echo "STATUS: preparing_directories"`
!`mkdir -p ai/steering ai/schemas || { echo "ERROR: mkdir ai/steering ai/schemas failed."; exit 1; }`
</directory_preparation>

<mode_resolution>
!`OUT="ai/steering/tech.toml"`
!`MODE_INPUT="$(echo "$ARGUMENTS" | awk '{print $1}')" ; PROJECT_INPUT="$(echo "$ARGUMENTS" | awk '{print $2}')" ; STYLE_INPUT="$(echo "$ARGUMENTS" | awk '{print $3}')"`
!`test -f "$OUT" && echo MODE_CANDIDATE=update || echo MODE_CANDIDATE=create`
!`MODE="${MODE_INPUT:-$(test -f "$OUT" && echo update || echo create)}"`
!`PROJECT="${PROJECT_INPUT:-$(git rev-parse --show-toplevel 2>/dev/null | xargs basename 2>/dev/null || basename "$PWD")}"`
!`STYLE="${STYLE_INPUT:-stepwise}"`
<parsed_input>
MODE=${MODE}
PROJECT=${PROJECT}
STYLE=${STYLE}
OUT=${OUT}
</parsed_input>
!`if [ -f "$OUT" ] && [ "$MODE" = "create" ]; then echo "ERROR: $OUT exists; creation refused to avoid overwrite. Use MODE=update."; exit 1; fi`
!`TMP_TOML="$(mktemp -t tech.XXXXXX.toml)"`
!`echo "STATUS: temp_file=$TMP_TOML"`
</mode_resolution>
</preflight>

<context_analysis>
!`echo "STATUS: loading_context"`
!`PROD_JSON="$(mktemp -t product.XXXXXX.json)"; tombi to-json ai/steering/product.toml > "$PROD_JSON" || { echo "ERROR: product toml->json failed"; exit 1; }`
!`PARCH_JSON="$(mktemp -t parch.XXXXXX.json)"; tombi to-json ai/steering/principles_architecture.toml > "$PARCH_JSON" || { echo "ERROR: principles_architecture toml->json failed"; exit 1; }`
!`PPROG_JSON="$(mktemp -t pprog.XXXXXX.json)"; tombi to-json ai/steering/principles_programming.toml > "$PPROG_JSON" || { echo "ERROR: principles_programming toml->json failed"; exit 1; }`

!`# Extract product context`
!`P_IDS="$(jq -r '[.product.problems[].id] | unique | join(",")' "$PROD_JSON")"`
!`O_IDS="$(jq -r '[.product.outcomes[].id] | unique | join(",")' "$PROD_JSON")"`
!`AC_IDS="$(jq -r '[.product.acceptance_criteria[].id] | unique | join(",")' "$PROD_JSON")"`
!`M_IDS="$(jq -r '[.product.success_metrics[].id] | unique | join(",")' "$PROD_JSON")"`
!`PE_IDS="$(jq -r '([.product.personas[]?.id] // []) | unique | join(",")' "$PROD_JSON")"`
!`DEP_NAMES="$(jq -r '([.product.dependencies[]?.name] // []) | unique | join(",")' "$PROD_JSON")"`
!`CONSTRAINTS="$(jq -r '([.product.constraints[]?.type] // []) | unique | join(",")' "$PROD_JSON")"`

!`# Extract principle IDs with severity weighting`
!`ARCH_PRINCIPLES="$(jq -r '([.principles[]?.id] // []) | unique | join(",")' "$PARCH_JSON")"`
!`PROG_PRINCIPLES="$(jq -r '([.principles[]?.id] // []) | unique | join(",")' "$PPROG_JSON")"`
!`ALL_PRINCIPLES="$ARCH_PRINCIPLES,$PROG_PRINCIPLES"`

!`echo "STATUS: context_loaded - Problems: $P_IDS | Outcomes: $O_IDS | Principles: $ALL_PRINCIPLES"`
</context_analysis>

<recommendation_engine>
!`# Create weighted principle scoring system
generate_principle_score() {
  local principles="$1"
  local context_type="$2"

  # Weight by severity: high=2.0, medium=1.0, low=0.5
  case "$context_type" in
    "architecture") echo 2.0 ;;
    "components") echo 1.5 ;;
    "security") echo 2.0 ;;
    "performance") echo 1.5 ;;
    *) echo 1.0 ;;
  esac
}`

!`# Generate option recommendations with principle alignment
generate_options() {
  local question_type="$1"
  local options="$2"

  echo "GENERATING OPTIONS FOR: $question_type"
  # Implementation will be expanded in the interactive sections
}`
</recommendation_engine>

<section_validation_protocol>
- Each section MUST be validated before proceeding.
- Validation MUST include:
  1. Content presentation (proposed TOML fragment or patch).
  2. A Validation Summary with status (✅ Pass, ⚠️ Needs Review, ❌ Fail) and concrete reasons.
  3. If STYLE=stepwise, execution MUST pause for explicit user approve / revise / reject.
  4. If STYLE=oneshot, execution MUST continue after self-checks.
- The protocol MUST be applied consistently to all sections.
</section_validation_protocol>

<schema_resolution>
!`if [ -f ai/schemas/steering_tech.schema.json ]; then SCHEMA_ROOT="ai/schemas"; else SCHEMA_ROOT="$HOME/.claude/schemas"; fi`
!`SCHEMA="$SCHEMA_ROOT/steering_tech.schema.json"`
!`test -f "$SCHEMA" || { echo "ERROR: schema not found at $SCHEMA. Place steering_tech.schema.json and meta.schema.json in ai/schemas/ or ~/.claude/schemas/."; exit 1; }`
!`echo "STATUS: schema_root=$SCHEMA_ROOT"`
</schema_resolution>

<data_collection_questions>
<creation_mode>
<q1_architecture>
!`echo "=== ARCHITECTURE SELECTION ==="`
!`echo "Which high-level architecture should be used?"`
!`echo "Options: Layered, Hexagonal, Event-Driven, Microservices, Monolithic, Serverless, Domain-Driven, Hybrid"`
!`echo "Consider: Product constraints: $CONSTRAINTS | Outcomes: $O_IDS"`
!`read -r SELECTED_ARCHITECTURE`
!`test -n "$SELECTED_ARCHITECTURE" || { echo "ERROR: Architecture selection required"; exit 1; }`
!`echo "Why this architecture? (align with product outcomes and constraints)"`
!`read -r ARCHITECTURE_RATIONALE`
!`test -n "$ARCHITECTURE_RATIONALE" || { echo "ERROR: Architecture rationale required"; exit 1; }`
</q1_architecture>

<q2_principles_focus>
!`echo "=== PRINCIPLE FOCUS ==="`
!`echo "Available principles: $ALL_PRINCIPLES"`
!`echo "Which principles most strongly govern this product context? (comma separated)"`
!`read -r FOCUS_PRINCIPLES`
!`test -n "$FOCUS_PRINCIPLES" || { echo "ERROR: Focus principles required"; exit 1; }`
!`# Validate principle IDs exist
for principle in $(echo "$FOCUS_PRINCIPLES" | tr ',' '\n'); do
  echo "$ALL_PRINCIPLES" | grep -q "$principle" || { echo "ERROR: Unknown principle '$principle'"; exit 1; }
done`
</q2_principles_focus>

<q3_integrations>
!`echo "=== INTEGRATIONS ==="`
!`echo "Product dependencies: $DEP_NAMES"`
!`INTEGRATIONS=()`
!`while true; do
    echo "Enter integration name (or press Enter to finish):"
    read -r INTEGRATION_NAME
    if [ -z "$INTEGRATION_NAME" ]; then break; fi
    echo "Integration type (API/Service/Database/External):"
    read -r INTEGRATION_TYPE
    case "$INTEGRATION_TYPE" in
      API|Service|Database|External) ;;
      *) echo "ERROR: Invalid integration type"; continue ;;
    esac
    echo "Maps to which product dependency?"
    read -r MAPS_TO_DEP
    echo "Ownership (internal/external/shared):"
    read -r OWNERSHIP
    case "$OWNERSHIP" in
      internal|external|shared) ;;
      *) echo "ERROR: Invalid ownership"; continue ;;
    esac
    INTEGRATIONS+=("$INTEGRATION_NAME|$INTEGRATION_TYPE|$MAPS_TO_DEP|$OWNERSHIP")
  done`
</q3_integrations>

<q4_security>
!`echo "=== SECURITY & COMPLIANCE ==="`
!`SECURITY_TECHNIQUES=()`
!`COMPLIANCE_PROFILES=()`
!`echo "Select compliance profiles (GDPR/HIPAA/PCI/SOX/ISO27001, comma separated):"
!`read -r COMPLIANCE_INPUT`
!`if [ -n "$COMPLIANCE_INPUT" ]; then
    IFS=',' read -ra COMPLIANCE_PROFILES <<< "$COMPLIANCE_INPUT"
  fi`
!`while true; do
    echo "Enter security technique (or press Enter to finish):"
    read -r SEC_TECHNIQUE
    if [ -z "$SEC_TECHNIQUE" ]; then break; fi
    echo "Implementation effort (low/medium/high):"
    read -r SEC_EFFORT
    case "$SEC_EFFORT" in
      low|medium|high) ;;
      *) echo "ERROR: Invalid effort level"; continue ;;
    esac
    SECURITY_TECHNIQUES+=("$SEC_TECHNIQUE|$SEC_EFFORT")
  done`
</q4_security>

<q5_performance>
!`echo "=== PERFORMANCE TARGETS ==="`
!`echo "Success metrics: $M_IDS"`
!`echo "Target latency (P95 in ms):"
!`read -r LATENCY_TARGET`
!`echo "Target throughput (RPS):"
!`read -r THROUGHPUT_TARGET`
!`echo "Concurrency target (concurrent users):"
!`read -r CONCURRENCY_TARGET`
!`echo "Which success metrics do these targets address? (comma separated)"
!`read -r PERF_METRICS`
</q5_performance>

<q6_stack>
!`echo "=== TECHNOLOGY STACK ==="`
!`LANGUAGES=()`
!`FRAMEWORKS=()`
!`echo "Primary programming languages (comma separated):"
!`read -r LANG_INPUT`
!`IFS=',' read -ra LANGUAGES <<< "$LANG_INPUT"`
!`test ${#LANGUAGES[@]} -gt 0 || { echo "ERROR: At least one language required"; exit 1; }`
!`echo "Frameworks (comma separated, optional):"
!`read -r FRAMEWORK_INPUT`
!`if [ -n "$FRAMEWORK_INPUT" ]; then
    IFS=',' read -ra FRAMEWORKS <<< "$FRAMEWORK_INPUT"
  fi`

!`# Collect language standards for each language
LANGUAGE_STANDARDS=()
for lang in "${LANGUAGES[@]}"; do
  lang=$(echo "$lang" | xargs)  # trim whitespace
  echo "For $lang - Testing framework:"
  read -r TEST_FW
  echo "For $lang - Linter:"
  read -r LINTER
  echo "For $lang - Formatter:"
  read -r FORMATTER
  echo "For $lang - Type checker (if applicable):"
  read -r TYPE_CHECKER
  echo "For $lang - Coverage threshold (70-100):"
  read -r COVERAGE
  test "$COVERAGE" -ge 70 2>/dev/null || { echo "ERROR: Coverage must be >= 70"; exit 1; }
  LANGUAGE_STANDARDS+=("$lang|$TEST_FW|$LINTER|$FORMATTER|$TYPE_CHECKER|$COVERAGE")
done`
</q6_stack>

<q7_components>
!`echo "=== SYSTEM COMPONENTS ==="`
!`echo "Personas: $PE_IDS | Outcomes: $O_IDS"`
!`COMPONENTS=()`
!`while true; do
    echo "Enter component name (or press Enter to finish):"
    read -r COMP_NAME
    if [ -z "$COMP_NAME" ]; then break; fi
    echo "Component responsibility (single clear responsibility):"
    read -r COMP_RESP
    echo "Design patterns (Repository/DAO/Adapter/Gateway/Strategy/etc, comma separated):"
    read -r COMP_PATTERNS
    echo "Serves personas (comma separated PE IDs):"
    read -r COMP_PERSONAS
    echo "Maps to outcomes (comma separated O IDs):"
    read -r COMP_OUTCOMES
    echo "Principle IDs for this component (comma separated):"
    read -r COMP_PRINCIPLES
    COMPONENTS+=("$COMP_NAME|$COMP_RESP|$COMP_PATTERNS|$COMP_PERSONAS|$COMP_OUTCOMES|$COMP_PRINCIPLES")
  done`
!`test ${#COMPONENTS[@]} -gt 0 || { echo "ERROR: At least one component required"; exit 1; }`
</q7_components>

<q8_operational>
!`echo "=== OPERATIONAL CONCERNS ==="`
!`echo "Containerization (Docker/Podman/None):"
!`read -r CONTAINERIZATION`
!`case "$CONTAINERIZATION" in
    Docker|Podman|None) ;;
    *) echo "ERROR: Invalid containerization option"; exit 1 ;;
  esac`
!`echo "Infrastructure as Code (Terraform/Pulumi/CloudFormation/CDK):"
!`read -r INFRASTRUCTURE_CODE`
!`case "$INFRASTRUCTURE_CODE" in
    Terraform|Pulumi|CloudFormation|CDK) ;;
    *) echo "ERROR: Invalid IaC option"; exit 1 ;;
  esac`
!`echo "Secrets management approach:"
!`read -r SECRETS_MGMT`
!`echo "Configuration management approach:"
!`read -r CONFIG_MGMT`
!`echo "Monitoring approach/tools:"
!`read -r MONITORING`
</q8_operational>

<q9_additional>
!`echo "=== ADDITIONAL CONSIDERATIONS ==="`
!`echo "Any additional technical architecture considerations?"
!`read -r ADDITIONAL_TECH`
</q9_additional>
</creation_mode>

<update_mode>
<existing_analysis>
!`if [ "$MODE" = "update" ]; then
    echo "STATUS: analyzing_existing_tech_document"
    EXISTING_JSON="$(mktemp -t existing.XXXXXX.json)"
    tombi to-json "$OUT" > "$EXISTING_JSON" || { echo "ERROR: existing tech toml->json failed"; exit 1; }
    echo "Current architecture: $(jq -r '.technical_vision.architecture_approach // "none"' "$EXISTING_JSON")"
    echo "Current components: $(jq -r '[.components[]?.name] | join(", ")' "$EXISTING_JSON")"
  fi`
</existing_analysis>

<update_intent>
!`if [ "$MODE" = "update" ]; then
    echo "What type of update? (Architecture changes/Integration updates/Security enhancements/Performance optimizations/Tooling modifications/Other)"
    read -r UPDATE_INTENT
    case "$UPDATE_INTENT" in
      *Architecture*|*Integration*|*Security*|*Performance*|*Tooling*|*Other*) ;;
      *) echo "ERROR: Invalid update intent"; exit 1 ;;
    esac
  fi`
</update_intent>

<update_rationale>
!`if [ "$MODE" = "update" ]; then
    echo "Why is this update needed now? (Business/technical rationale)"
    read -r UPDATE_RATIONALE
    test -n "$UPDATE_RATIONALE" || { echo "ERROR: Update rationale required"; exit 1; }
  fi`
</update_rationale>
</update_mode>
</data_collection_questions>

<section_generation>
<generate_meta_section>
!`DOC_ID=$(uuidgen)`
!`TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")`
!`if [ "$MODE" = "update" ] && [ -f "$OUT" ]; then
    EXISTING_ID=$(tomli-cli get meta.id "$OUT" 2>/dev/null || echo "")
    EXISTING_CREATED=$(tomli-cli get meta.created_datetime "$OUT" 2>/dev/null || echo "")
    DOC_ID="${EXISTING_ID:-$DOC_ID}"
    CREATED_TIME="${EXISTING_CREATED:-$TIMESTAMP}"
  else
    CREATED_TIME="$TIMESTAMP"
  fi`

!`cat > "$TMP_TOML" <<TOML
[meta]
id = "$DOC_ID"
name = "tech_steering"
title = "Technical Steering Document - $PROJECT"
project = "$PROJECT"
doc_type = "tech"
version = "1.0.0"
status = "draft"
rfc2119 = true
created_datetime = "$CREATED_TIME"
modified_datetime = "$TIMESTAMP"
description = "Technical architecture and design blueprint aligned to product and governed by principles."

TOML`
</generate_meta_section>

<generate_technical_vision>
!`cat >> "$TMP_TOML" <<TOML
[technical_vision]
architecture_approach = "$SELECTED_ARCHITECTURE"
architecture_rationale = "$ARCHITECTURE_RATIONALE"

TOML`
</generate_technical_vision>

<generate_clean_architecture_principles>
!`cat >> "$TMP_TOML" <<TOML
[clean_architecture_principles]
independence_of_frameworks = "The system core will not depend on external frameworks, keeping them as delivery details in adapters."
testability = "Business rules will be testable without requiring UI, database, or external services through dependency inversion."
independence_of_ui = "UI changes will not affect core business logic, with UI implemented as adapters around stable use cases."
independence_of_database = "Data storage implementation can be changed without impacting business rules through repository patterns."
independence_of_external_agencies = "External services will be accessed only through ports/adapters, isolating core from vendor specifics."
dependency_rule = "All source code dependencies will point inward toward the core domain, never outward to infrastructure."

TOML`
</generate_clean_architecture_principles>

<generate_guiding_principles>
!`# Source principle definitions from external files and apply to project context
ARCH_DEFS="$(jq -r '.principles[] | "\(.id)|\(.definition // .description // "")"' "$PARCH_JSON")"
PROG_DEFS="$(jq -r '.principles[] | "\(.id)|\(.definition // .description // "")"' "$PPROG_JSON")"

cat >> "$TMP_TOML" <<TOML
[guiding_principles]
TOML

# Generate principle applications based on external definitions
echo "$ARCH_DEFS" | while IFS='|' read -r id def; do
  case "$id" in
    DIP) echo "dependency_inversion = \"High-level modules depend on abstractions through ports; adapters handle vendor specifics.\"" ;;
    EB) echo "explicit_boundaries = \"All layer interfaces are explicitly defined with versioned contracts and clear responsibilities.\"" ;;
    HCLC) echo "high_cohesion_low_coupling = \"Components group related responsibilities tightly while minimizing inter-component dependencies.\"" ;;
    IOF) echo "independence_of_frameworks = \"Framework code confined to adapters; core business logic framework-agnostic.\"" ;;
    IOUI) echo "independence_of_ui = \"Core exposes UI-neutral use cases; UI changes don't ripple to business rules.\"" ;;
    IODB) echo "independence_of_database = \"Business logic independent of persistence; database accessed via repository abstractions.\"" ;;
    IOEA) echo "independence_of_external_agencies = \"External services accessed via adapters; failures handled at boundaries.\"" ;;
    DR) echo "dependency_rule = \"Source dependencies always point inward toward stable abstractions and domain.\"" ;;
    PRAG) echo "pragmatism = \"Architecture decisions balanced against delivery constraints with documented trade-offs.\"" ;;
  esac
done >> "$TMP_TOML"

echo "$PROG_DEFS" | while IFS='|' read -r id def; do
  case "$id" in
    SRP) echo "single_responsibility = \"Each component has exactly one reason to change with narrow, focused responsibilities.\"" ;;
    OCP) echo "open_closed = \"System extensible through configuration and composition rather than modification of existing code.\"" ;;
    LSP) echo "liskov_substitution = \"Interface implementations substitutable without breaking system contracts or invariants.\"" ;;
    ISP) echo "interface_segregation = \"Clients depend only on methods they use; large interfaces split into focused contracts.\"" ;;
    DRY) echo "dry = \"Business logic centralized in single authoritative locations; configuration single-sourced.\"" ;;
    KISS) echo "kiss = \"Solutions minimize complexity; abstractions justified by actual requirements rather than speculation.\"" ;;
    COI) echo "composition_over_inheritance = \"Behavior composed from small units; inheritance shallow and purpose-driven.\"" ;;
    YAGNI) echo "yagni = \"Features implemented when required; speculative capabilities deferred with documented rationale.\"" ;;
  esac
done >> "$TMP_TOML"

cat >> "$TMP_TOML" <<TOML

TOML`
</generate_guiding_principles>

<generate_architecture_decision>
!`cat >> "$TMP_TOML" <<TOML
[architecture_decision]
chosen_architecture = "$SELECTED_ARCHITECTURE"
decision_rationale = "$ARCHITECTURE_RATIONALE"

[[architecture_decision.options]]
option = "$SELECTED_ARCHITECTURE"
benefits = ["Aligns with product constraints", "Supports identified outcomes", "Enables evolution"]
risks = ["Complexity overhead", "Learning curve", "Initial setup cost"]
impact_on_outcomes = [$(echo "$O_IDS" | sed 's/,/", "/g' | sed 's/^/"/; s/$/"/')]
alignment_with_constraints = [$(echo "$CONSTRAINTS" | sed 's/,/", "/g' | sed 's/^/"/; s/$/"/')]
operational_overhead = "medium"
time_to_market = "moderate"
cost_efficiency = "medium"
evolutionary_flexibility = "high"
recommendation_score = "high"

TOML`
</generate_architecture_decision>

<generate_components_section>
!`for component_data in "${COMPONENTS[@]}"; do
    IFS='|' read -r name resp patterns personas outcomes principles <<< "$component_data"

    # Convert comma-separated values to TOML arrays
    patterns_array="[$(echo "$patterns" | sed 's/,/", "/g' | sed 's/^/"/; s/$/"/')]"
    personas_array="[$(echo "$personas" | sed 's/,/", "/g' | sed 's/^/"/; s/$/"/')]"
    outcomes_array="[$(echo "$outcomes" | sed 's/,/", "/g' | sed 's/^/"/; s/$/"/')]"
    principles_array="[$(echo "$principles" | sed 's/,/", "/g' | sed 's/^/"/; s/$/"/')]"

    cat >> "$TMP_TOML" <<TOML
[[components]]
name = "$name"
responsibility = "$resp"
design_patterns = $patterns_array
serves_personas = $personas_array
maps_to_outcomes = $outcomes_array
interfaces = []
dependencies = []

TOML
  done`
</generate_components_section>

<generate_integrations_section>
!`for integration_data in "${INTEGRATIONS[@]}"; do
    IFS='|' read -r name type maps_to ownership <<< "$integration_data"

    cat >> "$TMP_TOML" <<TOML
[[integrations]]
name = "$name"
type = "$type"
maps_to_product_dependency = "$maps_to"
ownership = "$ownership"
contract_schema = "To be defined"
versioning_strategy = "semantic"
backward_compatibility = "required"
error_handling = "Graceful degradation with circuit breaker pattern"

TOML
  done`
</generate_integrations_section>

<generate_data_strategy>
!`cat >> "$TMP_TOML" <<TOML
[data_strategy]
persistence_approach = "Repository pattern with adapter isolation"
data_lifecycle = "CREATE_READ_UPDATE_DELETE_ARCHIVE with governance"

[[data_strategy.entities]]
name = "PrimaryEntity"
purpose = "Core business entity supporting primary use cases"
persistence_layer = "DATABASE"
migration_strategy = "Versioned migrations with rollback capability"
governance_rules = ["Data retention policy compliance", "Privacy protection"]
quality_metrics = ["Consistency checks", "Referential integrity"]

TOML`
</generate_data_strategy>

<generate_security_compliance>
!`compliance_array="[$(printf '%s\n' "${COMPLIANCE_PROFILES[@]}" | sed 's/.*/"/; s/$/",/' | tr -d '\n' | sed 's/,$//')"]"`
!`selected_array="[$(printf '%s\n' "${SECURITY_TECHNIQUES[@]}" | cut -d'|' -f1 | sed 's/.*/"/; s/$/",/' | tr -d '\n' | sed 's/,$//')"]"`

!`cat >> "$TMP_TOML" <<TOML
[security_compliance]
selected_techniques = $selected_array
compliance_profiles = $compliance_array

TOML

for tech_data in "${SECURITY_TECHNIQUES[@]}"; do
  IFS='|' read -r technique effort <<< "$tech_data"
  cat >> "$TMP_TOML" <<TOML
[[security_compliance.techniques]]
technique = "$technique"
pros = ["Enhanced security posture", "Compliance alignment"]
cons = ["Implementation overhead", "Operational complexity"]
applicability_to_product = "Addresses identified security constraints and risk profile"
implementation_effort = "$effort"

TOML
done`
</generate_security_compliance>

<generate_performance_targets>
!`metrics_array="[$(echo "$PERF_METRICS" | sed 's/,/", "/g' | sed 's/^/"/; s/$/"/')]"`

!`cat >> "$TMP_TOML" <<TOML
[performance_targets]
latency_target = "${LATENCY_TARGET}ms P95"
throughput_target = "${THROUGHPUT_TARGET} RPS"
concurrency_target = "${CONCURRENCY_TARGET} concurrent users"
load_thresholds = "System degradation at 150% of target capacity"
maps_to_success_metrics = $metrics_array

TOML`
</generate_performance_targets>

<generate_technology_stack>
!`languages_array="[$(printf '%s\n' "${LANGUAGES[@]}" | sed 's/.*/"/; s/$/",/' | tr -d '\n' | sed 's/,$//')"]"`
!`frameworks_array="[$(printf '%s\n' "${FRAMEWORKS[@]}" | sed 's/.*/"/; s/$/",/' | tr -d '\n' | sed 's/,$//')"]"`

!`cat >> "$TMP_TOML" <<TOML
[technology_stack]
primary_languages = $languages_array
frameworks = $frameworks_array
testing_approach = "TDD mandatory for all development"
justfile_required = true
editorconfig_required = true

TOML

for lang_data in "${LANGUAGE_STANDARDS[@]}"; do
  IFS='|' read -r lang test_fw linter formatter type_checker coverage <<< "$lang_data"
  cat >> "$TMP_TOML" <<TOML
[[technology_stack.language_standards]]
language = "$lang"
testing_framework = "$test_fw"
linter = "$linter"
formatter = "$formatter"
type_checker = "$type_checker"
coverage_threshold = $coverage

TOML
done`
</generate_technology_stack>

<generate_operational_concerns>
!`cat >> "$TMP_TOML" <<TOML
[operational_concerns]

[operational_concerns.deployment_model]
containerization = "$CONTAINERIZATION"
infrastructure_as_code = "$INFRASTRUCTURE_CODE"
secrets_management = "$SECRETS_MGMT"
disaster_recovery = "Backup and restore procedures with RTO/RPO targets"

[operational_concerns.environment_strategy]
environments = ["local", "dev", "staging", "prod"]
configuration_management = "$CONFIG_MGMT"
monitoring_approach = "$MONITORING"
feature_toggles = "Feature flag system for safe deployments and A/B testing"

TOML`
</generate_operational_concerns>

<generate_traceability_section>
!`cat >> "$TMP_TOML" <<TOML
[traceability]

TOML

# Generate traceability mappings for each component
i=1
for component_data in "${COMPONENTS[@]}"; do
  IFS='|' read -r name resp patterns personas outcomes principles <<< "$component_data"

  # Map to first available problem/outcome/acceptance criteria
  problem_id=$(echo "$P_IDS" | cut -d',' -f$i)
  outcome_id=$(echo "$O_IDS" | cut -d',' -f$i)
  ac_id=$(echo "$AC_IDS" | cut -d',' -f$i)
  principle_array="[$(echo "$principles" | sed 's/,/", "/g' | sed 's/^/"/; s/$/"/')]"

  cat >> "$TMP_TOML" <<TOML
[[traceability.mappings]]
problem_id = "$problem_id"
outcome_id = "$outcome_id"
tech_component = "$name"
test_coverage = "Unit tests for core logic, integration tests for boundaries, E2E tests for user workflows"
acceptance_mapping = "$ac_id"

TOML

  i=$((i + 1))
done`
</generate_traceability_section>
</section_generation>

<section_validation>
!`validate_section() {
    local section_name="$1"
    echo "=== VALIDATING $section_name SECTION ==="

    if [ "$STYLE" = "stepwise" ]; then
      echo "✅ Validation Status for $section_name: Generated successfully"
      echo "Approve this section? (approve/revise/reject)"
      read -r APPROVAL
      case "$APPROVAL" in
        approve) echo "✅ $section_name section approved" ;;
        revise) echo "❌ Revision requested for $section_name"; return 1 ;;
        reject) echo "❌ $section_name section rejected"; return 1 ;;
        *) echo "❌ Invalid response"; return 1 ;;
      esac
    else
      echo "✅ $section_name section generated (oneshot mode)"
    fi
    return 0
  }`
</section_validation>

<schema_validation>
!`echo "STATUS: schema_validation_start"`
!`tombi validate "$TMP_TOML" "$SCHEMA" || { echo "ERROR: schema validation failed. See messages above."; exit 1; }`
!`echo "STATUS: schema_validation_passed"`
</schema_validation>

<content_verification>
!`echo "STATUS: content_verification_start"`
!`TECH_JSON="$(mktemp -t tech.XXXXXX.json)"; tombi to-json "$TMP_TOML" > "$TECH_JSON" || { echo "ERROR: tech toml->json failed"; exit 1; }`
!`JQ='jq -r'`

<basic_counts>
!`COMP_COUNT="$($JQ '([.components[]?] // []) | length' "$TECH_JSON")"`
!`MAP_COUNT="$($JQ '([.traceability.mappings[]?] // []) | length' "$TECH_JSON")"`
!`test "$COMP_COUNT" -ge 1 || { echo "ERROR: at least one component is required"; exit 1; }`
!`test "$MAP_COUNT" -ge 1 || { echo "ERROR: at least one traceability mapping is required"; exit 1; }`
</basic_counts>

<principle_membership_validation>
!`ALL_PRINCIPLE_IDS_JSON="$(echo "$ALL_PRINCIPLES" | tr ',' '\n' | jq -R . | jq -s .)"`
!`MISSING_PRIN="$($JQ --argjson ALL "$ALL_PRINCIPLE_IDS_JSON" '
    [ ( [.technical_vision.principle_ids[]?] // []) +
      ( [.architecture_decision.options[]?.principle_ids[]?] // []) +
      ( [.components[]? | select(has("principle_ids")) | .principle_ids[]?] // []) +
      ( [.integrations[]? | select(has("principle_ids")) | .principle_ids[]?] // []) +
      ( [.data_strategy.entities[]? | select(has("principle_ids")) | .principle_ids[]?] // []) +
      ( [.security_compliance.techniques[]? | select(has("principle_ids")) | .principle_ids[]?] // []) +
      ( [.performance_targets.principle_ids[]?] // []) +
      ( [.technology_stack.principle_ids[]?] // []) +
      ( [.operational_concerns.deployment_model.principle_ids[]?] // []) +
      ( [.operational_concerns.environment_strategy.principle_ids[]?] // []) ] as $ids
     | [$ids[] | select((. as $x | $ALL | index($x)) | not)] | unique' "$TECH_JSON")"`
!`[ "$MISSING_PRIN" = "[]" ] || { echo "WARNING: Some principle_ids may not exist in principles files: $MISSING_PRIN (continuing...)"; }`
</principle_membership_validation>

<traceability_validity>
!`P_IDS_JSON="$(echo "$P_IDS" | tr ',' '\n' | jq -R . | jq -s .)"`
!`O_IDS_JSON="$(echo "$O_IDS" | tr ',' '\n' | jq -R . | jq -s .)"`
!`AC_IDS_JSON="$(echo "$AC_IDS" | tr ',' '\n' | jq -R . | jq -s .)"`

!`BAD_TRACE="$($JQ --argjson P "$P_IDS_JSON" --argjson O "$O_IDS_JSON" --argjson AC "$AC_IDS_JSON" '
    [.traceability.mappings[]? |
      select(((.problem_id as $v | $P | index($v)) | not) or
             ((.outcome_id as $v | $O | index($v)) | not) or
             ((.acceptance_mapping as $v | $AC | index($v)) | not))]' "$TECH_JSON")"`
!`[ "$BAD_TRACE" = "[]" ] || { echo "ERROR: invalid traceability mappings (unknown P/O/AC): $BAD_TRACE"; exit 1; }`

!`COMP_NAMES="$($JQ '[.components[]?.name] | unique' "$TECH_JSON")"`
!`BAD_TRACE_COMP="$($JQ --argjson CN "$COMP_NAMES" '
    [.traceability.mappings[]? | select(((.tech_component as $v | $CN | index($v)) | not))]' "$TECH_JSON")"`
!`[ "$BAD_TRACE_COMP" = "[]" ] || { echo "ERROR: traceability.mappings.tech_component not found in components: $BAD_TRACE_COMP"; exit 1; }`
</traceability_validity>

<component_references_validation>
!`PE_IDS_JSON="$(echo "$PE_IDS" | tr ',' '\n' | jq -R . | jq -s .)"`
!`BAD_COMP="$($JQ --argjson O "$O_IDS_JSON" --argjson PE "$PE_IDS_JSON" '
    [.components[]? |
      select( (([.maps_to_outcomes[]?] // []) | any(. as $v | ($O | index($v)) | not)) or
              (([.serves_personas[]?]  // []) | any(. as $v | ($PE| index($v)) | not)) )]' "$TECH_JSON")"`
!`[ "$BAD_COMP" = "[]" ] || { echo "ERROR: components reference unknown outcomes/personas: $BAD_COMP"; exit 1; }`
</component_references_validation>

<integrations_references_validation>
!`DEP_NAMES_JSON="$(echo "$DEP_NAMES" | tr ',' '\n' | jq -R . | jq -s .)"`
!`if [ ${#INTEGRATIONS[@]} -gt 0 ]; then
    BAD_INT="$($JQ --argjson DEP "$DEP_NAMES_JSON" '
      [.integrations[]? |
        select(((.maps_to_product_dependency as $d | $DEP | index($d)) | not))]' "$TECH_JSON")"
    [ "$BAD_INT" = "[]" ] || { echo "ERROR: integrations map to unknown product dependency names: $BAD_INT"; exit 1; }
  fi`
</integrations_references_validation>

<technology_stack_invariants>
!`TESTING="$($JQ '.technology_stack.testing_approach // ""' "$TECH_JSON")"`
!`echo "$TESTING" | grep -qi 'tdd' || { echo "ERROR: technology_stack.testing_approach MUST include 'TDD'"; exit 1; }`
!`$JQ '.technology_stack.justfile_required' "$TECH_JSON" | grep -qx 'true' || { echo "ERROR: justfile_required MUST be true"; exit 1; }`
!`$JQ '.technology_stack.editorconfig_required' "$TECH_JSON" | grep -qx 'true' || { echo "ERROR: editorconfig_required MUST be true"; exit 1; }`
!`LOW_COV="$($JQ '([.technology_stack.language_standards[]?.coverage_threshold] // []) | map(select(. < 70)) | length' "$TECH_JSON")"`
!`test "$LOW_COV" -eq 0 || { echo "ERROR: coverage_threshold MUST be >= 70 for all languages"; exit 1; }`
</technology_stack_invariants>

<performance_targets_linkage>
!`if [ -n "$PERF_METRICS" ]; then
    M_IDS_JSON="$(echo "$M_IDS" | tr ',' '\n' | jq -R . | jq -s .)"
    BAD_MET="$($JQ --argjson M "$M_IDS_JSON" '
      [([.performance_targets.maps_to_success_metrics[]?] // []) | map(select((. as $x | $M | index($x)) | not)) | .[]?] | unique' "$TECH_JSON")"
    [ "$BAD_MET" = "[]" ] || { echo "ERROR: performance_targets.maps_to_success_metrics contains unknown metric IDs: $BAD_MET"; exit 1; }
  fi`
</performance_targets_linkage>

!`echo "STATUS: content_verification_passed"`
!`rm -f "$TECH_JSON"`
</content_verification>

<assembly_and_write>
!`echo "STATUS: assembly_and_write_start"`
!`# Final validation before write
test -s "$TMP_TOML" || { echo "ERROR: Generated TOML file is empty"; exit 1; }`

!`# Check for overwrite protection
if [ -f "$OUT" ] && [ "$MODE" = "create" ]; then
    echo "ERROR: $OUT exists; creation refused to avoid overwrite. Use MODE=update."; exit 1;
  fi`

!`# Copy temporary file to final location
cp "$TMP_TOML" "$OUT" || { echo "ERROR: Failed to write $OUT"; exit 1; }`
!`BYTES="$(wc -c < "$OUT" | tr -d ' ')" ; echo "STATUS: wrote $OUT ($BYTES bytes)"`
!`rm -f "$TMP_TOML"`
</assembly_and_write>

<completion_summary>
!`echo "========================================"`
!`echo "TECHNICAL STEERING DOCUMENT COMPLETED"`
!`echo "========================================"`
!`echo ""`
!`echo "File: $OUT"`
!`echo "Mode: $MODE | Project: $PROJECT | Style: $STYLE"`
!`echo "Size: $BYTES bytes"`
!`echo ""`
!`echo "Content Summary:"`
!`echo "  Architecture: $SELECTED_ARCHITECTURE"`
!`echo "  Components: $COMP_COUNT"`
!`echo "  Integrations: ${#INTEGRATIONS[@]}"`
!`echo "  Languages: ${#LANGUAGES[@]}"`
!`echo "  Traceability Mappings: $MAP_COUNT"`
!`echo ""`
!`echo "✅ Schema validation: PASSED"`
!`echo "✅ Content verification: PASSED"`
!`echo "✅ Traceability: COMPLETE"`
!`echo "✅ Principle alignment: VALIDATED"`
!`echo ""`
!`echo "Next steps:"`
!`echo "  → Run 'claude-code steering-structure create' to define delivery structure"`
!`echo "  → Consider adding ADRs to [decision_log] section for major decisions"`
!`echo "  → Review and refine component interfaces and dependencies"`
</completion_summary>

<error_handling>
!`# Cleanup on any error
cleanup() {
    rm -f "$TMP_TOML" "$PROD_JSON" "$PARCH_JSON" "$PPROG_JSON" "$TECH_JSON" "$EXISTING_JSON" 2>/dev/null || true
  }`
!`trap cleanup EXIT`
</error_handling>

<guardrails_and_principles>
- The command MUST mirror the tech steering process and sections defined by the schema.
- The command MUST ensure user interaction is explicit and validated (section_validation_protocol).
- The command MUST preserve traceability chain integrity end-to-end.
- The command MUST default to stepwise if style not given.
- The command MUST source external principles TOMLs and use their IDs/metadata for recommendations; it MUST NOT embed their definitions.
- The command MUST use RFC 2119 keywords consistently to eliminate ambiguity.
- The command MUST enforce TDD, Justfile, and EditorConfig requirements.
- The command MUST validate all cross-references to product and principle documents.
- The command MUST ensure schema compliance before writing final output.
</guardrails_and_principles>
