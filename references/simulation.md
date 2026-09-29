# Simulation workflow and delivery contract

## Before execution

Read user inputs, actual preflight and matching records in the user's shared lesson store (suggested path: project `knowledge/lessons.jsonl`, or a user-designated cross-project location). No log file constitutes authority to change the requested model.

Use [the plan template](../assets/simulation-plan.md) to save the proposed plan with: goal and observables; geometry and dimensions; materials with units/range/source; physics and couplings; boundary/initial conditions; steady/transient/frequency study; sweep points; mesh strategy and sensitive regions; solver strategy; validation metrics and thresholds; data extraction coordinates/datasets/solution indices; compute budget; open assumptions. Clearly distinguish numerical settings from physical assumptions.

Show the substantive plan in the user's language in the chat, including inputs/assumptions, modeling choices, validation and budget; a file link alone is insufficient. Link `plan.md`, identify the revision, and end the response with a clear request such as “请确认方案 v1；回复‘确认，按 v1 执行’，或告诉我需要修改的地方。” Explain that this plan confirmation is required by this skill's plan-and-wait rule. Stop before task-specific simulation programming or model execution. Missing decisive inputs keep the plan in `DRAFT`; a reviewable plan is `AWAITING_CONFIRMATION`.

On continuation, check the conversation for approval of this concrete revision. “已授权” counts only if its context unambiguously approves that plan; a tool permission or session-sharing response does not. Save the actual approval message (and message identifier/time when available) in `plan.md`, set `APPROVED`, then execute. A status label in an old file alone is not evidence of approval. Preserve existing approval for the same plan, including across context compaction. If the user explicitly waives the plan-confirmation step, record that instruction rather than falsely claiming the plan was reviewed.

After requested changes, show the revised plan and await confirmation of the new revision. Reconfirm changes to physical assumptions, boundary conditions, agreed accuracy, scope or compute budget; keep routine syntax/API repairs and retries within the approved limits autonomous. Installation-only or connection-only requests end after those checks. Existing-result analysis does not require a new simulation plan unless it introduces a new/changed solve.

Build small before sweeping. Reuse actual official examples or API introspection to avoid guessing feature/property names. Assign meaningful selections and verify their entity counts/locations after geometry changes. Keep explicit units. Preserve actual parameter values, study names and exported coordinate metadata.

## Errors and progress

Persist full exception (`getReport(err,'extended','hyperlinks','off')`) plus stage, source revision and environment. Keep the original failure if cleanup also fails. Status files need timestamp, run identity and stage; stale `running` is not a heartbeat. Separate tool transport errors, MATLAB syntax/runtime errors, COMSOL API errors, geometry/mesh errors, convergence errors, resource/license failures and failed scientific checks.

Use the smallest reproducible failing step. Retry a targeted repair with evidence. Do not fix convergence by silently deleting physics, altering materials/BCs or loosening agreed tolerances. Same failure three times without new evidence: stop and explain the concrete dependency. A long solver call may outlive transport; observe before retrying.

## Verification

Required checks depend on the task: dimensions/units/selections; material consistency; finite results; appropriate conservation law; benchmark/limiting solution; mesh, time step and solver tolerance sensitivity; singularity interpretation; exact result selection and sweep indexing. Identify which checks passed, failed, or remain unperformed. Never present a pretty plot as validation.

Save `.mph` with requested solution data. Reload with a new unique model tag and compare requested quantities. Deliver sources able to rebuild from explicit inputs. Independent postprocessing must load exported data rather than assume a live `model` in base workspace. A fresh process reproducibility test is distinct from same-session reload; report which was done.

## Suggested deliverable structure

`plan.md`, `config.json`, `src/` (run_all/build/solve/extract/postprocess/validate), `models/final.mph`, `results/` (MAT/CSV plus units/coordinates/dataset/solution/parameter metadata), `figures/`, `report.md`, `manifest.json`, `logs/`. Include external input data or clearly identify missing dependencies. The report states setup, assumptions, physical interpretation, validation evidence and limits, rerun instructions and compatibility. PDF/DOCX are optional unless requested.

Manifest: run ID, time, MATLAB/COMSOL/MCP versions, source/input hashes, output hashes and verification status. Do not include credentials, license keys or session secrets.

## Concise reusable lessons

JSONL, one validated fix per line, for example (illustrative, not a verified record):

```json
{"version":"COMSOL x.y / MATLAB R20xx","stage":"extract","symptom":"specific error fingerprint","cause":"confirmed cause","fix":"minimal change","verified_by":"run ID and passed check","source":"version-matched official URL if used"}
```

Only promote a record when the repaired stage passes. Retain failed hypotheses in run logs; do not teach them as facts. Before the next task search by error fingerprint, version and physics, and recheck applicability. A single successful case never establishes a universal COMSOL rule.
