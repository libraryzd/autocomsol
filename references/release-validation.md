# Release 1.0.0 validation

Validated on 2026-09-28, Windows x64, official MATLAB MCP v0.14.0, MATLAB R2025b, COMSOL 6.3 build 290. This COMSOL/MATLAB combination is outside COMSOL 6.3's officially listed MATLAB releases; passing this test does not expand vendor support.

Completed: official asset SHA-256 checks, MCP initialize/tools-list, connection to an existing shared session, live COMSOL version query, MATLAB static checks, heat-transfer model construction, two meshes, stationary solves, explicit solution extraction, `.mph` save/reload, raw MAT and CSV export, MATLAB-only plotting, artifact hashes, and rerun using a relocated copy of delivered sources. Independent replot succeeded after test models were removed. No clean MATLAB process or second physical computer was used.

Observed: max temperature error 6.5938366e-11 K; relative flux error 3.4826542e-12; relative energy imbalance 5.3316285e-12; mesh profile difference 4.5758952e-11 K; reloaded solution difference 0 K. These are infrastructure benchmark results, not general convergence/physics validation.

Installer tests: preserve unrelated config, valid TOML, exact pre-change backup, idempotent repeat, refuse conflicting registration, reject tampered cached binary. Skill frontmatter passes bundled validation.

Connection ran through the bundled diagnostic stdio client against the official server. Codex CLI reported the registered server enabled. New native tool discovery in a restarted/new chat remains a user-side activation check; it was not claimed as completed in the original chat.

Known limit: localized Chinese console output appeared corrupted through the tested MCP text channel. UTF-8 JSON and exception files written by MATLAB were readable; use these files for accurate diagnostics. See bundled lessons. Long-task asynchronous supervision/cancellation and non-Windows installers are not implemented in this release.
