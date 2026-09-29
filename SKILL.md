---
name: autocomsol
description: Set up the official MATLAB MCP Server and drive COMSOL through an existing COMSOL with MATLAB session. For new simulations, first show a concrete plan and wait for user confirmation, then build, debug, validate, and deliver reproducible models, data, reports, and verified error lessons.
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

Produce a concrete plan covering physics, units, materials, geometry, boundary/initial conditions, study, parameters, mesh, solver, requested outputs, validation criteria and compute/retry budget. Follow the plan-and-wait step above. Missing scientifically decisive inputs must not be invented.

## Execute, validate, deliver

Persist source files before executing them. Prefer separate build/solve/extract/postprocess/validate functions and an entrypoint with explicit inputs. Use unique model tags and task directories, stable named selections, explicit result datasets and solution indices. Checkpoints and logs must survive a failed stage.

Use the existing MCP tools `check_matlab_code`, `evaluate_matlab_code` and `run_matlab_file` when exposed; inspect live schemas rather than assume fixed arguments. The shipped smoke example is an infrastructure benchmark, not a universal physics template.

For an error: capture the full exception, classify its cause, look up verified relevant lessons, make a targeted change, and rerun the affected stage. Continue routine repairs within the approved plan. Ask for a revised plan only when the physical problem, agreed accuracy, resources or scope must change. Default to at most three attempts for the same failure without new evidence; report a concrete blocker instead of looping.

Treat tool timeouts as **unknown execution state**. Check logs/output/status before resubmitting. MATLAB may be unable to run a second command while solving. A status JSON file is not proof of a live process. This release has no guaranteed asynchronous cancellation or process supervisor; do not promise either. Never kill the user's MATLAB/COMSOL to resolve a timeout.

Validate units/selections and task-specific physical/numerical criteria. Compare with a benchmark when available; perform appropriate mesh/time/tolerance studies. Separate numerical verification from physical validation, and report unchecked items. A solver's success is not proof of correctness.

Deliver `.mph` with required solution data, all simulation and independent result-processing `.m` sources, raw/exported data with units and solution metadata, plots, confirmed plan, verification results, report, environment/manifest and logs. Reload the saved model and reproduce results before marking delivery validated. Include external input files or document their unresolved dependencies.

Keep full logs per run. Write only proven fixes to a compact shared `lessons.jsonl` with version, symptom, cause, fix and verification evidence; do not store credentials. Search it before subsequent work. See [simulation.md](references/simulation.md) for the record format.
