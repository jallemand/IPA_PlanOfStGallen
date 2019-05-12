function compareHuginProjectResults(baseFolder)
%% Produce the set of results from the output 

    % Convert the input folder path to lower case for comparison of the
    % photometric product type and the colour spectrum it was captured
    lowerPath = lower(baseFolder);
    
    % Get a logical flag if the product is from the white light acquisition
    whiteFlag = contains(lowerPath, 'white');
    
    % Get a cell array containing the associated patch name 
    fileNames = getFileNameOrder(whiteFlag);

    % Types of patch layers to perform comparison on
    layerTypes = {'Remapped'};
    
    % Get all the mosaics outputs from hugin and how many there are
    baseMosaics = dir(fullfile(baseFolder, '*.tif'));
    numMosaics = length(baseMosaics);
    
    % Create a folder for the output statistics
    outputFolder = fullfile(baseFolder, 'Output_Statistics');

    % Get path for the remapped layers
    remappedLayersFolder = fullfile(baseFolder, 'Remapped_Layers');

    % Get all the layer paths
    remappedLayers = dir(fullfile(remappedLayersFolder, '*.tif'));

    % Get the integer value for the number of layers
    numLayers = length(remappedLayers);
    
    % Define the output filename
    outputFileName = 'compiledResults.txt';
    
    % Create the fullpath names for the layers to be compared
    for i = 1:numLayers
        remappedLayers(i).fullPath = fullfile(remappedLayers(i).folder, remappedLayers(i).name);
    end
    
    % Pre-allocation
    mosaicPaths = cell(numMosaics,1);
    outputFolders = cell(numMosaics,1);
    
    % Iterate through the different mosaics
    for i = 1:numMosaics
        % Get the mosaic path
        mosaicPaths{i} = fullfile(baseMosaics(i).folder, baseMosaics(i).name);
        
        % Get the unique component of the mosaic name appended from the
        % hugin stitching process
        temp = split(baseMosaics(i).name, '.');
        temp = split(temp{1}, '_');
        
        % Initialise another layer of cell arrays for the output folders
        outputFolders{i} = cell(2,1);
        
        % Read in the mosiac
        fprintf('Reading mosaic:  %s\n', mosaicPaths{i});
        mosaic = imread(mosaicPaths{i});
        % Ignore the alpha channel to save on memory
        mosaic = mosaic(:,:,1:3);

        % Iterate through the two layer types output from Hugin
        for j = 1:1
            fprintf(' - Processing %s layers\n', layerTypes{j});

            % Create a subfolder path according to the layer types and the
            % mosaic being compared with
            outputFolders{i}{j} = fullfile(outputFolder, [sprintf('%s_',temp{4:end-1}),temp{end}], layerTypes{j});
            if ~exist(outputFolders{i}{j}, 'dir')
               mkdir(outputFolders{i}{j});
            end
                
            % pass through the correct set of layers being processed
            if j == 1
                curLayers = remappedLayers;
            end
            useLayers = cell(numLayers,1);
            for thisInd = 1:numLayers
                useLayers{thisInd} = fullfile(curLayers(thisInd).folder, curLayers(thisInd).name);
            end
                

            % Iterate through each layer and output the results to file
            parfor k = 1:numLayers
                [XYZ, outHull] = computeHuginDifferences(mosaic, useLayers{k});
                outStats = computeImageStats(XYZ);
                writeStatsToFile(outStats, outHull, fileNames{k}, outputFolders{i}{j})
                fprintf(' ... Written Image # %d\n', k);
            end

            % Compile and output the results from all patches in the mosaic
            outfile = fullfile(outputFolders{i}{j}, outputFileName);
            compileImageStats(outputFolders{i}{j}, outfile)
            
            % Compile the histogram values and output it to a mat file
            compileHistogramValues(outputFolders{i}{j})
        end
    end
end






        