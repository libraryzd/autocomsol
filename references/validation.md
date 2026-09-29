# Optional validation after the model runs

## 1. Preserve a working baseline, then ask

Implement the approved task and fix errors until the requested model solves and its required outputs are available. Check implementation/units/selections and finite usable outputs as part of getting it running. Save a baseline model with its solution, source, settings and extracted key results before refinement. Do not quietly run extra studies while waiting for user input.

Show a concise baseline result (run ID, model path, solve outcome and key outputs), followed by these **independent**, initially unchecked choices in the user's language:

- [ ] 网格验证：粗、中、精三档，关键结果差异小于 3%。
- [ ] 容差（相对容差）验证：宽松、中等、严格三档，关键结果差异小于 3%。
- [ ] 算例验证：优先使用你已上传文献中的相关算例。

Ask “请选择任意一项或多项；也可回复‘不进行进一步验证’，直接使用已跑通模型继续任务。” Link this reference and explain that the skill requires this choice after baseline success. Stop and wait. Unchecked boxes are not evidence that the user chose none.

If a native multi-select control exists, use it. Otherwise copy [validation-choice.html](../assets/validation-choice.html) into the task directory, fill the task/run ID, and open it for the user as a local HTML artifact. It provides real checkboxes and a generated selection message to paste back into the chat; it does not silently send messages or invoke MATLAB. Read the actual user reply before executing. If the host cannot display an interactive form, explain that limitation and show the checklist in chat; accept a reply naming any subset, or ask three independent yes/no questions using `request_user_input_async` when available. Do not encode all three as mutually exclusive choices, use that text-only tool to request a file upload, or treat a preselected answer as submitted.

Record the actual user reply, run ID and choices in `results/validation-status.json`. Each study starts `pending_selection`, then becomes `selected` or `skipped_by_user`. An explicit choice of none skips all three and uses the baseline for remaining extraction, plotting and delivery. Lack of a reply remains pending. Existing explicit selections for this same baseline remain valid across continuation.

## 2. Define the <3% comparison before selected refinement

Use the task's key physical outputs, including all relevant requested operating points. Declare quantities, units, extraction regions/coordinates, datasets/solution indices, comparison metric and zero-handling scale before a round. Keep these fixed across rounds; do not change the metric or drop an inconvenient quantity to obtain a pass.

For scalar quantity j and levels 1/2/3 (coarse/medium/fine, or loose/medium/tight), use:

`E_13,j = abs(Q_1,j - Q_3,j) / max(abs(Q_3,j), s_j)`

`E_23,j = abs(Q_2,j - Q_3,j) / max(abs(Q_3,j), s_j)`

`E_round = max of both errors over all declared quantities and operating points`.

Require finite valid results for all three distinct levels and **E_round < 0.03**, strictly; exactly 3% does not pass. Report errors as percentages. `s_j` is a small, physically meaningful absolute reference scale with the same units, declared before testing; use zero only if the reference magnitude is demonstrably nonzero. If no meaningful scale is available for a near-zero quantity, mark that comparison undefined and resolve the metric before claiming a pass. Do not insert an arbitrary epsilon or enlarge the scale to hide disagreement. For fields/curves, compare on matching coordinates/times and declare the norm/weighting and normalization in advance; do not compare unmatched mesh-node arrays. Singular point maxima may require a physically justified regional/integral observable, identified transparently rather than quietly substituted.

These are relative differences against the finest/tightest tested result, not a bound on unknown true error. Keep the requested 3% criterion distinct from physical validation and literature acceptance criteria.

## 3. Selected mesh validation

Plan coarse, medium and fine meshes suited to the geometry/physics. Record actual mesh parameters, element counts/DOFs and quality; COMSOL preset numbers alone do not establish ordering. Keep materials, conditions, study, solver tolerances and output definitions fixed. Solve all three, extract the declared outputs and compute both differences against the fine result.

If the round does not satisfy <3%, use its error distribution to plan a new coarse/medium/fine triplet, refine relevant regions, and repeat until it passes. Reuse an identical valid run only if its source, mesh, settings and extraction definition match exactly; record that reuse. Save every round, including failures, to `validation/mesh/round-N/`. Do not stop after three rounds just because the normal repeated-code-error retry limit is three: a completed but nonpassing refinement round is not a repeated execution error.

After a pass, retain the fine model/results of the passing round as the mesh-validated candidate, while preserving the baseline. Record the final triplet, both percentage differences and all monitored outputs.

## 4. Selected relative-tolerance validation

Plan three distinct applicable relative tolerances from loose to tight, with all other settings and the mesh fixed. Choose magnitudes for the actual solver and task; do not impose a universal set. Confirm through version-matched API/help and solver settings that the requested relative tolerance is active and applied to the intended solver. Record dependent scaling/absolute-tolerance settings and hold them fixed. If the study has no meaningful active relative tolerance, report that applicability blocker instead of manufacturing three identical solves.

Solve all three, compare loose/tight and medium/tight key results with the same <3% rule. If it fails, plan a new tighter triplet and repeat until it passes. Keep the threshold fixed and store all rounds under `validation/tolerance/round-N/`. Retain the tightest result of the passing round as the tolerance-validated candidate.

If both mesh and tolerance are selected, normally finish mesh first, then test tolerances on its fine mesh. Label precisely which mesh/tolerance combination each pass covers. A claim of combined independence requires verifying the final combined settings; when tighter tolerances materially change results, repeat the selected mesh comparison at the final tolerance and iterate the selected studies as needed. Do not run an unselected study for this purpose.

Continue refinement while resources permit. No rule can guarantee eventual convergence: on a real resource/license/execution blocker or an agreed budget limit, preserve the last working models, mark the study `blocked`/`incomplete`, and explain the concrete next step to the user. Do not silently skip a selected study, claim success, spend beyond explicit limits, or change the 3% target. Ordinary replanning within the selected study and agreed budget does not need repeated confirmation.

## 5. Selected reference-case validation

Inspect references uploaded/provided for this task before asking for more. If a relevant reproducible case is available, read it and perform the case validation directly; do not ask the user to re-upload it or redundantly approve this selected validation. Extract geometry, material laws/parameters, conditions, study settings and reference outputs with page/figure/table citations. Reproduce the reference problem in a separate model/directory so it cannot overwrite the application model. Compare corresponding quantities with the literature's stated accuracy/uncertainty or a transparently stated task-specific criterion. The 3% refinement threshold is not automatically a literature-agreement threshold.

If no case reference was supplied, end the response asking: “请上传包含验证算例的文献/算例资料，或回复‘请直接网上查找相关算例’。” This is a request for the missing input needed by the selected workflow, not another authorization to run the simulation. Do not ask for uploads through a text-only input tool. Wait; do not automatically start substitute benchmark research merely because ordinary API research is allowed.

After an explicit web-search instruction, search relevant official examples and primary literature. Check physics, geometry, regime, boundary conditions, material definitions and available quantitative reference results before selecting a case. Save queries, source links and why the case matches. If no relevant reproducible case is found, state **“未调研到相关算例”**, mark `skipped_no_reference_found`, and continue the remaining selected studies and original task. Report an inaccessible search service as a search blocker, not as evidence that no case exists.

If a supplied/found case lacks decisive reproducibility inputs, explain exactly what is missing and request those data or permission to search another case. Do not invent them. If a reproduced case disagrees, record the discrepancy, investigate within scope, and report failed/incomplete validation honestly; never relabel it “no reference found”.

## 6. Continue and deliver

Use the baseline when all studies are skipped. When refinement passes, use the final application candidate at the passing settings for requested extraction, MATLAB analysis and figures. A separately reproduced reference case does not replace the user's application model. Preserve baseline and study provenance; save final `.mph`, all simulation/processing/selected-validation sources, data and concise verified error lessons. Rewrite the final plan using the actual adopted application settings; produce that plan and the results report as Word documents in the task-request language with native editable math under [word-delivery.md](word-delivery.md). Preserve original proposals and approvals separately.

The status record/report includes the user choice, baseline identity, per-study status, each triplet and measured differences, final model/settings, sources and limitations. Suggested terminal statuses are `passed`, `failed`, `blocked`, `skipped_by_user`, and `skipped_no_reference_found`; retain `pending_selection` while waiting. With no further validation, say “模型已按任务跑通；用户选择不进行进一步验证”. Do not add automatic mesh/time/physical/re-solve studies under another label. Reading exported files and checking deliverable completeness may continue normally.

The bundled `assets/smoke/run_smoke.m` and `run_all.m` are historical full-regression runners: they execute two meshes and analytic/reload checks in one call. They are not baseline-first task drivers and do not implement this optional workflow. Do not call either as a shortcut before the user's choice. For initial setup, build a single baseline from the example's separate build/solve/extract functions, then offer the choices above. Use the full legacy runner only when the user explicitly requests that complete regression workflow. Historical regression measurements do not claim acceptance of this new workflow.
