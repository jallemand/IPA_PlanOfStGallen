function comparePhotoshopProjectResults(baseFolder)
%% Produce the set of results from the output 
    intermediateFolders = dir(baseFolder);
    intermediateFolders = getFolderNames(intermediateFolders);
    % Convert the input folder path to lower case for comparison of the
    % photometric product type and the colour spectrum it was captured
    lowerPath = lower(baseFolder);
    
    mosaicPrefixes = {'_geocorr', '_nogeocorr', '_reposition'};
    imageType = {'_overlap', '_mask'};
    
    % Get a logical flag if the product is from the white light acquisition
    flags.whiteLight = contains(lowerPath, 'white');
    flags.normal = contains(lowerPath, 'normal');
    flags.threeChannels = flags.whiteLight | flags.normal;
    
    % Get a cell array containing the associated patch name 
    fileNames = getFileNameOrder(flags.whiteLight);
    
    % Get all the mosaics outputs from hugin and how many there are
    baseMosaics = dir(fullfile(baseFolder, '*.tif'));
    numMosaics = length(baseMosaics);
    
    % Create a folder for the output statistics
    outputFolder = fullfile(baseFolder, 'Output_Statistics');

    % Define the output filename
    outputFileName = 'compiledResults.txt';
    
    % Separate the corresponding mosaic outputs and image output types
    imageFolders = cell(numMosaics, length(imageType));
    for i = 1:numMosaics
        for j = 1:length(imageType)
            for k = 1:length(intermediateFolders)
                if contains(lower(intermediateFolders(k)), [mosaicPrefixes{i}, imageType{j}])
                    imageFolders{i, j} = intermediateFolders{k};
                end
            end
        end
    end

    % Pre-allocation
    mosaicPaths = cell(numMosaics,1);
    outputFolders = cell(numMosaics,1);
    
    % Iterate through the different mosaics
    for i = 1:numMosaics
        overlapImagePaths = dir(fullfile(imageFolders{i,1}, '*.png'));
        maskImagePaths = dir(fullfile(imageFolders{i,2}, '*.png'));
        
        numLayers = length(maskImagePaths);
        
        % Get the mosaic path
        mosaicPaths{i} = fullfile(baseMosaics(i).folder, baseMosaics(i).name);
        
        % Get the unique component of the mosaic name appended from the
        % hugin stitching process
        temp = split(baseMosaics(i).name, '.');
        temp = split(temp{1}, '_');
        
        % Read in the mosiac
        fprintf('Reading mosaic:  %s\n', mosaicPaths{i});
        mosaic = imread(mosaicPaths{i});

        % Create a subfolder path according to the layer types and the
        % mosaic being compared with
        outputFolders{i} = fullfile(outputFolder, [sprintf('%s_',temp{4:end-1}),temp{end}]);
        if ~exist(outputFolders{i}, 'dir')
           mkdir(outputFolders{i});
        end

        % Iterate through each layer and output the results to file
        parfor k = 1:numLayers
            % Get the specific paths for the mask and overlap file
            overlapPath = fullfile(overlapImagePaths(k).folder, overlapImagePaths(k).name);
            maskPath = fullfile(maskImagePaths(k).folder, maskImagePaths(k).name);
            
            [XYZ, outHull] = computePhotoshopDifferences(mosaic, overlapPath, maskPath);
            outStats = computeImageStats(XYZ, flags);
            writeStatsToFile(outStats, outHull, fileNames{k}, outputFolders{i}, flags)
            fprintf(' ... Written Image # %d\n', k);
        end

        % Compile and output the results from all patches in the mosaic
        outfile = fullfile(outputFolders{i}, outputFileName);
        fprintf('... %s created\n', outputFileName);
        compileImageStats(outputFolders{i}, outfile, flags)

        % Compile the histogram values and output it to a mat file
        compileHistogramValues(outputFolders{i}, flags)

    end
end

function folders = getFolderNames(folders)
    for i = length(folders):-1:1
        thisFile = fullfile(folders(i).folder, folders(i).name);
        if ~isfolder(thisFile)
            folders(i) = []; 
        elseif length(folders(i).name) <= 2
            folders(i) = [];
        end    
    end
    
    numFolders = length(folders);
    outFolders = cell(numFolders,1);
    for i = 1:numFolders
        outFolders{i} = fullfile(folders(i).folder, folders(i).name);
    end
    folders = outFolders;
end






        