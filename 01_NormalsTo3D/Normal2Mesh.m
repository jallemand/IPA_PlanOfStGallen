function Normal2Mesh(varargin)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

addpath(genpath('../02_MatlabDependencies'))

% Define the "constant" distance between pixels
pixelSpacing = 1;

if nargin == 2
    % Get a list of all the input normal aps
    imagePaths = dir(fullfile(varargin{1}, '*.tif'));
    
    % Define the output folder variable
    outputFolder = varargin{2};
    
    % Set flag for false as no ambient maps were passed
    colourImagesFlag = false;
    
    % Set variable associated with number of images
    n = size(imagePaths,1);
    imagesList = {};
    for i = n:-1:1
        imagesList{i} = [imagePaths(i).folder, '\', imagePaths(i).name];
    end
        
        
    % Check that there are images in file
    if n == 0
        error(['No normal maps were passed. Please choose a directory', ...
            ' that contains normal maps']);
    end
    
    % Check the size of the images
    [width, height, ~] = size(imread(imagesList{1}));
    fprintf(['You are about to process: \n  Images : %i\n    ', ...
        'Width: %i\n    Height: %i\n\n'], n, width, height);
    inp = lower(input('Are you sure you want to continue (y,n)?', 's'));
    
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
        fprintf('Processing Terminated.')
    else
        colourVector = [];
        
        for i = 1:n
            image_path = imagesList{i};
            fprintf('Processing image %i\n', i)
            produceMesh(image_path, outputFolder, pixelSpacing, colourImagesFlag, colourVector);
        end
        fprintf('===== PROCESSING COMPLETE =====\n\n')
    end
elseif nargin == 3
%     imagePaths = dir(fullfile(varargin{1}, '*.tif'));
%     outputFolder = varargin{2};
%     colourImagePaths = dir(fullfile(varargin{3}, '*.tif'));
%     
%     colourImagesFlag = true;
%     
%     % Set variable associated with number of images
%     n = length(inputImages);
%         
%     % Check that there are images in file
%     if n == 0
%         error(['No normal maps were passed. Please choose a directory', ...
%             ' that contains normal maps']);
%     end
%     
%     % Check the size of the images
%     [width, height, ~] = size(imread(imagePaths(1)));
%     fprintf(['You are about to process: \n  Images : %i\n    ', ...
%         'Width: %i\n    Height: %i\n\n'], n, width, height);
%     inp = lower(input('Are you sure you want to continue (y,n)?', 's'));
%     
%     while 1
%         if length(inp) == 1
%             if inp == 'y'
%                 break
%             elseif inp == 'n'
%                 breakFlag = true;
%                 break
%             else
%                 inp = lower(input(['Invalid entry. Please enter either', ...
%                     '"y" or "n".\n Are you sure you want to continue', ...
%                     ' (y/n)?'], 's'));
%             end
%         else
%             inp = lower(input(['Invalid entry. Please enter either', ...
%                     '"y" or "n".\n Are you sure you want to continue', ...
%                     ' (y/n)?'], 's'));
%         end
%     end
%     
%     if breakFlag
%         fprintf('Processing Terminated.')
%     else
%         parfor i = 1:n
%             image_path = imagePaths(i);
%             colourVector 
%             produceMesh(image_path, outputFolder, pixelSpacing, colourImagesFlag, colourVector);
%         end
%         fprintf('===== PROCESSING COMPLETE =====')
%     end
%     
%     
%     
%     
else
    error(['Too many variables were passed.\nPlease pass only the input'... 
            'folder and output folder'])
end
end




