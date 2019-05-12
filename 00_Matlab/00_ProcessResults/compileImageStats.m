function compileImageStats(resultsFolder, outputFile)
% Get the all the stats files
files = dir(fullfile(resultsFolder, 'stats_*.csv'));

% Get the number of files
numFiles = numel(files);

% Create cell array to contain the patch names
patchNames = cell(length(files), 1);

% Pre-allocate array to contain the results
outStats = zeros(numFiles, 13);

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
        outStats(i,:) = csvread(tempFile);
    end
end

% Get the average of all the images statistics
meanStats = mean(outStats);
meanStats(1:6) = ceil(meanStats(1:6));
meanStats(end) = round(meanStats(end));

writeCompiledResults(outputFile, outStats, meanStats, patchNames)
end