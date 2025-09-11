---
description: Create or update Technical Steering (tech.toml) — architecture & design blueprint aligned to product steering and governed by architecture/programming principles. Outputs ONLY ai/steering/tech.toml.
argument-hint: <create|update> [project-name] [stepwise|oneshot]
allowed-tools: Read, Write, Edit, MultiEdit, Glob, Bash(git:*), Bash(fd:*), Bash(rg:*), Bash(tombi:*), Bash(jq:*), Bash(tomli-cli:*)
model: claude-sonnet-4-20250514
---

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
!`command -v tombi >/dev/null 2>&1 || { echo "ERROR: tombi missing. Install: npm i -g@tomltools/tombi"; exit 1; }`
!`command -v jq    >/dev/null 2>&1 || { echo "ERROR: jq missing. Install jq and re-run."; exit 1; `
!`test -w . || { echo "ERROR: CWD not writable. Fix permissions or use a writable workspace.";exit 1; }`
!`test -f ai/steering/product.toml                 || { echo "ERROR: missingai/steering/product.toml. Create product steering first."; exit 1; }`
!`test -f ai/steering/principles_architecture.toml || { echo "ERROR: missingai/steering/principles_architecture.toml."; exit 1; }`
!`test -f ai/steering/principles_programming.toml  || { echo "ERROR: missingai/steering/principles_programming.toml."; exit 1; }`
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
</mode_resolution>
</preflight>

<context_analysis>
- MUST read ai/steering/product.toml and capture IDs: Problems (P*), Outcomes (O*), Acceptance Criteria (AC*), Personas (PE*), Dependencies, Constraints, Success Metrics (M\*).
- MUST read both principles files and collect canonical principle IDs from their [[principles]] arrays (e.g., SRP, ISP, DIP, OCP, KISS, DRY, PRAG, YAGNI), and any metadata such as severity, guidance, and anti_patterns for weighting.
  !`echo "STATUS: product_and_principles_loaded"`
</context_analysis>

<recommendation_engine>
- The AI MUST SOURCE principles from the external TOMLs (architecture + programming). It MUST NOT copy their definitions into tech.toml; only reference IDs and write project-specific “how we apply it” strings required by the schema.
- Weighting: map severity high→2.0, medium→1.0, low→0.5. Penalize options matching any anti_patterns. Boost options whose principle_ids align with the highest-severity principles most relevant to product constraints and outcomes.
- For each creation/update question, propose 1–3 options and compute:
  principles_score (weighted), fit_with_outcomes, alignment_with_constraints, operational_overhead, time_to_market, cost_efficiency, evolutionary_flexibility → synthesize recommendation_score (high|medium|low).
- Justification: each recommended option MUST cite the top 2–3 contributing principle IDs and link them to the relevant P*/O*/constraints context in prose fields. No definitions pasted.
</recommendation_engine>

<section_validation_protocol>

- Each section MUST: (1) present content (TOML fragment/patch), (2) provide Validation Summary (✅/⚠️/❌) with reasons, (3) in STYLE=stepwise, pause for approve/revise/reject; in STYLE=oneshot, continue after self-checks.
</section_validation_protocol>

<schema_resolution>

- Tech schema search order (first-found MUST be used as TECH_SCHEMA):
  1. ai/schemas/steering_tech.schema.json
  2. .claude/schemas/steering_tech.schema.json
  3. ~/.claude/schemas/steering_tech.schema.json
     !`for C in "ai/schemas/steering_tech.schema.json" ".claude/schemas/steering_tech.schema.json" "$HOME/.claude/schemas/steering_tech.schema.json"; do [ -f "$C" ] && { TECH_SCHEMA="$C"; break; }; done; echo TECH_SCHEMA="${TECH_SCHEMA:-MISSING}"`
     !`[ "$TECH_SCHEMA" != "MISSING" ] || { echo "ERROR: steering_tech.schema.json not found in any known location."; exit 1; }`
</schema_resolution>

<data_collection_questions>
<creation_mode>
- For each question, the system MUST recommend 1–3 options with a trade-off grid: option, benefits[], risks[], impact_on_outcomes, alignment_with_constraints, operational_overhead, time_to_market, cost_efficiency, evolutionary_flexibility, principle_ids[], recommendation_score.
<q1_architecture>
Which high-level architecture should be used? (Layered, Hexagonal, Event-Driven, Microservices, Monolith, Serverless, DDD, Hybrid)
</q1_architecture>
<q2_principles_focus>
Which principles (from architecture/programming sets) most strongly govern this product context?
</q2_principles_focus>
<q3_integrations>
Which integrations/dependencies are most critical based on product dependencies?
</q3_integrations>
<q4_security>
Which security/compliance techniques are appropriate given product constraints/risks?
</q4_security>
<q5_performance>
What performance/scaling targets align with product success metrics?
</q5_performance>
<q6_stack>
Which languages/frameworks fit team expertise and requirements?
</q6_stack>
<q7_nfr>
Which NFRs are most important (availability, reliability, maintainability, usability, scalability)?
</q7_nfr>
<q8_personas>
Which personas require dedicated technical components or specialized handling?
</q8_personas>
<q9_additional>
Anything else important for the technical architecture?
</q9_additional>
</creation_mode>

<update_mode>
<existing_analysis>
- MUST read ai/steering/tech.toml before changes.
</existing_analysis>
<update_intent>
Choose: Architecture changes | Integration updates | Security enhancements | Performance optimizations | Tooling modifications | Other [specify]
</update_intent>
<update_rationale>
Why now? (Business/technical rationale)
</update_rationale>
<update_additional>
Anything else about this update?
</update_additional>

- For chosen intents, MUST present 1–3 options with trade-off grids; MUST maintain ID consistency and additive history; SHOULD mark deprecations.
</update_mode>
</data_collection_questions>

<section_shapes>
NOTE: Shapes below are normative (must conform to steering_tech.schema.json and meta.schema.json). These are not separate code blocks—final TOML MUST be synthesized into a single file.

[technical_vision]
architecture_approach = "CHOSEN_ARCHITECTURE"
architecture_rationale = "WHY_SELECTED (tie to O\* and constraints)"
principle_ids = ["SRP","DIP"]

[clean_architecture_principles]
independence_of_frameworks = "HOW achieved"
testability = "HOW achieved"
independence_of_ui = "HOW achieved"
independence_of_database = "HOW achieved"
independence_of_external_agencies = "HOW achieved"
dependency_rule = "HOW enforced"

[guiding_principles]
single_responsibility = "Project-specific application of SRP"
open_closed = "Project-specific application of OCP"
liskov_substitution = "Project-specific application of LSP"
interface_segregation = "Project-specific application of ISP"
dependency_inversion = "Project-specific application of DIP"
dry = "Project-specific application of DRY"
kiss = "Project-specific application of KISS"
composition_over_inheritance = "Project-specific stance"
high_cohesion_low_coupling = "Project-specific stance"
yagni = "Project-specific stance"
explicit_boundaries = "Project-specific stance"
pragmatism = "Project-specific stance"

[architecture_decision]
chosen_architecture = "SELECTED_ARCHITECTURE"
decision_rationale = "RATIONALE_WITH_PRODUCT_ALIGNMENT"
principle_ids = ["SRP","DIP"]
[[architecture_decision.options]]
option = "ARCHITECTURE_NAME"
benefits = ["benefit1","benefit2"]
risks = ["risk1","risk2"]
impact_on_outcomes = ["O1","O2"]
alignment_with_constraints = ["privacy","availability"]
operational_overhead = "low|medium|high"
time_to_market = "fast|moderate|slow"
cost_efficiency = "low|medium|high"
evolutionary_flexibility = "low|medium|high"
principle_ids = ["SRP","OCP"]
recommendation_score = "high|medium|low"

[[components]]
name = "COMPONENT_NAME"
responsibility = "SINGLE_CLEAR_RESPONSIBILITY"
design_patterns = ["Repository","Adapter","Strategy"]
serves_personas = ["PE1"]
maps_to_outcomes = ["O1","O2"]
interfaces = ["IFoo","IBar"]
dependencies = ["OtherComponent"]
principle_ids = ["SRP","ISP","DIP"]

[[integrations]]
name = "INTEGRATION_NAME"
type = "API|Service|Database|External"
maps_to_product_dependency = "DEPENDENCY_NAME_OR_ID"
ownership = "internal|external|shared"
contract_schema = "SCHEMA_DEFINITION_OR_LINK"
versioning_strategy = "semantic|date|hash"
backward_compatibility = "required|optional|none"
error_handling = "APPROACH"
compliance_requirements = ["GDPR","PCI"]
principle_ids = ["EB","IOEA","IODB"]

[data_strategy]
persistence_approach = "PATTERN"
data_lifecycle = "CREATE_READ_UPDATE_DELETE_ARCHIVE"
[[data_strategy.entities]]
name = "ENTITY_NAME"
purpose = "BUSINESS_PURPOSE"
persistence_layer = "DATABASE|FILE|MEMORY|CACHE"
migration_strategy = "APPROACH"
governance_rules = ["rule1","rule2"]
quality_metrics = ["metric1","metric2"]
principle_ids = ["IODB","DRY"]

[security_compliance]
selected_techniques = ["TECHNIQUE1","TECHNIQUE2"]
compliance_profiles = ["GDPR","HIPAA","PCI"]
[[security_compliance.techniques]]
technique = "SEC_TECHNIQUE"
pros = ["pro1","pro2"]
cons = ["con1","con2"]
applicability_to_product = "WHY_RELEVANT_TO_CONSTRAINTS_OR_RISKS"
implementation_effort = "low|medium|high"
principle_ids = ["EB","IOEA"]

[performance_targets]
latency_target = "P95_MS"
throughput_target = "RPS"
concurrency_target = "USERS"
load_thresholds = "LIMITS"
maps_to_success_metrics = ["M1","M2"]
principle_ids = ["KISS","PRAG"]
[performance_targets.scaling_strategy]
horizontal_scaling = "APPROACH"
vertical_scaling = "APPROACH"
auto_scaling_rules = "RULES"
principle_ids = ["PRAG","YAGNI"]

[technology_stack]
primary_languages = ["Python","TypeScript"]
frameworks = ["FRAMEWORK1","FRAMEWORK2"]
testing_approach = "TDD"
justfile_required = true
editorconfig_required = true
principle_ids = ["DRY","KISS","PRAG"]
[[technology_stack.language_standards]]
language = "Python"
testing_framework = "pytest"
linter = "ruff"
formatter = "ruff format"
type_checker = "mypy"
coverage_threshold = 85
[[technology_stack.language_standards]]
language = "TypeScript"
testing_framework = "jest"
linter = "eslint"
formatter = "prettier"
type_checker = "tsc"
coverage_threshold = 80

[operational_concerns]
[operational_concerns.deployment_model]
containerization = "Docker|Podman|None"
orchestration = "Kubernetes|Compose|None"
infrastructure_as_code = "Terraform|Pulumi|CloudFormation"
secrets_management = "APPROACH"
disaster_recovery = "STRATEGY"
principle_ids = ["EB","PRAG"]
[operational_concerns.environment_strategy]
environments = ["local","dev","staging","prod"]
configuration_management = "HOW_CONFIGS_ARE_MANAGED"
monitoring_approach = "TOOLS"
feature_toggles = "STRATEGY"
principle_ids = ["EB","HCLC"]

[traceability]
[[traceability.mappings]]
problem_id = "P1"
outcome_id = "O1"
tech_component = "COMPONENT_NAME"
acceptance_mapping = "AC1"
test_coverage = "TEST_DESCRIPTION"
principle_ids = ["SRP","DIP"]

[decision_log]
[[decision_log.adrs]]
adr_id = "ADR0001"
title = "Title of decision"
decision = "Chosen path"
rationale = "Why, with references to outcomes/constraints/principles"

[meta]
id = "UUIDv4"
name = "tech_steering"
title = "Technical Steering Document - PROJECT_NAME"
project = "PROJECT_NAME"
doc_type = "tech"
version = "1.0.0"
status = "draft"
rfc2119 = true
created_datetime = "YYYY-MM-DDTHH:MM:SSZ"
modified_datetime = "YYYY-MM-DDTHH:MM:SSZ"
description = "Technical architecture and design blueprint aligned to product and governed by principles."
</section_shapes>

<generate_toml>
!`TMP_TOML="$(mktemp -t tech.XXXXXX.toml)"`
!`NOW="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"`
!`HAS_UUIDGEN="$(command -v uuidgen || true)"`
!`JSON_EXISTING="$(mktemp -t tech.exist.XXXXXX.json)"`
!`if [ -f "$OUT" ]; then tombi to-json "$OUT" > "$JSON_EXISTING" || true; fi`
!`EXIST_CREATED="$([ -s "$JSON_EXISTING" ] && jq -r '.meta.created_datetime // empty' "$JSON_EXISTING")"`
!`EXIST_ID="$([ -s "$JSON_EXISTING" ] && jq -r '.meta.id // empty' "$JSON_EXISTING")"`

<synthesis_requirements>

- If updating and .meta.id exists, preserve it; else set a valid UUIDv4 (use uuidgen if available, else synthesize).
- Set meta.title to "Technical Steering Document - ${PROJECT}" and meta.project to "${PROJECT}".
- If EXIST_CREATED non-empty: use it for meta.created_datetime; else set created_datetime = NOW. Always set meta.modified_datetime = NOW; set meta.name = "tech_steering".
- Populate all required objects per section_shapes; preserve stable IDs; apply minimal diffs in MODE=update.
- Ensure technology_stack.testing_approach contains "TDD"; justfile_required=true; editorconfig_required=true; coverage_thresholds ≥ 70.
- Ensure ≥1 components item and ≥1 traceability.mappings item.
- Ensure all principle_ids[] exist in external principles files.
</synthesis_requirements>

!`echo "STATUS: ready_for_write_to_tmp"`

<!-- The model MUST now synthesize the full, schema-conformant TOML document and write it to $TMP_TOML using the Write/Edit tools. -->

</generate_toml>

<schema_validation>
!`echo "STATUS: schema_validation_start"`
!`tombi validate "$TMP_TOML" "$TECH_SCHEMA" || { echo "ERROR: schema validation failed (tech schema)."; exit 1; }`
!`echo "STATUS: schema_validation_passed"`
</schema_validation>

<content_verification>
!`echo "STATUS: content_verification_start"`
!`TECH_JSON="$(mktemp -t tech.XXXX.json)"; tombi to-json "$TMP_TOML" > "$TECH_JSON" || { echo "ERROR: tech toml->json failed"; exit 1; }`
!`PROD_JSON="$(mktemp -t product.XXXX.json)"; tombi to-json ai/steering/product.toml > "$PROD_JSON" || { echo "ERROR: product toml->json failed"; exit 1; }`
!`PARCH_JSON="$(mktemp -t parch.XXXX.json)"; tombi to-json ai/steering/principles_architecture.toml > "$PARCH_JSON" || { echo "ERROR: principles_architecture toml->json failed"; exit 1; }`
!`PPROG_JSON="$(mktemp -t pprog.XXXX.json)"; tombi to-json ai/steering/principles_programming.toml > "$PPROG_JSON" || { echo "ERROR: principles_programming toml->json failed"; exit 1; }`
!`JQ='jq -r'`

<collect_product_ids>
!`P_IDS="$($JQ '[.product.problems[].id] | unique' "$PROD_JSON")"`
!`O_IDS="$($JQ '[.product.outcomes[].id] | unique' "$PROD_JSON")"`
!`AC_IDS="$($JQ '[.product.acceptance_criteria[].id] | unique' "$PROD_JSON")"`
!`M_IDS="$($JQ '[.product.success_metrics[].id] | unique' "$PROD_JSON")"`
!`PE_IDS="$($JQ '([.product.personas[]?.id] // []) | unique' "$PROD_JSON")"`
!`DEP_NAMES="$($JQ '([.product.dependencies[]?.name] // []) | unique' "$PROD_JSON")"`
</collect_product_ids>

<collect_principle_ids>
!`ARCH_IDS="$($JQ '([.principles[]?.id] // []) | unique' "$PARCH_JSON")"`
!`PROG_IDS="$($JQ '([.principles[]?.id] // []) | unique' "$PPROG_JSON")"`
!`ALL_PRINCIPLE_IDS="$(jq -n --argjson a "$ARCH_IDS" --argjson b "$PROG_IDS" '$a+$b | unique')"`
</collect_principle_ids>

<basic_counts>
!`COMP_COUNT="$($JQ '([.components[]?] // []) | length' "$TECH_JSON")"`
!`MAP_COUNT="$($JQ '([.traceability.mappings[]?] // []) | length' "$TECH_JSON")"`
!`test "$COMP_COUNT" -ge 1 || { echo "ERROR: at least one component is required"; exit 1; }`
!`test "$MAP_COUNT" -ge 1 || { echo "ERROR: at least one traceability mapping is required"; exit 1; }`
</basic_counts>

<meta_immutability>
!`if [ -n "$EXIST_ID" ]; then NEW_ID="$($JQ '.meta.id // empty' "$TECH_JSON")"; test "$NEW_ID" = "$EXIST_ID" || { echo "ERROR: meta.id changed on update"; exit 1; }; fi`
!`if [ -n "$EXIST_CREATED" ]; then NEW_CREATED="$($JQ '.meta.created_datetime // empty' "$TECH_JSON")"; test "$NEW_CREATED" = "$EXIST_CREATED" || { echo "ERROR: meta.created_datetime changed on update"; exit 1; }; fi`
</meta_immutability>

<principle_membership>
!`MISSING_PRIN="$($JQ --argjson ALL "$ALL_PRINCIPLE_IDS" '
    [ ( [.technical_vision.principle_ids[]?] // []) +
      ( [.architecture_decision.principle_ids[]?] // []) +
      ( [.architecture_decision.options[]?.principle_ids[]?] // []) +
      ( [.components[]?.principle_ids[]?] // []) +
      ( [.integrations[]?.principle_ids[]?] // []) +
      ( [.data_strategy.entities[]?.principle_ids[]?] // []) +
      ( [.security_compliance.techniques[]?.principle_ids[]?] // []) +
      ( [.performance_targets.principle_ids[]?] // []) +
      ( [.performance_targets.scaling_strategy.principle_ids[]?] // []) +
      ( [.technology_stack.principle_ids[]?] // []) +
      ( [.operational_concerns.deployment_model.principle_ids[]?] // []) +
      ( [.operational_concerns.environment_strategy.principle_ids[]?] // []) +
      ( [.traceability.mappings[]?.principle_ids[]?] // []) ] as $ids
     | [$ids[] | select((. as $x | $ALL | index($x)) | not)] | unique' "$TECH_JSON")"`
!`[ "$MISSING_PRIN" = "[]" ] || { echo "ERROR: unknown principle_ids (not found in principles files): $MISSING_PRIN"; exit 1; }`
</principle_membership>

<traceability_validity>
!`BAD_TRACE="$($JQ --argjson P "$P_IDS" --argjson O "$O_IDS" --argjson AC "$AC_IDS" '
    [.traceability.mappings[]? |
      select(((.problem_id        as $v | $P  | index($v)) | not) or
             ((.outcome_id        as $v | $O  | index($v)) | not) or
             ((.acceptance_mapping as $v | $AC | index($v)) | not))]' "$TECH_JSON")"`
!`[ "$BAD_TRACE" = "[]" ] || { echo "ERROR: invalid traceability mappings (unknown P/O/AC): $BAD_TRACE"; exit 1; }`

!`COMP_NAMES="$($JQ '[.components[]?.name] | unique' "$TECH_JSON")"`
!`BAD_TRACE_COMP="$($JQ --argjson CN "$COMP_NAMES" '
    [.traceability.mappings[]? | select(((.tech_component as $v | $CN | index($v)) | not))]' "$TECH_JSON")"`
!`[ "$BAD_TRACE_COMP" = "[]" ] || { echo "ERROR: traceability.mappings.tech_component not found in components: $BAD_TRACE_COMP"; exit 1; }`
</traceability_validity>

<component_references>
!`BAD_COMP="$($JQ --argjson O "$O_IDS" --argjson PE "$PE_IDS" '
    [.components[]? |
      select( (([.maps_to_outcomes[]?] // []) | any(. as $v | ($O | index($v)) | not)) or
              (([.serves_personas[]?]  // []) | any(. as $v | ($PE| index($v)) | not)) )]' "$TECH_JSON")"`
!`[ "$BAD_COMP" = "[]" ] || { echo "ERROR: components reference unknown outcomes/personas: $BAD_COMP"; exit 1; }`
</component_references>

<integrations_references>
!`BAD_INT="$($JQ --argjson DEP "$DEP_NAMES" '
    [.integrations[]? |
      select(((.maps_to_product_dependency as $d | $DEP | index($d)) | not))]' "$TECH_JSON")"`
!`[ "$BAD_INT" = "[]" ] || { echo "ERROR: integrations map to unknown product dependency names: $BAD_INT"; exit 1; }`
</integrations_references>

<technology_stack_invariants>
!`TESTING="$($JQ '.technology_stack.testing_approach // ""' "$TECH_JSON")"`
!`echo "$TESTING" | rg -qi 'tdd' || { echo "ERROR: technology_stack.testing_approach MUST include \"TDD\""; exit 1; }`
!`$JQ '.technology_stack.justfile_required'      "$TECH_JSON" | rg -qx 'true' || { echo "ERROR: justfile_required MUST be true"; exit 1; }`
!`$JQ '.technology_stack.editorconfig_required' "$TECH_JSON" | rg -qx 'true' || { echo "ERROR: editorconfig_required MUST be true"; exit 1; }`
!`LOW_COV="$($JQ '([.technology_stack.language_standards[]?.coverage_threshold] // []) | map(select(. < 70)) | length' "$TECH_JSON")"`
!`test "$LOW_COV" -eq 0 || { echo "ERROR: coverage_threshold MUST be >= 70 for all languages"; exit 1; }`
</technology_stack_invariants>

<performance_targets_linkage>
!`BAD_MET="$($JQ --argjson M "$M_IDS" '
    [([.performance_targets.maps_to_success_metrics[]?] // []) | map(select((. as $x | $M | index($x)) | not)) | .[]?] | unique' "$TECH_JSON")"`
!`[ "$BAD_MET" = "[]" ] || { echo "ERROR: performance_targets.maps_to_success_metrics contains unknown metric IDs: $BAD_MET"; exit 1; }`
</performance_targets_linkage>

!`echo "STATUS: content_verification_passed"`
</content_verification>

<write_file>
!`echo "STATUS: writing_artifact"`
!`if [ -f "$OUT" ] && [ "$MODE" = "create" ]; then echo "ERROR: $OUT exists; use MODE=update."; exit 1; fi`
!`cp "$TMP_TOML" "$OUT" || { echo "ERROR: write failed to $OUT"; exit 1; }`
!`BYTES="$(wc -c < "$OUT" | tr -d ' ')" ; echo "STATUS: wrote $OUT ($BYTES bytes)"`
</write_file>

<completion_summary>

- Result: ai/steering/tech.toml
- Mode: ${MODE}; Project: ${PROJECT}; Style: ${STYLE}
- Counts: components=${COMP_COUNT}, mappings=${MAP_COUNT}
- Status: SCHEMA=PASS; CONTENT=PASS; TRACEABILITY=COMPLETE
- Next steps: Consider recording ADRs under [decision_log] if not present; update structure.md separately (outside this command).
</completion_summary>

<guardrails_and_principles>

- The command MUST mirror the tech steering process and sections defined by the schema.
- The command MUST ensure user interaction is explicit and validated (section_validation_protocol).
- The command MUST preserve traceability chain integrity end-to-end.
- The command MUST default to stepwise if style not given.
- The command MUST source external principles TOMLs and use their IDs/metadata for recommendations; it MUST NOT embed their definitions.
- The command MUST use RFC 2119 keywords consistently to eliminate ambiguity.
</guardrails_and_principles>
