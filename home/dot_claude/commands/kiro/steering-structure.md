---
description: Create or update Structure Steering document (structure.toml) defining operational delivery structures for consistent, scalable execution aligned to product and technical steering. 
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
You are a structure delivery specialist who MUST create comprehensive structure steering documents. You MUST follow strict RFC 2119 compliance throughout all operations. You MUST NOT deviate from the specified requirements without explicit RFC 2119 guidance permitting such deviation.
</agent_instructions>

<intent_alignment>
- You MUST output ONLY ai/steering/structure.toml as the final artifact.
- You MUST focus content on: operational delivery structures, repository organization, agentic workflows, CI/CD automation, environment strategy, governance processes, and traceability.
- You MUST NOT include product feature definitions, technical architecture decisions, or business strategy elements.
- You MUST ground ALL structural decisions in ai/steering/product.toml AND ai/steering/tech.toml.
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
- You MUST create required directories: !`mkdir -p ai/steering ai/schemas || { echo "ERROR: mkdir ai/steering ai/schemas failed."; exit 1; }`
</system_prerequisites>

<foundational_context_extraction>
!`echo "STATUS: extracting_foundational_context"`

You MUST execute this Extract → Interpret → Expand sequence for foundational context processing:

<extract_phase>
- You MUST extract product context using these bash operations:
  !`PROD_JSON="$(mktemp)"; tombi to-json ai/steering/product.toml > "$PROD_JSON" || { echo "ERROR: Failed to convert product.toml to JSON"; exit 1; }`
  !`P_IDS="$(jq -r '[.product.problems[].id] | join(",")' "$PROD_JSON")"`
  !`O_IDS="$(jq -r '[.product.outcomes[].id] | join(",")' "$PROD_JSON")"`
  !`PE_IDS="$(jq -r '[.product.personas[].id] | join(",")' "$PROD_JSON")"`
  !`TEAM_SIZE_INDICATOR="$(jq -r '[.product.users[]] | length' "$PROD_JSON")"`
  !`CONSTRAINT_TYPES="$(jq -r '[.product.constraints[].type] | join(",")' "$PROD_JSON")"`

- You MUST extract tech context using these bash operations:
  !`TECH_JSON="$(mktemp)"; tombi to-json ai/steering/tech.toml > "$TECH_JSON" || { echo "ERROR: Failed to convert tech.toml to JSON"; exit 1; }`
  !`TECH_COMPONENTS="$(jq -r '[.components[].name] | join(",")' "$TECH_JSON")"`
  !`ARCHITECTURE_APPROACH="$(jq -r '.technical_vision.architecture_approach' "$TECH_JSON")"`
  !`PRIMARY_LANGUAGES="$(jq -r '[.technology_stack.primary_languages[]] | join(",")' "$TECH_JSON")"`
  !`JUSTFILE_TARGETS="$(jq -r '.technology_stack.justfile_required' "$TECH_JSON")"`

- You MUST extract existing structure context in update mode:
  !`if [ "$MODE" = "update" ]; then STRUCT_JSON="$(mktemp)"; tombi to-json ai/steering/structure.toml > "$STRUCT_JSON" 2>/dev/null || STRUCT_JSON=""; fi`
</extract_phase>

<interpret_phase>
You MUST interpret extracted materials through structural delivery lens:
- You MUST map product outcomes to operational delivery requirements
- You MUST translate tech components into repository and workflow organization needs  
- You MUST identify agentic role assignments based on component complexity and team size
- You MUST assess constraint impacts on delivery structure decisions
- You MUST evaluate architecture approach implications for repository strategy
</interpret_phase>

<expand_phase>
You MUST expand interpretation with structure-guided inferences:
- You MUST apply repository strategy principles (monorepo vs polyrepo trade-offs based on component count and team size)
- You MUST generate workflow recommendations based on team structure indicators and architecture complexity
- You MUST propose environment strategies aligned with operational maturity suggested by tech stack
- You MUST document all assumptions with risk linkage to source context
- You MUST cite specific extracted context when justifying structural recommendations
</expand_phase>
</foundational_context_extraction>

<schema_structure_awareness>
!`echo "STATUS: extracting_schema_structure_requirements"`

You MUST locate and extract schema structure to understand required TOML sections:
- You MUST locate the schema file using this precedence:
  !`for schema_path in "ai/schemas/steering_structure.schema.json" ".claude/schemas/steering_structure.schema.json" "$HOME/.claude/schemas/steering_structure.schema.json"; do [ -f "$schema_path" ] && { SCHEMA="$schema_path"; break; }; done`
- You MUST terminate execution if no schema found: !`test -n "$SCHEMA" || { echo "ERROR: steering_structure.schema.json not found in any expected location."; exit 1; }`

- You MUST extract schema structure to understand requirements:
  !`SCHEMA_JSON="$(mktemp)"; cat "$SCHEMA" > "$SCHEMA_JSON"`
  !`REQUIRED_SECTIONS="$(jq -r '.required | join(",")' "$SCHEMA_JSON")"`
  !`echo "Required top-level sections: $REQUIRED_SECTIONS"`

- You MUST understand specific section requirements:
  !`jq -r '.properties.traceability_matrix.required | join(",")' "$SCHEMA_JSON" | xargs -I {} echo "traceability_matrix requires: {}"`
  !`jq -r '.properties.repository_strategy.required | join(",")' "$SCHEMA_JSON" | xargs -I {} echo "repository_strategy requires: {}"`
  !`jq -r '.properties.agentic_roles.required | join(",")' "$SCHEMA_JSON" | xargs -I {} echo "agentic_roles requires: {}"`
  !`jq -r '.properties.branching_workflow.required | join(",")' "$SCHEMA_JSON" | xargs -I {} echo "branching_workflow requires: {}"`
  !`jq -r '.properties.cicd_pipeline.required | join(",")' "$SCHEMA_JSON" | xargs -I {} echo "cicd_pipeline requires: {}"`
  !`jq -r '.properties.environment_matrix.required | join(",")' "$SCHEMA_JSON" | xargs -I {} echo "environment_matrix requires: {}"`

- You MUST understand field constraints and enums:
  !`jq -r '.properties.repository_strategy.properties.approach.enum | join(", ")' "$SCHEMA_JSON" | xargs -I {} echo "repository approach options: {}"`
  !`jq -r '.properties.agentic_roles.properties.capabilities.items.properties.name.enum | join(", ")' "$SCHEMA_JSON" | xargs -I {} echo "agentic capability options: {}"`
  !`jq -r '.properties.environment_matrix.properties.environments.items.properties.name.enum | join(", ")' "$SCHEMA_JSON" | xargs -I {} echo "environment name options: {}"`

- You MUST be prepared to generate TOML that exactly matches these schema requirements.
</schema_structure_awareness>

<data_collection_requirements>
You MUST collect comprehensive input data through systematic questioning aligned with foundational context.

<mode_determination>
!`MODE_INPUT="$(echo "$ARGUMENTS" | awk '{print $1}')" ; PROJECT_INPUT="$(echo "$ARGUMENTS" | awk '{print $2}')" ; STYLE_INPUT="$(echo "$ARGUMENTS" | awk '{print $3}')"`
!`OUT="ai/steering/structure.toml"`
!`MODE="${MODE_INPUT:-$(test -f "$OUT" && echo update || echo create)}"`
!`PROJECT="${PROJECT_INPUT:-$(git rev-parse --show-toplevel 2>/dev/null | xargs basename 2>/dev/null || basename "$PWD")}"`
!`STYLE="${STYLE_INPUT:-stepwise}"`
!`echo "Resolved: MODE=$MODE | PROJECT=$PROJECT | STYLE=$STYLE"`
</mode_determination>

<creation_mode_questions>
When MODE="create", you MUST ask these contextually-informed questions:

<repository_strategy_question>
You MUST ask: "Based on the extracted tech components ($(echo $TECH_COMPONENTS | tr ',' ' ')) and team size indicators ($TEAM_SIZE_INDICATOR user groups), should this use a monorepo or polyrepo approach?"
You MUST provide recommendation based on:
- Component count: ≤5 components → monorepo recommendation
- Component count: >5 components → consider polyrepo 
- Team size: ≤3 user groups → monorepo recommendation
- Team size: >3 user groups → consider polyrepo
You MUST collect rationale that references the specific extracted context.
</repository_strategy_question>

<workflow_preferences_question>
You MUST ask: "Given the architecture approach ($ARCHITECTURE_APPROACH) and primary languages ($PRIMARY_LANGUAGES), are there specific preferences for Git worktree usage, branch naming, or CI/CD pipeline stages beyond standard requirements?"
You MAY accept "use standards" as valid response.
You MUST collect any specific workflow requirements that align with the tech stack.
</workflow_preferences_question>

<environment_strategy_question>
You MUST ask: "Considering the operational concerns from tech steering, are there specific environment requirements or constraints beyond the standard local, dev, staging, prod progression?"
You MAY accept "standard environments" as valid response.  
You MUST validate environment strategy aligns with tech stack deployment model.
</environment_strategy_question>

<additional_structural_needs>
You MUST ask: "Based on the extracted constraints ($CONSTRAINT_TYPES) and product outcomes, are there additional delivery structure requirements?"
You MAY accept "nothing additional" as valid response.
You MUST ensure any additional requirements align with product constraints.
</additional_structural_needs>
</creation_mode_questions>

<update_mode_questions>
When MODE="update", you MUST follow this process:

<existing_analysis>
!`if [ -n "$STRUCT_JSON" ]; then echo "Current structure document:"; cat ai/steering/structure.toml; echo "STATUS: existing_structure_analyzed"; else echo "WARNING: Could not read existing structure for analysis"; fi`
</existing_analysis>

<update_intent_question>
You MUST ask: "What aspect of the structure needs updating? Choose at least one:
- Repository organization and component mappings  
- Agentic roles and capability assignments
- Workflow and branching strategy
- CI/CD pipeline and automation
- Environment strategy and promotion gates
- Governance and decision processes
- Other (specify)"
You MUST collect specific update focus area.
</update_intent_question>

<update_rationale_question>
You MUST ask: "Why is this structural update needed? Provide operational rationale."
You MUST collect rationale that justifies the structural change.
</update_rationale_question>

<additional_update_context>
You MUST ask: "Any additional context about this structural update?"
You MAY accept "nothing additional" as valid response.
</additional_update_context>
</update_mode_questions>
</data_collection_requirements>

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
!`DOC_ID=$(uuidgen)`
!`TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")`
```toml
[meta]
id = "$DOC_ID"
name = "structure_steering" 
title = "Structure Steering Document - $PROJECT"
project = "$PROJECT"
doc_type = "structure"
version = "1.0.0"
status = "draft"
rfc2119 = true
created_datetime = "$TIMESTAMP"
modified_datetime = "$TIMESTAMP" 
description = "Operational delivery structures for consistent, scalable, and reliable execution."
```
You MUST preserve existing created_datetime in update mode.
Validation: You MUST verify all required meta fields are present with correct types.
</section_1_meta>

<section_2_purpose_scope>
You MUST generate purpose and scope linking to foundational context:
```toml
[purpose_scope]
execution_scope = "Operational delivery structures for consistent, scalable, reliable execution"
links_to_product_outcomes = [extracted O_IDS array]
links_to_tech_components = [extracted TECH_COMPONENTS array]

[scope_boundaries]
in_scope = [
    "Repository organization and directory standards",
    "Agentic workflow automation and AI-agent capabilities", 
    "CI/CD automation and promotion rules",
    "Environment configuration and responsibilities",
    "Governance and decision-making processes",
    "Documentation and cross-cutting practices",
    "Monitoring and operational concerns",
    "Traceability across product/tech/structure layers"
]
out_scope = [
    "Product feature definitions",
    "Technical architecture decisions", 
    "Business strategy and market analysis",
    "Individual performance management"
]
```
Validation: You MUST check scope explicitly links to extracted product outcomes and tech components.
</section_2_purpose_scope>

<section_3_traceability_matrix>
You MUST generate traceability mappings connecting foundational context:
```toml
[traceability_matrix]

[[traceability_matrix.mappings]]
problem_id = "P1" # from extracted P_IDS
outcome_id = "O1" # from extracted O_IDS  
tech_component = "COMPONENT_NAME" # from extracted TECH_COMPONENTS
repo_directory = "path/based/on/component"
agentic_role = "code_generation" # appropriate AI capability
acceptance_test = "component functionality verification"
```
You MUST ensure each mapping includes:
- Valid problem ID from extracted product context
- Valid outcome ID from extracted product context
- Valid tech component from extracted tech context
- Appropriate agentic role assignment
- Meaningful acceptance test description
Validation: You MUST verify all ID references exist in extracted foundational context.
</section_3_traceability_matrix>

<section_4_repository_strategy>
You MUST generate repository strategy based on collected input and context:
```toml
[repository_strategy]  
approach = "monorepo" # or "polyrepo" based on user input
rationale = "contextual rationale referencing component count and team size"
pros = [list of specific advantages]
cons = [list of specific disadvantages]
```
Validation: You MUST ensure rationale references extracted foundational context.
</section_4_repository_strategy>

<section_5_directory_standards>
You MUST generate language-specific directory standards based on extracted tech stack:
```toml
[directory_standards]
# Include standards for extracted PRIMARY_LANGUAGES
python_structure = "src/ tests/ docs/ scripts/" 
# Additional language structures based on tech stack
```
Validation: You MUST include directory standards for all extracted primary languages.
</section_5_directory_standards>

<section_6_component_mappings>
You MUST map extracted tech components to repository structure:
```toml
[[component_mappings]]
tech_component = "EXTRACTED_COMPONENT"
repo_path = "appropriate/path/structure"
language_standard = "extracted_language"
agentic_capability = "assigned_ai_capability"
```
You MUST ensure all extracted tech components have mappings.
Validation: You MUST verify every tech component from extracted context is mapped.
</section_6_component_mappings>

<section_7_agentic_roles>
You MUST define AI-agent capabilities for operational delivery:
```toml
[agentic_roles]

[[agentic_roles.capabilities]]
name = "code_generation"
responsibility = "Generate application code following patterns and standards"
assigned_repos = [repos based on component mappings]
tools_used = [relevant tools from tech stack]

[[agentic_roles.capabilities]]  
name = "testing"
responsibility = "Create and maintain test suites with coverage requirements"
assigned_repos = [repos requiring testing]
tools_used = [testing tools from tech stack]

[[agentic_roles.capabilities]]
name = "infrastructure_orchestration"
responsibility = "Manage deployment, scaling, and infrastructure as code"
assigned_repos = ["infrastructure"]
tools_used = [deployment tools from tech stack]

[[agentic_roles.capabilities]]
name = "documentation_generation"
responsibility = "Generate and maintain technical documentation"
assigned_repos = ["ALL"]
tools_used = [documentation tools]
```
You MUST ensure at least one capability is assigned per repository.
Validation: You MUST verify capability assignment coverage for all repository areas.
</section_7_agentic_roles>

<section_8_branching_workflow>
You MUST generate Git worktree-based workflow:
```toml
[branching_workflow]
model = "Git worktree per feature"
main_branch = "main"
protected_branches = ["main", "develop"]  
merge_strategy = "PR only, no direct pushes"

[conventional_commits]
required = true
format = "type(scope): description"
types = ["feat", "fix", "docs", "style", "refactor", "test", "chore"]

[git_worktree_lifecycle]
create_command = "git worktree add ../project-feature-<id> -b feature/<id>"
develop_process = "Work in isolated worktree directory"
commit_requirements = "Conventional commits with proper testing"
pr_process = "Create PR from feature branch to main"
review_requirements = "AI code review + human approval"
merge_process = "Squash merge to main after approval"
cleanup_command = "git worktree remove ../project-feature-<id>"
```
Validation: You MUST verify Git worktree workflow is completely specified.
</section_8_branching_workflow>

<section_9_cicd_pipeline>
You MUST generate CI/CD automation integrated with Justfile:
```toml
[cicd_pipeline]
required_stages = ["lint", "format", "test", "coverage", "build", "deploy"]
justfile_integration = true
pre_commit_hooks = true
pre_commit_parity = "CI/CD MUST run same checks as pre-commit"

[pipeline_stages]
lint_stage = "just lint - run all configured linters"
format_stage = "just format - apply code formatting"  
test_stage = "just test - run full test suite"
coverage_stage = "just coverage - generate and check coverage thresholds"
build_stage = "just build - create deployment artifacts"
deploy_stage = "just deploy - deploy to target environment"

[promotion_gates]
dev_requirements = ["lint_pass", "format_pass", "test_pass"]
staging_requirements = ["dev_requirements", "coverage_threshold", "build_success"]
prod_requirements = ["staging_requirements", "manual_approval", "security_scan"]
```
Validation: You MUST verify Justfile integration aligns with extracted tech stack requirements.
</section_9_cicd_pipeline>

<section_10_environment_matrix>
You MUST generate all four required environments:
```toml
[environment_matrix]

[[environment_matrix.environments]]
name = "local"
purpose = "Developer workstation development and testing"
owner = "individual_developer"
config_differences = "Local database, mock external services"
promotion_rules = "N/A - development only"
monitoring = "IDE debugging, local logs"

[[environment_matrix.environments]]
name = "dev" 
purpose = "Integration testing and early validation"
owner = "development_team"
config_differences = "Shared test database, staging external services"
promotion_rules = "Automatic on main branch merge"
monitoring = "Basic health checks, application logs"

[[environment_matrix.environments]]
name = "staging"
purpose = "Pre-production validation and acceptance testing"
owner = "qa_team"
config_differences = "Production-like data, production external services"
promotion_rules = "Manual promotion after dev validation"
monitoring = "Full monitoring stack, performance metrics"

[[environment_matrix.environments]]
name = "prod"
purpose = "Live production system serving end users"
owner = "operations_team"
config_differences = "Live data, live external services, high availability"
promotion_rules = "Manual promotion after staging approval"
monitoring = "Comprehensive monitoring, alerting, SLA tracking"
```
Validation: You MUST verify all four required environments are present with complete specifications.
</section_10_environment_matrix>

<section_11_governance_workflow>
You MUST generate governance that minimizes user interaction:
```toml
[governance_workflow]
decision_process = "RFC → Review → Decision → ADR"
ai_drafts = true
human_approval_required = true
user_interaction_minimized = true

[[governance_workflow.decision_states]]
state = "proposal"
description = "RFC drafted and submitted for review"
required_actions = ["technical_review", "product_alignment_check"]
next_states = ["review", "rejected"]

[[governance_workflow.decision_states]]
state = "review"
description = "Under active review by stakeholders"
required_actions = ["stakeholder_feedback", "impact_assessment"]
next_states = ["decision", "request_changes"]

[[governance_workflow.decision_states]]
state = "decision"  
description = "Decision made and ADR created"
required_actions = ["adr_creation", "communication"]
next_states = ["implemented", "deprecated"]
```
Validation: You MUST verify governance minimizes interaction while maintaining quality.
</section_11_governance_workflow>

<section_12_scenarios>
You MUST generate scenario-driven adaptability:
```toml
[[scenarios]]
scenario = "10x user growth in 6 months"
structural_impact = "Repository scaling, team coordination challenges"
repo_changes = "Microservice extraction, service boundaries"
team_changes = "Specialized agentic roles per service"
workflow_changes = "Service-specific CI/CD pipelines"
trade_offs = "Increased complexity vs scalability"

[[scenarios]]
scenario = "Key dependency service failure"
structural_impact = "Service degradation, manual intervention required"  
repo_changes = "Circuit breaker patterns, fallback implementations"
team_changes = "Incident response agentic capabilities"
workflow_changes = "Emergency deployment procedures"
trade_offs = "Resilience vs development velocity"
```
You MUST include at least one growth scenario and one failure scenario.
Validation: You MUST verify scenarios address structural adaptability with trade-off analysis.
</section_12_scenarios>

<section_13_update_policy>
You MUST enforce additive updates:
```toml
[update_policy]
default_approach = "additive"
deprecation_required = true
version_tracking = true

[deprecation_format]
version = "MUST include version when deprecated"
rationale = "MUST include reason for deprecation"  
replacement = "SHOULD include replacement guidance"
timeline = "MUST include deprecation timeline"
```
Validation: You MUST verify additive update policy is enforced.
</section_13_update_policy>
</document_generation_requirements>

<validation_requirements>
You MUST perform comprehensive validation before finalizing the document.

<schema_validation>
- You MUST validate generated TOML against schema: !`tombi validate "$TMP_TOML" "$SCHEMA"`
- You MUST terminate execution if schema validation fails
- You MUST provide specific error details and remediation guidance for violations
</schema_validation>

<cross_reference_validation>
- You MUST validate all problem IDs in traceability exist in extracted product context
- You MUST validate all outcome IDs in traceability exist in extracted product context  
- You MUST validate all tech component references exist in extracted tech context
- You MUST validate all agentic capability assignments have corresponding repository mappings
- You MUST validate environment matrix includes exactly four required environments
</cross_reference_validation>

<business_rule_validation>
- You MUST verify at least one agentic capability exists
- You MUST verify all four environments [local, dev, staging, prod] are defined
- You MUST verify Git worktree workflow is specified with complete lifecycle
- You MUST verify CI/CD pipeline includes all required stages
- You MUST verify Justfile integration is enabled
- You MUST verify traceability mappings provide complete coverage
</business_rule_validation>
</validation_requirements>

<output_requirements>
!`TMP_TOML="$(mktemp -t structure.XXXXXX.toml)"`
- You MUST write final TOML to ai/steering/structure.toml
- You MUST NOT overwrite existing files in create mode without confirmation
- You MUST preserve existing metadata (ID, created timestamp) in update mode  
- You MUST provide comprehensive completion summary including:
  - File path and size
  - Mode, project, and style used
  - Content summary (repository strategy, agentic capabilities count, etc.)
  - Validation status confirmations
  - Recommended next steps
</output_requirements>

<error_handling_requirements>
- You MUST provide structured error messages with specific remediation guidance
- You MUST clean up temporary files on both success and failure: !`cleanup() { rm -f "$TMP_TOML" "$PROD_JSON" "$TECH_JSON" "$STRUCT_JSON" "$SCHEMA_JSON" 2>/dev/null || true; }; trap cleanup EXIT`
- You MUST preserve partial work as draft files when encountering fatal errors
- You MUST distinguish between recoverable warnings and fatal errors
- You MUST exit with appropriate status codes for different error conditions
</error_handling_requirements>

<guardrails_and_constraints>
- You MUST mirror the structure steering process defined by the schema
- You MUST ensure user interaction follows section validation protocol  
- You MUST preserve traceability chain integrity from product through tech to structure
- You MUST default to stepwise mode when style is not specified
- You MUST extract foundational context before making structural recommendations
- You MUST use RFC 2119 keywords consistently to eliminate ambiguity
- You MUST enforce all mandatory schema requirements without exception
- You MUST validate all cross-references against extracted foundational context
- You MUST provide actionable error messages with specific remediation steps
</guardrails_and_constraints>