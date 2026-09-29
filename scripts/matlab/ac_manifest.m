function manifest = ac_manifest(outputDir)
% Hash completed run artifacts in bounded chunks; no Python dependency.
entries = dir(fullfile(outputDir,'**','*'));
files = struct('path',{},'bytes',{},'sha256',{});
for i=1:numel(entries)
    item = entries(i);
    if item.isdir || strcmp(item.name,'manifest.json'), continue; end
    filename = fullfile(item.folder,item.name);
    relative = filename(numel(outputDir)+2:end);
    files(end+1) = struct('path',strrep(relative,'\','/'), ...
        'bytes',item.bytes,'sha256',hashFile(filename)); %#ok<AGROW>
end
manifest = struct('schemaVersion',1,'created', ...
    char(datetime('now','Format','yyyy-MM-dd HH:mm:ss')), ...
    'files',files,'note','Hashes exclude this manifest; runtime versions are in environment.json.');
ac_writejson(fullfile(outputDir,'manifest.json'),manifest);
end

function value = hashFile(filename)
digest = java.security.MessageDigest.getInstance('SHA-256');
fid = fopen(filename,'rb');
assert(fid~=-1,'AutoCOMSOL:HashRead','Cannot read %s',filename);
cleanup = onCleanup(@() fclose(fid));
while true
    block = fread(fid,1024*1024,'*uint8');
    if isempty(block), break; end
    digest.update(typecast(block,'int8'));
end
bytes = typecast(digest.digest(),'uint8');
value = lower(reshape(dec2hex(bytes,2).',1,[]));
end
