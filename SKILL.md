---
name: autocomsol
description: Set up the official MATLAB MCP Server and drive COMSOL through an existing COMSOL with MATLAB session. Show a simulation plan for confirmation, get the model running, then offer optional mesh, relative-tolerance and reference-case validation before delivering models, data, reports and verified error lessons.
---

# AutoCOMSOL

Use the official MathWorks MATLAB MCP Server in `existing` session mode and COMSOL LiveLink for MATLAB. This package automates Windows x64 setup; other platforms require the official platform-specific installation. Never infer a working connection or a valid physical model from installed software or running processes.

For what was actually tested and the current limits, read [release-validation.md](references/release-validation.md) when assessing readiness or troubleshooting portability.

## First response to a new simulation: plan, then wait

Before writing task-specific simulation programs or creating/modifying/meshing/solving a COMSOL model, present a concrete plan **in the chat**, save it as the task's `plan.md`, and end the turn awaiting the user's confirmation. A plan saved only in a file, a progress update, or an internal task checklist does not satisfy this requirement. Use [the plan template](assets/simulation-plan.md) and the details below. If decisive inputs are missing, show the proposed approach and those questions; do not invent values or present an incomplete plan as ready to execute.

Before confirmation, installation/connection checks, read-only version/model inspection, research and plan preparation may proceed within the requested scope. A request to “do this simulation”, MATLAB session sharing, MCP/tool permission, or approval to install/publish the skill is not confirmation of a specific simulation plan. The bundled acceptance simulation also follows this rule; a connection check alone must not trigger it.

Record plan revision and status `AWAITING_CONFIRMATION`. After the user confirms the displayed revision, record `APPROVED` and the actual user message establishing approval, then proceed. Never generate the user's approval yourself, treat silence as approval, or continue to execution in the turn that first proposes the plan. If the conversation already contains approval of the same concrete plan, honor it without asking again. Explicit user instructions overriding the confirmation workflow take precedence; record that instruction accurately. See [simulation.md](references/simulation.md) for continuation and revision handling.

## Setup or repair a connection

Read [setup.md](references/setup.md). Run the bundled installer with normal host permissions; request platform escalation for network access or writes outside the workspace when required. Respect an existing MCP configuration rather than overwriting it. Do not install a different COMSOL/MATLAB version without a user request.

The user shares the **COMSOL with MATLAB** session using the generated `prepare_session.m`. Use `shareMATLABSession()` for this official server, not the Python Engine sharing API. Do not automatically start a replacement MATLAB, clear the workspace, quit MATLAB, or remove unrelated COMSOL models.

Discover native MATLAB MCP tools first. If the current chat has not loaded newly registered tools, reload MCP/open a new chat, or use the bundled stdio client to test the same official server. A shell client is a diagnostic transport, not a separate MATLAB engine.

## Plan a simulation

Read [simulation.md](references/simulation.md). Inspect the live environment and relevant [bundled verified lessons](references/verified-lessons.jsonl) plus the user's accumulated lesson store. Research APIs against the installed COMSOL version using local help, official documentation and examples; use third-party material as unverified leads. Save source URLs/version and distinguish assumptions from supplied facts.

Produce a concrete plan covering physics, units, materials, geometry, boundary/initial conditions, study, parameters, initial mesh/solver, requested outputs and compute/retry budget. Identify key results for later optional validation, but do not treat initial plan approval as selection of those validations. Follow the plan-and-wait step above. Missing scientifically decisive inputs must not be invented.

## Execute, validate, deliver

Persist source files before executing them. Prefer separate build/solve/extract/postprocess/validate functions and an entrypoint with explicit inputs. Use unique model tags and task directories, stable named selections, explicit result datasets and solution indices. Checkpoints and logs must survive a failed stage.

Use the existing MCP tools `check_matlab_code`, `evaluate_matlab_code` and `run_matlab_file` when exposed; inspect live schemas rather than assume fixed arguments. The shipped smoke example is an infrastructure benchmark, not a universal physics template.

For an error: capture the full exception, classify its cause, look up verified relevant lessons, make a targeted change, and rerun the affected stage. Continue routine repairs within the approved plan. Ask for a revised plan only when the physical problem, agreed accuracy, resources or scope must change. Default to at most three attempts for the same failure without new evidence; report a concrete blocker instead of looping.

Treat tool timeouts as **unknown execution state**. Check logs/output/status before resubmitting. MATLAB may be unable to run a second command while solving. A status JSON file is not proof of a live process. This release has no guaranteed asynchronous cancellation or process supervisor; do not promise either. Never kill the user's MATLAB/COMSOL to resolve a timeout.

First get the model running according to the task: required physics/conditions are implemented, the solve succeeds, and requested outputs are available and usable. Preserve this baseline `.mph`, source, settings and results. Do not automatically launch mesh, relative-tolerance or reference-case validation to achieve this milestone.

## After the baseline runs: let the user select validation

Read [validation.md](references/validation.md). Show evidence that the baseline runs, then offer **three independent checkboxes**: mesh validation, relative-tolerance validation, and reference-case validation. The user may select any combination or explicitly choose no further validation. Stop and wait for the selection; silence, initial plan approval and a preselected UI option are not a selection. Use a native multi-select UI if available; otherwise use the bundled [checkbox form](assets/validation-choice.html) or the documented chat fallback.

Run only the selected validations. Mesh validation uses coarse/medium/fine meshes; relative-tolerance validation uses loose/medium/tight settings. For each selected study, plan three distinct levels, compare declared key outputs against the finest/tightest result, and require **both other levels to differ by strictly less than 3%**. If not, plan and run a new triplet until it passes; do not declare completion just because three refinement rounds elapsed. Preserve settings, results and error history. Genuine execution/resource blockers pause the selected study with an honest status; they never count as a pass.

For reference-case validation, inspect user-uploaded references first and directly reproduce a sufficiently specified relevant case. If none was supplied, ask the user to upload one or send “请直接网上查找相关算例”; wait before searching for a substitute. When explicitly requested, research suitable cases and validate a reproducible one. If none is found, state “未调研到相关算例”, mark that validation skipped and continue the task. Missing decisive benchmark inputs must not be invented. Details and numerical comparison rules are in [validation.md](references/validation.md).

If the user chooses no further validation, continue extraction, MATLAB visualization and delivery with the already working baseline. Do not add other convergence/physical-validation studies as a substitute. Report “model ran successfully; further validation skipped by user”, not “validated”. A solver's success or a <3% sensitivity result alone is not proof of physical correctness.

## Deliver results

Deliver `.mph` with required solution data, all simulation and independent result-processing `.m` sources, raw/exported data with units and solution metadata, plots, confirmed plan, the user's validation choices and actual outcomes, report, environment/manifest and logs. File existence/readability and complete exports are delivery checks, not permission for additional solves. Do not force a save/reload comparison or reproducibility solve after the user declines further validation; perform one only when requested/agreed. Include external input files or document their unresolved dependencies.

Keep full logs per run. Write only proven fixes to a compact shared `lessons.jsonl` with version, symptom, cause, fix and verification evidence; do not store credentials. Search it before subsequent work. See [simulation.md](references/simulation.md) for the record format.
