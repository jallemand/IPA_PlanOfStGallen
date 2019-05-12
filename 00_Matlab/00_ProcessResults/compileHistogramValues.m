function compileHistogramValues(resultsFolder)
% Get the all the stats files
files = dir(fullfile(resultsFolder, 'histogram_*.csv'));

% Get the number of files
numFiles = numel(files);

% Create cell array to contain the patch names
patchNames = cell(length(files), 1);

% Pre-allocate array to contain the results

temp = fullfile(files(1).folder, files(1).name);
temp = csvread(temp);
numCols = length(temp);

outHists = zeros(numFiles, numCols);
% Iterate through the files
for i = numel(files):-1:1
    % Get the full file path to read
    tempFile = fullfile(files(i).folder, files(i).name);
    
    % Ensure that the file is not the output file as well
    if ~strcmp(tempFile, outputFile)
        temp = split(files(i).name, '.');
        temp = split(temp, '_');
        temp = temp{2};
        patchNames{i} = temp;
        outHists(i,:) = csvread(tempFile);
    end
end

outFile = fullfile(resultsFolder, 'patchHistograms.mat');

save(outFile, 'outHists');


end