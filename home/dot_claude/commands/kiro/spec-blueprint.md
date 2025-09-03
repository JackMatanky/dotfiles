---
description: Feature Implementation Blueprint (blueprint.toml) — PROMPT-FIRST command that GUIDES an AI agent with RFC 2119 rules and THEN runs a deterministic script. Acts as a BRIDGE and a TRANSFORMER from a narrowly scoped portfolio feature → implementable detail (requirements seeds, design hypotheses, TIP-grade task DAG). Enforces schema validation, provenance, risk taxonomy, TDD guidance, coverage guarantees, and acyclic planning.
argument-hint: <feature-id> [create|update] [stepwise|oneshot]
allowed-tools: Read, Write, Edit, MultiEdit, Grep, Glob, LS, Bash(jq:*), Bash(tombi:*), Bash(tomli-cli:*), Bash(date:*), Bash(mkdir:*), Bash(cat:*), Bash(test:*), Bash(cp:*), Bash(sed:*), Bash(rg:*), Bash(awk:*), Bash(git:*)
model: claude-sonnet-4-20250514
---

<prompt_first_contract>
This file is **foremost a prompt** that instructs the AI agent, and **secondarily a script**. The agent:

- MUST read and follow every MUST/SHOULD/MAY (RFC 2119).
- MUST reason step-by-step but MUST keep the final written artifact free of commentary.
- MUST NOT invent facts; MUST ground any transformative claim in steering or label it as an assumption with a linked risk.
- MUST preserve sequential integrity: Steering → Features (portfolio) → Blueprint → Requirements → Design → Tasks.
- MUST fail-fast on violations in `stepwise` mode; MAY insert explicit placeholders + risks in `oneshot` mode.
- MUST write **pure TOML** output deterministically and atomically after all validations pass.
- MUST emit structured, actionable errors with remediation guidance.
  </prompt_first_contract>

<agent_behavior_and_rfc2119>

- Inputs MUST be authoritative in this order: product → tech → structure → features.toml. Conflicts MUST be surfaced; hard conflicts MUST block in `stepwise`.
- The blueprint MUST be both a bridge (traceable linkage to portfolio and steering) AND a transformer (design hypotheses + TIP-style task DAG; seeds requirements_index).
- The output file MUST contain: [meta], [linking], [context], [[requirements_index]], [[nfr_matrix]], [interfaces], [data.touchpoints], [design_transform], [tasks_transform], [acceptance], [coverage.plan], [risks], [test_guidance], [provenance], [confidence].
- Every NFR entry MUST include: name, target, method, instrumentation, thresholds[], owner. NFRs SHOULD reference tech steering anchors.
- Success metrics MUST be present and measurable (name, target). Each SHOULD include unit and window.
- Requirements seeds MUST include id (R1..Rn), title, rationale. Missing fields MUST fail.
- Task DAG MUST be acyclic; every node MUST have deliverables and acceptance_criteria; edges MUST reference valid node IDs and SHOULD include a reason.
- Coverage MUST map every requirement_id → at least one design_ref AND one task_ref (coarse).
- Provenance MUST include source file+anchor+linespan excerpts for each non-trivial claim. If provenance is missing for a proposed interface/component in `stepwise`, the run MUST fail.
- spec.json MUST only be updated AFTER all schema and semantic validations pass; partial updates MUST NOT occur.
- The command MUST be idempotent: re-runs MUST NOT scramble ordering or duplicate entries.
- The command MUST NOT access the public internet; all derivations MUST come from local steering/portfolio artifacts.
  </agent_behavior_and_rfc2119>

<error_contract>

- Errors MUST include: CODE, SECTION, FIELD (if applicable), and REMEDIATION.
- Common codes:
  - E-MISSING-INPUT: Required upstream file missing → Create the file or fix path.
  - E-FEATURE-NOT-FOUND: Feature id not present → Add to features.toml.
  - E-CONFLICT: Contradictory steering constraints → Resolve in steering.
  - E-NFR-INCOMPLETE: NFR missing fields → Provide target/method/instrumentation/owner.
  - E-METRICS-MISSING: success_metrics empty → Provide measurable metrics.
  - E-REQ-SEED-BAD: requirements_index missing id/title/rationale → Fill fields.
  - E-DAG-CYCLE: tasks_transform cyclic → Fix edges.
  - E-COVERAGE-GAP: coverage.plan missing requirement mapping → Add coverage.
  - E-PROVENANCE-ABSENT: design proposals without provenance in stepwise → Add provenance or mark assumption+risk (oneshot only).
    </error_contract>

<args_and_env>
!`test -n "$ARGUMENTS" || { echo "ERROR E-ARGS: FEATURE_ID REQUIRED. REMEDIATION: invoke as '<feature-id> [create|update] [stepwise|oneshot]'"; exit 1; }`
!`FEATURE_ID=$(echo "$ARGUMENTS" | awk '{print $1}')`
!`MODE_ARG=$(echo "$ARGUMENTS" | awk '{print $2}')`
!`STYLE=$(echo "$ARGUMENTS" | awk '{print $3}')`
!`STYLE=${STYLE:-stepwise} # stepwise=MUST fail on gaps; oneshot=MAY insert placeholders+risks`
!`TS=$(date -u +"%Y-%m-%dT%H:%M:%SZ")`
!`OUTDIR="ai/specs/$FEATURE_ID"`
!`TEMP="$(mktemp -t ${FEATURE_ID}.blueprint.XXXXXX).toml"`
!`FINAL="$OUTDIR/blueprint.toml"`
!`SPECJSON="$OUTDIR/spec.json"`
!`mkdir -p "$OUTDIR" || { echo "ERROR E-FS: cannot create $OUTDIR. REMEDIATION: check permissions."; exit 1; }`
!`MODE=${MODE_ARG:-$(test -f "$FINAL" && echo update || echo create)}`
!`echo "INFO: MODE=$MODE STYLE=$STYLE"`
</args_and_env>

<preflight_tools_and_inputs>
!`command -v jq >/dev/null 2>&1 || { echo "ERROR E-TOOL: jq REQUIRED. REMEDIATION: install jq."; exit 1; }`
!`command -v rg >/dev/null 2>&1 || { echo "ERROR E-TOOL: ripgrep (rg) REQUIRED. REMEDIATION: install ripgrep."; exit 1; }`
!`command -v tomli-cli >/dev/null 2>&1 || { echo "ERROR E-TOOL: tomli-cli REQUIRED. REMEDIATION: pip install tomli-cli."; exit 1; }`
!`test -f ai/steering/features.toml || { echo "ERROR E-MISSING-INPUT: ai/steering/features.toml missing. REMEDIATION: create portfolio file."; exit 1; }`
!`PROD=$(ls ai/steering/product.* 2>/dev/null | head -n1 || true)`
!`TECH=$(ls ai/steering/tech.* 2>/dev/null | head -n1 || true)`
!`STRU=$(ls ai/steering/structure.* 2>/dev/null | head -n1 || true)`
!`test -n "$PROD" || { echo "ERROR E-MISSING-INPUT: product steering file missing. REMEDIATION: add ai/steering/product.md|toml"; exit 1; }`
!`test -n "$TECH" || { echo "ERROR E-MISSING-INPUT: tech steering file missing. REMEDIATION: add ai/steering/tech.md|toml"; exit 1; }`
!`test -n "$STRU" || { echo "ERROR E-MISSING-INPUT: structure steering file missing. REMEDIATION: add ai/steering/structure.md|toml"; exit 1; }`
</preflight_tools_and_inputs>

<load_feature_and_assertions>
!`F_JSON=$(tomli-cli tojson ai/steering/features.toml)`
!`MATCH=$(echo "$F_JSON" | jq -c --arg id "$FEATURE_ID" '.features[]? | select(.id==$id)')`
!`test -n "$MATCH" || { echo "ERROR E-FEATURE-NOT-FOUND: '$FEATURE_ID' not in features.toml. REMEDIATION: add feature entry."; exit 1; }`
!`F_NAME=$(echo "$MATCH"   | jq -r '.name // "UNNAMED"')`
!`F_CAT=$(echo "$MATCH"    | jq -r '.category // "unspecified"')`
!`F_ORDER=$(echo "$MATCH"  | jq -r '.order // 0')`
!`F_STATUS=$(echo "$MATCH" | jq -r '.status // "planned"')`
!`F_OWNER=$(echo "$MATCH"  | jq -r '.owner // ""')`
!`F_RAT=$(echo "$MATCH"    | jq -r '.rationale // ""')`
!`F_SCOPE=$(echo "$MATCH"  | jq -r '.scope // ""')`
!`F_DEPS=$(echo "$MATCH"   | jq -c '.dependencies // []')`
!`F_SRCS=$(echo "$MATCH"   | jq -c '.source_reference // []')`
!`F_AC=$(echo "$MATCH"     | jq -c '.acceptance_criteria // []')`
!`F_MET=$(echo "$MATCH"    | jq -c '.success_metrics // []')`
!`test "$(echo "$F_SRCS" | jq 'length')" -gt 0 || { echo "ERROR E-PORTFOLIO: features.toml entry MUST include source_reference[]. REMEDIATION: add steering anchors."; exit 1; }`
</load_feature_and_assertions>

<id_stability>
!`if test -f "$FINAL"; then
   OLD_ID=$(tomli-cli tojson "$FINAL" | jq -r '.meta.id // empty');
   NEW_ID="${FEATURE_ID}-v1";
   test -z "$OLD_ID" -o "$OLD_ID" = "$NEW_ID" || { echo "ERROR E-ID-STABILITY: meta.id MUST remain stable ($OLD_ID != $NEW_ID). REMEDIATION: do not change meta.id."; exit 1; }
 fi`
</id_stability>

<context_scan_and_conflict_detection>
!`TMPD=$(mktemp -d)`
!`NEEDLE=$(echo "$F_NAME" | tr '[:upper:]' '[:lower:]')`
!`rg -n -i "$NEEDLE|problem|persona|outcome|scope|use case" "$PROD" > "$TMPD/prod_hits" || true`
!`rg -n -i "$NEEDLE|latency|p(95|99)|ms|throughput|rps|availability|sla|slo|timeout|idempot|rate limit|observab|security|privacy|compliance|stack|integration" "$TECH" > "$TMPD/tech_hits" || true`
!`rg -n -i "$NEEDLE|repo|directory|module|branch|pr|review|ci|cd|pipeline|env|flag|rollback|migration|secrets|canary|feature flag" "$STRU" > "$TMPD/stru_hits" || true`
!`rg -n -i 'latency|p(95|99)|ms' "$TECH" > "$TMPD/tech_perf" || true`
!`rg -n -i 'latency|p(95|99)|ms' "$PROD" > "$TMPD/prod_perf" || true`
!`TECH_LAT=$(awk -F'[^0-9]+' '{for(i=1;i<=NF;i++) if($i~/^[0-9]+$/) print $i}' "$TMPD/tech_perf" 2>/dev/null | sort -n | head -n1)`
!`PROD_LAT=$(awk -F'[^0-9]+' '{for(i=1;i<=NF;i++) if($i~/^[0-9]+$/) print $i}' "$TMPD/prod_perf" 2>/dev/null | sort -n | head -n1)`
!`if test -n "$TECH_LAT" -a -n "$PROD_LAT" -a "$PROD_LAT" -lt "$TECH_LAT"; then
     if [ "$STYLE" = "stepwise" ]; then
       echo "ERROR E-CONFLICT: product latency (~$PROD_LAT ms) stricter than tech (~$TECH_LAT ms). MUST reconcile steering."; exit 1;
     else
       echo "WARN: Perf target conflict; WILL record risk and assumption."
     fi
 fi`
</context_scan_and_conflict_detection>

<compose_blueprint_toml_pure>
!`cat > "$TEMP" <<TOML
[meta]
id = "${FEATURE_ID}-v1"
feature_id = "${FEATURE_ID}"
name = "${F_NAME}"
category = "${F_CAT}"
order = ${F_ORDER}
status = "${F_STATUS}"
version = "1.0.0"
created_at = "${TS}"
updated_at = "${TS}"
owner = "${F_OWNER}"

[linking]
steering_feature_id = "${FEATURE_ID}"
steering_source_reference = $(echo "$F_SRCS")
dependencies = $(echo "$F_DEPS")
upstream_feature_rationale = "$(printf "%s" "$F_RAT" | sed 's/\"/\\\"/g')"
upstream_scope_ref = "features.toml#${FEATURE_ID}.scope"

[context]
problem_statement = ""
outcomes = []
assumptions = []
non_goals = []
constraints = []
open_questions = []

[acceptance]
acceptance_criteria = []
success_metrics = $(echo "$F_MET")

[[nfr_matrix]]
name = ""
target = ""
method = ""
instrumentation = ""
thresholds = []
owner = ""

[[requirements_index]]
id = ""
title = ""
rationale = ""
source_refs = []

[interfaces]
required = []
proposed = []

[data.touchpoints]
entities = []

[design_transform]
summary = ""
components_impacted = []
interfaces_proposed = []
data_contracts_touched = []
cross_cutting = []
nfr_targets = []
integration_points = []
rollout_strategy = []
design_risks = []
design_open_questions = []

[design_transform.coverage_plan]
rows = []

[tasks_transform]
milestones = []
nodes = []
edges = []
delivery_risks = []
env_prep = []
validation_strategy = []
rollback_plan = []

[coverage.plan]
by_requirement = []

[risks]
technical = []
development = []
integration = []
security = []
dependency = []
schedule = []
other = []

[test_guidance]
tdd = true
methods = ["AAA","integration","e2e"]
requirements = ["All acceptance criteria must be testable and mapped"]
frameworks = ["pytest"]
coverage_target = ">=80%"

[provenance]
items = []
notes = []

[confidence]
score = 0.0
drivers = []
TOML`
</compose_blueprint_toml_pure>

<seed_requirements_and_metrics_rfc>
!`AC_LEN=$(echo "$F_AC" | jq 'length')`
!`if [ "$AC_LEN" -gt 0 ]; then
   I=1
   echo "$F_AC" | jq -r '.[] | .title // "Requirement"' | while read T; do
     printf "\n[[requirements_index]]\n" >> "$TEMP"
     printf "id = \"R%d\"\n" "$I" >> "$TEMP"
     printf "title = \"%s\"\n" "$(printf "%s" "$T" | sed 's/[\"\\]/\\&/g')" >> "$TEMP"
     printf "rationale = \"Seeded from portfolio acceptance_criteria\"\n" >> "$TEMP"
     printf "source_refs = []\n" >> "$TEMP"
     I=$((I+1))
   done
 else
   if [ "$STYLE" = "stepwise" ]; then
     echo "ERROR E-REQ-SEED-BAD: acceptance_criteria REQUIRED to seed requirements_index. REMEDIATION: add ACs in features.toml."; exit 1;
   else
     echo "WARN: No acceptance_criteria; WILL seed placeholder R1 and log an assumption."
     {
       echo
       echo '[[requirements_index]]'
       echo 'id = "R1"'
       echo 'title = "Define primary capability"'
       echo 'rationale = "Heuristic seed due to missing ACs"'
       echo 'source_refs = []'
     } >> "$TEMP"
     awk '
       /^$begin:math:display$provenance$end:math:display$$/ {print; p=1; next}
       p && /^notes = $begin:math:display$$end:math:display$$/ {print "notes = [\"ASSUMPTION: acceptance_criteria missing; seeded R1\"]"; p=0; next}
       {print}
     ' "$TEMP" > "$TEMP.tmp" && mv "$TEMP.tmp" "$TEMP"
   fi
 fi`
!`MET_LEN=$(echo "$F_MET" | jq 'length')`
!`if [ "$MET_LEN" -eq 0 ]; then
   if [ "$STYLE" = "stepwise" ]; then
     echo "ERROR E-METRICS-MISSING: acceptance.success_metrics MUST NOT be empty. REMEDIATION: add measurable metrics."; exit 1;
   else
     echo "WARN: success_metrics empty; WILL add placeholder and record development risk."
     jq '
       .acceptance.success_metrics = [{"name":"adoption_rate","target":">=30%","unit":"%","window":"30d"}]
     ' <(tomli-cli tojson "$TEMP") | tomli-cli fromjson > "$TEMP"
     awk '
       /^$begin:math:display$risks$end:math:display$$/ {print; p=1; next}
       p && /^development = $begin:math:display$$end:math:display$$/ {print "development = [{description=\"Missing success metrics (placeholder added)\", likelihood=\"medium\", impact=\"medium\", mitigation=\"Define real metrics before approval\"}]"; p=0; next}
       {print}
     ' "$TEMP" > "$TEMP.tmp" && mv "$TEMP.tmp" "$TEMP"
   fi
 fi`
</seed_requirements_and_metrics_rfc>

<derive*design_and_tasks_with_tip_rigor>
!`COMP=$( (cat "$TMPD/tech_hits" 2>/dev/null || true) | rg -oi '(svc\.[a-z0-9*.-]+|db\.[a-z0-9_.-]+|queue\.[a-z0-9_.-]+|api)' | sort -u | head -n 12 | jq -R . | jq -s . )`
!`INTF=$( (cat "$TMPD/tech*hits" 2>/dev/null || true) | rg -oi '(GET|POST|PUT|PATCH|DELETE)\s+/[a-z0-9/*-]+' | sort -u | head -n 10 | jq -R . | jq -s . )`
!`ENVH=$( (cat "$TMPD/stru_hits" 2>/dev/null || true) | rg -i 'flag|pipeline|staging|secrets|rollback|migration|canary' | head -n 10 | jq -R . | jq -s . )`
!`jq --argjson comp "${COMP:-[]}" --argjson intf "${INTF:-[]}" --argjson envh "${ENVH:-[]}" '
   .design_transform.components_impacted = (if $comp==null then [] else $comp end)
 | .design_transform.interfaces_proposed = (if $intf==null then [] else $intf end)
 | .tasks_transform.env_prep = (if $envh==null then [] else $envh end)
 ' <(tomli-cli tojson "$TEMP") | tomli-cli fromjson > "$TEMP"`
!`cat >> "$TEMP" <<TOML

[tasks_transform]
milestones = [
{id="M1", goal="Foundations", exit_criteria=["feature flag live"]},
{id="M2", goal="Core Path", exit_criteria=["happy-path passes"]},
{id="M3", goal="Integration", exit_criteria=["external contract green"]},
{id="M4", goal="Validation", exit_criteria=["perf/security checks"]},
{id="M5", goal="Rollout", exit_criteria=["canary → 100%"]}
]
nodes = [
{ id="T1", label="Add feature flag & config", preconds=[], deliverables=["flag"], acceptance_criteria=["toggleable"], test_guidance={tdd=true, methods=["AAA"]} },
{ id="T2", label="Define interface contracts & tests", preconds=["T1"], deliverables=["pact files"], acceptance_criteria=["consumer/provider green"], test_guidance={tdd=true, methods=["integration"]} },
{ id="T3", label="DB migration (if needed)", preconds=["T1"], deliverables=["migration"], acceptance_criteria=["applies/rolls back clean"], test_guidance={tdd=true, methods=["integration"]} },
{ id="T4", label="Implement core path", preconds=["T2","T3"], deliverables=["endpoint"], acceptance_criteria=["happy-path"], test_guidance={tdd=true, methods=["AAA"]} },
{ id="T5", label="Integrate external dependency", preconds=["T4"], deliverables=["integration"], acceptance_criteria=["contract passes"], test_guidance={tdd=true, methods=["integration"]} },
{ id="T6", label="Observability & SLO checks", preconds=["T4"], deliverables=["traces/metrics"], acceptance_criteria=["SLO burn alerts"], test_guidance={tdd=true, methods=["integration","e2e"]} },
{ id="T7", label="Perf/Sec validations", preconds=["T6"], deliverables=["reports"], acceptance_criteria=["NFR targets met"], test_guidance={tdd=true, methods=["e2e"]} },
{ id="T8", label="Rollout & monitoring & rollback", preconds=["T7"], deliverables=["deployment"], acceptance_criteria=["canary stable"], test_guidance={tdd=true, methods=["e2e"]} }
]
edges = [
{ from="T1", to="T2", reason="contracts before implementation" },
{ from="T1", to="T3", reason="schema before writes" },
{ from="T2", to="T4", reason="implement after contract" },
{ from="T3", to="T4", reason="schema before implementation" },
{ from="T4", to="T5", reason="integrate after core" },
{ from="T4", to="T6", reason="instrument after core" },
{ from="T6", to="T7", reason="validate after observability" },
{ from="T7", to="T8", reason="rollout after validation" }
]
TOML`
!`if test -n "$TECH_LAT" -a -n "$PROD_LAT" -a "$PROD_LAT" -lt "$TECH_LAT"; then
awk '
/^$begin:math:display$risks$end:math:display$$/ {print; p=1; next}
     p && /^technical = $begin:math:display$$end:math:display$$/ {print "technical = [{description=\"Perf target conflict (product "~'"$PROD_LAT"'" "ms vs tech "~'"$TECH_LAT"'" "ms)\", likelihood=\"medium\", impact=\"medium\", mitigation=\"Align NFRs before design\"}]"; p=0; next}
     {print}
   ' "$TEMP" > "$TEMP.tmp" && mv "$TEMP.tmp" "$TEMP"
fi`
</derive_design_and_tasks_with_tip_rigor>

<provenance_and_confidence_rules>
!`PROVLIST=$(printf "%s\n%s\n%s\n" "$(sed 's/"/\\"/g' "$TMPD/prod_hits" 2>/dev/null)" "$(sed 's/"/\\"/g' "$TMPD/tech_hits" 2>/dev/null)" "$(sed 's/"/\\"/g' "$TMPD/stru_hits" 2>/dev/null)" | awk 'NF{print}' | jq -R . | jq -s . )`
!`jq --argjson prov "${PROVLIST:-[]}" '
    .provenance.items = $prov
  | .confidence.score = (
      0.4
      + (if (.design_transform.components_impacted|length)>0 then 0.2 else 0 end)
      + (if (.design_transform.interfaces_proposed|length)>0 then 0.2 else 0 end)
      + (if (.tasks_transform.nodes|length)>=4 then 0.2 else 0 end)
    )
  | .confidence.drivers = [
      "components=" + ((.design_transform.components_impacted|length)|tostring),
      "interfaces=" + ((.design_transform.interfaces_proposed|length)|tostring),
      "tasks=" + ((.tasks_transform.nodes|length)|tostring)
    ]
' <(tomli-cli tojson "$TEMP") | tomli-cli fromjson > "$TEMP"`
!`if [ "$STYLE" = "stepwise" ]; then
  PV=$(tomli-cli tojson "$TEMP" | jq '(.provenance.items|length) // 0')
  DT=$(tomli-cli tojson "$TEMP" | jq '((.design_transform.components_impacted|length) + (.design_transform.interfaces_proposed|length)) // 0')
  if [ "$DT" -gt 0 ] && [ "$PV" -eq 0 ]; then
    echo "ERROR E-PROVENANCE-ABSENT: Proposals MUST be grounded by provenance. REMEDIATION: add steering anchors or mark assumption+risk (oneshot only)."; exit 1;
  fi
fi`
</provenance_and_confidence_rules>

<semantic_rfc_validations>
!`BP_JSON=$(tomli-cli tojson "$TEMP")`
!`REQ_BAD=$(echo "$BP_JSON" | jq '([.requirements_index[]? | select((.id=="") or (.title=="") or (.rationale==""))] | length) // 0')`
!`[ "$REQ_BAD" -eq 0 ] || { echo "ERROR E-REQ-SEED-BAD: requirements_index MUST contain id/title/rationale. REMEDIATION: fill missing fields."; exit 1; }`
!`NFR_MISS=$(echo "$BP_JSON" | jq '([.nfr_matrix[]? | select((.name=="") or (.target=="") or (.method=="") or (.instrumentation==""))] | length) // 0')`
!`[ "$NFR_MISS" -eq 0 ] || { echo "ERROR E-NFR-INCOMPLETE: each NFR MUST include name,target,method,instrumentation. REMEDIATION: complete NFR fields."; exit 1; }`
!`MET_EMPTY=$(echo "$BP_JSON" | jq '(.acceptance.success_metrics | length) // 0')`
!`[ "$MET_EMPTY" -gt 0 ] || { echo "ERROR E-METRICS-MISSING: success_metrics MUST NOT be empty. REMEDIATION: add measurable metrics."; exit 1; }`
!`ALLOWED='["AAA","integration","e2e"]'
BADTG=$(echo "$BP_JSON" | jq --argjson allowed "$ALLOWED" '[ (.test_guidance.methods // [])[] | select( ([.] - $allowed) | length > 0 ) ] | length')
[ "$BADTG" -eq 0 ] || { echo "ERROR E-TDD: test_guidance.methods MUST be in {AAA, integration, e2e}. REMEDIATION: fix methods."; exit 1; }`
!`# DAG checks
NODES=$(echo "$BP_JSON" | jq -r '.tasks_transform.nodes[]?.id')
if [ -n "$NODES" ]; then
  NODE_BAD=$(echo "$BP_JSON" | jq '([.tasks_transform.nodes[]? | select((.deliverables|length==0) or (.acceptance_criteria|length==0))] | length) // 0')
  [ "$NODE_BAD" -eq 0 ] || { echo "ERROR E-TASK-NODE: each node MUST have deliverables and acceptance_criteria. REMEDIATION: fill both."; exit 1; }
  EDGES=$(echo "$BP_JSON" | jq -r '.tasks_transform.edges[]? | "\(.from) \(.to)"')
  if [ -n "$EDGES" ]; then
    while read -r F T; do
      echo "$NODES" | grep -qx "$F" || { echo "ERROR E-TASK-EDGE: 'from' MUST be a valid node ($F)."; exit 1; }
      echo "$NODES" | grep -qx "$T" || { echo "ERROR E-TASK-EDGE: 'to' MUST be a valid node ($T)."; exit 1; }
    done <<< "$EDGES"
    # Cycle detection (Kahn)
    echo "$EDGES" > "$TMPD/edges.txt"
    awk '
      {ind[$2]++; out[$1]=1; edges[NR]=$1" "$2; nodes[$1]=1; nodes[$2]=1}
      END{
        for (k in nodes) if (!(k in ind)) q[k]=1;
        while (length(q)>0){
          for (k in q){v=k; delete q[k]; break}
          for (i in edges){
            split(edges[i],a," ");
            if(a[1]==v){ind[a[2]]--; delete edges[i]; if(ind[a[2]]==0) q[a[2]]=1}
          }
        }
        rem=0; for (i in edges) rem++;
        if (rem>0){print "ERROR E-DAG-CYCLE: tasks_transform MUST be acyclic. REMEDIATION: remove cycle."; exit 1;}
      }' "$TMPD/edges.txt" >/dev/null || exit 1
  fi
else
  if [ "$STYLE" = "stepwise" ]; then
    echo "ERROR E-TASKS-EMPTY: tasks_transform.nodes MUST NOT be empty."; exit 1;
  fi
fi`
!`# Coverage completeness (coarse)
REQ_IDS=$(echo "$BP_JSON" | jq -r '.requirements_index[]?.id')
if [ -n "$REQ_IDS" ]; then
  MISS=$(echo "$BP_JSON" | jq -r '([.requirements_index[]?.id] - [.coverage.plan.by_requirement[]?.requirement_id]) | length')
  if [ "$MISS" -gt 0 ]; then
    if [ "$STYLE" = "stepwise" ]; then
      echo "ERROR E-COVERAGE-GAP: coverage.plan.by_requirement MUST cover all requirement_id. REMEDIATION: add missing links."; exit 1;
    else
      echo "WARN: coverage incomplete; WILL add placeholders."
      echo "$BP_JSON" | jq '
        . as $root
        | ([.requirements_index[]?.id] - [.coverage.plan.by_requirement[]?.requirement_id]) as $missing
        | .coverage.plan.by_requirement += ($missing | map({requirement_id:., design_refs:[], task_refs:[]}))
      ' | tomli-cli fromjson > "$TEMP"
    fi
  fi
fi`
</semantic_rfc_validations>

<schema_validation_and_atomic_write>
!`if test -f ai/schemas/blueprint.schema.toml && command -v tombi >/dev/null 2>&1; then
    tombi validate -s ai/schemas/blueprint.schema.toml "$TEMP" || { echo "ERROR E-SCHEMA: schema validation MUST pass. REMEDIATION: fix fields per schema."; exit 1; }
  else
    echo "NOTE: Schema file missing or tombi unavailable; CI SHOULD enforce schema validation."
  fi`
!`cp "$TEMP" "$FINAL" || { echo "ERROR E-ATOMIC: write MUST succeed. REMEDIATION: check disk/permissions."; exit 1; }`
</schema_validation_and_atomic_write>

<lifecycle_update_specjson>
!`test -f "$SPECJSON" || echo '{}' > "$SPECJSON"`
!`jq --arg ts "$TS" --arg fid "$FEATURE_ID" '
  .feature_id=$fid
  | .phase="blueprint-generated"
  | .approvals = (.approvals // {})
  | .approvals.blueprint = {generated:true, approved:false, at:$ts}
  | .updated_at=$ts
' "$SPECJSON" > "$SPECJSON.tmp" && mv "$SPECJSON.tmp" "$SPECJSON" || { echo "ERROR E-SPECJSON: lifecycle update MUST succeed."; exit 1; }`
</lifecycle_update_specjson>

<final_notice>
!`echo "OK: $FINAL written (mode=$MODE, style=$STYLE). You MUST review provenance, risks, NFR methods, and coverage before approval."`
!`ls -la "$OUTDIR" || true`
</final_notice>
