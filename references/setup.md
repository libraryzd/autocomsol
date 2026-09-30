# Windows setup and migration

The package contains instructions, a pinned installer, a diagnostic MCP client and MATLAB benchmark sources. Installing a skill alone does not register a running MCP server or select a MATLAB session. First invocation performs bootstrap; the user shares their intended session once per MATLAB launch. Network/system permissions still apply.

## Installation

1. Copy the complete `autocomsol` directory into the actual Codex skill directory (`$CODEX_HOME/skills`, otherwise the user's `.codex/skills`). Do not nest it twice. Discoverability may require a new chat.
2. Execute `scripts/install-mcp.ps1 -RegisterMcp` in PowerShell. The script downloads pinned official Windows x64 assets, checks SHA-256, prepares session setup, backs up existing Codex config and adds only `mcp_servers.autocomsol_matlab`. It does not overwrite a conflicting registration. It respects CODEX_HOME. Use `-RuntimeDir` and `-CodexDirectory` for an explicit alternative. Do not hardcode the development computer's drive/user paths.
3. In **COMSOL with MATLAB**, run the `prepare_session.m` path printed by the installer. This validates LiveLink connectivity, installs the official downloaded Toolbox if the sharing function is absent, and calls `shareMATLABSession()`. If a different version of that Toolbox is already installed, inspect it and use the matching pinned Toolbox deliberately; do not silently replace it.
4. Reload MCP or open a new chat. Discover `autocomsol_matlab` tools. Confirm the running MATLAB PID, MATLAB/COMSOL versions and LiveLink path with `ac_preflight` before executing a model.
5. If an acceptance simulation was requested, use the geometry/physics in `assets/smoke/plan.md` to propose a single baseline run and wait for plan confirmation under SKILL.md. Setup/connection permission alone is not approval to solve. After confirmation, copy the example into a new task directory and use its separate build/solve/extract functions in a baseline driver. Once it runs, save its solution and offer the three choices in [validation.md](validation.md). Do not call the legacy `run_smoke`/`run_all` entrypoints before that choice: they automatically perform two-mesh/analytic/reload regression checks. Only an explicit request for that complete legacy regression workflow authorizes its bundled entrypoint. Preserve actual plan approval and validation selections in the delivered task records.

For a newly generated baseline driver, adapt the solve stage to [initial-solver.md](initial-solver.md) before running it, and package outputs under [delivery-layout.md](delivery-layout.md). The historical example's existing `solve_model.m` runs immediately with generated defaults and does not set/read back the 200 cap; using it unmodified does not satisfy that new preference. Preserve historical regression sources/results as historical evidence.

`existing` mode is deliberate: `auto` can launch a new MATLAB if sharing fails. Multiple sessions: the server selects the most recently shared one. Do not use `restoredefaultpath`, `clear all`, `ModelUtil.clear`, `quit`, or process killing to repair a connection. Never attach by guessing which window is correct.

## Diagnostic fallback without MCP tool refresh

Use a local Python 3 executable (stdlib only) with:

```text
python mcp-client.py --binary ABSOLUTE_OFFICIAL_EXE --list --output ABSOLUTE_EVIDENCE_JSON
python mcp-client.py --binary ABSOLUTE_OFFICIAL_EXE --tool evaluate_matlab_code --arguments-file ABSOLUTE_ARGS_JSON --output ABSOLUTE_RESULT_JSON --timeout 180
```

An arguments file is JSON, for example `{"code":"disp(version)"}`. Tool schemas are saved by `--list`. Execute one request at a time; do not have native and diagnostic clients mutate the same MATLAB concurrently. The client only starts the official MCP executable with `existing` mode. It never starts a Python MATLAB engine. It terminates only its owned transport subprocess. Any timeout is unknown MATLAB execution state, not a failed/stopped solve.

If shell sockets are sandbox-blocked, request platform escalation; do not change transports to evade restrictions. This fallback needs a Python runtime; native MCP operation does not.

## Compatibility and trouble isolation

- COMSOL 6.3 lists MATLAB R2024a/R2024b. R2025b is outside that list; test actual functions, record the mismatch, and do not claim vendor certification after a successful benchmark.
- No shared session: share in the intended window; check tool installation, matching Windows user and TEMP/TMP context. Do not start a replacement session.
- `mphversion` absent: the shared session is missing LiveLink. Prefer reopening COMSOL with MATLAB. Manual `mphstart` requires an actual COMSOL server, correct `mli` path and licensing; do not blindly call it in an already connected session.
- Module unavailable: report the missing physics/license; do not substitute different physics silently.
- Busy or timeout: inspect task status/logs first; never submit the same solve blindly. Long-run supervision/cancellation is outside this first release.
- New computer: rerun installer and test. Do not carry old absolute paths, config backups, user-specific environment files or live session tokens inside the portable skill.

## Official sources (checked 2026-09-28)

- [MathWorks MCP v0.14.0](https://github.com/matlab/matlab-mcp-server/tree/v0.14.0)
- [Official release](https://github.com/matlab/matlab-mcp-server/releases/tag/v0.14.0)
- [Codex MCP configuration](https://developers.openai.com/codex/mcp)
- [COMSOL 6.3 MATLAB support](https://www.comsol.com/system-requirements/63/module)
- [LiveLink startup](https://doc.comsol.com/6.3/doc/com.comsol.help.llmatlab/llmatlab_ug_start.5.03.html)

The package does not redistribute MathWorks binaries. Installer pins asset hashes from official release metadata. Updating a version requires updating hashes and retesting.
