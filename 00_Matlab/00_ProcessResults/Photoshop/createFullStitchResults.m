%createFullStitchResults(inputDirectory, outputDirectory)
inputDirectory = 'E:\Scratch\Diff_Images\FullRes_Normal_NIR_Auto_GeomtricCorrection_images';
outputDirectory = 'E:\Scratch\temp';
outputFileName = 'compiledResults.txt';

S = dir(fullfile(inputDirectory, '*.png')); % pattern to match filenames.
try 
    F = fullfile(inputDirectory, S(1).name);
catch
    S = dir(fullfile(inputDirectory, '*.tif')); % pattern to match filenames.
    F = fullfile(inputDirectory, S(1).name);
end

[~, imName, ~] = fileparts(F);
normFlag = strcmp(imName(4:6), 'nor');
numFiles = numel(S);

outStats = cell(numFiles,1);

parfor k = 1:numFiles
    F = fullfile(inputDirectory, S(k).name);
    [~, imName, ~] = fileparts(F);
    [im, ~, alpha] = imread(fullfile(inputDirectory, S(k).name));
    [rows, cols, ~] = size(im);
    im = single(im);
    inds = logical(alpha(:));
    x = reshape(im(:,:,1), rows*cols, 1);
    y = reshape(im(:,:,2), rows*cols, 1);
    z = reshape(im(:,:,3), rows*cols, 1);
    x(inds) = [];
    y(inds) = [];
    z(inds) = [];
    outStats{k} = rmsFromImage(x, y, z, imName(1:2), outputDirectory, normFlag);
    fprintf('Obtained results from file %d of %d.\n', k, numFiles);
end

T = dir(fullfile(outputDirectory, '*.txt')); % pattern to match filenames.

totals = [];
totals.minX = 0;
totals.minY = 0;
totals.minZ = 0;
totals.maxX = 0;
totals.maxY = 0;
totals.maxZ = 0;
totals.stdX = 0;
totals.stdY = 0;
totals.stdZ = 0;
totals.RMSE_X = 0;
totals.RMSE_Y = 0;
totals.RMSE_Z = 0;
totals.maxMag = 0;
totals.pixels = 0;

files = {};  % Thanks Walter

for i = numel(T):-1:1
   files{i} = fullfile(T(i).folder, T(i).name);
   totals = compTotals(totals, outStats{i});
end

aves = compAverages(totals, numFiles);

numberOfFiles = length(files);                     %
[fid, msg] = fopen(fullfile(outputDirectory, outputFileName), 'w');
if fid == -1
    error('Cannot open file for writing: %s', msg);
end

% Header
if normFlag
    fprintf(fid, '%6s | %6s | %6s | %6s | %6s | %6s | %6s | %6s | %6s | %6s | %6s | %6s | %6s | %7s| %6s\n', ...
            'Name', 'Min X', 'Min Y', 'Min Z', 'Max X', 'Max Y', ...
            'Max Z', 'Std X', 'Std Y', 'Std Z', 'RMSE X', 'RMSE Y', ...
            'RMSE Z', 'Max Mag', 'Pixels');
    fprintf(fid, ['-------|', repmat('--------|', 1, 13), '---------\n']);
else
    fprintf(fid, '%6s | %6s | %6s | %6s | %6s | %6s | %6s | %6s | %6s | %6s | %6s | %6s | %6s | %6s\n', ...
            'Name', 'Min X', 'Min Y', 'Min Z', 'Max X', 'Max Y', ...
            'Max Z', 'Std X', 'Std Y', 'Std Z', 'RMSE X', 'RMSE Y', ...
            'RMSE Z', 'Pixels');
    fprintf(fid, ['-------|', repmat('--------|', 1, 12), '---------\n']);
end

for k = 1:numberOfFiles
    fprintf(fid, '%s\n', fileread(files{k}));
    delete(files{k});
end

%% Average at the end

if normFlag
    fprintf(fid, ['-------|', repmat('--------|', 1, 13), '---------\n']);

    % Output from normals
    fprintf(fid, '%7s| %6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %8d', ...
            'Average', aves.minX, aves.minY, aves.minZ, ...
            aves.maxX, aves.maxY, aves.maxZ, aves.stdX, ...
            aves.stdY, aves.stdZ, aves.RMSE_X, aves.RMSE_Y, ...
            aves.RMSE_Z, aves.maxMag, ceil(aves.pixels));
else
    fprintf(fid, ['-------|', repmat('--------|', 1, 13), '---------\n']);
    % Output from normals
    fprintf(fid, '%6s | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %8d', ...
            'Average', aves.minX, aves.minY, aves.minZ, ...
            aves.maxX, aves.maxY, aves.maxZ, aves.stdX, ...
            aves.stdY, aves.stdZ, aves.RMSE_X, aves.RMSE_Y, ...
            aves.RMSE_Z, ceil(aves.pixels));
end

fclose(fid);
    
% end