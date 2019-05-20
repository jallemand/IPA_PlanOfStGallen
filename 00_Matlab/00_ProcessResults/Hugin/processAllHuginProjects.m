function processAllHuginProjects(projectFolders, resultsFolder, rawIms)
%% This function reads in all the different hugin projects stored in the results folder.

    % Get the current list of folders
    inFolders = dir(projectFolders);
    inRawImageFolders = dir(rawIms);
    
    % Iterate through the result of dir to remove items that aren't folders
    % or the return folders . and ..
    for i = length(inFolders):-1:1
        thisFolder = fullfile(inFolders(i).folder, inFolders(i).name);
        if ~isfolder(thisFolder)
            inFolders(i) = []; 
        elseif length(inFolders(i).name) <= 2
            inFolders(i) = [];
        end    
    end
    
    % Get the raw images folder names
    for i = length(inRawImageFolders):-1:1
        thisFile = fullfile(inRawImageFolders(i).folder, inRawImageFolders(i).name);
        if ~isfolder(thisFile)
            inRawImageFolders(i) = []; 
        elseif length(inRawImageFolders(i).name) <= 2
            inRawImageFolders(i) = [];
        end    
    end

    % Iterate through the folders
    for thisInd = 2:length(inFolders)
        % Create the full folder path
        thisFolder = fullfile(inFolders(thisInd).folder, inFolders(thisInd).name);
        fprintf('Processing: %s\n...\n', thisFolder);
        
        % Start generating the results for this folder (wavelength and
        % output type)
        lowerPath = lower(thisFolder);
        
        % Get general project parameters
        project = getProjectParams(lowerPath);
        flags = getProjectFlags(project);
        resultPaths = generateResultPaths(project, resultsFolder, i);
        patchNames = getFileNameOrder(project);
       
        rawDataImagePaths = getRawImagePaths(inRawImageFolders, project);

        % Types of patch layers to perform comparison on
        layerType = 'Remapped';

        % Get all the mosaics outputs from hugin and how many there are
        baseMosaics = dir(fullfile(thisFolder, '*.tif'));
        project.numMosaics = length(baseMosaics);

        % Create a folder for the output statistics

        % Get path for the remapped layers
        remappedLayersFolder = fullfile(thisFolder, 'Remapped_Layers');

        % Get all the layer paths
        remappedLayers = dir(fullfile(remappedLayersFolder, '*.tif'));

        % Get the integer value for the number of layers
        project.numLayers = length(remappedLayers);

        % Create the fullpath names for the layers to be compared
        for i = 1:project.numLayers
            remappedLayers(i).fullPath = fullfile(remappedLayers(i).folder, remappedLayers(i).name);
        end

        % Get the mosaic path
        mosaicPath = fullfile(baseMosaics(1).folder, baseMosaics(1).name);

        % Read in the mosiac
        fprintf('Reading mosaic:  %s\n', mosaicPath);
        mosaic = imread(mosaicPath);
        % Ignore the alpha channel to save on memory
        mosaic = mosaic(:,:,1:3);

        fprintf(' - Processing %s layers\n', layerType);
        % Create a subfolder path according to the layer types and the
        % mosaic being compared with

        % pass through the correct set of layers being processed
        curLayers = remappedLayers;
        useLayers = cell(project.numLayers,1);
        for l = 1:project.numLayers
            useLayers{l} = fullfile(curLayers(l).folder, curLayers(l).name);
        end

        % Iterate through each layer and output the results to file
        for k = 1:project.numLayers
            fprintf('Writing homography\n')
            saveHomography(rawDataImagePaths{k}, useLayers{k}, patchNames{k}, resultPaths.homographies)
            fprintf('Computing difference\n')
            [XYZ, outHull] = computeHuginDifferences(mosaic, useLayers{k});
            fprintf('Computing statistics\n')
            outStats = computeImageStats(XYZ, flags);
            fprintf('Writing statistics to file\n')
            writeStatsToFile(outStats, outHull, patchNames{k}, resultPaths, flags)
            fprintf(' ... Written Image # %d\n', k);
        end

        % Compile and output the results from all patches in the mosaic
        compileImageStats(resultPaths.mosaicDiffs, flags)

        % Compile the histogram values and output it to a mat file
        compileHistogramValues(resultPaths.histograms, flags)

        fprintf('Complete!\n\n');
    end
end

function project = getProjectParams(lowerPath)
    project = [];

    if contains(lowerPath, 'albedo')
        project.format = 'Albedo';
    elseif contains(lowerPath, 'ambient')
        project.format = 'Ambient';
    elseif contains(lowerPath, 'normal')
        project.format = 'Normal';
    end
    
    if contains(lowerPath, 'white')
        project.wavelength = 'White';
    elseif contains(lowerPath, 'nir')
        project.wavelength = 'NIR';
    elseif contains(lowerPath, 'red')
        project.wavelength = 'Red';
    elseif contains(lowerPath, 'green')
        project.wavelength = 'Green';
    elseif contains(lowerPath, 'blue')
        project.wavelength = 'Blue';
    elseif contains(lowerPath, 'nuv')
        project.wavelength = 'NUV';
    else
        error('Problem getting the wavelength from the passed project folder');
    end
end

function flags = getProjectFlags(project)
    flags = [];

    if strcmp(project.format, 'Normal')
        flags.normal = true;
    else
        flags.normal = false;
    end

    % Get a logical flags
    if strcmp(project.wavelength, 'White')
        flags.whiteLight = true;
    else
        flags.whiteLight = false;
    end
    
    flags.threeChannels = flags.whiteLight | flags.normal;
end

function resultPaths = generateResultPaths(project, resultsFolder, i)
resultPaths = [];

baseTemp = fullfile(resultsFolder, '00_Homographies');
createFolder(baseTemp);

baseTemp = fullfile(baseTemp, '00_Hugin');
createFolder(baseTemp);

temp = [sprintf('%02d', i), '_', project.format, '_', project.wavelength];
resultPaths.homographies = fullfile(baseTemp, temp);
createFolder(resultPaths.homographies);

baseTemp = fullfile(resultsFolder, '01_MosaicDiffs', '00_Hugin');
resultPaths.mosaicDiffs = fullfile(baseTemp, temp);
createFolder(resultPaths.mosaicDiffs);

baseTemp = fullfile(resultsFolder, '02_ConvexHulls', '00_Hugin');
resultPaths.convexHulls = fullfile(baseTemp, temp);
createFolder(resultPaths.convexHulls);

baseTemp = fullfile(resultsFolder, '03_DiffHistograms', '00_Hugin');
resultPaths.histograms = fullfile(baseTemp, temp);
createFolder(resultPaths.histograms);

end

function createFolder(folder)
    if ~exist(folder, 'dir')
       mkdir(folder);
    end
end

function patchNames = getFileNameOrder(project)
%% Creates a cell array containing the names of the patches
    % Names of the rows
    letters = {'a', 'b', 'c', 'd', 'e', 'f'};
    
    switch project.format
        case 'Albedo'
            suffix1 = '_alb';
        case 'Ambient'
            suffix1 = '_amb';
        case 'Normal'
            suffix1 = '_nor';
    end
    
    switch project.wavelength
        case 'White'
            suffix2 = '';
        case 'NIR'
            suffix2 = '0';
        case 'Red'
            suffix2 = '1';
        case 'Green'
            suffix2 = '2';
        case 'Blue'
            suffix2 = '3';
        case 'NUV'
            suffix2 = '4';
    end
    
    % For the white light acquisition
    if strcmp(project.wavelength, 'White')
        patchNames = cell(61,1);
        count = 1;
        
        % Loop through the columns corresponding to the letters
        for i = 1:6
            % 'a' and 'b' are numbered 0-9, 'c' 0-10; 'd', 'e' and 'f' are
            % numbered 1-10
            if i < 3
                startNum = 0;
                endNum = 9;
            elseif i == 3
                startNum = 0;
                endNum = 10;
            elseif i > 3
                startNum = 1;
                endNum = 10;
            end
            for j = startNum:endNum
                patchNames{count} = [sprintf('%1c%02d', letters{i}, j), suffix1, suffix2];
                count = count + 1;
            end
        end
    % For the multispectral acquisition, all rows are numbered 0-9
    else
        patchNames = cell(60,1);
        
        for i = 1:6
            for j = 1:10
                patchNames{(i-1)*10 + j} = [letters{i}, char(string(j-1)), suffix1, suffix2];
            end
        end
    end
end

function rawDataImagePaths = getRawImagePaths(inRawImageFolders, project)
    if strcmp(project.format, 'Normal')
        fileType = '*.tif';
    else
        fileType = '*.png';
    end
    
    for i = 1:length(inRawImageFolders)
       thisFolder = lower(fullfile(inRawImageFolders(i).folder, inRawImageFolders(i).name));
       
        if contains(thisFolder, lower(project.wavelength)) && contains(thisFolder, lower(project.format))
            theseFiles = dir(fullfile(thisFolder, fileType));
            numLayers = length(theseFiles);
            rawDataImagePaths = cell(numLayers,1);

            for j = 1:numLayers
                rawDataImagePaths{j} = fullfile(theseFiles(j).folder, theseFiles(j).name);
            end
            break
        end
    end
end
