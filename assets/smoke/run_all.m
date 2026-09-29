function checks = run_all(outputDir)
% Self-contained delivery entrypoint: add this src folder, choose NEW output.
addpath(fileparts(mfilename('fullpath')));
checks = run_smoke(outputDir);
end
