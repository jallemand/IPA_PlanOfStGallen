fullPtCloudDir = 'D:\00_Allemand_IPA\00_Data\02_FinalOutput\01_Front\00_WhiteLight\03_PointClouds\Full_Resolution';
subsampledDir = 'D:\00_Allemand_IPA\00_Data\02_FinalOutput\01_Front\00_WhiteLight\03_PointClouds\Subsampled\Raw';

% Get a list of all point clouds
ptCloudFiles = dir(fullfile(fullPtCloudDir, '*.ply'));
ptCloudPaths = [];
% Get the number of point clouds
num = size(ptCloudFiles,1);

% Create full paths
for i = num:-1:1
    ptCloudPaths{i} = [ptCloudFiles(i).folder, '\', ptCloudFiles(i).name];
end

% Iterate through
parfor i = 1:num
	% Generate the new file path
	[~, name, ~] = fileparts(ptCloudPaths{i});
	ptCloudName = [subsampledDir, '\', name, '.ply'];
    
    fprintf('Reading in - %s \n', name);
    
    % Read in point cloud
    tempCloud = pcread(ptCloudPaths{i});
    
    % Downsample point cloud
    outCloud = pcdownsample(tempCloud, 'random', 0.25);

    % Write new point cloud
    pcwrite(outCloud, ptCloudName, 'Encoding', 'binary');
    
    fprintf('Finished sampling - %s\n', name);
end