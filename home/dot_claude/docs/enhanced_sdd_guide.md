# Enhanced SDD Guide & Overview: Steering → Features → Spec

## Purpose of This Guide

Provide a clear, comprehensive, and actionable overview of an enhanced Spec-Driven Development (SDD) workflow that adds a **Steering** and **Portfolio** layer on top of Kiro’s baseline SDD. This guide defines **what each artifact is for (Purpose), what it must contain (Scope), and how it is used (Function)**—with zero ambiguity.

---

## Why Extend Kiro’s SDD

Problems observed in baseline SDD (as commonly practiced):

- Lack of a **Steering foundation**: teams jump into requirements without an agreed product vision, technical constraints, or delivery structure.
- **Weak portfolio control**: features are not explicitly ordered, statused, or guaranteed to be small and independent.
- **One-way traceability**: downstream docs reference upstream context, but upstream artifacts don’t list their downstream children, impairing impact analysis.
- **Coverage gaps**: no hard rule that every requirement is covered by design and every design element is covered by tasks.
- **Governance gaps**: approvals and lifecycle states are not captured in a machine-readable way, limiting automation.

Enhancements introduced here:

- **Steering Stage** (product.md, tech.md, structure.md) creates the contextual foundation.
- **Portfolio & Scoping Stage** (features.toml, spec_overview.toml) ensures atomic, sprint-feasible features with explicit **order** and **status**.
- **Bidirectional traceability**: upstream lists children; downstream cites parents.
- **Coverage guarantees**: Requirements → Design → Tasks mapping is mandatory.
- **Lifecycle governance**: spec.json records status and approvals to enable CI/CD enforcement.

---

## Workflow Overview (Three Stages)

Stage 1 — **Steering (Context Foundation)**

- Files: product.md, tech.md, structure.md
- Goal: establish _why_ we build, _how_ we must build, and _where_ work lives.

Stage 2 — **Features (Portfolio & Scoping)**

- Files: features.toml, spec_overview.toml
- Goal: transform steering into **atomic**, **prioritized**, **independently deliverable** features.

Stage 3 — **Spec (Implementation-Ready)**

- Files: requirements.md, design.md, tasks.md, spec.json
- Goal: produce testable, traceable, executable specs with full coverage and governance.

Guiding Principles:

- **Sequential Integrity**: never create downstream artifacts without upstream prerequisites.
- **Traceability**: bidirectional, stable identifiers everywhere.
- **Minimal Duplication**: reference by IDs instead of copying content.
- **Portfolio Governance**: features are atomic, ordered, and statused.
- **Change Impact**: upstream changes trigger downstream re-validation.

---

## Artifact Reference (Exhaustive Purpose · Scope · Function)

### 1. ai/steering/product.md

Purpose:

- Be the **north star**: articulate product vision, problems, users, and value clearly enough that every downstream artifact can justify its existence against it.

Scope (must include):

- Product definition in one sentence (what, for whom, why it matters).
- Problem statements with measurable pains and current constraints.
- Primary/secondary personas; user segments and stakeholders.
- Value proposition; intended outcomes and success signals.
- Core use cases and key scenarios (happy-path + critical edge cases).
- Explicit scope boundaries (in-scope / out-of-scope).
- Business assumptions, external dependencies, and non-goals.
- Links to related strategies/OKRs (if applicable).

Function (how it’s used):

- **Input** to features.toml scoping and prioritization.
- **Anchor** for acceptance criteria and success metrics.
- **Change driver**: any material update triggers feature/spec impact analysis.

Acceptance & Quality Gates:

- All problems trace to personas; all outcomes are measurable.
- No conflicting scope statements; non-goals are explicit.
- Each feature later in features.toml cites at least one problem/outcome here.

Common Ambiguities Eliminated:

- “Vague target users” → require specific personas and pains.
- “Soft outcomes” → require measurable signals.

---

### 2. ai/steering/tech.md

Purpose:

- Serve as the **technical constitution**: define architectural boundaries, approved technologies, NFRs, and integration constraints that all specs must honor.

Scope (must include):

- Target architecture and component decomposition; key interfaces/ports.
- Approved technology stacks and libraries; deprecations/disallowed items.
- Security, privacy, compliance requirements (authZ/authN, data handling).
- Performance, scalability, availability, and latency targets.
- Data strategy: models, retention, migration, lineage, backup/restore.
- Integration constraints: external systems, SLAs, error contracts, rate limits.
- Reliability/observability baselines: logging, tracing, metrics, alerting.

Function:

- **Guardrails** for design.md; **constraints** for requirements phrasing.
- **Basis** for structure.md decisions on repo/workflow/CI conventions.
- **Change driver**: any principle/NFR change triggers design/task review.

Acceptance & Quality Gates:

- Every NFR has a measurable target and validation approach.
- Stacks are approved and mapped to components (no orphan tech choices).
- External integrations declare SLAs and contract expectations.

Ambiguities Eliminated:

- “Use best practices” → specify exact practices, thresholds, and tools.
- “We can scale later” → define scale targets and testing approach now.

---

### 3. ai/steering/structure.md

Purpose:

- Act as the **operational delivery blueprint**: define repository layout, modular boundaries, branch strategy, CI/CD, environments, and governance rules.

Scope (must include):

- Repository & directory layout; module boundaries; naming conventions.
- Layering rules (e.g., domain ↔ application ↔ infrastructure) and allowed dependencies.
- Branching model, PR policy, code review standards, required checks.
- CI/CD stages, promotion rules, artifact naming/versioning, rollback policy.
- Environment definitions (local/dev/staging/prod), config & secrets handling.
- Traceability conventions (IDs in commits/PRs), decision logs/ADRs, RACI.

Function:

- **Reference** for where code lives and how it flows to production.
- **Enforcement**: CI/CD pipelines rely on these rules.
- **Change driver**: process/layout changes trigger contributor enablement work.

Acceptance & Quality Gates:

- No path ambiguity: every module has a single canonical home.
- CI/CD pipeline stages and required checks are unambiguous and testable.
- Governance (reviewers, approvers) is defined by role, not ad hoc.

Ambiguities Eliminated:

- “We’ll figure branching as we go” → branching & PR rules are explicit.
- “Loose structure” → directory & ownership are strictly defined.

---

### 4. ai/steering/features.toml

Purpose:

- Be the **single source of truth** for the feature portfolio: each feature is **atomic**, **independently valuable**, **sprint-feasible**, and **prioritized**.

Scope (must include per feature):

- Stable identifiers: id, name (snake_case recommended).
- Portfolio fields: order (execution precedence), status (planned/in-progress/done/archived), owner.
- Category (product/tech/structure) and rationale (why now).
- Scope boundaries: includes/excludes; assumptions; dependencies.
- Integration points; upstream references (product.md/tech.md/structure.md sections).
- Acceptance criteria; success metrics; high-level test scenarios.

Function:

- **Intake**: gate for any new work—no spec without a portfolio entry.
- **Sequencing**: the backlog’s authoritative order of execution.
- **Traceability**: each feature links back to steering sources and forward to its spec folder.

Acceptance & Quality Gates:

- **Atomicity**: deliverable by one team in one sprint.
- **Independence**: useful without requiring other not-yet-delivered features.
- **Non-overlap**: scopes don’t intersect with other features.
- **Completeness**: has ACs/metrics and upstream references.

Ambiguities Eliminated:

- “Epic-like features” → break down until atomic/sprint-feasible.
- “Implied dependencies” → list explicit dependencies and integration points.

---

### 5. ai/specs/<feature-id>/spec_overview.toml

Purpose:

- Serve as the **per-feature blueprint** that translates portfolio intent into the precise inputs needed to generate high-quality requirements, design, and tasks.

Scope (must include):

- [meta] with lifecycle/version info; linkage to features.toml (steering_feature_id).
- Canonical upstream references (product/tech/structure section anchors).
- Requirements index: stable requirement IDs/titles with short descriptions.
- High-level design summary: components touched, interfaces, constraints.
- Acceptance criteria and success metrics at implementable granularity.
- Risks/assumptions; open questions; data & integration notes.

Function:

- **Bridge** between features.toml and spec documents.
- **Quality gate**: prevents under-specified requirements/design later.
- **Change driver**: updates here cascade to requirements/design.

Acceptance & Quality Gates:

- Requirements index is complete and free of duplicates.
- Each requirement has at least one AC and a measurable metric link.
- Design summary identifies all impacted components and interfaces.

Ambiguities Eliminated:

- “We’ll decide details in design” → outline constraints and interfaces up front.
- “Requirements TBD” → index must be explicit before requirements.md generation.

---

### 6. ai/specs/<feature-id>/requirements.md

Purpose:

- Define **what must be built** in testable, unambiguous terms using an EARS-style structure, suitable for review, approval, and automated validation.

Scope (must include):

- Grouped functional areas with numbered, stable requirement IDs.
- Each requirement written in EARS-style (WHEN/IF/WHILE/WHERE → SHALL).
- Acceptance criteria linked to ACs from spec_overview; references to steering.
- NFRs linked to tech.md targets (latency, availability, security, etc.).

Function:

- **Acceptance contract** for the feature; input to design and tests.
- **Traceability hub**: every design element and task must map back here.

Acceptance & Quality Gates:

- Each requirement has ACs that are objectively testable.
- No requirement contradicts tech constraints or product scope.
- Coverage: no dangling requirements (must be referenced by design and tasks).

Ambiguities Eliminated:

- “Should/May/Could” phrasing → use SHALL with explicit triggers and outcomes.
- “Implicit success criteria” → ACs are explicit and measurable.

---

### 7. ai/specs/<feature-id>/design.md

Purpose:

- Define **how** the requirements will be realized: architecture, component changes, interfaces, data models, error handling, and testing strategy.

Scope (must include):

- System/context diagrams; component diagrams; data flow diagrams (as needed).
- Interface contracts: inputs/outputs, error semantics, timeouts, idempotency.
- Data model deltas: schemas, migrations, retention, privacy.
- Cross-cutting concerns: logging, tracing, metrics, rate limiting, retries.
- Test strategy: unit, integration, contract, performance; mapping to requirements.
- Operational concerns: deployment impact, feature flags, rollback.

Function:

- **Blueprint** for engineering; enables deterministic task planning.
- **Constraint enforcement** from tech.md; ensures feasibility & compliance.

Acceptance & Quality Gates:

- Every requirement maps to at least one design element (coverage matrix).
- All external integrations are specified with error contracts and SLAs.
- NFRs have a test approach (e.g., load tests, chaos, fault injection).

Ambiguities Eliminated:

- “We’ll discover the interface while coding” → define contracts here.
- “We’ll test later” → define test strategy and responsibilities now.

---

### 8. ai/specs/<feature-id>/tasks.md

Purpose:

- Provide the **execution plan**: granular, ordered tasks (1–2 hours each) that implement the design incrementally and test-first.

Scope (must include):

- Flat, dependency-aware task list grouped by functional area.
- Each task ends with `_Requirements: <IDs or statement>` for traceability.
- 3–5 sub-steps max per task; clear “done” signal.
- Explicit notes on generated code/tests/artifacts.

Function:

- **Day-to-day guide** for contributors; feeds issue trackers and PR sequencing.
- **Traceability** to requirements and back from commits (include IDs in branch/PR/commit messages per structure.md).

Acceptance & Quality Gates:

- No orphan tasks (every task maps to a requirement).
- No uncovered requirements (every requirement has tasks).
- Tasks are truly 1–2 hours; split if larger.

Ambiguities Eliminated:

- “Research tasks disguised as delivery” → separate spikes from delivery tasks.
- “Phase labels” → use functional grouping and dependency ordering instead.

---

### 9. ai/specs/<feature-id>/spec.json

Purpose:

- Act as the **lifecycle ledger**: machine-readable status, approvals, and pointers enabling CI/CD enforcement and audits.

Scope (must include):

- Phase booleans/states (requirements_generated/approved, design_approved, tasks_approved).
- Approval history (who, when, decision, notes).
- Links: steering_feature_id, upstream file references, downstream artifact hashes.
- Optional: language/tooling preferences for code generation, test thresholds.

Function:

- **Gatekeeper**: CI fails if a phase is advanced without approvals.
- **Audit**: single source for who approved what and when.
- **Impact**: used by bots to open/update issues upon upstream changes.

Acceptance & Quality Gates:

- States are consistent with file timestamps and PR records.
- Approvals captured with identity and timestamp.
- Links are resolvable; hashes match the current content.

Ambiguities Eliminated:

- “Was this approved?” → spec.json is authoritative.
- “Who approved?” → immutable approval history.

---

## Cross-Artifact Rules (Non-Negotiable)

- **Sequential Integrity**: product/tech/structure → features.toml → spec_overview → requirements → design → tasks.
- **Bidirectional Traceability**: downstream cites upstream IDs; upstream lists downstream children (feature lists spec folder; product lists features; etc.).
- **Coverage Guarantees**:
  - Every requirement appears in design and tasks.
  - Every design element maps back to one or more requirements.
  - Every task maps back to one or more requirements.
- **Change Impact Protocol**:
  - If product.md changes problems/outcomes → re-assess affected features; reopen spec_overview and requirements as needed.
  - If tech.md changes NFRs/constraints → reopen design and tasks for affected specs.
  - If structure.md changes pipelines/workflows → update tasks affecting delivery steps.

---

## Roles & Responsibilities (RACI-style, lightweight)

- **Product Lead**: owns product.md; co-owns features.toml rationale/order.
- **Architect/Tech Lead**: owns tech.md; co-owns design.md and structure.md.
- **Eng Lead**: owns structure.md and tasks.md; enforces CI/CD gates.
- **QA/Verification**: co-owns acceptance criteria consistency and test strategy.
- **All Contributors**: must preserve IDs and traceability in branches/PRs/commits.

---

## File Organization (Canonical Layout)

```
ai/
  steering/
    product.md        (product vision)
    tech.md           (technical constitution)
    structure.md      (delivery blueprint)
    features.toml     (feature portfolio)
  specs/
    <feature-id>/
      spec_overview.toml
      requirements.md
      design.md
      tasks.md
      spec.json
```

---

## Quality Checklists (Quick Exit Criteria)

- product.md: personas linked to problems; outcomes measurable; non-goals explicit.
- tech.md: NFRs measurable; stacks mapped to components; integration SLAs documented.
- structure.md: repo layout unambiguous; CI/CD stages & required checks defined.
- features.toml: atomicity, independence, non-overlap, ACs/metrics present.
- spec_overview.toml: complete requirement index; design summary; risks & questions logged.
- requirements.md: EARS style; ACs testable; no contradictions with tech/product.
- design.md: interfaces/contracts explicit; test strategy mapped to requirements.
- tasks.md: 1–2h tasks; each ends with \_Requirements: …; no orphan/oversized tasks.
- spec.json: states consistent; approvals recorded; links resolve; hashes match.

---

## Glossary (Ambiguity Killers)

- **Atomic Feature**: independently deliverable in one sprint by one team, with its own ACs/metrics; provides standalone value.
- **Independence**: a feature is useful without requiring not-yet-delivered features.
- **Bidirectional Traceability**: every artifact links up and is listed down (parents know children; children cite parents).
- **EARS**: requirement style using explicit triggers and SHALL clauses to ensure testability.
- **NFRs**: non-functional requirements (performance, security, reliability, etc.) with measurable targets.

---

## How to Use This Guide

- As a **reader**: understand where each artifact fits, what it must contain, and how quality is enforced.
- As a **practitioner**: create/update artifacts in the stated sequence and meet each artifact’s acceptance gates.
- As a **governor**: wire CI/CD to spec.json and structure.md rules; fail builds when gates aren’t met.

---

## Final Notes

- This guide is an **overview and reference**, not a schema. Keep artifacts short, precise, and **traceable by IDs**. When in doubt, add a Purpose/Scope/Function paragraph and tighten acceptance gates.
