function checks = validate_results(coarse, fine, reloaded)
checks.maxTemperatureError_K = max(abs(fine.temperature_K-fine.analytic_K));
checks.coarseTemperatureError_K = max(abs(coarse.temperature_K-coarse.analytic_K));
checks.relativeFluxError = max(abs([fine.leftFlux_W_per_m+200, fine.rightFlux_W_per_m-200]))/200;
checks.relativeEnergyImbalance = abs(fine.leftFlux_W_per_m+fine.rightFlux_W_per_m)/200;
checks.meshDifference_K = max(abs(coarse.temperature_K-fine.temperature_K));
checks.reloadDifference_K = max(abs(fine.temperature_K-reloaded.temperature_K));
checks.thresholds = struct('temperature_K',1e-3, 'relativeFlux',1e-5, ...
    'relativeEnergy',1e-6, 'meshDifference_K',1e-3, 'reloadDifference_K',1e-8);
checks.passed = checks.maxTemperatureError_K < 1e-3 && ...
    checks.coarseTemperatureError_K < 1e-3 && ...
    checks.relativeFluxError < 1e-5 && checks.relativeEnergyImbalance < 1e-6 && ...
    checks.meshDifference_K < 1e-3 && checks.reloadDifference_K < 1e-8;
checks.scope = 'Linear analytic infrastructure benchmark; not general physical validation or proof of mesh convergence.';
end
