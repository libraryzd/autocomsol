# Simulation plan / 仿真方案

Task / 任务：
Revision / 版本：v1
Status / 状态：DRAFT
Document language / 文档语言：match the simulation-task request unless explicitly overridden
Final run and source revision / 最终运行与源码版本：not available at proposal stage

<!-- Fill this template in the user's language. Remove these comments in the task copy.
DRAFT: decisive inputs missing; AWAITING_CONFIRMATION: concrete plan shown in chat;
APPROVED: actual user confirmation recorded. Never pre-fill approval.
This is a working outline, not the final user deliverable. Use only the chosen
language in the generated DOCX, including headings, tables and captions.
At delivery, archive previous revisions and rewrite this source from actual
adopted settings. Keep approval history separate from final implemented status.
Use native Word equations for all mathematical variables and formulas. -->

## 1 Simulation task / 仿真任务介绍

Introduce the background, physical object, question to answer, requested observables, scope and required deliverables. Identify supplied data, sources, missing decisive inputs and task constraints. Make the task understandable before discussing software.

## 2 Scientific analysis and modeling rationale / 科学分析与建模依据

Explain the governing physical mechanisms, relevant scales and simplifying assumptions. Justify the adopted dimensionality/symmetry, physics and couplings, study type, material laws and boundary treatment. Where needed, provide governing equations, dimensional/scale estimates or analytical limits with variable definitions, units and applicability. Connect this scientific justification to the COMSOL method in the next section. Explain consequential alternatives/tradeoffs briefly; do not reproduce an internal deliberation transcript. Distinguish sourced facts, assumptions, estimates and observed evidence.

For the final plan, rewrite this reasoning to explain the method actually adopted after debugging/refinement. Do not invent a theoretical justification for a purely software/API repair.

## 3 Concrete COMSOL settings / COMSOL 具体设置

Specify software versions, model/component dimension, geometry/dimensions/units, domains and named selections, materials and sources/ranges, physics/couplings, boundary/initial conditions, study type, parameter values and sweep scope. Use the actual final settings at delivery; do not present abandoned settings as active.

### Mesh solver and extraction / 网格求解器与结果提取

Specify mesh/refinement regions and counts when available, solver and applied tolerances, time/frequency discretization if relevant, solve sequence and extraction datasets/solution indices/coordinates. Distinguish proposed settings from implemented settings. Identify actual final model/source/run references.

## 4 Baseline and optional validation / 初步跑通与可选验证

State what constitutes running the requested model successfully and which outputs must be available. Preserve this baseline before asking the user to choose further validation.

After baseline success, offer three independent choices (selection pending until the user responds):

- [ ] Mesh validation / 网格验证：coarse, medium, fine; key-result differences <3%.
- [ ] Relative-tolerance validation / 相对容差验证：loose, medium, tight; key-result differences <3%.
- [ ] Reference-case validation / 算例验证：use uploaded references first; otherwise ask for an upload or explicit web-search instruction.

The user may select any combination or no further validation. Initial plan approval does not select these options. Define key comparison quantities and a meaningful normalization for near-zero values before running a selected study; retain them through all rounds. Do not schedule unselected studies.

At delivery replace pending instructions with the actual user choices, performed method/settings, pass/fail/skip/blocked status and evidence. Refer to the results report for detailed numerical results. If all validation was declined, describe the final baseline and say further validation was skipped.

## 5 Outputs and execution limits / 交付与执行限制

Specify model/source/data/figure/report outputs, extraction locations and solution selection, output directory, compute limits, retry limits and timeout handling. Mark runtime estimates as estimates.

## 6 Confirmation and version record / 确认与版本记录

Plan revision shown in chat：
Actual user confirmation or explicit workflow override：Pending / 尚未收到
Message identifier or time, if available：

## 7 Changes incorporated in the final method / 最终方案变更记录

Record original choice, adopted choice, reason/error, scope or user approval basis, and verifying source/run for meaningful changes. Keep full exceptions and routine repairs in execution logs. Archive original plans/approvals instead of overwriting their history; do not mark the final documentation rewrite as new user approval.
