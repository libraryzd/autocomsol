function solve_model(model, meshLevel)
model.component('comp1').mesh('mesh1').autoMeshSize(meshLevel);
model.component('comp1').mesh('mesh1').run;
model.study('std1').run;
% This isolated model has exactly one study and solver, never select an
% arbitrary existing user's data set or an active plot by default.
solvers = cell(model.sol.tags);
assert(isscalar(solvers), 'AutoCOMSOL:Solver', 'Expected one solver.');
datasets = cell(model.result.dataset.tags);
if ~ismember('acData', datasets)
    model.result.dataset.create('acData', 'Solution');
end
model.result.dataset('acData').set('solution', solvers{1});
end
