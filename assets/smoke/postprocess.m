function postprocess(outputDir)
% Independent MATLAB-only plotting: no COMSOL connection is required.
loaded = load(fullfile(outputDir, 'results', 'raw_results.mat'), 'fine');
fine = loaded.fine;
figDir = fullfile(outputDir, 'figures');
if ~isfolder(figDir), mkdir(figDir); end
fig = figure('Visible','off', 'Color','w', 'Position',[100 100 900 400]);
cleanup = onCleanup(@() close(fig));
tiledlayout(1,2, 'TileSpacing','compact');
nexttile;
plot(fine.x_m, fine.analytic_K, 'k-', 'LineWidth',1.4);
hold on;
plot(fine.x_m(1:5:end), fine.temperature_K(1:5:end), 'o', 'MarkerSize',4);
xlabel('x (m)'); ylabel('Temperature (K)');
legend('Analytic','COMSOL','Location','best'); grid on;
title('Steady conduction');
nexttile;
plot(fine.x_m, fine.temperature_K-fine.analytic_K, 'LineWidth',1.2);
xlabel('x (m)'); ylabel('COMSOL - analytic (K)'); grid on;
title('Numerical error');
exportgraphics(fig, fullfile(figDir, 'temperature_validation.png'), 'Resolution',180);
exportgraphics(fig, fullfile(figDir, 'temperature_validation.pdf'), 'ContentType','vector');
savefig(fig, fullfile(figDir, 'temperature_validation.fig'));
end
