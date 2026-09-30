# Curated task output and folder readmes

Use this layout for new simulation tasks. Match all generated `readme.md` prose to the simulation-task language. File names can be stable ASCII identifiers. The lowercase `readme.md` is required in each of `models`, `results`, `source`, and `src`.

```text
task/
  models/
    readme.md
    baseline-first-success.mph
    validation/mesh/round-001/coarse.mph
    validation/mesh/round-001/medium.mph
    validation/mesh/round-001/fine.mph
    validation/tolerance/round-001/loose.mph
    validation/tolerance/round-001/medium.mph
    validation/tolerance/round-001/tight.mph
    validation/reference/case-id.mph
    final/task-id.mph
  results/
    readme.md
    validation/mesh/round-001/
    validation/tolerance/round-001/
    validation/reference/case-id/
    final/task-id/
  source/
    readme.md
  src/
    readme.md
  documents/
    simulation-plan.docx
    simulation-report.docx
  plans/revisions/
  figures/
  logs/
    validation-status.json
    validation/mesh/round-001/
    validation/tolerance/round-001/
  work/
  plan.md
  config.json
  environment.json
  manifest.json
```

This tree illustrates possible contents, not permission to run every validation. Create only selected studies and actual outputs; do not manufacture files for skipped/unavailable cases. All four required readmes still exist, even when a directory has no applicable files.

## Models

Retain only these `.mph` categories and `models/readme.md`:

- The first successfully solved application baseline, with its required solution data, saved once and not overwritten by later refinements. For genuinely independent models that cannot share a baseline, label the first baseline of each model family explicitly.
- Models actually used in selected validation, including the coarse/medium/fine or loose/medium/tight levels of completed rounds and reference cases. Keep completed nonpassing validation rounds as genuine validation evidence, clearly labeled nonpassing; do not retain merely broken debugging saves here.
- The final solved model(s) covering **each requested task**, including its study/parameter/solution selection. A single model may cover multiple tasks; map each task to that model and its relevant solution in the readme instead of creating unexplained duplicates.

Initial unsolved builds, preflight scratch models, failed debugging attempts, solver experiments outside validation, checkpoints, backup copies and transient lock/recovery files do not belong in the final curated model folder. Save intermediate work outside it from the start. Do not delete a live COMSOL lock, forcibly detach a user's model, or delete unique/user-owned files to make a directory look clean. If a needed file has external dependencies, package inputs in `source/`, preserve resolvable paths, and document them; do not break a model by removing required data.

`models/readme.md` briefly lists **every retained model** by relative link with: category, task/case ID, purpose, key settings (mesh/tolerance/parameters when relevant), contained study/solution, status, corresponding result path and generating script/run. Clearly identify the first baseline and the final model(s). If the baseline is also final, record both roles without another solve; a byte-identical copy is optional, not required.

## Results

Retain only data/results corresponding to selected validation and final tasks, plus `results/readme.md`. Essential units/coordinates/parameter/dataset metadata stored with those outputs is part of the result. Completed nonpassing validation rounds remain labeled validation results. Preserve every result needed to reproduce comparisons and plots.

Exclude exploratory baseline exports that were not adopted as validation/final output, temporary/debug results, console logs, install evidence, runtime status, full environment snapshots and unrelated data. Keep runtime/validation-choice status in `logs/validation-status.json`, failure traces and round settings in `logs/`, raw original inputs in `source/`, and abandoned exploratory outputs in `work/`. When no further validation is selected, the baseline outputs become the **final task results** and are saved/labeled accordingly.

`results/readme.md` briefly describes **every result file** (include sidecar metadata) with relative link, task/validation and round, quantity/columns and units, corresponding model/study/solution/parameters, producing script, status and intended use. Avoid vague entries such as “all CSV files”; list actual names. Results for multiple tasks must be separately identifiable even if produced by the same model.

## Source inputs

By default `source/` contains original supplied/referenced inputs: CAD/geometry, material tables, measured data, benchmark reference files and any original code provided by the user. Preserve supplied originals; put maintained executable task programs in `src/` and document their origin. Do not duplicate licensed publications when only a citation/link is available or redistribution is not permitted.

`source/readme.md` lists every contained file, what it supplies, origin/citation, units or relevant format, which model/script consumes it, and any dependency/path/use constraints. If no inputs exist, say so. If an existing user project already assigns `source/` a different role, preserve that role and document its actual contents instead of silently moving files or treating `source` as a typo for `src`.

## Executable source code

`src/readme.md` must do more than list filenames. Include:

1. Purpose and structural organization of the delivered program (entrypoints, modules/functions and data flow).
2. An inventory of every source/helper/configuration file here, with its function, inputs, outputs and important dependencies.
3. Actual environment/session/path setup and exact runnable MATLAB commands matching the implemented function signatures, expected working directory and a new output directory. Do not invent `run_all` if it does not exist.
4. Execution order: input/config -> build -> auto-generated solver and applicable 200 cap -> solve -> preserve first successful baseline -> wait for user's validation choices -> run only selected validation branches -> final-task extraction -> independent postprocessing -> Word documents/folder readmes/manifest.
5. The initial plan-confirmation pause and the later validation-selection pause. An all-in-one entrypoint must not silently default to running every validation; describe the real staged commands or explicit options. Avoid implying an unimplemented interactive gate exists inside MATLAB.
6. How to rerun individual stages and reproduce plots from saved result data without rebuilding/solving, what outputs are created, and how to preserve the first baseline and earlier evidence. Identify documentation-generation scripts and dependencies when provided.

## Final curation and consistency

Prefer building a clean delivery directory by copying verified intended files from working runs. Do not mass-delete existing user folders. Keep runtime scratch, original evidence and legacy benchmark outputs intact outside the curated deliverables. Do not move/rename a saved model until all writers are finished and references are accounted for.

Check inventory coverage, relative links, task-to-model-to-result mapping and actual commands, then refresh all four readmes and the manifest after the last change. Every requested task must have its final model/result mapping or an explicit incomplete status; do not pass off an intermediate as final. Align the Word plan/report with these file paths and roles. These are packaging/read-only consistency checks and do not authorize new solves or skipped validation.

The historical smoke runner saves built/debug models and operational JSON with results. Its raw directory is not the current curated delivery: copy qualifying models/results into the required layout, document their identities, and leave original run evidence intact. Do not claim historical files were created under this new contract.
