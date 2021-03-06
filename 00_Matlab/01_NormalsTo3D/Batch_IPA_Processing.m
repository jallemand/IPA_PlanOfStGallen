%% IPA BATCH PROCESSING
% Add dependencies
addpath(genpath('../02_MatlabDependencies'));

% Define input directories
normalFolder = 'E:\Scratch\temp\Normals';
ambientFolder = 'E:\Scratch\temp\Ambients';

% Define output directories
outputFolder = 'E:\Scratch\temp\Outputs\04_NUV';
outHeightDir = fullfile(outputFolder,'00_Heightmaps');
outFullPointDir = fullfile(outputFolder,'01_Full_Resolution_PointClouds');
outSubPointDir = fullfile(outputFolder,'02_SubSampled_PointClouds');
% Spacing between pixels
pixelSpacing = 1;

%% Processing Flags
createPtCloud = true;
createHeightMap = true;
ptCloudColours = true;
ptCloudNormals = true;

%% Pre-processing
normalPaths = [dir(fullfile(normalFolder, '*.png')) dir(fullfile(normalFolder, '*.tif'))];
ambientPaths = [dir(fullfile(ambientFolder, '*.png')) dir(fullfile(ambientFolder, '*.tif'))];
n_norms = size(normalPaths,1);
n_ambs = size(ambientPaths,1);

if n_norms ~= n_ambs
   error(['The number of normal maps does not match the number of ' ...
            'ambient images input']);
end

if n_norms == 0
    error(['No normal maps were passed. Please choose a directory', ...
        ' that contains normal maps']);
end

normalsList = {};
ambientList = {};
for i = n_norms:-1:1
    normalsList{i} = [normalPaths(i).folder, '\', normalPaths(i).name];
    ambientList{i} = [ambientPaths(i).folder, '\', ambientPaths(i).name];
end

% Get the image dimensions and check they match.
[width_norm, height_norm, ~] = size(imread(normalsList{1}));
[width_ambs, height_ambs, ~] = size(imread(ambientList{1}));

if width_norm ~= width_ambs
   error('The width of the ambient images and normal maps do not match.');
end
if height_norm ~= height_ambs
   error('The height of the ambient images and normal maps do not match.');
end

if createHeightMap
    if strcmp(outHeightDir,"")
        outHeightDir = [outputFolder, '\04_Heightmaps\'];
        if 7 ~= exist(outHeightDir,'dir')
           mkdir(outHeightDir)
        end
    else
        if 7 ~= exist(outHeightDir,'dir')
           mkdir(outHeightDir)
        end
    end
end

if createPtCloud
    if strcmp(outFullPointDir,"")
        outFullPointDir = [outputFolder, '\03_PointClouds\'];
        if 7 ~= exist(outFullPointDir,'dir')
           mkdir(outFullPointDir)
        end
        if 7 ~= exist(outSubPointDir,'dir')
           mkdir(outSubPointDir)
        end
        
    else
        if 7 ~= exist(outFullPointDir,'dir')
           mkdir(outFullPointDir)
        end
        if 7 ~= exist(outSubPointDir,'dir')
           mkdir(outSubPointDir)
        end
    end
end

%% User input to see if they want to process everything.
fprintf(['Processing: \n  Images : %i\n    ', ...
    'Width: %i\n    Height: %i\n\n'], n_norms, width_norm, height_norm);

%% Initiate parallel processing
if isempty(gcp('nocreate'))
    c = parcluster('local');
else
    c = gcp;
    num_cores = c.NumWorkers;
end

minZ = zeros(n_norms,1);
maxZ = zeros(n_norms,1);
out_Z = cell(n_norms,1);

parfor i = 1:n_norms
    normalPath = normalsList{i};
    ambientPath = ambientList{i};

    if ptCloudColours
        imAmb = imread(ambientPath);
    else
        imAmb = [];
    end

    fprintf('Integrating the normals for image %i ... \n', i);
    if createPtCloud || createHeightMap
        imNorm = imread(normalPath);
        [~, name, ~] = fileparts(normalPath);
        [xyz, Z] = normal2xyz(imNorm, pixelSpacing);
        minZ(i) = min(Z(:));
        maxZ(i) = max(Z(:));
        out_Z{i} = Z;

        if createPtCloud
            fprintf('Creating point cloud for image %i ... \n', i);
            ptCloudName = [outFullPointDir, '\', name, '.ply'];

            [fullCloud] = createPtCloud_IPA(xyz, imNorm, imAmb, ...
                ptCloudNormals, ptCloudColours);
            pcwrite(fullCloud, ptCloudName, 'Encoding', 'binary');
            
            subCloud = pcdownsample(fullCloud, 'random', 0.1);
            
            [~, name, ~] = fileparts(ptCloudName);
            ptCloudName = [outSubPointDir, '\', name, '.ply'];
            pcwrite(subCloud, ptCloudName, 'Encoding', 'binary');
        end

    end
end
fprintf('===== FINISHED CREATING POINT CLOUDS =====\n');

parfor i = 1:n_norms
    fprintf('Creating height map for image %i ... \n', i);
    normalPath = normalsList{i};
    [~, name, ~] = fileparts(normalPath);

    if createHeightMap
        Z = out_Z{i} - min(minZ(i));
        Z = uint16(Z * floor(2^16 / maxZ(i)));
        file_heightmap = fullfile(outHeightDir, [name, '.png']);
        imwrite(Z, file_heightmap, 'BitDepth', 16);
    end
end
fprintf('===== FINISHED CREATING HEIGHT MAPS =====\n')
fprintf('========== PROCESSING COMPLETE ==========\n\n')




