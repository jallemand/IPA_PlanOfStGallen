function Normal2PtClouds(varargin)
%UNTITLED2 Summary of this function goes here
%   This function takes the following input options:
%   - Normal2PtClouds(normalFolder, outputFolder)
%   - Normal2PtClouds(normalFolder, ambientFolder, outputFolder)
%   - Normal2PtClouds(normalFolder, ambientFolder, outputFolder,
%   heightmapFolder)

addpath(genpath('../02_MatlabDependencies'))
% Define the "constant" distance between pixels
pixelSpacing = 1;

heightMapFlag = true;
normFlag = false;

if nargin == 2
    %%
     % Get a list of all the input normal aps
    normalPaths = dir(fullfile(varargin{1}, '*.tif'));
    
    % Define the output folder variable
    outputFolder = varargin{2};
    
    

    % Set variable associated with number of images
    n = size(normalPaths,1);
    normalsList = {};
    for i = n:-1:1
        normalsList{i} = [normalPaths(i).folder, '\', normalPaths(i).name];
    end

	% Check that there are images in file
    if n == 0
        error(['No normal maps were passed. Please choose a directory', ...
            ' that contains normal maps']);
    end
    
    % Check the size of the images
    [width, height, ~] = size(imread(normalsList{1}));
    fprintf(['You are about to process: \n  Images : %i\n    ', ...
        'Width: %i\n    Height: %i\n\n'], n, width, height);
    inp = lower(input('Are you sure you want to continue (y,n)?', 's'));
    
    % Logical Check if they want to continue
    while 1
        if length(inp) == 1
            if inp == 'y'
                breakFlag = false;
                break
            elseif inp == 'n'
                breakFlag = true;
                break
            else
                inp = lower(input(['Invalid entry. Please enter either', ...
                    '"y" or "n".\n Are you sure you want to continue', ...
                    ' (y/n)?'], 's'));
            end
        else
            inp = lower(input(['Invalid entry. Please enter either', ...
                    '"y" or "n".\n Are you sure you want to continue', ...
                    ' (y/n)?'], 's'));
        end
    end
    
    if heightMapFlag
        outHeightDir = [outputFolder, '\Heightmaps\'];
        if 7 ~= exist(outHeightDir,'dir')
           mkdir(outHeightDir)
        end
    end
    
       
    if breakFlag
        fprintf('Processing Terminated.')
    else
        c = parcluster('local');
        num_cores = c.NumWorkers;
        if n == 1
            normalPath = normalsList{1};
            fprintf('Processing normal maps %i\n', 1)
            [pCloud, filename] = createPtCloud( ...
                normalPath, outputFolder, pixelSpacing, heightMapFlag);
            pcwrite(pCloud,filename, 'Encoding', 'binary');

        elseif n >= c
            parpool(num_cores)
        elseif n > 1
            parpool(n)
        else
            error('No files were passed...')
        end
            
            
        parfor i = 1:n
            normalPath = normalsList{i};
            fprintf('Processing normal maps %i\n', i)
            [pCloud, filename] = createPtCloud( ...
                normalPath, outputFolder, pixelSpacing, heightMapFlag);
            pcwrite(pCloud,filename, 'Encoding', 'binary');
        end
            
        fprintf('===== PROCESSING COMPLETE =====\n\n')
    end
    
elseif nargin == 3
    %%
    % Get a list of all the input normal aps
    normalPaths = dir(fullfile(varargin{1}, '*.tif'));
    
    % Get ambient images
    colourImagePaths = dir(fullfile(varargin{2}, '*.png'));
    
    % Define the output folder variable
    outputFolder = varargin{3};

    % Set variable associated with number of images
    n = size(normalPaths,1);
    normalsList = {};
    for i = n:-1:1
        normalsList{i} = [normalPaths(i).folder, '\', normalPaths(i).name];
    end

    ambientPaths = {};
    for i = n:-1:1
        ambientPaths{i} = [colourImagePaths(i).folder, '\', colourImagePaths(i).name];
    end
        
        
    % Check that there are images in file
    if n == 0
        error(['No normal maps were passed. Please choose a directory', ...
            ' that contains normal maps']);
    end
    
    % Check the size of the images
    [width, height, ~] = size(imread(normalsList{1}));
    fprintf(['You are about to process: \n  Images : %i\n    ', ...
        'Width: %i\n    Height: %i\n\n'], n, width, height);
    inp = lower(input('Are you sure you want to continue (y,n)?', 's'));
    
    % Logical Check if they want to continue
    while 1
        if length(inp) == 1
            if inp == 'y'
                breakFlag = false;
                break
            elseif inp == 'n'
                breakFlag = true;
                break
            else
                inp = lower(input(['Invalid entry. Please enter either', ...
                    '"y" or "n".\n Are you sure you want to continue', ...
                    ' (y/n)?'], 's'));
            end
        else
            inp = lower(input(['Invalid entry. Please enter either', ...
                    '"y" or "n".\n Are you sure you want to continue', ...
                    ' (y/n)?'], 's'));
        end
    end
       
    if breakFlag
        fprintf('Processing Terminated.\n\n')
    else
        c = parcluster('local');
        num_cores = c.NumWorkers;
        if n == 1
            normalPath = normalsList{1};
            ambientPath = ambientPaths{1};
            fprintf('Processing normal and ambient maps %i\n', 1)
            [pCloud, filename, Z] = createPtCloudColour(normalPath, ambientPath, ...
                outputFolder, pixelSpacing, normFlag);
            pcwrite(pCloud,filename, 'Encoding', 'binary');
            if heightMapFlag
                fprintf('Processing heightmap %i... \n', i);
                % Get file name
                [~,name,~] = fileparts(normalPath);
                file_heightmap = [outputFolder, '\Heightmaps\', name, '.png'];
                Z_norm = (Z - min(Z(:))) * 100;
                Z_out = uint16(Z_norm);
                
                % Write image from Z data
                imwrite(Z_out, file_heightmap, 'BitDepth', 16);
            end
            
        elseif n >= c
            parpool(num_cores);
        elseif n > 1
            parpool(num_cores);
        else
            error('No files were passed...')
        end
        
        if heightMapFlag
            outHeightDir = [outputFolder, '\Heightmaps\'];
            if 7 ~= exist(outHeightDir,'dir')
               mkdir(outHeightDir)
            end
        end
        
        parfor i = 1:n
            normalPath = normalsList{i};
            ambientPath = ambientPaths{i};
            fprintf('Processing normal and ambient maps %i\n', i)
            
            [pCloud, filename, Z] = createPtCloudColour(normalPath, ambientPath, ...
                outputFolder, pixelSpacing, normFlag);
            
            if heightMapFlag
                fprintf('Processing heightmap %i... \n', i);
                % Get file name
                [~,name,~] = fileparts(normalPath);
                file_heightmap = [outHeightDir, name, '.png'];
                
                
                % Write image from Z data
                imwrite(Z_out, file_heightmap, 'BitDepth', 16);
            end
%             pcwrite(pCloud, filename, 'Encoding', 'binary');
        end
        fprintf('===== PROCESSING COMPLETE =====\n\n')
    end
    
else
    error(['Too many variables were passed.\nPlease pass only the input'... 
            'folder and output folder'])
end
end




