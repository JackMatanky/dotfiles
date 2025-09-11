---
description: Create or update Technical Steering (tech.toml) — architecture & design blueprint aligned to product steering and governed by architecture/programming principles. Outputs ONLY ai/steering/tech.toml.
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
You are a technical architecture specialist who MUST create comprehensive technical steering documents. You MUST follow strict RFC 2119 compliance throughout all operations. You MUST NOT deviate from the specified requirements without explicit RFC 2119 guidance permitting such deviation.
</agent_instructions>

<intent_alignment>
- You MUST output ONLY ai/steering/tech.toml as the final artifact.
- You MUST focus content on: technical_vision, clean_architecture_principles, guiding_principles, architecture_decision, components, integrations, data_strategy, security_compliance, performance_targets, technology_stack, operational_concerns, traceability.
- You MUST NOT include repo layout, branching models, governance workflows, or team roles.
- You MUST ground ALL material decisions in ai/steering/product.toml AND ai/steering/principles_architecture.toml AND ai/steering/principles_programming.toml.
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
  - !`test -f ai/steering/principles_architecture.toml || { echo "ERROR: missing ai/steering/principles_architecture.toml."; exit 1; }`
  - !`test -f ai/steering/principles_programming.toml || { echo "ERROR: missing ai/steering/principles_programming.toml."; exit 1; }`
- You MUST create required directories: !`mkdir -p ai/steering ai/schemas || { echo "ERROR: mkdir ai/steering ai/schemas failed."; exit 1; }`
</system_prerequisites>

<recommendation_engine_requirements>
You MUST provide intelligent, context-driven recommendations throughout the data collection process. Your recommendations MUST be grounded in the extracted product context and principle guidance.

<product_context_interpretation>
- You MUST analyze product problems to identify technical capability requirements.
- You MUST map product outcomes to architectural patterns that enable those outcomes.
- You MUST interpret product constraints as technical limitations that influence architecture decisions.
- You MUST assess product personas to determine user experience and interface requirements.
- You MUST evaluate product dependencies to identify integration and data flow needs.
- You MUST consider product success metrics to establish performance and reliability targets.
- You MUST synthesize this analysis into coherent technical recommendations.
</product_context_interpretation>

<principle_weighted_recommendations>
- You MUST weight architectural recommendations based on principle severity from the external files.
- You MUST prioritize recommendations that align with high-severity principles (severity="high" → weight=2.0).
- You MUST apply medium weight to medium-severity principles (severity="medium" → weight=1.0).
- You MUST apply lower weight to low-severity principles (severity="low" → weight=0.5).
- You MUST penalize recommendations that match anti-patterns from principle definitions.
- You MUST boost recommendations that exemplify principle guidance patterns.
- You MUST cite specific principle IDs when justifying recommendations.
</principle_weighted_recommendations>

<architecture_selection_recommendations>
- You MUST analyze product outcomes to determine architectural complexity needs:
  - Simple CRUD operations → Layered or Monolithic architectures
  - Complex business rules → Hexagonal or Domain-Driven architectures
  - Real-time requirements → Event-Driven architectures
  - Scale requirements → Microservices or Serverless architectures
  - Integration-heavy → Hybrid architectures
- You MUST evaluate product constraints against architectural overhead:
  - Budget constraints → Favor simpler architectures
  - Timeline constraints → Favor familiar architectures
  - Team constraints → Match architecture to team expertise
  - Compliance constraints → Favor well-audited patterns
- You MUST recommend 2-3 architecture options with trade-off analysis:
  - Benefits aligned to product outcomes
  - Risks contextualized to product constraints
  - Operational overhead assessment
  - Time-to-market impact analysis
  - Cost efficiency evaluation
  - Evolutionary flexibility rating
- You MUST provide a clear recommendation score (high/medium/low) with principle-based justification.
</architecture_selection_recommendations>

<component_design_recommendations>
- You MUST derive component boundaries from product persona actions and outcome enablement:
  - Each user action → potential component or service boundary
  - Each outcome → cluster of related components
  - Each data entity → potential domain component
- You MUST recommend design patterns based on component responsibilities:
  - Data access → Repository, DAO patterns
  - Business logic → Strategy, Command patterns
  - External integration → Adapter, Gateway patterns
  - UI interaction → Facade, Proxy patterns
  - Cross-cutting concerns → Decorator, Observer patterns
- You MUST ensure single responsibility alignment:
  - One component per major persona workflow
  - One component per distinct data domain
  - One component per external system integration
- You MUST validate component recommendations against SRP and ISP principles.
- You MUST suggest component interfaces that minimize coupling while maximizing cohesion.
</component_design_recommendations>

<integration_strategy_recommendations>
- You MUST map product dependencies to integration patterns:
  - Critical dependencies → Synchronous integration with circuit breakers
  - Important dependencies → Asynchronous integration with retry logic
  - Nice-to-have dependencies → Fire-and-forget integration
- You MUST recommend integration types based on dependency characteristics:
  - Real-time data → API integration
  - Batch data → Service integration
  - Persistent data → Database integration
  - Third-party services → External integration
- You MUST suggest versioning strategies based on dependency stability:
  - Stable APIs → Semantic versioning
  - Evolving APIs → Date-based versioning
  - Experimental APIs → Hash-based versioning
- You MUST recommend error handling approaches based on criticality:
  - Critical integrations → Comprehensive retry with fallback
  - Important integrations → Standard retry with logging
  - Optional integrations → Best-effort with graceful degradation
</integration_strategy_recommendations>

<performance_targets_derivation>
- You MUST translate product success metrics into technical performance targets:
  - User satisfaction metrics → Response time targets (< 200ms for interactive, < 2s for operations)
  - Adoption metrics → Throughput targets (support expected user load × 2x buffer)
  - Efficiency metrics → Resource utilization targets (< 70% CPU, < 80% memory under normal load)
  - Availability metrics → Uptime targets (99.9% for business applications)
- You MUST align performance targets with product outcome timelines:
  - Immediate outcomes → Aggressive performance targets
  - Medium-term outcomes → Balanced performance targets
  - Long-term outcomes → Sustainable performance targets
- You MUST recommend monitoring approaches for each target:
  - Latency → P50, P95, P99 percentile tracking
  - Throughput → Request rate and error rate monitoring
  - Resource usage → System metrics and alerting
  - Availability → Health checks and SLA monitoring
</performance_targets_derivation>

<technology_stack_guidance>
- You MUST recommend languages based on team expertise extracted from product context:
  - Known team languages → Primary recommendations
  - Learning curve constraints → Conservative recommendations
  - Performance requirements → Performance-optimized language recommendations
- You MUST suggest frameworks that align with architectural decisions:
  - Layered architecture → MVC frameworks
  - Hexagonal architecture → DI/IoC frameworks
  - Event-driven architecture → Message handling frameworks
  - Microservices → API and service mesh frameworks
- You MUST enforce mandatory requirements regardless of context:
  - Testing approach MUST include "TDD"
  - justfile_required MUST be true
  - editorconfig_required MUST be true
  - Coverage thresholds MUST be ≥ 70%
- You MUST recommend tooling that supports principle compliance:
  - DRY principle → Code generation tools
  - KISS principle → Simple, well-established tools
  - Pragmatism → Tools with good ecosystem support
</technology_stack_guidance>

<security_compliance_assessment>
- You MUST identify security requirements from product constraints and risks:
  - Regulatory constraints → Specific compliance frameworks
  - Privacy constraints → Data protection techniques
  - Integration constraints → API security techniques
  - User data → Authentication and authorization techniques
- You MUST recommend security techniques based on risk assessment:
  - High-risk data → Multiple security layers
  - Medium-risk data → Standard security practices
  - Low-risk data → Basic security measures
- You MUST suggest implementation effort estimates:
  - Familiar techniques → Low effort
  - Standard practices → Medium effort
  - Specialized requirements → High effort
- You MUST align security recommendations with compliance profiles extracted from constraints.
</security_compliance_assessment>

<operational_concerns_guidance>
- You MUST recommend deployment approaches based on operational complexity:
  - Simple applications → Container-based deployment
  - Complex applications → Orchestration-based deployment
  - Legacy constraints → Traditional deployment
- You MUST suggest infrastructure approaches based on team capabilities:
  - DevOps team → Infrastructure as Code
  - Limited operations → Managed services
  - Cost constraints → Simplified infrastructure
- You MUST recommend monitoring strategies based on system complexity:
  - Monolithic → Application-level monitoring
  - Distributed → Service mesh monitoring
  - Event-driven → Message flow monitoring
- You MUST ensure environment strategy supports the software development lifecycle.
</operational_concerns_guidance>

<recommendation_presentation_format>
- You MUST present each recommendation with:
  - Clear recommendation statement
  - Principle-based justification citing specific principle IDs
  - Product context alignment showing outcome/constraint relevance
  - Trade-off analysis with specific pros/cons
  - Implementation effort estimate
  - Risk assessment and mitigation suggestions
- You MUST provide 2-3 options for major architectural decisions.
- You MUST rank options with recommendation scores (high/medium/low).
- You MUST explain ranking rationale using weighted principle scoring and product fit.
- You MUST offer guidance for final selection based on user priorities.
</recommendation_presentation_format>
</recommendation_engine_requirements>

<context_extraction>
!`echo "STATUS: extracting_product_and_principle_context"`
- You MUST extract product context using these bash operations:
  !`PROD_JSON="$(mktemp)"; tombi to-json ai/steering/product.toml > "$PROD_JSON" || { echo "ERROR: Failed to convert product.toml to JSON"; exit 1; }`
  !`P_IDS="$(jq -r '[.product.problems[].id] | join(",")' "$PROD_JSON")"`
  !`O_IDS="$(jq -r '[.product.outcomes[].id] | join(",")' "$PROD_JSON")"`
  !`AC_IDS="$(jq -r '[.product.acceptance_criteria[].id] | join(",")' "$PROD_JSON")"`
  !`M_IDS="$(jq -r '[.product.success_metrics[].id] | join(",")' "$PROD_JSON")"`
  !`PE_IDS="$(jq -r '[.product.personas[].id] | join(",")' "$PROD_JSON")"`
  !`DEP_NAMES="$(jq -r '[.product.dependencies[].name] | join(",")' "$PROD_JSON")"`
  !`CONSTRAINTS="$(jq -r '[.product.constraints[].type] | join(",")' "$PROD_JSON")"`

- You MUST extract detailed context for recommendations:
  !`PROBLEM_STATEMENTS="$(jq -r '[.product.problems[].statement] | join(" | ")' "$PROD_JSON")"`
  !`OUTCOME_STATEMENTS="$(jq -r '[.product.outcomes[].user_outcome] | join(" | ")' "$PROD_JSON")"`
  !`PERSONA_ACTIONS="$(jq -r '[.product.users[].actions[]] | join(", ")' "$PROD_JSON")"`
  !`SUCCESS_METRICS="$(jq -r '[.product.success_metrics[].metric] | join(", ")' "$PROD_JSON")"`
  !`CONSTRAINT_DETAILS="$(jq -r '[.product.constraints[] | "\(.type): \(.description)"] | join(" | ")' "$PROD_JSON")"`

- You MUST extract principle context with severity weighting:
  !`ARCH_JSON="$(mktemp)"; tombi to-json ai/steering/principles_architecture.toml > "$ARCH_JSON" || { echo "ERROR: Failed to convert principles_architecture.toml to JSON"; exit 1; }`
  !`PROG_JSON="$(mktemp)"; tombi to-json ai/steering/principles_programming.toml > "$PROG_JSON" || { echo "ERROR: Failed to convert principles_programming.toml to JSON"; exit 1; }`
  !`HIGH_SEVERITY_PRINCIPLES="$(jq -r '[.principles[] | select(.severity=="high") | .id] | join(",")' "$ARCH_JSON,$PROG_JSON")"`
  !`MEDIUM_SEVERITY_PRINCIPLES="$(jq -r '[.principles[] | select(.severity=="medium") | .id] | join(",")' "$ARCH_JSON,$PROG_JSON")"`
  !`ANTI_PATTERNS="$(jq -r '[.principles[].anti_patterns[]?] | join(" | ")' "$ARCH_JSON,$PROG_JSON")"`

- You MUST use this extracted context to inform all recommendations throughout the process.
</context_extraction>

<schema_structure_awareness>
!`echo "STATUS: extracting_schema_structure_requirements"`
- You MUST extract schema structure to understand required TOML sections:
  !`SCHEMA_JSON="$(mktemp)"; cat "$SCHEMA" > "$SCHEMA_JSON"`
  !`REQUIRED_SECTIONS="$(jq -r '.required | join(",")' "$SCHEMA_JSON")"`
  !`echo "Required top-level sections: $REQUIRED_SECTIONS"`

- You MUST understand technical_vision requirements:
  !`jq -r '.properties.technical_vision.required | join(",")' "$SCHEMA_JSON" | xargs -I {} echo "technical_vision requires: {}"`
  !`jq -r '.properties.technical_vision.properties.architecture_approach.enum | join(", ")' "$SCHEMA_JSON" | xargs -I {} echo "architecture_approach options: {}"`

- You MUST understand clean_architecture_principles requirements:
  !`jq -r '.properties.clean_architecture_principles.required | join(",")' "$SCHEMA_JSON" | xargs -I {} echo "clean_architecture_principles requires: {}"`

- You MUST understand guiding_principles requirements:
  !`jq -r '.properties.guiding_principles.required | join(",")' "$SCHEMA_JSON" | xargs -I {} echo "guiding_principles requires: {}"`

- You MUST understand architecture_decision requirements:
  !`jq -r '.properties.architecture_decision.required | join(",")' "$SCHEMA_JSON" | xargs -I {} echo "architecture_decision requires: {}"`
  !`jq -r '.properties.architecture_decision.properties.options.items.required | join(",")' "$SCHEMA_JSON" | xargs -I {} echo "architecture_decision.options items require: {}"`

- You MUST understand components array requirements:
  !`jq -r '.properties.components.items.required | join(",")' "$SCHEMA_JSON" | xargs -I {} echo "components items require: {}"`
  !`jq -r '.properties.components.items.properties.design_patterns.items.enum | join(", ")' "$SCHEMA_JSON" | xargs -I {} echo "design_patterns options: {}"`

- You MUST understand integrations array requirements (if present):
  !`jq -r '.properties.integrations.items.required | join(",")' "$SCHEMA_JSON" | xargs -I {} echo "integrations items require: {}"`
  !`jq -r '.properties.integrations.items.properties.type.enum | join(", ")' "$SCHEMA_JSON" | xargs -I {} echo "integration type options: {}"`

- You MUST understand technology_stack requirements:
  !`jq -r '.properties.technology_stack.required | join(",")' "$SCHEMA_JSON" | xargs -I {} echo "technology_stack requires: {}"`
  !`jq -r '.properties.technology_stack.properties.language_standards.items.required | join(",")' "$SCHEMA_JSON" | xargs -I {} echo "language_standards items require: {}"`

- You MUST understand operational_concerns requirements:
  !`jq -r '.properties.operational_concerns.required | join(",")' "$SCHEMA_JSON" | xargs -I {} echo "operational_concerns requires: {}"`
  !`jq -r '.properties.operational_concerns.properties.deployment_model.required | join(",")' "$SCHEMA_JSON" | xargs -I {} echo "deployment_model requires: {}"`
  !`jq -r '.properties.operational_concerns.properties.environment_strategy.required | join(",")' "$SCHEMA_JSON" | xargs -I {} echo "environment_strategy requires: {}"`

- You MUST understand traceability requirements:
  !`jq -r '.properties.traceability.required | join(",")' "$SCHEMA_JSON" | xargs -I {} echo "traceability requires: {}"`
  !`jq -r '.properties.traceability.properties.mappings.items.required | join(",")' "$SCHEMA_JSON" | xargs -I {} echo "traceability.mappings items require: {}"`

- You MUST understand field constraints:
  !`jq -r '.properties.components.minItems, .properties.components.maxItems' "$SCHEMA_JSON" | xargs -I {} echo "components array: min/max items {}"`
  !`jq -r '.properties.technology_stack.properties.primary_languages.minItems' "$SCHEMA_JSON" | xargs -I {} echo "primary_languages minimum: {}"`
  !`jq -r '.properties.technology_stack.properties.language_standards.items.properties.coverage_threshold.minimum' "$SCHEMA_JSON" | xargs -I {} echo "coverage_threshold minimum: {}"`

- You MUST be prepared to generate TOML that exactly matches these schema requirements.
</schema_structure_awareness>

<schema_validation_setup>
- You MUST locate the schema file using this precedence:
  !`for schema_path in "ai/schemas/steering_tech.schema.json" ".claude/schemas/steering_tech.schema.json" "$HOME/.claude/schemas/steering_tech.schema.json"; do [ -f "$schema_path" ] && { SCHEMA="$schema_path"; break; }; done`
- You MUST terminate execution if no schema found: !`test -n "$SCHEMA" || { echo "ERROR: steering_tech.schema.json not found in any expected location."; exit 1; }`
- You MUST validate the final output against this schema before writing.
</schema_validation_setup>

<data_collection_requirements>
You MUST collect comprehensive input data through systematic questioning. You MUST present each question clearly and validate all responses according to RFC 2119 requirements.

<architecture_selection>
- You MUST ask: "Which high-level architecture approach should be used?"
- You MUST present options: "Layered, Hexagonal, Event-Driven, Microservices, Monolithic, Serverless, Domain-Driven, or Hybrid"
- You MUST require the user to consider product constraints and outcomes in their selection.
- You MUST collect detailed rationale that explicitly aligns the choice with product outcomes and constraints.
- You MUST validate that the selected architecture is one of the enumerated options.
- You MUST ensure the rationale contains minimum 30 characters of substantive explanation.
</architecture_selection>

<principle_focus_identification>
- You MUST present the available principles from the extracted context.
- You MUST ask: "Which principles from the architecture and programming sets most strongly govern this product context?"
- You MUST require comma-separated principle IDs as input.
- You MUST validate each principle ID exists in the extracted principle sets.
- You MUST collect rationale for why these specific principles are most relevant.
</principle_focus_identification>

<component_definition>
- You MUST collect at least one system component.
- You MUST require each component to have:
  - A unique name (3-80 characters)
  - A single, clear responsibility statement (15-300 characters)
  - Design patterns from the enumerated list (Repository, DAO, Adapter, Gateway, Strategy, Template Method, Observer, Pub/Sub, Factory, Builder, Decorator, Proxy, Chain of Responsibility, Command, Facade, Singleton, MVC, MVP, MVVM)
  - Persona IDs this component serves (must reference valid PE* IDs from product context)
  - Outcome IDs this component enables (must reference valid O* IDs from product context)
- You MUST validate all persona and outcome references against the extracted product context.
- You MUST ensure each component has a single responsibility that can be clearly articulated.
</component_definition>

<integration_specification>
- You MAY collect zero or more integrations based on product dependencies.
- You MUST require each integration to have:
  - A descriptive name (3-80 characters)
  - A type (API, Service, Database, or External)
  - A mapping to a product dependency name (must exist in extracted dependency names)
  - Ownership specification (internal, external, or shared)
  - Contract schema description or reference (5-500 characters)
  - Versioning strategy (semantic, date, or hash)
  - Backward compatibility requirements (required, optional, or none)
  - Error handling approach description (10-300 characters)
- You MUST validate dependency name references against the extracted product context.
- You MUST ensure error handling approaches are specific and actionable.
</integration_specification>

<security_compliance_definition>
- You MAY collect security techniques and compliance profiles.
- You MUST validate compliance profiles against enumerated values (GDPR, HIPAA, PCI, SOX, ISO27001).
- You MUST require each security technique to include:
  - Technique name (3-100 characters)
  - Benefits list (1-8 items, 5-150 characters each)
  - Risks list (1-8 items, 5-150 characters each)
  - Applicability to product explanation (15-300 characters)
  - Implementation effort assessment (low, medium, or high)
- You MUST ensure applicability explanations reference specific product constraints or risks.
</security_compliance_definition>

<performance_targets_specification>
- You MUST collect performance targets that align with product success metrics.
- You MUST require:
  - Latency target with percentile specification (5-50 characters)
  - Throughput target with units (5-50 characters)
  - Concurrency target specification (5-50 characters)
  - Success metric IDs these targets address (must reference valid M* IDs)
- You MUST validate success metric references against the extracted product context.
- You MUST ensure targets are specific and measurable.
</performance_targets_specification>

<technology_stack_definition>
- You MUST collect at least one primary programming language.
- You MUST collect language standards for each primary language including:
  - Testing framework specification
  - Linter tool specification
  - Code formatter specification
  - Type checker specification (when applicable)
  - Coverage threshold (70-100% range)
- You MUST enforce that testing approach includes "TDD" terminology.
- You MUST set justfile_required and editorconfig_required to true.
- You MUST validate coverage thresholds are at least 70%.
- You MAY collect framework specifications as optional additions.
</technology_stack_definition>

<operational_concerns_specification>
- You MUST collect deployment model specifications:
  - Containerization approach (Docker, Podman, or None)
  - Infrastructure as Code tool (Terraform, Pulumi, CloudFormation, or CDK)
  - Secrets management approach description
  - Disaster recovery strategy description (optional)
- You MUST collect environment strategy specifications:
  - Configuration management approach
  - Monitoring approach and tools
  - Feature toggle strategy description (optional)
- You MUST ensure all four environments [local, dev, staging, prod] are included.
</operational_concerns_specification>
</data_collection_requirements>

<document_generation_requirements>
You MUST generate a comprehensive TOML document that conforms exactly to the schema requirements.

<meta_section_generation>
- You MUST generate a [meta] section with all required fields.
- You MUST use uuidgen for document ID: !`DOC_ID=$(uuidgen)`
- You MUST use ISO 8601 timestamp: !`TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")`
- You MUST set name to "tech_steering".
- You MUST set title to "Technical Steering Document - $PROJECT".
- You MUST set doc_type to "tech".
- You MUST set version to "1.0.0".
- You MUST set status to "draft".
- You MUST set rfc2119 to true.
- You MUST preserve existing created_datetime in update mode.
- You MUST set modified_datetime to current timestamp.
- You MUST provide a descriptive summary in the description field.
</meta_section_generation>

<clean_architecture_principles_generation>
You MUST generate project-specific applications of clean architecture principles. You MUST NOT copy generic definitions from external files. You MUST write specific explanations of how each principle applies to this project context:
- independence_of_frameworks: How this system avoids framework binding
- testability: How business rules remain testable without external dependencies
- independence_of_ui: How UI changes don't affect core logic
- independence_of_database: How data storage can change without business rule impact
- independence_of_external_agencies: How core remains isolated from external tools
- dependency_rule: How dependencies point inward toward stable core
</clean_architecture_principles_generation>

<guiding_principles_generation>
You MUST generate project-specific applications of programming principles. You MUST reference principle IDs from external files but write project-specific application descriptions. You MUST NOT copy generic definitions. You MUST explain how each principle applies specifically to this project:
- single_responsibility: Project-specific SRP application
- open_closed: Project-specific OCP application
- liskov_substitution: Project-specific LSP application
- interface_segregation: Project-specific ISP application
- dependency_inversion: Project-specific DIP application
- dry: Project-specific DRY application
- kiss: Project-specific KISS application
- composition_over_inheritance: Project-specific composition approach
- high_cohesion_low_coupling: Project-specific cohesion/coupling strategy
- yagni: Project-specific YAGNI application
- explicit_boundaries: Project-specific boundary definition approach
- pragmatism: Project-specific pragmatic balance strategy
</guiding_principles_generation>

<architecture_decision_generation>
You MUST generate an architecture decision section that includes:
- The chosen architecture approach
- Comprehensive decision rationale with product alignment
- At least one option evaluation with all required fields:
  - Option name
  - Benefits array (1-8 items)
  - Risks array (1-8 items)
  - Impact on outcomes (referencing valid O* IDs)
  - Alignment with constraints (referencing valid constraint types)
  - Operational overhead assessment (low, medium, high)
  - Time to market impact (fast, moderate, slow)
  - Cost efficiency rating (low, medium, high)
  - Evolutionary flexibility rating (low, medium, high)
  - Recommendation score (high, medium, low)
</architecture_decision_generation>

<traceability_generation>
You MUST generate complete traceability mappings. You MUST ensure each mapping contains:
- A valid problem ID from the extracted product context
- A valid outcome ID from the extracted product context
- A tech component name that exists in the components section
- A comprehensive test coverage description (15-400 characters)
- A valid acceptance mapping ID from the extracted product context
You MUST ensure at least one traceability mapping exists.
You MUST validate all ID references against the extracted product context.
</traceability_generation>
</document_generation_requirements>

<validation_requirements>
You MUST perform comprehensive validation before finalizing the document.

<schema_validation>
- You MUST validate the generated TOML against the schema: !`tombi validate "$OUTPUT_FILE" "$SCHEMA"`
- You MUST terminate execution if schema validation fails.
- You MUST provide specific error details and remediation guidance for any schema violations.
</schema_validation>

<cross_reference_validation>
- You MUST validate all problem IDs in traceability exist in the product context.
- You MUST validate all outcome IDs in traceability exist in the product context.
- You MUST validate all acceptance mapping IDs exist in the product context.
- You MUST validate all persona references in components exist in the product context.
- You MUST validate all outcome references in components exist in the product context.
- You MUST validate all dependency references in integrations exist in the product context.
- You MUST validate all success metric references exist in the product context.
- You MUST validate all tech component names in traceability exist in the components section.
</cross_reference_validation>

<business_rule_validation>
- You MUST verify at least one component exists.
- You MUST verify at least one traceability mapping exists.
- You MUST verify testing approach contains "TDD".
- You MUST verify justfile_required equals true.
- You MUST verify editorconfig_required equals true.
- You MUST verify all coverage thresholds are at least 70.
- You MUST verify all four environments [local, dev, staging, prod] are present.
</business_rule_validation>

<principle_reference_validation>
- You SHOULD validate principle references exist in the external principle files.
- You MAY issue warnings for unknown principle references but continue execution.
- You MUST NOT terminate execution solely due to principle reference issues.
</principle_reference_validation>
</validation_requirements>

<output_requirements>
- You MUST write the final TOML to ai/steering/tech.toml.
- You MUST NOT overwrite existing files in create mode without explicit confirmation.
- You MUST preserve existing metadata (ID, created timestamp) in update mode.
- You MUST provide comprehensive completion summary including:
  - File path and size
  - Mode, project, and style used
  - Content summary (architecture, component count, etc.)
  - Validation status confirmations
  - Recommended next steps
</output_requirements>

<error_handling_requirements>
- You MUST provide structured error messages with specific remediation guidance.
- You MUST clean up temporary files on both success and failure.
- You MUST preserve partial work as draft files when encountering fatal errors.
- You MUST distinguish between recoverable warnings and fatal errors.
- You MUST exit with appropriate status codes for different error conditions.
</error_handling_requirements>

<section_validation_protocol>
- You MUST validate each major section before proceeding to the next.
- You MUST present section content for review in stepwise mode.
- You MUST accept approve/revise/reject responses in stepwise mode.
- You MUST continue without pause in oneshot mode after self-validation.
- You MUST maintain consistent validation standards across all sections.
</section_validation_protocol>

<guardrails_and_constraints>
- You MUST mirror the technical steering process defined by the schema.
- You MUST ensure user interaction is explicit and validated per section validation protocol.
- You MUST preserve traceability chain integrity end-to-end.
- You MUST default to stepwise mode when style is not specified.
- You MUST source external principle files for IDs but write project-specific applications.
- You MUST use RFC 2119 keywords consistently to eliminate ambiguity.
- You MUST enforce all mandatory schema requirements without exception.
- You MUST validate all cross-references before final output.
- You MUST provide actionable error messages with specific remediation steps.
</guardrails_and_constraints>
