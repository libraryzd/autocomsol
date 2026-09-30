# Final adopted plan and Word report

## Language and document versions

Determine the document language from the user's simulation-task request, not the skill's instruction language, software interface, source-code language or reference-paper language. Chinese task -> Chinese plan/report; English task -> English plan/report. An explicit requested output language takes precedence. For mixed-language requests use the dominant language of the user's task instructions. Translate headings, prose, captions, table labels, validation statuses and cautions consistently; original reference titles, units, paths and COMSOL API identifiers may retain their original spelling. Do not produce bilingual boilerplate unless requested.

At proposal time, show the substantive plan in chat and supply `documents/plan-proposed-vN.docx`; keep `plan.md` as its editable working source. Initial Word generation does not authorize simulation execution. Preserve earlier proposal sources/documents and actual approval messages in `plans/revisions/` before revising them. Use unique revision names rather than overwriting history.

At task completion, produce two principal documents:

- `documents/simulation-plan.docx`: the final adopted simulation method, reconciled with what actually ran.
- `documents/simulation-report.docx`: the results, interpretation, selected validation outcomes, limitations and reproduction instructions.

Supplementary Markdown/JSON sources are allowed; they do not replace these DOCX deliverables. The output is a genuine Word Open XML document, not renamed Markdown, HTML, PDF or a collection of page screenshots.

## Reconcile the final plan before writing

Read the final executed sources/configuration, recorded model settings, saved model identity, run metadata, results and validation selections. Use read-only model inspection if a setting is uncertain; do not launch a new solve solely to document it. Distinguish the original baseline from the application candidate actually used for final results, and distinguish a separately reproduced literature case from the application model.

Update every affected part of the plan: physics, geometry, materials, conditions, study, mesh, active solver tolerances, parameter scope, solve sequence, extraction method and intended validation method. Also update the scientific rationale when the adopted modeling approach changed. Remove abandoned values from active-setting tables; preserve them only in a concise change record. A stale initial plan with a debugging appendix is not a final adopted plan.

For each consequential change record the original choice, final choice, reason/error, evidence that the fix worked, and whether it stayed within approved scope or required actual user approval. Keep full errors and routine API details in logs. Do not invent theory to justify a syntax/API repair. Do not falsify earlier approvals or treat retrospective documentation as approval for a substantive unapproved model change. The final document can be labeled “Final implemented method” with source/run identifiers; that label is distinct from a user approval status.

## Required order and content

The plan must begin with these three sections, in order:

1. **Simulation task introduction**: background, object/system, physical question, objectives, requested outputs, inputs/sources and scope. The reader should understand the task before encountering COMSOL settings.
2. **Scientific analysis and modeling rationale**: explain the physical mechanisms, assumptions, relevant scales, and the basis for dimensionality, physics/couplings, study type, boundary treatment and numerical choices. Include governing equations, short reproducible derivations, dimensional estimates or analytical limits where they help justify the method. Define mathematical variables, units, provenance and applicability. Present a concise scientific explanation of decisions, not private internal reasoning or a tool-call transcript.
3. **Concrete COMSOL setup**: geometry/units, parameters, domains/selections, material properties and sources, physics and conditions, study/sweeps, actual mesh settings, solver/tolerances, datasets/solution indices, extraction and postprocessing. Distinguish a proposal's intended settings from the final plan's implemented settings.

Follow with baseline/selected-validation method and actual choices, execution limits/deliverables, provenance and meaningful revisions. Use [simulation-plan.md](../assets/simulation-plan.md) as the working outline, localizing all headings/content in the DOCX.

The report uses [simulation-report.md](../assets/simulation-report.md): task/findings, adopted method, results and interpretation, selected validation/status/limits, important changes, deliverables/reproduction and references. Report numerical values with units and corresponding run/dataset/parameter identifiers. Keep conclusions proportional to actual evidence; an optional validation not selected remains skipped in both documents.

## Generate native Word documents and editable math

Use a document-authoring runtime available on the current computer. Prefer the host's workspace dependency loader and an available documents skill for creation/rendering. Read and follow that skill when used. Do not hardcode the development computer's runtime paths. This skill's content contract remains applicable when that optional helper skill is absent: use a verified DOCX writer/OOXML workflow and a local Word-compatible renderer. Missing authoring/rendering dependencies are a concrete delivery limitation to resolve/report, not permission to silently replace the requested format.

Use Word paragraph styles for title/headings/body, a readable Chinese-capable font when needed, consistent page margins/spacing, page numbers, appropriately sized tables and figures, and descriptive captions. Put long explanations in prose rather than narrow table cells. Populate documents from a shared final-settings/results source to prevent plan/report drift. Preserve the task-local document generation script and any required assets for regeneration.

All mathematical formulas and mathematical variables, including isolated inline variables and symbols in tables/captions, must be **native Word equations in Office Math Markup Language (OMML)**. Use `m:oMath` inline and `m:oMathPara` with `m:oMath` for displayed equations. Construct structured fractions, superscripts/subscripts, radicals, integrals and matrices with the corresponding OMML elements rather than visually approximating them using ordinary text. Use appropriate math fonts such as Cambria Math; ensure Chinese explanatory text stays in normal document runs. Plain numeric values/units and literal code/API identifiers may remain text/code where they are not mathematical notation.

For example, an inline mathematical variable can be represented as:

```xml
<m:oMath xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math">
  <m:r><m:t>T</m:t></m:r>
</m:oMath>
```

This is an OOXML authoring example, not text to paste into the user's document. With `python-docx`, insert a parsed OMML element into the intended paragraph's XML at the correct run position; a normal `add_run('T')` is not a native equation. Structured formulas require structured OMML or a tested converter that emits OMML. Do not put unconverted LaTeX commands inside `m:t` and claim conversion succeeded. OMML must remain present in the final saved DOCX after any render/conversion workflow.

Do not substitute PNG/SVG equation images, equation screenshots, raw LaTeX strings or external equation objects for native Word equations. Scientific plots may be images; mathematical captions/variable definitions outside those plots remain editable Word math. If no reliable conversion path exists for a formula, resolve that issue or explicitly report the limitation; do not call a raster fallback compliant.

## Document checks before delivery

1. Cross-check plan/report statements and tables against the final model/configuration, actual source/run records, results and selected validation outcomes. Confirm that the plan explains the final adopted method and retains traceable historical changes. No new physics/convergence run is needed for this document audit.
2. Check both DOCX ZIP packages for well-formed Open XML and appropriate `m:oMath`/`m:oMathPara` elements wherever mathematical content is required. Compare the authored equation/inline-variable inventory with the final document; one token equation does not establish that every formula was converted. Check notation structure and displayed text for accidental raw LaTeX, math images and plain-text substitutions. A formula-free document need not contain artificial OMML.
3. Render each DOCX to page images using the available document renderer, inspect every page, and fix/re-render clipping, missing glyphs, broken equations, bad table breaks or inconsistent language. Follow an available documents skill's renderer instructions. Inspect the final DOCX package again if rendering involved a save/conversion. Package inspection proves representation; visual inspection proves readability, and neither proves scientific validity.
4. Record document QA status honestly. If rendering is unavailable/fails, retain the editable DOCX/source and report the unresolved visual check rather than claiming completion. Do not swap in PDF or formula images without the user's request. Rendering intermediates are QA files, not default deliverables.
5. Reconcile model/result paths and task coverage with all four directory readmes under [delivery-layout.md](delivery-layout.md). Include the initial default-solver/200-cap policy and actual final solver settings, documenting exceptions and changes. After the final edit, update artifact hashes/manifest, confirm both DOCX files are present and readable, and link the final plan and report in the final response. Earlier proposal files are history, not substitutes for the final plan.

Existing historical smoke output includes a Markdown report. That runner alone does not satisfy this Word delivery contract: synthesize the final adopted plan and Word report from its actual evidence when that legacy run is requested. Do not describe old benchmark results as a test of this new document workflow.
