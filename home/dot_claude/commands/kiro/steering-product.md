---
description: Create or update the Product Steering document as structured TOML (canonical). Defines the WHAT and WHY; excludes the technical HOW. Outputs ONLY ai/steering/product.toml.
argument-hint: <create|update> [project-name] [stepwise|oneshot]
allowed-tools: Read, Write, Edit, MultiEdit, Glob, Bash(git:*), Bash(fd:*), Bash(rg:*), Bash(tombi:*), Bash(tomli-cli:*), Bash(jq:*), Bash(uuidgen:*)
model: claude-sonnet-4-20250514
---

<!--
This Claude Code command is a prompt-first spec (not a shell script).
Execution lines are expressed as tool calls (prefixed with !`) and MUST stop on fatal errors (include exit 1).
-->

<intent_alignment>
- The output MUST be ai/steering/product.toml.
- The document MUST encode product definition, problems, outcomes, success metrics, users, personas, scope, constraints, dependencies, acceptance criteria, risks, assumptions, non-goals, future directions, and meta/traceability.
- The document MUST NOT include technical design or delivery details (those belong in tech.md and structure.md).
- The process MUST support stepwise (pause for approval per section) and oneshot (single pass).
- All requirement-like text MUST use RFC 2119 keywords consistently.
</intent_alignment>

<arguments_and_environment>
- $1 (mode) MUST be create or update if provided.
- If $1 is absent, mode MUST be auto-detected by presence of @ai/steering/product.toml (EXISTS→update, MISSING→create).
- $2 (project) MUST set the project name if provided; otherwise it MUST be derived from Git toplevel or PWD basename.
- $3 (style) MAY be stepwise or oneshot; if omitted it MUST default to stepwise.
- The resolved {MODE, PROJECT, STYLE} MUST be printed before generation.
- Git toplevel SHOULD be detected via: !`git rev-parse --show-toplevel 2>/dev/null | xargs basename 2>/dev/null || basename "$PWD"`.
- File presence SHOULD be detected via: !`test -f ai/steering/product.toml && echo "EXISTS" || echo "MISSING"`.
</arguments_and_environment>

<preflight>
<system_requirements>
!`echo "STATUS: checking_system_requirements"`
!`command -v tombi >/dev/null 2>&1 || { echo "ERROR: tombi missing. Install: npm i -g @tomltools/tombi"; exit 1; }`
!`command -v jq >/dev/null 2>&1 || { echo "ERROR: jq missing. Install jq and re-run."; exit 1; }`
!`command -v uuidgen >/dev/null 2>&1 || { echo "ERROR: uuidgen missing. Install uuid-runtime or equivalent."; exit 1; }`
!`test -w . || { echo "ERROR: CWD not writable. Fix permissions or use a writable workspace."; exit 1; }`
</system_requirements>
<directory_preparation>
!`echo "STATUS: preparing_directories"`
!`mkdir -p ai/steering ai/schemas || { echo "ERROR: mkdir ai/steering ai/schemas failed."; exit 1; }`
</directory_preparation>
<mode_resolution>
!`OUT="ai/steering/product.toml"`
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
!`TMP_TOML="$(mktemp -t product.XXXXXX.toml)"`
!`echo "STATUS: temp_file=$TMP_TOML"`
</mode_resolution>
</preflight>

<section_validation_protocol>
- Each section MUST be validated before proceeding.
- Validation MUST include:
  1. Content presentation (proposed TOML fragment or patch).
  2. A Validation Summary with status (✅ Pass, ⚠️ Needs Review, ❌ Fail) and concrete reasons.
  3. If STYLE=stepwise, execution MUST pause for explicit user approve / revise / reject.
  4. If STYLE=oneshot, execution MUST continue after self-checks.
- The protocol MUST be applied consistently to all sections.
</section_validation_protocol>

<schema_enforced_enums>
- Constraint/dependency types, criticality levels, risk likelihood/impact, user priority, and feature priority MUST conform to the schema enumerations.
- The schema IS the source of truth; the command SHOULD NOT restate enum lists here.
- ID prefixes MUST follow: Problems P*, Outcomes O*, Metrics M*, Acceptance Criteria AC*, Users U*, Personas PE*, Risks R*, Assumptions A*.
</schema_enforced_enums>

<id_generation_system>
!`NEXT_PROBLEM_ID=1`
!`NEXT_OUTCOME_ID=1`
!`NEXT_METRIC_ID=1`
!`NEXT_AC_ID=1`
!`NEXT_USER_ID=1`
!`NEXT_PERSONA_ID=1`
!`NEXT_RISK_ID=1`
!`NEXT_ASSUMPTION_ID=1`

!`generate_problem_id() { echo "P$NEXT_PROBLEM_ID"; NEXT_PROBLEM_ID=$((NEXT_PROBLEM_ID + 1)); }`
!`generate_outcome_id() { echo "O$NEXT_OUTCOME_ID"; NEXT_OUTCOME_ID=$((NEXT_OUTCOME_ID + 1)); }`
!`generate_metric_id() { echo "M$NEXT_METRIC_ID"; NEXT_METRIC_ID=$((NEXT_METRIC_ID + 1)); }`
!`generate_ac_id() { echo "AC$NEXT_AC_ID"; NEXT_AC_ID=$((NEXT_AC_ID + 1)); }`
!`generate_user_id() { echo "U$NEXT_USER_ID"; NEXT_USER_ID=$((NEXT_USER_ID + 1)); }`
!`generate_persona_id() { echo "PE$NEXT_PERSONA_ID"; NEXT_PERSONA_ID=$((NEXT_PERSONA_ID + 1)); }`
!`generate_risk_id() { echo "R$NEXT_RISK_ID"; NEXT_RISK_ID=$((NEXT_RISK_ID + 1)); }`
!`generate_assumption_id() { echo "A$NEXT_ASSUMPTION_ID"; NEXT_ASSUMPTION_ID=$((NEXT_ASSUMPTION_ID + 1)); }`
</id_generation_system>

<data_collection_questions>
<creation_mode>
<identity_and_value>
1. Product Definition — "What is the product in one sentence? (MUST include: what it is, who it is for, why it is valuable.)"
2. Primary Users — "Who is the primary group of people who will use this product?"
3. Core Value — "Why will this product be valuable to them? (Use plain, everyday words.)"
</identity_and_value>
<problems>
4. Problems — "What problems or pain points should this product solve? (MUST list ≥1; write in user language.)"
</problems>
<outcomes_and_metrics>
5. User Outcomes — "What improvements will users experience if those problems are solved?"
6. Business Outcomes — "What improvements will the business experience if those problems are solved?"
7. Success Metrics — "How should success be measured? (Provide 1–3 measurable indicators.)"
</outcomes_and_metrics>
<users_and_personas>
8. User Groups — "List all groups who will use this product. (Mark each as primary or secondary.)"
9. User Actions — "For each group, list 1–2 actions they want to perform (start with action verbs like 'create', 'track', 'analyze')."
10. Primary Persona — "For the main user group, describe one persona: role, main need, current frustration."
</users_and_personas>
<constraints_and_dependencies>
11. Constraints — "What rules, laws, or policies must this product follow?"
12. Dependencies — "What systems/services/data does this product depend on?"
</constraints_and_dependencies>
<additional>
13. Additional Information — "Anything else important that we did not ask?"
</additional>
</creation_mode>

<update_mode>
<update_intent>
Step 1 — "What type of update do you want to make?"
</update_intent>
<branching_questions>
<add_feature>
- "What is the feature name?"
- "What is the feature description?"
- "Which problem(s) does this feature address?"
- "What outcome(s) should result?"
- "Which user groups will use this feature?"
- "What constraints or dependencies are unique to this feature?"
- "How should this feature be prioritized (P1/P2/P3)?"
</add_feature>
<remove_feature>
- "Which feature is being removed?"
- "Why is this feature being removed?"
- "What effect will removal have on users and business operations?"
</remove_feature>
<change_use_cases>
- "Which user group's use cases are changing?"
- "What are the new/revised actions?"
- "Which problem or outcome motivates this change?"
</change_use_cases>
<update_value_proposition>
- "What is the revised value proposition?"
- "Which users are affected?"
- "Why is this change necessary now?"
</update_value_proposition>
<update_problems>
- "What new problems should be added?"
- "What existing problems should be revised or removed?"
- "Why are these changes needed?"
</update_problems>
<update_outcomes>
- "What new user outcomes should be added?"
- "What new business outcomes should be added?"
- "What existing outcomes should be revised or removed?"
- "How do these changes align with current problems?"
</update_outcomes>
<other>
- "Describe the update in plain language."
- "Which sections of the product document are affected?"
</other>
</branching_questions>
<rationale>
Step 3 — "Why is this update needed now?"
</rationale>
<additional_update>
Step 4 — "Anything else about this update that should be captured?"
</additional_update>
</update_mode>
</data_collection_questions>

<input_collection_implementation>
<collect_basic_info>
!`echo "=== PRODUCT DEFINITION COLLECTION ==="`
!`echo "1. Product Definition — What is the product in one sentence? (MUST include: what it is, who it is for, why it is valuable.)"`
!`read -r PRODUCT_DEFINITION`
!`test -n "$PRODUCT_DEFINITION" || { echo "ERROR: Product definition required"; exit 1; }`

!`echo "2. Primary Users — Who is the primary group of people who will use this product?"`
!`read -r PRIMARY_USERS`
!`test -n "$PRIMARY_USERS" || { echo "ERROR: Primary users required"; exit 1; }`

!`echo "3. Core Value — Why will this product be valuable to them? (Use plain, everyday words.)"`
!`read -r VALUE_PROPOSITION`
!`test -n "$VALUE_PROPOSITION" || { echo "ERROR: Value proposition required"; exit 1; }`
</collect_basic_info>

<collect_problems>
!`echo "=== PROBLEMS COLLECTION ==="`
!`echo "4. Problems — What problems or pain points should this product solve? (Enter each problem on a separate line, end with empty line)"`
!`PROBLEMS=()
PROBLEM_IMPACTS_USER=()
PROBLEM_IMPACTS_BUSINESS=()`
!`while true; do
    echo "Enter problem statement (or press Enter to finish):"
    read -r PROBLEM_STMT
    if [ -z "$PROBLEM_STMT" ]; then break; fi
    echo "How does this problem affect users?"
    read -r USER_IMPACT
    echo "How does this problem affect the business?"
    read -r BUSINESS_IMPACT
    PROBLEMS+=("$PROBLEM_STMT")
    PROBLEM_IMPACTS_USER+=("$USER_IMPACT")
    PROBLEM_IMPACTS_BUSINESS+=("$BUSINESS_IMPACT")
  done`
!`test ${#PROBLEMS[@]} -gt 0 || { echo "ERROR: At least one problem required"; exit 1; }`
</collect_problems>

<collect_outcomes>
!`echo "=== OUTCOMES COLLECTION ==="`
!`OUTCOMES_USER=()
OUTCOMES_BUSINESS=()
OUTCOME_PROBLEM_REFS=()`
!`for i in "${!PROBLEMS[@]}"; do
    echo "For problem: ${PROBLEMS[i]}"
    echo "What user outcome will result from solving this?"
    read -r USER_OUTCOME
    echo "What business outcome will result from solving this?"
    read -r BUSINESS_OUTCOME
    OUTCOMES_USER+=("$USER_OUTCOME")
    OUTCOMES_BUSINESS+=("$BUSINESS_OUTCOME")
    OUTCOME_PROBLEM_REFS+=("P$((i+1))")
  done`
</collect_outcomes>

<collect_metrics>
!`echo "=== SUCCESS METRICS COLLECTION ==="`
!`METRICS=()
METRIC_TARGETS=()
METRIC_METHODS=()
METRIC_OUTCOME_REFS=()`
!`for i in "${!OUTCOMES_USER[@]}"; do
    echo "For outcome: ${OUTCOMES_USER[i]}"
    echo "What metric will measure success?"
    read -r METRIC_NAME
    echo "What is the target value?"
    read -r METRIC_TARGET
    echo "How will this be measured?"
    read -r METRIC_METHOD
    METRICS+=("$METRIC_NAME")
    METRIC_TARGETS+=("$METRIC_TARGET")
    METRIC_METHODS+=("$METRIC_METHOD")
    METRIC_OUTCOME_REFS+=("O$((i+1))")
  done`
</collect_metrics>

<collect_users_personas>
!`echo "=== USERS AND PERSONAS COLLECTION ==="`
!`USER_GROUPS=()
USER_ACTIONS=()
USER_PRIORITIES=()
PERSONA_ROLES=()
PERSONA_NEEDS=()
PERSONA_FRUSTRATIONS=()`
!`while true; do
    echo "Enter user group name (or press Enter to finish):"
    read -r USER_GROUP
    if [ -z "$USER_GROUP" ]; then break; fi
    echo "Is this group primary or secondary?"
    read -r USER_PRIORITY
    echo "What actions does this group want to perform? (comma separated)"
    read -r USER_ACTION_LIST
    echo "For the main persona in this group:"
    echo "What is their role?"
    read -r PERSONA_ROLE
    echo "What is their main need?"
    read -r PERSONA_NEED
    echo "What is their current frustration?"
    read -r PERSONA_FRUSTRATION
    
    USER_GROUPS+=("$USER_GROUP")
    USER_PRIORITIES+=("$USER_PRIORITY")
    USER_ACTIONS+=("$USER_ACTION_LIST")
    PERSONA_ROLES+=("$PERSONA_ROLE")
    PERSONA_NEEDS+=("$PERSONA_NEED")
    PERSONA_FRUSTRATIONS+=("$PERSONA_FRUSTRATION")
  done`
!`test ${#USER_GROUPS[@]} -gt 0 || { echo "ERROR: At least one user group required"; exit 1; }`
</collect_users_personas>

<collect_scope>
!`echo "=== SCOPE COLLECTION ==="`
!`SCOPE_INCLUDES=()
SCOPE_EXCLUDES=()`
!`echo "What will the product explicitly include? (Enter each item, end with empty line)"`
!`while true; do
    echo "Include item:"
    read -r INCLUDE_ITEM
    if [ -z "$INCLUDE_ITEM" ]; then break; fi
    SCOPE_INCLUDES+=("$INCLUDE_ITEM")
  done`
!`echo "What will the product explicitly exclude? (Enter each item, end with empty line)"`
!`while true; do
    echo "Exclude item:"
    read -r EXCLUDE_ITEM
    if [ -z "$EXCLUDE_ITEM" ]; then break; fi
    SCOPE_EXCLUDES+=("$EXCLUDE_ITEM")
  done`
</collect_scope>

<collect_constraints_dependencies>
!`echo "=== CONSTRAINTS AND DEPENDENCIES ==="`
!`CONSTRAINT_TYPES=()
CONSTRAINT_DESCRIPTIONS=()
CONSTRAINT_IMPACTS=()
DEPENDENCY_TYPES=()
DEPENDENCY_NAMES=()
DEPENDENCY_DESCRIPTIONS=()
DEPENDENCY_CRITICALITIES=()`

!`VALID_CONSTRAINT_TYPES="regulatory technical business legal compliance budget timeline resource security privacy accessibility performance integration other"`
!`echo "Available constraint types: $VALID_CONSTRAINT_TYPES"`
!`while true; do
    echo "Enter constraint type (or press Enter to finish):"
    read -r CONSTRAINT_TYPE
    if [ -z "$CONSTRAINT_TYPE" ]; then break; fi
    echo "$VALID_CONSTRAINT_TYPES" | grep -q "$CONSTRAINT_TYPE" || { echo "ERROR: Invalid constraint type"; continue; }
    echo "Describe this constraint:"
    read -r CONSTRAINT_DESC
    echo "How does this impact the product?"
    read -r CONSTRAINT_IMPACT
    CONSTRAINT_TYPES+=("$CONSTRAINT_TYPE")
    CONSTRAINT_DESCRIPTIONS+=("$CONSTRAINT_DESC")
    CONSTRAINT_IMPACTS+=("$CONSTRAINT_IMPACT")
  done`

!`VALID_DEPENDENCY_TYPES="system service data integration vendor team infrastructure api database authentication payment other"`
!`VALID_CRITICALITIES="critical important nice-to-have"`
!`echo "Available dependency types: $VALID_DEPENDENCY_TYPES"`
!`echo "Available criticality levels: $VALID_CRITICALITIES"`
!`while true; do
    echo "Enter dependency type (or press Enter to finish):"
    read -r DEPENDENCY_TYPE
    if [ -z "$DEPENDENCY_TYPE" ]; then break; fi
    echo "$VALID_DEPENDENCY_TYPES" | grep -q "$DEPENDENCY_TYPE" || { echo "ERROR: Invalid dependency type"; continue; }
    echo "Enter dependency name:"
    read -r DEPENDENCY_NAME
    echo "Describe what this dependency provides:"
    read -r DEPENDENCY_DESC
    echo "Enter criticality (critical/important/nice-to-have):"
    read -r DEPENDENCY_CRIT
    echo "$VALID_CRITICALITIES" | grep -q "$DEPENDENCY_CRIT" || { echo "ERROR: Invalid criticality"; continue; }
    DEPENDENCY_TYPES+=("$DEPENDENCY_TYPE")
    DEPENDENCY_NAMES+=("$DEPENDENCY_NAME")
    DEPENDENCY_DESCRIPTIONS+=("$DEPENDENCY_DESC")
    DEPENDENCY_CRITICALITIES+=("$DEPENDENCY_CRIT")
  done`
</collect_constraints_dependencies>

<collect_acceptance_criteria>
!`echo "=== ACCEPTANCE CRITERIA ==="`
!`AC_CRITERIA=()
AC_VERIFICATION_METHODS=()
AC_OUTCOME_REFS=()`
!`for i in "${!OUTCOMES_USER[@]}"; do
    echo "For outcome: ${OUTCOMES_USER[i]}"
    echo "What acceptance criterion will verify this outcome?"
    read -r AC_CRITERION
    echo "How will this criterion be verified?"
    read -r AC_VERIFICATION
    AC_CRITERIA+=("$AC_CRITERION")
    AC_VERIFICATION_METHODS+=("$AC_VERIFICATION")
    AC_OUTCOME_REFS+=("O$((i+1))")
  done`
</collect_acceptance_criteria>

<collect_risks_assumptions>
!`echo "=== RISKS AND ASSUMPTIONS ==="`
!`RISK_DESCRIPTIONS=()
RISK_LIKELIHOODS=()
RISK_IMPACTS=()
RISK_MITIGATIONS=()
ASSUMPTION_STATEMENTS=()
ASSUMPTION_VALIDATIONS=()`

!`VALID_RISK_LEVELS="low medium high"`
!`echo "Available risk levels: $VALID_RISK_LEVELS"`
!`while true; do
    echo "Enter risk description (IF/THEN format preferred, or press Enter to finish):"
    read -r RISK_DESC
    if [ -z "$RISK_DESC" ]; then break; fi
    echo "What is the likelihood? (low/medium/high)"
    read -r RISK_LIKELIHOOD
    echo "$VALID_RISK_LEVELS" | grep -q "$RISK_LIKELIHOOD" || { echo "ERROR: Invalid likelihood"; continue; }
    echo "What is the impact? (low/medium/high)"
    read -r RISK_IMPACT
    echo "$VALID_RISK_LEVELS" | grep -q "$RISK_IMPACT" || { echo "ERROR: Invalid impact"; continue; }
    echo "What is the mitigation strategy?"
    read -r RISK_MITIGATION
    RISK_DESCRIPTIONS+=("$RISK_DESC")
    RISK_LIKELIHOODS+=("$RISK_LIKELIHOOD")
    RISK_IMPACTS+=("$RISK_IMPACT")
    RISK_MITIGATIONS+=("$RISK_MITIGATION")
  done`

!`while true; do
    echo "Enter assumption statement (or press Enter to finish):"
    read -r ASSUMPTION_STMT
    if [ -z "$ASSUMPTION_STMT" ]; then break; fi
    echo "How will this assumption be validated?"
    read -r ASSUMPTION_VALIDATION
    ASSUMPTION_STATEMENTS+=("$ASSUMPTION_STMT")
    ASSUMPTION_VALIDATIONS+=("$ASSUMPTION_VALIDATION")
  done`
</collect_risks_assumptions>

<collect_non_goals_future>
!`echo "=== NON-GOALS AND FUTURE DIRECTIONS ==="`
!`NON_GOALS=()
FUTURE_DIRECTIONS=()`
!`echo "What are explicit non-goals? (Enter each item, end with empty line)"`
!`while true; do
    echo "Non-goal:"
    read -r NON_GOAL
    if [ -z "$NON_GOAL" ]; then break; fi
    NON_GOALS+=("$NON_GOAL")
  done`
!`echo "What are possible future directions? (Enter each item, end with empty line)"`
!`while true; do
    echo "Future direction:"
    read -r FUTURE_DIR
    if [ -z "$FUTURE_DIR" ]; then break; fi
    FUTURE_DIRECTIONS+=("$FUTURE_DIR")
  done`
</collect_non_goals_future>
</input_collection_implementation>

<section_generation>
<generate_meta_section>
!`DOC_ID=$(uuidgen)`
!`TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")`
!`cat > "$TMP_TOML" <<TOML
[meta]
id = "$DOC_ID"
name = "${PROJECT}_product_steering"
title = "Product Steering Document - $PROJECT"
project = "$PROJECT"
doc_type = "product"
version = "1.0.0"
status = "draft"
rfc2119 = true
created_datetime = "$TIMESTAMP"
modified_datetime = "$TIMESTAMP"
description = "Product definition, problems, outcomes, metrics, users, personas, scope, constraints, dependencies, acceptance criteria, risks, assumptions, non-goals, and future directions."

TOML`
</generate_meta_section>

<generate_product_section>
!`cat >> "$TMP_TOML" <<TOML
[product]
definition = "$PRODUCT_DEFINITION"
value_proposition = "$VALUE_PROPOSITION"

TOML`
</generate_product_section>

<generate_problems_section>
!`for i in "${!PROBLEMS[@]}"; do
    PROBLEM_ID=$(generate_problem_id)
    cat >> "$TMP_TOML" <<TOML
[[product.problems]]
id = "$PROBLEM_ID"
statement = "${PROBLEMS[i]}"
user_impact = "${PROBLEM_IMPACTS_USER[i]}"
business_impact = "${PROBLEM_IMPACTS_BUSINESS[i]}"

TOML
  done`
</generate_problems_section>

<generate_outcomes_section>
!`for i in "${!OUTCOMES_USER[@]}"; do
    OUTCOME_ID=$(generate_outcome_id)
    cat >> "$TMP_TOML" <<TOML
[[product.outcomes]]
id = "$OUTCOME_ID"
problem_ids = ["${OUTCOME_PROBLEM_REFS[i]}"]
user_outcome = "${OUTCOMES_USER[i]}"
business_outcome = "${OUTCOMES_BUSINESS[i]}"

TOML
  done`
</generate_outcomes_section>

<generate_metrics_section>
!`for i in "${!METRICS[@]}"; do
    METRIC_ID=$(generate_metric_id)
    cat >> "$TMP_TOML" <<TOML
[[product.success_metrics]]
id = "$METRIC_ID"
outcome_ids = ["${METRIC_OUTCOME_REFS[i]}"]
metric = "${METRICS[i]}"
target = "${METRIC_TARGETS[i]}"
measurement_method = "${METRIC_METHODS[i]}"

TOML
  done`
</generate_metrics_section>

<generate_users_section>
!`for i in "${!USER_GROUPS[@]}"; do
    USER_ID=$(generate_user_id)
    # Convert comma-separated actions to TOML array
    IFS=',' read -ra ACTION_ARRAY <<< "${USER_ACTIONS[i]}"
    ACTION_TOML=""
    for action in "${ACTION_ARRAY[@]}"; do
      ACTION_TOML="$ACTION_TOML\"$(echo $action | xargs)\", "
    done
    ACTION_TOML="[${ACTION_TOML%%, }]"
    
    cat >> "$TMP_TOML" <<TOML
[[product.users]]
id = "$USER_ID"
group = "${USER_GROUPS[i]}"
actions = $ACTION_TOML
priority = "${USER_PRIORITIES[i]}"

TOML
  done`
</generate_users_section>

<generate_personas_section>
!`for i in "${!PERSONA_ROLES[@]}"; do
    PERSONA_ID=$(generate_persona_id)
    USER_REF="U$((i+1))"
    cat >> "$TMP_TOML" <<TOML
[[product.personas]]
id = "$PERSONA_ID"
user_id = "$USER_REF"
role = "${PERSONA_ROLES[i]}"
main_need = "${PERSONA_NEEDS[i]}"
current_frustration = "${PERSONA_FRUSTRATIONS[i]}"

TOML
  done`
</generate_personas_section>

<generate_scope_section>
!`cat >> "$TMP_TOML" <<TOML
[product.scope]
TOML`
!`# Generate include array
cat >> "$TMP_TOML" <<TOML
include = [
TOML`
!`for include_item in "${SCOPE_INCLUDES[@]}"; do
    echo "  \"$include_item\"," >> "$TMP_TOML"
  done`
!`cat >> "$TMP_TOML" <<TOML
]
exclude = [
TOML`
!`for exclude_item in "${SCOPE_EXCLUDES[@]}"; do
    echo "  \"$exclude_item\"," >> "$TMP_TOML"
  done`
!`cat >> "$TMP_TOML" <<TOML
]

TOML`
</generate_scope_section>

<generate_constraints_section>
!`for i in "${!CONSTRAINT_TYPES[@]}"; do
    cat >> "$TMP_TOML" <<TOML
[[product.constraints]]
type = "${CONSTRAINT_TYPES[i]}"
description = "${CONSTRAINT_DESCRIPTIONS[i]}"
impact = "${CONSTRAINT_IMPACTS[i]}"

TOML
  done`
</generate_constraints_section>

<generate_dependencies_section>
!`for i in "${!DEPENDENCY_TYPES[@]}"; do
    cat >> "$TMP_TOML" <<TOML
[[product.dependencies]]
type = "${DEPENDENCY_TYPES[i]}"
name = "${DEPENDENCY_NAMES[i]}"
description = "${DEPENDENCY_DESCRIPTIONS[i]}"
criticality = "${DEPENDENCY_CRITICALITIES[i]}"

TOML
  done`
</generate_dependencies_section>

<generate_acceptance_criteria_section>
!`for i in "${!AC_CRITERIA[@]}"; do
    AC_ID=$(generate_ac_id)
    cat >> "$TMP_TOML" <<TOML
[[product.acceptance_criteria]]
id = "$AC_ID"
outcome_ids = ["${AC_OUTCOME_REFS[i]}"]
criterion = "${AC_CRITERIA[i]}"
verification_method = "${AC_VERIFICATION_METHODS[i]}"

TOML
  done`
</generate_acceptance_criteria_section>

<generate_risks_section>
!`for i in "${!RISK_DESCRIPTIONS[@]}"; do
    RISK_ID=$(generate_risk_id)
    cat >> "$TMP_TOML" <<TOML
[[product.risks]]
id = "$RISK_ID"
description = "${RISK_DESCRIPTIONS[i]}"
likelihood = "${RISK_LIKELIHOODS[i]}"
impact = "${RISK_IMPACTS[i]}"
mitigation = "${RISK_MITIGATIONS[i]}"

TOML
  done`
</generate_risks_section>

<generate_assumptions_section>
!`for i in "${!ASSUMPTION_STATEMENTS[@]}"; do
    ASSUMPTION_ID=$(generate_assumption_id)
    cat >> "$TMP_TOML" <<TOML
[[product.assumptions]]
id = "$ASSUMPTION_ID"
statement = "${ASSUMPTION_STATEMENTS[i]}"
validation_method = "${ASSUMPTION_VALIDATIONS[i]}"

TOML
  done`
</generate_assumptions_section>

<generate_non_goals_section>
!`cat >> "$TMP_TOML" <<TOML
[product.non_goals]
items = [
TOML`
!`for non_goal in "${NON_GOALS[@]}"; do
    echo "  \"$non_goal\"," >> "$TMP_TOML"
  done`
!`cat >> "$TMP_TOML" <<TOML
]

TOML`
</generate_non_goals_section>

<generate_future_directions_section>
!`cat >> "$TMP_TOML" <<TOML
[product.future_directions]
items = [
TOML`
!`for future_dir in "${FUTURE_DIRECTIONS[@]}"; do
    echo "  \"$future_dir\"," >> "$TMP_TOML"
  done`
!`cat >> "$TMP_TOML" <<TOML
]

TOML`
</generate_future_directions_section>

<generate_traceability_section>
!`cat >> "$TMP_TOML" <<TOML
[product.traceability]
TOML`
!`# Generate traceability mappings - one for each problem
for i in "${!PROBLEMS[@]}"; do
    PROBLEM_REF="P$((i+1))"
    OUTCOME_REF="O$((i+1))"
    METRIC_REF="M$((i+1))"
    AC_REF="AC$((i+1))"
    cat >> "$TMP_TOML" <<TOML
[[product.traceability.mappings]]
problem_id = "$PROBLEM_REF"
outcome_id = "$OUTCOME_REF"
metric_id = "$METRIC_REF"
acceptance_criterion_id = "$AC_REF"

TOML
  done`
</generate_traceability_section>
</section_generation>

<section_validation>
<validate_section>
!`validate_section() {
    local section_name="$1"
    local section_content="$2"
    echo "=== VALIDATING $section_name SECTION ==="
    echo "$section_content"
    
    if [ "$STYLE" = "stepwise" ]; then
      echo "✅ Validation Status for $section_name:"
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
</validate_section>
</section_validation>

<schema_resolution>
!`if [ -f ai/schemas/steering_product.schema.json ]; then SCHEMA_ROOT="ai/schemas"; else SCHEMA_ROOT="$HOME/.claude/schemas"; fi`
!`SCHEMA="$SCHEMA_ROOT/steering_product.schema.json"`
!`test -f "$SCHEMA" || { echo "ERROR: schema not found at $SCHEMA. Place steering_product.schema.json and meta.schema.json in ai/schemas/ or ~/.claude/schemas/."; exit 1; }`
!`echo "STATUS: schema_root=$SCHEMA_ROOT"`
</schema_resolution>

<schema_validation>
!`echo "STATUS: schema_validation_start"`
!`tombi validate "$TMP_TOML" "$SCHEMA" || { echo "ERROR: schema validation failed. See messages above."; exit 1; }`
!`echo "STATUS: schema_validation_passed"`
</schema_validation>

<content_verification>
!`echo "STATUS: content_verification_start"`
!`JSON_TMP="$(mktemp -t product.XXXXXX.json)"; tombi to-json "$TMP_TOML" > "$JSON_TMP" || { echo "ERROR: to-json failed"; exit 1; }`
!`JQ='jq -r'`

!`# Verify all problem_ids referenced in outcomes exist in problems
MISSING_P="$($JQ '[.product.problems[].id] as $P | (.product.outcomes // []) as $Out | [$Out[].problem_ids[]?] as $R | ($P - ($R|unique)) | unique' "$JSON_TMP")"`
!`test "$MISSING_P" = "[]" || { echo "ERROR: Unmapped problems (no outcome references): $MISSING_P"; exit 1; }`

!`# Verify all outcomes have success metrics
OM="$($JQ '[.product.outcomes[].id] as $O | [.product.success_metrics[].outcome_ids[]] as $RM | ($O - ($RM|unique)) | unique' "$JSON_TMP")"`
!`test "$OM" = "[]" || { echo "ERROR: Outcomes without success metrics: $OM"; exit 1; }`

!`# Verify all outcomes have acceptance criteria
OAC="$($JQ '[.product.outcomes[].id] as $O | [.product.acceptance_criteria[].outcome_ids[]] as $RA | ($O - ($RA|unique)) | unique' "$JSON_TMP")"`
!`test "$OAC" = "[]" || { echo "ERROR: Outcomes without acceptance criteria: $OAC"; exit 1; }`

!`# Verify all user_ids in personas exist in users
MISSING_USERS=$($JQ '[.product.personas[].user_id] - [.product.users[].id] | unique' "$JSON_TMP")`
!`test "$MISSING_USERS" = "[]" || { echo "ERROR: Referenced users don't exist in personas: $MISSING_USERS"; exit 1; }`

!`# Verify traceability mappings reference valid IDs
BAD_MAP="$($JQ '(.product.traceability.mappings // []) as $M | [. as $root | $M[] | select((.problem_id|in([$root.product.problems[].id][])|not) or (.outcome_id|in([$root.product.outcomes[].id][])|not) or (.metric_id|in([$root.product.success_metrics[].id][])|not) or (.acceptance_criterion_id|in([$root.product.acceptance_criteria[].id][])|not))]' "$JSON_TMP")"`
!`test "$BAD_MAP" = "[]" || { echo "ERROR: Invalid traceability mappings: $BAD_MAP"; exit 1; }`

!`# Verify at least one primary user group exists
PRIMARY_USERS=$($JQ '[.product.users[] | select(.priority=="primary")] | length' "$JSON_TMP")`
!`test "$PRIMARY_USERS" -gt 0 || { echo "ERROR: At least one user group must have priority='primary'"; exit 1; }`

!`# Verify constraint types are valid
INVALID_CONSTRAINTS=$($JQ '[.product.constraints[].type] - ["regulatory","technical","business","legal","compliance","budget","timeline","resource","security","privacy","accessibility","performance","integration","other"] | unique' "$JSON_TMP")`
!`test "$INVALID_CONSTRAINTS" = "[]" || { echo "ERROR: Invalid constraint types: $INVALID_CONSTRAINTS"; exit 1; }`

!`# Verify dependency types are valid
INVALID_DEPENDENCIES=$($JQ '[.product.dependencies[].type] - ["system","service","data","integration","vendor","team","infrastructure","api","database","authentication","payment","other"] | unique' "$JSON_TMP")`
!`test "$INVALID_DEPENDENCIES" = "[]" || { echo "ERROR: Invalid dependency types: $INVALID_DEPENDENCIES"; exit 1; }`

!`# Verify risk levels are valid
INVALID_RISK_LIKELIHOODS=$($JQ '[.product.risks[].likelihood] - ["low","medium","high"] | unique' "$JSON_TMP")`
!`test "$INVALID_RISK_LIKELIHOODS" = "[]" || { echo "ERROR: Invalid risk likelihoods: $INVALID_RISK_LIKELIHOODS"; exit 1; }`

!`INVALID_RISK_IMPACTS=$($JQ '[.product.risks[].impact] - ["low","medium","high"] | unique' "$JSON_TMP")`
!`test "$INVALID_RISK_IMPACTS" = "[]" || { echo "ERROR: Invalid risk impacts: $INVALID_RISK_IMPACTS"; exit 1; }`

!`echo "STATUS: content_verification_passed"`
!`rm -f "$JSON_TMP"`
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
!`echo "PRODUCT STEERING DOCUMENT COMPLETED"`
!`echo "========================================"`
!`echo ""`
!`echo "File: $OUT"`
!`echo "Mode: $MODE | Project: $PROJECT | Style: $STYLE"`
!`echo "Size: $BYTES bytes"`
!`echo ""`
!`PROBLEM_COUNT=$(tomli-cli get product.problems "$OUT" | jq '. | length')`
!`OUTCOME_COUNT=$(tomli-cli get product.outcomes "$OUT" | jq '. | length')`
!`METRIC_COUNT=$(tomli-cli get product.success_metrics "$OUT" | jq '. | length')`
!`USER_COUNT=$(tomli-cli get product.users "$OUT" | jq '. | length')`
!`echo "Content Summary:"`
!`echo "  Problems: $PROBLEM_COUNT"`
!`echo "  Outcomes: $OUTCOME_COUNT"`
!`echo "  Success Metrics: $METRIC_COUNT"`
!`echo "  User Groups: $USER_COUNT"`
!`echo ""`
!`echo "✅ Schema validation: PASSED"`
!`echo "✅ Content verification: PASSED"`
!`echo "✅ Traceability: COMPLETE"`
!`echo ""`
!`echo "Next steps:"`
!`echo "  → Run 'claude-code steering-tech create' to define technical architecture"`
!`echo "  → Run 'claude-code steering-structure create' to define delivery structure"`
</completion_summary>

<error_handling>
!`# Cleanup on any error
cleanup() {
    rm -f "$TMP_TOML" "$JSON_TMP" 2>/dev/null || true
  }`
!`trap cleanup EXIT`
</error_handling>

<guardrails_and_principles>
- The command MUST mirror the product steering process and sections.
- The command MUST include all creation and update questions with branching.
- The command MUST ensure user interaction is explicit and validated.
- The command MUST preserve traceability chain integrity end-to-end.
- The command MUST default to stepwise if style not given.
- The command MUST NOT include technical implementation details.
- The command MUST use RFC 2119 keywords consistently to eliminate ambiguity.
</guardrails_and_principles>