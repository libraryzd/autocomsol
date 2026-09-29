function info = ac_preflight(outputFile)
% Inspect the actual shared session without clearing variables or model tags.
info = struct;
info.timestamp = char(datetime('now', 'Format', 'yyyy-MM-dd HH:mm:ss'));
info.matlabVersion = version;
info.matlabRelease = version('-release');
info.matlabRoot = matlabroot;
info.pid = feature('getpid');
info.mphversionPath = which('mphversion');
info.mcpSharePath = which('shareMATLABSession');
assert(~isempty(info.mphversionPath), 'AutoCOMSOL:MissingLiveLink', ...
    'The shared MATLAB has no LiveLink path; share COMSOL with MATLAB.');
info.comsolVersion = char(mphversion);
info.compatibility = 'Not audited against the vendor support matrix';
isComsol63 = ~isempty(regexp(info.comsolVersion, '(^|\s)6\.3([\s\.]|$)', 'once'));
if isComsol63 && ~ismember(info.matlabRelease, {'2024a','2024b'})
    info.compatibility = 'Outside COMSOL 6.3 listed MATLAB R2024a/R2024b support; benchmark required, not certification';
elseif isComsol63
    info.compatibility = 'COMSOL 6.3 / MATLAB release listed by vendor';
end
% getComsolVersion above requires LiveLink; tags also checks server reachability.
import com.comsol.model.util.*
info.existingModelTags = cell(ModelUtil.tags);
info.licenseNote = 'Installed toolboxes are not proof of COMSOL module license availability; check when creating requested physics.';
if nargin > 0 && ~isempty(outputFile), ac_writejson(outputFile, info); end
disp(jsonencode(info, PrettyPrint=true));
end
