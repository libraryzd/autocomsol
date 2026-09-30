---
name: autocomsol
description: Set up the official MATLAB MCP Server and drive COMSOL through an existing COMSOL with MATLAB session. Show a simulation plan for confirmation, get the model running, then offer optional mesh, relative-tolerance and reference-case validation before delivering models, data, reports and verified error lessons.
---

# AutoCOMSOL

Use the official MathWorks MATLAB MCP Server in `existing` session mode and COMSOL LiveLink for MATLAB. This package automates Windows x64 setup; other platforms require the official platform-specific installation. Never infer a working connection or a valid physical model from installed software or running processes.

For what was actually tested and the current limits, read [release-validation.md](references/release-validation.md) when assessing readiness or troubleshooting portability.

## First response to a new simulation: plan, then wait

Before writing task-specific simulation programs or creating/modifying/meshing/solving a COMSOL model, present a concrete plan **in the chat**, save its working source as `plan.md` and its user-facing version as `documents/plan-proposed-vN.docx`, and end the turn awaiting the user's confirmation. A plan saved only in a file, a progress update, or an internal task checklist does not satisfy this requirement. Use [the plan template](assets/simulation-plan.md) and [Word delivery rules](references/word-delivery.md). If decisive inputs are missing, show the proposed approach and those questions; do not invent values or present an incomplete plan as ready to execute.

Before confirmation, installation/connection checks, read-only version/model inspection, research and plan preparation may proceed within the requested scope. A request to “do this simulation”, MATLAB session sharing, MCP/tool permission, or approval to install/publish the skill is not confirmation of a specific simulation plan. The bundled acceptance simulation also follows this rule; a connection check alone must not trigger it.

Record plan revision and status `AWAITING_CONFIRMATION`. After the user confirms the displayed revision, record `APPROVED` and the actual user message establishing approval, then proceed. Never generate the user's approval yourself, treat silence as approval, or continue to execution in the turn that first proposes the plan. If the conversation already contains approval of the same concrete plan, honor it without asking again. Explicit user instructions overriding the confirmation workflow take precedence; record that instruction accurately. See [simulation.md](references/simulation.md) for continuation and revision handling.

## Setup or repair a connection

Read [setup.md](references/setup.md). Run the bundled installer with normal host permissions; request platform escalation for network access or writes outside the workspace when required. Respect an existing MCP configuration rather than overwriting it. Do not install a different COMSOL/MATLAB version without a user request.

The user shares the **COMSOL with MATLAB** session using the generated `prepare_session.m`. Use `shareMATLABSession()` for this official server, not the Python Engine sharing API. Do not automatically start a replacement MATLAB, clear the workspace, quit MATLAB, or remove unrelated COMSOL models.

Discover native MATLAB MCP tools first. If the current chat has not loaded newly registered tools, reload MCP/open a new chat, or use the bundled stdio client to test the same official server. A shell client is a diagnostic transport, not a separate MATLAB engine.

## Plan a simulation

Read [simulation.md](references/simulation.md). Inspect the live environment and relevant [bundled verified lessons](references/verified-lessons.jsonl) plus the user's accumulated lesson store. Research APIs against the installed COMSOL version using local help, official documentation and examples; use third-party material as unverified leads. Save source URLs/version and distinguish assumptions from supplied facts.

Structure every plan in this order: **simulation task introduction; scientific analysis and modeling rationale, with necessary theory; concrete COMSOL settings**. Explain assumptions, relevant physics/scales and why the chosen dimensionality, physics, conditions and numerical approach fit the task. Provide concise, reproducible scientific justification and derivations rather than an internal deliberation transcript. Then specify units, materials, geometry, boundary/initial conditions, study, parameters, initial mesh/solver, requested outputs and compute/retry budget. Identify key results for later optional validation, but do not treat initial plan approval as selection of those validations. Follow the plan-and-wait step above. Missing scientifically decisive inputs must not be invented.

## Execute, validate, deliver

Persist source files before executing them. Prefer separate build/solve/extract/postprocess/validate functions and an entrypoint with explicit inputs. Use unique model tags and task directories, stable named selections, explicit result datasets and solution indices. Checkpoints and logs must survive a failed stage.

For initial model bring-up, prefer the study's **automatically generated default solver sequence**, with the applicable main iteration limit set to **200** before the first solve. Read [initial-solver.md](references/initial-solver.md): discover actual nodes/properties, preserve default solver architecture and convergence tests, set/read back the applicable cap, and record exceptions. Do not hand-build a custom solver tree first or set every unrelated iterative subsolver to 200. This is the user's starting preference, not a claim that 200 is COMSOL's default or universally optimal.

Use the existing MCP tools `check_matlab_code`, `evaluate_matlab_code` and `run_matlab_file` when exposed; inspect live schemas rather than assume fixed arguments. The shipped smoke example is an infrastructure benchmark, not a universal physics template.

For an error: capture the full exception, classify its cause, look up verified relevant lessons, make a targeted change, and rerun the affected stage. Continue routine repairs within the approved plan. Ask for a revised plan only when the physical problem, agreed accuracy, resources or scope must change. Default to at most three attempts for the same failure without new evidence; report a concrete blocker instead of looping.

Treat tool timeouts as **unknown execution state**. Check logs/output/status before resubmitting. MATLAB may be unable to run a second command while solving. A status JSON file is not proof of a live process. This release has no guaranteed asynchronous cancellation or process supervisor; do not promise either. Never kill the user's MATLAB/COMSOL to resolve a timeout.

First get the model running according to the task: required physics/conditions are implemented, the solve succeeds, and requested outputs are available and usable. Preserve the **first** successful baseline `.mph` without replacing it with later tuning attempts. Preserve its source/settings/evidence separately under the [delivery layout](references/delivery-layout.md). Do not automatically launch mesh, relative-tolerance or reference-case validation to achieve this milestone.

## After the baseline runs: let the user select validation

Read [validation.md](references/validation.md). Show evidence that the baseline runs, then offer **three independent checkboxes**: mesh validation, relative-tolerance validation, and reference-case validation. The user may select any combination or explicitly choose no further validation. Stop and wait for the selection; silence, initial plan approval and a preselected UI option are not a selection. Use a native multi-select UI if available; otherwise use the bundled [checkbox form](assets/validation-choice.html) or the documented chat fallback.

Run only the selected validations. Mesh validation uses coarse/medium/fine meshes; relative-tolerance validation uses loose/medium/tight settings. For each selected study, plan three distinct levels, compare declared key outputs against the finest/tightest result, and require **both other levels to differ by strictly less than 3%**. If not, plan and run a new triplet until it passes; do not declare completion just because three refinement rounds elapsed. Preserve settings, results and error history. Genuine execution/resource blockers pause the selected study with an honest status; they never count as a pass.

For reference-case validation, inspect user-uploaded references first and directly reproduce a sufficiently specified relevant case. If none was supplied, ask the user to upload one or send “请直接网上查找相关算例”; wait before searching for a substitute. When explicitly requested, research suitable cases and validate a reproducible one. If none is found, state “未调研到相关算例”, mark that validation skipped and continue the task. Missing decisive benchmark inputs must not be invented. Details and numerical comparison rules are in [validation.md](references/validation.md).

If the user chooses no further validation, continue extraction, MATLAB visualization and delivery with the already working baseline. Do not add other convergence/physical-validation studies as a substitute. Report “model ran successfully; further validation skipped by user”, not “validated”. A solver's success or a <3% sensitivity result alone is not proof of physical correctness.

## Deliver results

Follow [delivery-layout.md](references/delivery-layout.md). `models/` contains only the first successful baseline, actual validation `.mph` models and final models covering each requested task, plus `readme.md`. `results/` contains only validation results and final-task results (with essential per-result metadata), plus `readme.md`. Keep debugging attempts/checkpoints and operational records outside those two folders. Add `source/readme.md` describing input/reference files and `src/readme.md` describing every delivered program, its structure/function, dependencies, exact run commands, execution order and the two user-choice pauses. Use the task language for all four readmes. Curate new delivery folders without deleting existing user files, live locks or unique run evidence.

Read [word-delivery.md](references/word-delivery.md). After execution and selected validation, **rewrite the final plan to match the actual adopted model, code, settings and method**, including successful fixes and the final mesh/tolerance choice. Preserve earlier plans and their actual approvals in revision history; do not merely append an error log to an obsolete plan. Reconcile the final plan and report against the saved model/configuration, executed sources, final run metadata and validation records. Documentation cleanup within approved scope does not require another approval; it must never retroactively authorize a substantive unapproved model change.

Deliver the final plan as `documents/simulation-plan.docx` and the results report as `documents/simulation-report.docx`. Both use the language of the user's simulation-task request (Chinese request -> Chinese documents; English request -> English documents), unless the user explicitly requests another language. Mathematical formulas **and inline mathematical variables** must use native editable Word equations (OMML), including inside tables; do not substitute equation images, raw LaTeX or plain-text approximations. Working Markdown is supplementary, not a substitute for the required Word documents. Follow the Word generation and visual/equation checks in the linked reference.

Deliver `.mph` with required solution data, all simulation and independent result-processing `.m` sources, raw/exported data with units and solution metadata, plots, final adopted plan and report in Word, plan/approval history, the user's validation choices and actual outcomes, environment/manifest and logs. File/document completeness, equation/layout checks and read-only consistency checks are delivery checks, not permission for additional solves. Do not force a save/reload comparison or reproducibility solve after the user declines further validation; perform one only when requested/agreed. Include external input files or document their unresolved dependencies.

Keep full logs per run. Write only proven fixes to a compact shared `lessons.jsonl` with version, symptom, cause, fix and verification evidence; do not store credentials. Search it before subsequent work. See [simulation.md](references/simulation.md) for the record format.
