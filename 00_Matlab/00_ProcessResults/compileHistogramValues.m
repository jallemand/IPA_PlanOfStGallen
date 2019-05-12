function compileHistogramValues(resultsFolder, flags)
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

if flags.threeChannels
    outHists = zeros(numFiles*3, numCols);
else
    outHists = zeros(numFiles, numCols);
end

% Iterate through the files
for i = numel(files):-1:1
    % Get the full file path to read
    tempFile = fullfile(files(i).folder, files(i).name);
    
    % Ensure that the file is not the output file as well

    temp = split(files(i).name, '.');
    temp = split(temp{1}, '_');
    temp = temp{2};
    patchNames{i} = temp;
    if flags.threeChannels
        outHists(((i-1)*3)+1:((i-1)*3)+3,:) = csvread(tempFile);
    else
        outHists(i,:) = csvread(tempFile);
    end

end

outFile = fullfile(resultsFolder, 'patchHistograms.mat');

save(outFile, 'outHists');
end