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
  !`JUSTFILE_REQUIRED="$(jq -r '.technology_stack.justfile_required' "$TECH_JSON")"`
  !`DEPLOYMENT_MODEL="$(jq -r '.operational_concerns.deployment_model.containerization' "$TECH_JSON")"`

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
- You MUST apply standardized workflow patterns (Git worktree, conventional commits, standard CI/CD stages)
- You MUST propose environment strategies aligned with deployment model from tech stack
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

- You MUST understand field constraints and enums:
  !`jq -r '.properties.repository_strategy.properties.approach.enum | join(", ")' "$SCHEMA_JSON" | xargs -I {} echo "repository approach options: {}"`
  !`jq -r '.properties.agentic_roles.properties.capabilities.items.properties.name.enum | join(", ")' "$SCHEMA_JSON" | xargs -I {} echo "agentic capability options: {}"`

- You MUST be prepared to generate TOML that exactly matches these schema requirements.
</schema_structure_awareness>

<standardized_structural_decisions>
You MUST apply these standardized best practices without user input:

<repository_strategy_determination>
You MUST determine repository strategy based on extracted context:
- IF TECH_COMPONENTS count ≤ 5 AND TEAM_SIZE_INDICATOR ≤ 3: You MUST recommend "monorepo"
- IF TECH_COMPONENTS count > 5 OR TEAM_SIZE_INDICATOR > 3: You MUST recommend "polyrepo"
- You MUST document rationale referencing specific component count and team size indicators
- You MUST include standard pros/cons for the selected approach
</repository_strategy_determination>

<workflow_standards_enforcement>
You MUST enforce these standardized workflow practices:
- You MUST enforce Git worktree per feature workflow (no exceptions)
- You MUST enforce conventional commits with standard types [feat, fix, docs, style, refactor, test, chore]
- You MUST enforce branch naming: feature/<id>, bugfix/<id>, hotfix/<id>
- You MUST enforce standard CI/CD pipeline stages: [lint, format, test, coverage, build, deploy]
- You MUST enforce Justfile integration for all automation tasks
- You MUST enforce pre-commit hooks with CI/CD parity
- You MUST apply these standards regardless of architecture approach or languages
- You MUST document rationale: "Standardized workflows ensure consistency across teams and reduce cognitive overhead"
</workflow_standards_enforcement>

<environment_strategy_standardization>
You MUST enforce standard four-environment progression:
- local: Developer workstation with mocked dependencies
- dev: Shared integration environment with automatic promotion
- staging: Production-like validation environment with manual promotion
- prod: Live production with manual promotion and comprehensive monitoring
You MUST align monitoring complexity with environment criticality
</environment_strategy_standardization>

<agentic_roles_standardization>
You MUST define standard agentic capabilities based on extracted tech components:
- code_generation: Always required for any system with components
- testing: Always required (aligned with TDD requirement from tech stack)
- infrastructure_orchestration: Required if containerization != "None"
- documentation_generation: Always required for maintainability
- refactoring: Optional based on system complexity
You MUST assign capabilities to repositories based on component mappings
</agentic_roles_standardization>

<governance_standardization>
You MUST apply standard governance workflow:
- decision_process: "RFC → Review → Decision → ADR"
- ai_drafts: true (AI generates initial drafts)
- human_approval_required: true (humans make final decisions)
- user_interaction_minimized: true (reduce cognitive overhead)
You MUST define standard decision states: [proposal, review, decision] with appropriate transitions
</governance_standardization>
</standardized_structural_decisions>

<mode_determination>
!`MODE_INPUT="$(echo "$ARGUMENTS" | awk '{print $1}')" ; PROJECT_INPUT="$(echo "$ARGUMENTS" | awk '{print $2}')" ; STYLE_INPUT="$(echo "$ARGUMENTS" | awk '{print $3}')"`
!`OUT="ai/steering/structure.toml"`
!`MODE="${MODE_INPUT:-$(test -f "$OUT" && echo update || echo create)}"`
!`PROJECT="${PROJECT_INPUT:-$(git rev-parse --show-toplevel 2>/dev/null | xargs basename 2>/dev/null || basename "$PWD")}"`
!`STYLE="${STYLE_INPUT:-stepwise}"`
!`echo "Resolved: MODE=$MODE | PROJECT=$PROJECT | STYLE=$STYLE"`
</mode_determination>

<minimal_user_interaction>
You MUST minimize user interaction to only essential contextual decisions:

<creation_mode_interaction>
When MODE="create", you MUST ask ONLY this single contextual question:

You MUST ask: "Are there any specific compliance, regulatory, or operational constraints from your product context that require non-standard delivery structure adaptations?"

You MUST provide context: "Based on extracted constraints: $CONSTRAINT_TYPES"

You MAY accept responses like:
- "No special constraints"
- "Standard structure is fine"
- "Apply best practices"

You MUST collect any genuine structural constraints that cannot be standardized (e.g., specific regulatory requirements, unique operational limitations, mandatory security protocols).

You MUST NOT ask about:
- Repository strategy (determined algorithmically from context)
- Workflow preferences (standardized best practices applied)
- Environment names or progression (standardized four-environment model)
- Agentic role definitions (standardized based on tech stack)
- Branch naming or commit conventions (standardized)
- CI/CD pipeline stages (standardized)
</creation_mode_interaction>

<update_mode_interaction>
When MODE="update", you MUST ask these minimal questions:

!`if [ -n "$STRUCT_JSON" ]; then echo "Current structure document:"; cat ai/steering/structure.toml; echo "STATUS: existing_structure_analyzed"; else echo "WARNING: Could not read existing structure for analysis"; fi`

You MUST ask: "What structural aspect needs updating?"
- Repository organization
- Agentic role assignments
- Environment configuration
- Compliance/governance requirements
- Other (specify)

You MUST ask: "What is the operational reason for this update?"

You MUST collect only the specific change scope and rationale, then apply standardized best practices to the updated areas.
</update_mode_interaction>
</minimal_user_interaction>

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
!`TMP_TOML="$(mktemp -t structure.XXXXXX.toml)"`
!`DOC_ID=$(uuidgen)`
!`TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")`
!`if [ "$MODE" = "update" ] && [ -n "$STRUCT_JSON" ]; then EXISTING_ID="$(jq -r '.meta.id // ""' "$STRUCT_JSON")"; EXISTING_CREATED="$(jq -r '.meta.created_datetime // ""' "$STRUCT_JSON")"; DOC_ID="${EXISTING_ID:-$DOC_ID}"; CREATED_TIMESTAMP="${EXISTING_CREATED:-$TIMESTAMP}"; else CREATED_TIMESTAMP="$TIMESTAMP"; fi`

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
created_datetime = "$CREATED_TIMESTAMP"
modified_datetime = "$TIMESTAMP"
description = "Operational delivery structures for consistent, scalable, and reliable execution."
```
Validation: You MUST verify all required meta fields are present with correct types.
</section_1_meta>

<section_2_purpose_scope>
You MUST generate purpose and scope linking to foundational context:
```toml
[purpose_scope]
execution_scope = "Operational delivery structures for consistent, scalable, reliable execution"
links_to_product_outcomes = [$O_IDS_ARRAY]
links_to_tech_components = [$TECH_COMPONENTS_ARRAY]

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

# Generate one mapping per problem-outcome pair from extracted context
[[traceability_matrix.mappings]]
problem_id = "P1" # from extracted P_IDS
outcome_id = "O1" # from extracted O_IDS
tech_component = "COMPONENT_NAME" # from extracted TECH_COMPONENTS
repo_directory = "src/component-name" # standardized path
agentic_role = "code_generation" # appropriate AI capability
acceptance_test = "Component integration and functionality verification"
```
You MUST ensure each mapping includes:
- Valid problem ID from extracted product context
- Valid outcome ID from extracted product context
- Valid tech component from extracted tech context
- Standardized repository directory path
- Appropriate agentic role assignment
- Meaningful acceptance test description
Validation: You MUST verify all ID references exist in extracted foundational context.
</section_3_traceability_matrix>

<section_4_repository_strategy>
You MUST generate repository strategy based on algorithmic determination:
!`COMPONENT_COUNT="$(echo "$TECH_COMPONENTS" | tr ',' '\n' | wc -l | tr -d ' ')"`
!`if [ "$COMPONENT_COUNT" -le 5 ] && [ "$TEAM_SIZE_INDICATOR" -le 3 ]; then REPO_APPROACH="monorepo"; else REPO_APPROACH="polyrepo"; fi`

```toml
[repository_strategy]
approach = "$REPO_APPROACH"
rationale = "Selected based on $COMPONENT_COUNT components and $TEAM_SIZE_INDICATOR user groups from foundational context analysis"
pros = [
    # Standard pros for selected approach
]
cons = [
    # Standard cons for selected approach
]
```
You MUST include standard pros/cons based on approach:
- monorepo pros: ["Simplified dependency management", "Unified tooling", "Atomic cross-component changes", "Simplified CI/CD"]
- monorepo cons: ["Potential build performance issues at scale", "Repository size growth"]
- polyrepo pros: ["Independent release cycles", "Clear ownership boundaries", "Scalable development"]
- polyrepo cons: ["Complex dependency coordination", "Duplicated tooling setup", "Cross-repo changes complexity"]
Validation: You MUST ensure rationale references extracted foundational context.
</section_4_repository_strategy>

<section_5_directory_standards>
You MUST generate language-specific directory standards based on extracted tech stack:
```toml
[directory_standards]
python_structure = "src/ tests/ docs/ scripts/"
go_structure = "cmd/ pkg/ internal/ api/ docs/"
javascript_structure = "src/ __tests__/ docs/ scripts/"
typescript_structure = "src/ __tests__/ types/ docs/"
```
You MUST include standards for all languages in PRIMARY_LANGUAGES.
Validation: You MUST include directory standards for all extracted primary languages.
</section_5_directory_standards>

<section_6_naming_conventions>
You MUST generate standardized naming conventions:
```toml
[naming_conventions]
directories = "snake_case"
files = "snake_case for scripts, PascalCase for components, camelCase for configs"
branches = "feature/<id>, bugfix/<id>, hotfix/<id>"
commits = "Conventional Commits: type(scope): description"
```
Validation: You MUST verify all naming conventions follow established best practices.
</section_6_naming_conventions>

<section_7_component_mappings>
You MUST map extracted tech components to repository structure:
```toml
# Generate one mapping per tech component
[[component_mappings]]
tech_component = "EXTRACTED_COMPONENT"
repo_path = "src/component-name" # standardized path structure
language_standard = "primary_language" # from PRIMARY_LANGUAGES
agentic_capability = "code_generation" # appropriate assignment
```
You MUST ensure all extracted tech components have mappings.
You MUST assign appropriate agentic capabilities based on component type.
Validation: You MUST verify every tech component from extracted context is mapped.
</section_7_component_mappings>

<section_8_agentic_roles>
You MUST define standardized AI-agent capabilities:
```toml
[agentic_roles]

[[agentic_roles.capabilities]]
name = "code_generation"
responsibility = "Generate application code following patterns and standards"
assigned_repos = ["src", "components"]
tools_used = ["IDE extensions", "linters", "formatters"]

[[agentic_roles.capabilities]]
name = "testing"
responsibility = "Create and maintain test suites with coverage requirements"
assigned_repos = ["ALL"]
tools_used = ["test frameworks", "coverage tools", "test generators"]

[[agentic_roles.capabilities]]
name = "documentation_generation"
responsibility = "Generate and maintain technical documentation"
assigned_repos = ["ALL"]
tools_used = ["doc generators", "markdown processors", "API doc tools"]

# Add infrastructure_orchestration if containerization is enabled
# Add refactoring if system complexity warrants it
```
You MUST ensure at least three core capabilities: code_generation, testing, documentation_generation.
You MUST add infrastructure_orchestration if DEPLOYMENT_MODEL != "None".
Validation: You MUST verify capability assignment coverage for all repository areas.
</section_8_agentic_roles>

<section_9_branching_workflow>
You MUST generate standardized Git worktree-based workflow:
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
examples = [
    "feat(auth): add OAuth2 integration",
    "fix(api): resolve timeout issues",
    "docs(readme): update installation steps"
]

[git_worktree_lifecycle]
create_command = "git worktree add ../project-feature-<id> -b feature/<id>"
develop_process = "Work in isolated worktree directory"
commit_requirements = "Conventional commits with proper testing"
pr_process = "Create PR from feature branch to main"
review_requirements = "AI code review + human approval"
merge_process = "Squash merge to main after approval"
cleanup_command = "git worktree remove ../project-feature-<id>"

[merge_rules]
direct_push_to_main = false
pr_required = true
review_required = true
ci_checks_required = true
branch_protection = ["main", "develop"]
```
You MUST apply these standards without customization.
Validation: You MUST verify Git worktree workflow is completely and consistently specified.
</section_9_branching_workflow>

<section_10_cicd_pipeline>
You MUST generate standardized CI/CD automation with Justfile integration:
```toml
[cicd_pipeline]
required_stages = ["lint", "format", "test", "coverage", "build", "deploy"]
justfile_integration = true
pre_commit_hooks = true
pre_commit_parity = "CI/CD MUST run same checks as pre-commit hooks"

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

[quality_gates]
test_coverage_threshold = 70
lint_failure_blocks_merge = true
format_failure_blocks_merge = true
security_scan_required = true
```
You MUST enforce these standards regardless of tech stack variations.
Validation: You MUST verify Justfile integration aligns with extracted JUSTFILE_REQUIRED.
</section_10_cicd_pipeline>

<section_11_environment_matrix>
You MUST generate standardized four-environment matrix:
```toml
[environment_matrix]

[[environment_matrix.environments]]
name = "local"
purpose = "Developer workstation development and testing"
owner = "individual_developer"
config_differences = "Local database, mock external services, debug logging"
promotion_rules = "N/A - development only"
monitoring = "IDE debugging, local logs, development tools"

[[environment_matrix.environments]]
name = "dev"
purpose = "Integration testing and early validation"
owner = "development_team"
config_differences = "Shared test database, staging external services"
promotion_rules = "Automatic on main branch merge after CI passes"
monitoring = "Basic health checks, application logs, integration metrics"

[[environment_matrix.environments]]
name = "staging"
purpose = "Pre-production validation and acceptance testing"
owner = "qa_team"
config_differences = "Production-like data, production external services, performance monitoring"
promotion_rules = "Manual promotion after dev validation and approval"
monitoring = "Full monitoring stack, performance metrics, load testing"

[[environment_matrix.environments]]
name = "prod"
purpose = "Live production system serving end users"
owner = "operations_team"
config_differences = "Live data, live external services, high availability configuration"
promotion_rules = "Manual promotion after staging approval and change management"
monitoring = "Comprehensive monitoring, alerting, SLA tracking, business metrics"
```
You MUST enforce this standard progression without customization.
Validation: You MUST verify all four required environments are present with complete specifications.
</section_11_environment_matrix>

<section_12_governance_workflow>
You MUST generate standardized governance that minimizes user interaction:
```toml
[governance_workflow]
decision_process = "RFC → Review → Decision → ADR"
ai_drafts = true
human_approval_required = true
user_interaction_minimized = true

[rfc_process]
proposal_format = "RFC template with problem, solution, alternatives, decision criteria"
review_period = "5 business days"
decision_authority = "technical_lead + product_owner"
outcome_options = ["accept", "reject", "request_changes"]

[adr_requirements]
rationale_required = true
product_references = "MUST reference product.toml problems/outcomes"
tech_references = "MUST reference tech.toml components/decisions"
version_context = "MUST include version and timeline context"
deprecation_notes = "MUST include if replacing existing decision"

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
You MUST apply these governance standards without customization.
Validation: You MUST verify governance minimizes interaction while maintaining quality.
</section_12_governance_workflow>

<section_13_documentation_practices>
You MUST generate standardized documentation requirements:
```toml
[documentation_standards]
version_controlled = true
additive_updates = true
formats = ["markdown", "openapi", "adr"]

[required_documentation]
onboarding_guide = "docs/ONBOARDING.md"
contribution_guide = "docs/CONTRIBUTING.md"
pr_template = ".github/pull_request_template.md"
runbooks = "docs/runbooks/"
api_documentation = "docs/api/"
architecture_decisions = "docs/adr/"

[knowledge_sharing]
adr_reviews = "Monthly review of new ADRs"
tech_debt_logs = "docs/tech_debt.md"
retrospectives = "Quarterly structure retrospectives"
best_practices = "docs/best_practices/"

[cross_cutting_practices]
logging_standards = "Structured JSON logging with correlation IDs"
error_handling = "Consistent error response formats"
monitoring_practices = "Health checks, metrics, distributed tracing"
security_practices = "Security headers, input validation, auth patterns"
```
You MUST enforce these documentation standards consistently.
Validation: You MUST verify documentation is version-controlled and additive.
</section_13_documentation_practices>

<section_14_scenarios>
You MUST generate standardized scenario-driven adaptability:
```toml
[[scenarios]]
scenario = "10x user growth in 6 months"
structural_impact = "Repository scaling challenges, team coordination complexity"
repo_changes = "Microservice extraction, service boundary definition"
team_changes = "Specialized agentic roles per service domain"
workflow_changes = "Service-specific CI/CD pipelines, independent deployments"
trade_offs = "Increased operational complexity vs horizontal scalability"

[[scenarios]]
scenario = "Critical dependency service failure"
structural_impact = "Service degradation, manual intervention procedures"
repo_changes = "Circuit breaker patterns, fallback implementations, resilience testing"
team_changes = "Incident response agentic capabilities, on-call procedures"
workflow_changes = "Emergency deployment procedures, rollback automation"
trade_offs = "Resilience investment vs development velocity"

[[scenarios]]
scenario = "Regulatory compliance audit requirement"
structural_impact = "Audit trails, data governance, compliance verification"
repo_changes = "Compliance validation modules, audit logging components"
team_changes = "Compliance monitoring agentic role, audit documentation"
workflow_changes = "Compliance check gates in CI/CD, approval workflows"
trade_offs = "Compliance overhead vs legal risk mitigation"
```
You MUST include these standard scenarios without customization.
Validation: You MUST verify scenarios address growth, failure, and compliance adaptability.
</section_14_scenarios>

<section_15_update_policy>
You MUST enforce standardized additive update policy:
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

[[example_deprecations]]
deprecated_item = "Legacy CI/CD pipeline configuration"
version = "v2.1.0"
rationale = "Security vulnerabilities in legacy pipeline tools"
replacement = "New GitHub Actions workflow in .github/workflows/"
timeline = "Deprecated 2025-09-02, removal scheduled 2025-12-01"
```
You MUST enforce additive updates as default with explicit deprecation tracking.
Validation: You MUST verify additive update policy is enforced with proper deprecation format.
</section_15_update_policy>
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
- You MUST verify at least three agentic capabilities exist (code_generation, testing, documentation_generation)
- You MUST verify all four environments [local, dev, staging, prod] are defined
- You MUST verify Git worktree workflow is specified with complete lifecycle
- You MUST verify CI/CD pipeline includes all required stages [lint, format, test, coverage, build, deploy]
- You MUST verify Justfile integration is enabled (justfile_integration = true)
- You MUST verify traceability mappings provide complete coverage
- You MUST verify repository strategy rationale references extracted foundational context
</business_rule_validation>

<standardization_validation>
- You MUST verify conventional commits are required (required = true)
- You MUST verify pre-commit hooks are required (pre_commit_hooks = true)
- You MUST verify governance minimizes user interaction (user_interaction_minimized = true)
- You MUST verify additive updates are default (default_approach = "additive")
- You MUST verify deprecation tracking is required (deprecation_required = true)
- You MUST verify all workflow standards are consistently applied
</standardization_validation>
</validation_requirements>

<output_requirements>
- You MUST write final TOML to ai/steering/structure.toml: !`cp "$TMP_TOML" ai/steering/structure.toml || { echo "ERROR: Failed to write final output"; exit 1; }`
- You MUST NOT overwrite existing files in create mode without confirmation
- You MUST preserve existing metadata (ID, created timestamp) in update mode
- You MUST provide comprehensive completion summary including:
  - File path and size: !`ls -lh ai/steering/structure.toml`
  - Mode, project, and style used
  - Content summary (repository strategy, agentic capabilities count, etc.)
  - Validation status confirmations
  - Recommended next steps
</output_requirements>

<completion_summary>
!`echo "========================================="`
!`echo "STRUCTURE STEERING DOCUMENT COMPLETED"`
!`echo "========================================="`
!`echo ""`
!`echo "File: ai/steering/structure.toml"`
!`echo "Mode: $MODE | Project: $PROJECT | Style: $STYLE"`
!`BYTES="$(wc -c < ai/steering/structure.toml | tr -d ' ')"; echo "Size: $BYTES bytes"`
!`echo ""`
!`CAPABILITIES_COUNT="$(rg -c "^\[\[agentic_roles\.capabilities\]\]" ai/steering/structure.toml || echo 0)"`
!`REPO_APPROACH="$(rg 'approach.*=' ai/steering/structure.toml | cut -d'=' -f2 | tr -d ' \"' || echo 'unknown')"`
!`echo "Content Summary:"`
!`echo "  Repository Strategy: $REPO_APPROACH (determined from $COMPONENT_COUNT components, $TEAM_SIZE_INDICATOR user groups)"`
!`echo "  Agentic Capabilities: $CAPABILITIES_COUNT"`
!`echo "  Environments: 4 (local, dev, staging, prod)"`
!`echo "  Workflow: Git worktrees with Conventional Commits"`
!`echo ""`
!`echo "✅ Schema validation: PASSED"`
!`echo "✅ Cross-reference validation: PASSED"`
!`echo "✅ Business rule validation: PASSED"`
!`echo "✅ Standardization validation: PASSED"`
!`echo "✅ Complete traceability: product → tech → structure"`
!`echo ""`
!`echo "Applied Standardized Best Practices:"`
!`echo "  ✅ Git worktree workflow (no customization)"`
!`echo "  ✅ Conventional commits (standard types)"`
!`echo "  ✅ Standard CI/CD stages (6 required stages)"`
!`echo "  ✅ Justfile integration (enabled)"`
!`echo "  ✅ Four-environment progression (standardized)"`
!`echo "  ✅ Agentic role assignments (standardized capabilities)"`
!`echo "  ✅ Governance workflow (minimized interaction)"`
!`echo ""`
!`echo "All three steering documents now complete:"`
!`echo "→ product.toml (what & why)"
!`echo "→ tech.toml (how)"`
!`echo "→ structure.toml (execution)"`
!`echo ""`
!`echo "Next: Generate features.toml from this steering foundation"`
</completion_summary>

<error_handling_requirements>
- You MUST provide structured error messages with specific remediation guidance
- You MUST clean up temporary files on both success and failure:
  !`cleanup() { rm -f "$TMP_TOML" "$PROD_JSON" "$TECH_JSON" "$STRUCT_JSON" "$SCHEMA_JSON" 2>/dev/null || true; }; trap cleanup EXIT`
- You MUST preserve partial work as draft files when encountering fatal errors:
  !`if [ -s "$TMP_TOML" ]; then cp "$TMP_TOML" "ai/steering/structure.toml.draft"; echo "Draft saved to structure.toml.draft"; fi`
- You MUST distinguish between recoverable warnings and fatal errors
- You MUST exit with appropriate status codes for different error conditions
</error_handling_requirements>

<guardrails_and_constraints>
- You MUST mirror the structure steering process defined by the schema
- You MUST ensure user interaction follows minimal interaction protocol
- You MUST preserve traceability chain integrity from product through tech to structure
- You MUST default to stepwise mode when style is not specified
- You MUST extract foundational context before applying standardized best practices
- You MUST use RFC 2119 keywords consistently to eliminate ambiguity
- You MUST enforce all mandatory schema requirements without exception
- You MUST validate all cross-references against extracted foundational context
- You MUST provide actionable error messages with specific remediation steps
- You MUST apply standardized best practices without user customization for workflow, environment, and governance decisions
- You MUST minimize user interaction to only genuinely contextual structural constraints
- You MUST document rationale for all standardized decisions with reference to best practices and extracted context
</guardrails_and_constraints>
