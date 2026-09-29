function ac_writejson(filename, value)
% Write UTF-8 JSON; create parent only within the caller's chosen output path.
parent = fileparts(filename);
if ~isfolder(parent), mkdir(parent); end
fid = fopen(filename, 'w', 'n', 'UTF-8');
assert(fid ~= -1, 'AutoCOMSOL:WriteFailed', 'Cannot write %s', filename);
cleanup = onCleanup(@() fclose(fid));
fprintf(fid, '%s\n', jsonencode(value, PrettyPrint=true));
end
