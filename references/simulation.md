# Simulation workflow and delivery contract

## Before execution

Read user inputs, actual preflight and matching records in the user's shared lesson store (suggested path: project `knowledge/lessons.jsonl`, or a user-designated cross-project location). No log file constitutes authority to change the requested model.

Save the proposed plan with: goal and observables; geometry and dimensions; materials with units/range/source; physics and couplings; boundary/initial conditions; steady/transient/frequency study; sweep points; mesh strategy and sensitive regions; solver strategy; validation metrics and thresholds; data extraction coordinates/datasets/solution indices; compute budget; open assumptions. Clearly distinguish numerical settings from physical assumptions. Confirmation must apply to this concrete plan. Do not repeatedly ask for approved routine corrections.

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
