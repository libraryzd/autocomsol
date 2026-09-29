# Simulation plan / 仿真方案

Task / 任务：
Revision / 版本：v1
Status / 状态：DRAFT

<!-- Fill this template in the user's language. Remove these comments in the task copy.
DRAFT: decisive inputs missing; AWAITING_CONFIRMATION: concrete plan shown in chat;
APPROVED: actual user confirmation recorded. Never pre-fill approval. -->

## Objective and inputs / 目标与输入

State the requested observables, supplied facts, missing decisive inputs, and proposed assumptions. Include geometry/dimensions, units and material sources/applicable ranges.

## Model and study / 模型与研究

Specify physics/couplings, simplifications, boundary/initial conditions, steady/transient/frequency study, parameter values and sweep scope.

## Numerical approach / 数值方案

Specify mesh/refinement regions, solver, time/frequency discretization if relevant, and convergence strategy. Distinguish proposed settings from verified settings.

## Baseline and optional validation / 初步跑通与可选验证

State what constitutes running the requested model successfully and which outputs must be available. Preserve this baseline before asking the user to choose further validation.

After baseline success, offer three independent choices (selection pending until the user responds):

- [ ] Mesh validation / 网格验证：coarse, medium, fine; key-result differences <3%.
- [ ] Relative-tolerance validation / 相对容差验证：loose, medium, tight; key-result differences <3%.
- [ ] Reference-case validation / 算例验证：use uploaded references first; otherwise ask for an upload or explicit web-search instruction.

The user may select any combination or no further validation. Initial plan approval does not select these options. Define key comparison quantities and a meaningful normalization for near-zero values before running a selected study; retain them through all rounds. Do not schedule unselected studies.

## Outputs and budget / 交付与预算

Specify model/source/data/figure/report outputs, extraction locations and solution selection, output directory, compute limits, retry limits and timeout handling. Mark runtime estimates as estimates.

## Confirmation record / 确认记录

Plan revision shown in chat：
Actual user confirmation or explicit workflow override：Pending / 尚未收到
Message identifier or time, if available：

## Revisions / 修订记录

Record substantive changes and which revision is approved. Keep routine repairs in the execution log.
