# Release validation

## 1.0.2 optional validation workflow (2026-09-29)

The requested task now reaches a runnable, saved baseline before the user chooses any combination of mesh, relative-tolerance and reference-case validation, or no further validation. Selected mesh/tolerance studies use three levels, compare the first two with the third using declared metrics, require <3%, and replan until passing or a real blocker. Literature validation uses uploaded cases first, requests upload/search direction when absent, and skips with an explicit no-case-found status after an unsuccessful authorized search.

The package includes a local three-checkbox form that generates a message for the user to send to the chat. It does not invoke MATLAB or submit user choices automatically. The historical MATLAB regression runners remain unchanged and are explicitly excluded from the baseline-first path. No new COMSOL convergence results or fresh-chat behavioral acceptance are claimed. Static package/link checks and checkbox-form interaction tests cover the new artifacts; live simulation-loop acceptance remains outstanding.

## 1.0.1 workflow correction (2026-09-29)

Following a report that execution skipped the visible plan, the skill now explicitly requires a plan in the chat, a revisioned `plan.md`, and a turn ending while awaiting confirmation before simulation programming/model execution. The default prompt, setup/benchmark instructions and both READMEs follow that rule. A reusable plan template records actual confirmation without inventing approval. Existing approval of a concrete plan and explicit user workflow overrides remain valid.

This is a workflow-instruction correction, not a server-side execution lock. Static package validation does not prove agent behavior; a fresh-chat behavioral acceptance test remains outstanding. MATLAB solver sources and the results below are unchanged; no new scientific benchmark result is claimed for this correction.

## 1.0.0 simulation validation

Validated on 2026-09-28, Windows x64, official MATLAB MCP v0.14.0, MATLAB R2025b, COMSOL 6.3 build 290. This COMSOL/MATLAB combination is outside COMSOL 6.3's officially listed MATLAB releases; passing this test does not expand vendor support.

Completed: official asset SHA-256 checks, MCP initialize/tools-list, connection to an existing shared session, live COMSOL version query, MATLAB static checks, heat-transfer model construction, two meshes, stationary solves, explicit solution extraction, `.mph` save/reload, raw MAT and CSV export, MATLAB-only plotting, artifact hashes, and rerun using a relocated copy of delivered sources. Independent replot succeeded after test models were removed. No clean MATLAB process or second physical computer was used.

Observed: max temperature error 6.5938366e-11 K; relative flux error 3.4826542e-12; relative energy imbalance 5.3316285e-12; mesh profile difference 4.5758952e-11 K; reloaded solution difference 0 K. These are infrastructure benchmark results, not general convergence/physics validation.

Installer tests: preserve unrelated config, valid TOML, exact pre-change backup, idempotent repeat, refuse conflicting registration, reject tampered cached binary. Skill frontmatter passes bundled validation.

Connection ran through the bundled diagnostic stdio client against the official server. Codex CLI reported the registered server enabled. New native tool discovery in a restarted/new chat remains a user-side activation check; it was not claimed as completed in the original chat.

Known limit: localized Chinese console output appeared corrupted through the tested MCP text channel. UTF-8 JSON and exception files written by MATLAB were readable; use these files for accurate diagnostics. See bundled lessons. Long-task asynchronous supervision/cancellation and non-Windows installers are not implemented in this release.
