function checks = run_smoke(outputDir)
% Run from a COPY of this example. Requires ac_preflight/ac_writejson on path.
assert(nargin==1 && ~isfolder(outputDir), 'AutoCOMSOL:OutputExists', ...
    'Choose a new output directory to preserve all previous runs.');
mkdir(outputDir);
for folder = {'models','results','logs','src','figures'}
    mkdir(fullfile(outputDir,folder{1}));
end
sourceDir = fileparts(mfilename('fullpath'));
copyfile(fullfile(sourceDir, '*.m'), fullfile(outputDir,'src'));
planFile = fullfile(sourceDir,'plan.md');
if ~isfile(planFile), planFile = fullfile(fileparts(sourceDir),'plan.md'); end
copyfile(planFile, fullfile(outputDir,'plan.md'));
copyfile(which('ac_writejson'),fullfile(outputDir,'src','ac_writejson.m'));
copyfile(which('ac_preflight'),fullfile(outputDir,'src','ac_preflight.m'));
copyfile(which('ac_manifest'),fullfile(outputDir,'src','ac_manifest.m'));
% Avoid replacing an existing user diary.
priorDiary = get(0,'Diary');
ownsDiary = strcmpi(priorDiary,'off');
if ownsDiary, diary(fullfile(outputDir,'logs','run.log')); end
cleanupDiary = onCleanup(@() stopDiary(ownsDiary));
import com.comsol.model.util.*
[~, uniquePart] = fileparts(tempname);
tag = ['AC_' uniquePart];
reloadTag = [tag '_reload'];
cleanupModels = onCleanup(@() removeOwnedModels({tag,reloadTag}));
stage = 'preflight';
try
    environment = ac_preflight(fullfile(outputDir,'environment.json'));
    stage = 'build'; updateStatus(outputDir,stage);
    model = build_model(tag);
    mphsave(model, fullfile(outputDir,'models','built.mph'));
    stage = 'solve_coarse'; updateStatus(outputDir,stage);
    solve_model(model,5);
    stage = 'extract_coarse'; updateStatus(outputDir,stage);
    coarse = extract_results(model);
    stage = 'solve_fine'; updateStatus(outputDir,stage);
    solve_model(model,3);
    stage = 'extract_fine'; updateStatus(outputDir,stage);
    fine = extract_results(model);
    stage = 'save_reload'; updateStatus(outputDir,stage);
    mphsave(model,fullfile(outputDir,'models','final.mph'));
    % Release only our original test model before loading its saved file.
    ModelUtil.remove(tag);
    reloadedModel = mphload(fullfile(outputDir,'models','final.mph'),reloadTag);
    reloaded = extract_results(reloadedModel);
    stage = 'export_validate'; updateStatus(outputDir,stage);
    save(fullfile(outputDir,'results','raw_results.mat'),'coarse','fine','reloaded');
    profile = table(fine.x_m,fine.y_m,fine.temperature_K,fine.analytic_K, ...
        'VariableNames',{'x_m','y_m','temperature_K','analytic_K'});
    writetable(profile,fullfile(outputDir,'results','profile.csv'));
    checks = validate_results(coarse,fine,reloaded);
    ac_writejson(fullfile(outputDir,'results','validation.json'),checks);
    metadata = rmfield(fine, {'x_m','y_m','temperature_K','analytic_K'});
    metadata.meshLevels = [5 3];
    metadata.units = struct('position','m','temperature','K','integratedFlux','W/m');
    ac_writejson(fullfile(outputDir,'results','metadata.json'),metadata);
    stage = 'postprocess'; updateStatus(outputDir,stage);
    postprocess(outputDir);
    writeReport(outputDir,environment,checks);
    assert(checks.passed,'AutoCOMSOL:ValidationFailed','Inspect results/validation.json.');
    updateStatus(outputDir,'passed');
    disp(jsonencode(checks,PrettyPrint=true));
    stopDiary(ownsDiary);
    removeOwnedModels({tag,reloadTag});
    ac_manifest(outputDir);
catch err
    ac_writejson(fullfile(outputDir,'status.json'),struct('state','failed', ...
        'stage',stage,'identifier',err.identifier,'message',err.message));
    fid = fopen(fullfile(outputDir,'logs','error.log'),'w','n','UTF-8');
    if fid ~= -1
        fprintf(fid,'%s\n',getReport(err,'extended','hyperlinks','off')); fclose(fid);
    end
    rethrow(err);
end
end

function updateStatus(outputDir,state)
ac_writejson(fullfile(outputDir,'status.json'),struct('state',state, ...
    'updated',char(datetime('now','Format','yyyy-MM-dd HH:mm:ss'))));
fprintf('AUTOCOMSOL_STAGE %s\n',state);
end

function stopDiary(owned)
if owned, diary off; end
end

function removeOwnedModels(tags)
import com.comsol.model.util.*
for i=1:numel(tags)
    try
        if ismember(tags{i},cell(ModelUtil.tags)), ModelUtil.remove(tags{i}); end
    catch
        % Do not replace an original exception if the server disconnected.
    end
end
end

function writeReport(outputDir,environment,checks)
fid = fopen(fullfile(outputDir,'report.md'),'w','n','UTF-8');
assert(fid~=-1,'AutoCOMSOL:Report','Cannot write report.');
cleanup = onCleanup(@() fclose(fid));
fprintf(fid,'# AutoCOMSOL infrastructure acceptance\n\n');
fprintf(fid,'MATLAB: %s. COMSOL: %s.\n\n',environment.matlabRelease,environment.comsolVersion);
fprintf(fid,'Compatibility: %s.\n\n',environment.compatibility);
fprintf(fid,'Validation passed: %d\n\n',checks.passed);
fprintf(fid,'Temperature error: %.6g K; flux relative error: %.6g; energy imbalance: %.6g.\n\n', ...
    checks.maxTemperatureError_K,checks.relativeFluxError,checks.relativeEnergyImbalance);
fprintf(fid,'Mesh difference: %.6g K; saved/reloaded difference: %.6g K.\n\n', ...
    checks.meshDifference_K,checks.reloadDifference_K);
fprintf(fid,'%s\n\n',checks.scope);
fprintf(fid,'See plan.md for exact equations, assumptions and thresholds. Two-dimensional integrated flux is W/m, not total W.\n\n');
fprintf(fid,'Replot without COMSOL: add this delivery src folder to MATLAB path; call postprocess(outputDir).\n');
end
