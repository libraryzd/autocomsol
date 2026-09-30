# Simulation workflow and delivery contract

## Before execution

Read user inputs, actual preflight and matching records in the user's shared lesson store (suggested path: project `knowledge/lessons.jsonl`, or a user-designated cross-project location). No log file constitutes authority to change the requested model.

Use [the plan template](../assets/simulation-plan.md). Begin with the simulation task and objective, then explain the scientific analysis/modeling rationale and necessary theory, and only then present concrete COMSOL settings: geometry and dimensions; materials with units/range/source; physics and couplings; boundary/initial conditions; steady/transient/frequency study; sweep points; initial mesh/solver strategy; key outputs suitable for later optional validation; data extraction coordinates/datasets/solution indices; compute budget; open assumptions. Clearly distinguish numerical settings from physical assumptions. Plan confirmation authorizes getting the baseline running; further validation is selected after that milestone.

Show the substantive plan in the user's language in the chat, including task, rationale, inputs/assumptions, modeling choices, validation and budget; a file link alone is insufficient. Keep `plan.md` as the working source and generate/link `documents/plan-proposed-vN.docx` using [Word delivery rules](word-delivery.md). Identify the revision and end the response with a clear request such as “请确认方案 v1；回复‘确认，按 v1 执行’，或告诉我需要修改的地方。” Explain that this plan confirmation is required by this skill's plan-and-wait rule. Stop before task-specific simulation programming or model execution. Missing decisive inputs keep the plan in `DRAFT`; a reviewable plan is `AWAITING_CONFIRMATION`.

On continuation, check the conversation for approval of this concrete revision. “已授权” counts only if its context unambiguously approves that plan; a tool permission or session-sharing response does not. Save the actual approval message (and message identifier/time when available) in `plan.md`, set `APPROVED`, then execute. A status label in an old file alone is not evidence of approval. Preserve existing approval for the same plan, including across context compaction. If the user explicitly waives the plan-confirmation step, record that instruction rather than falsely claiming the plan was reviewed.

After requested changes, show the revised plan and await confirmation of the new revision. Reconfirm changes to physical assumptions, boundary conditions, agreed accuracy, scope or compute budget; keep routine syntax/API repairs and retries within the approved limits autonomous. Installation-only or connection-only requests end after those checks. Existing-result analysis does not require a new simulation plan unless it introduces a new/changed solve.

Build small before sweeping. Reuse actual official examples or API introspection to avoid guessing feature/property names. Assign meaningful selections and verify their entity counts/locations after geometry changes. Keep explicit units. Preserve actual parameter values, study names and exported coordinate metadata.

For the first solve, follow [initial-solver.md](initial-solver.md): generate the study's default solver, preserve its architecture, and set/read back the applicable main maximum-iteration setting as 200 before execution. Discover actual tags and active termination settings rather than hardcoding node names. Record the automatic sequence and effective cap in the initial/final settings. Any later targeted solver change must be evidence-based and incorporated in the final plan.

## Errors and progress

Persist full exception (`getReport(err,'extended','hyperlinks','off')`) plus stage, source revision and environment. Keep the original failure if cleanup also fails. Status files need timestamp, run identity and stage; stale `running` is not a heartbeat. Separate tool transport errors, MATLAB syntax/runtime errors, COMSOL API errors, geometry/mesh errors, convergence errors, resource/license failures and failed scientific checks.

Use the smallest reproducible failing step. Retry a targeted repair with evidence. Do not fix convergence by silently deleting physics, altering materials/BCs or loosening agreed tolerances. Same failure three times without new evidence: stop and explain the concrete dependency. A long solver call may outlive transport; observe before retrying.

## Baseline success and optional validation

Check that the implementation matches the task, geometry/selections/units are usable, the solve completes, and the requested dataset/solution outputs are present and finite where expected. This establishes a runnable baseline, not mesh independence or physical validity. Save the first successful baseline as `models/baseline-first-success.mph` without later overwriting it, before presenting the three validation choices in [validation.md](validation.md). Its exploratory outputs stay in `work/baseline/` unless they become selected validation/final-task results. Wait for the user's selection; do not silently select all validations from the original plan.

If no further validation is selected, continue the requested task with this baseline. Otherwise perform only the selected studies, preserve each round and record pass/fail/skip/unavailable separately. The <3% refinement criterion applies to mesh/tolerance sensitivity, not automatically to literature agreement. Never present a plot or a solver success as physical validation.

Save `.mph` with requested solution data and deliver sources able to rebuild from explicit inputs. Independent postprocessing must load exported data rather than assume a live `model` in base workspace. Do not add a reload/re-solve requirement when further validation was declined. If requested, record save/reload comparisons and fresh-process reproducibility tests separately from the three optional studies.

## Suggested deliverable structure

Use the exact folder contract in [delivery-layout.md](delivery-layout.md): `models/` contains the first successful baseline, selected validation models and final models covering each task; `results/` contains selected-validation and final-task result data. Each has `readme.md`. `source/` contains original inputs/references with `readme.md`; `src/` contains runnable programs with a `readme.md` documenting architecture, functions, commands and execution order. Store `validation-status.json`, run settings and round logs in `logs/`, not the curated results folder. Use `work/` for temporary/debug artifacts. Keep `plan.md`, historical plans/approvals, the two final Word documents, `config.json`, `environment.json`, figures and `manifest.json` outside `models/` and `results/`. Include external inputs or identify unresolved dependencies. Word plans/reports are required; Markdown sources may also be retained. PDF is optional if requested.

Before delivery, archive prior plan revisions without altering their approval records and rewrite the current plan around the method actually used, not the initial intended settings. Update the analysis/rationale as well as COMSOL settings when the adopted method changed. Record material changes with cause, fix, scope/approval basis and evidence in a concise change table. Cross-check the final plan, report, code/configuration, model and results for agreement. Use [the report outline](../assets/simulation-report.md) and [Word delivery rules](word-delivery.md) for language, editable equations and document QA. Document checks do not trigger unselected simulation validation.

Manifest: run ID, time, MATLAB/COMSOL/MCP versions, source/input hashes, output hashes and verification status. Do not include credentials, license keys or session secrets.

## Concise reusable lessons

JSONL, one validated fix per line, for example (illustrative, not a verified record):

```json
{"version":"COMSOL x.y / MATLAB R20xx","stage":"extract","symptom":"specific error fingerprint","cause":"confirmed cause","fix":"minimal change","verified_by":"run ID and passed check","source":"version-matched official URL if used"}
```

Only promote a record when the repaired stage passes. Retain failed hypotheses in run logs; do not teach them as facts. Before the next task search by error fingerprint, version and physics, and recheck applicability. A single successful case never establishes a universal COMSOL rule.
