%% First get folder structure
% Overall directory where the different spectral bands are
baseFolder = 'E:\Scratch\temp';
allFilePaths = getAllFilePaths(baseFolder);
normFlag = true;
% Loop through each "project"
for i = 1:length(allFilePaths)
    mosaicTiffPaths = getMosaicTiffsPaths(allFilePaths{i}{1}{1}{1});
    % Loop through the mosaic
    for j = 1:length(allFilePaths{i})
        % Loop through the files
        temp = allFilePaths{i}{j}{1}{1};
        temp = split(temp, '\');
        outputFolder = fullfile(temp{1:end-2}, '\Results');
        for k = 1:length(allFilePaths{i}{j}{1})
            for m = 1:2:5
                imLayerPath = allFilePaths{i}{j}{m}{k};
                mosaicMaskPath = allFilePaths{i}{j}{m+1}{k};
                diffs = getDiffsWithMosaic(mosaicTiffPaths{j}, imLayerPath, mosaicMaskPath);
                temp = split(imLayerPath, '\');
                imName = temp(end);
                
                switch m
                    case 1
                        outputFolder = fullfile(temp{1:end-2}, '\Results', '\Full_Layer');
                    case 3
                        outputFolder = fullfile(temp{1:end-2}, '\Results', '\Overlap');
                    case 5
                        outputFolder = fullfile(temp{1:end-2}, '\Results', '\Center');
                end
                
                if ~isfolder(outputFolder)
                    mkdir(outputFolder);
                end
                
                outStats = rmsFromImage(diffs.vector(:,1), diffs.vector(:,2), ...
                    diffs.vector(:,3), imName(1:2), outputFolder, normFlag);
            end
        end
    end
end

% Number of combinations of observations and output types

function allFilePaths = getAllFilePaths(baseFolder)
    outputFolderNames = {
        '00_Full_Images', '01_Full_Masks', '02_Overlap_Images', ...
        '03_Overlap_Masks', '04_Center_Images', '05_Center_Masks'};
    numOutputs = length(outputFolderNames);
    subFolders = dir(baseFolder);
    subFolders = getSubFolders(subFolders);

    numProjects = length(subFolders);
    allFilePaths = cell(numProjects,1);
    for i = 1:numProjects
        theseMosaics = dir(fullfile(subFolders(i).folder, subFolders(i).name));
        theseMosaics = getSubFolders(theseMosaics);
        numMosaics = length(theseMosaics);
        allFilePaths{i} = cell(numMosaics,1);
        for j = 1:numMosaics
            allFilePaths{i}{j} = cell(numOutputs,1); 
            for k = 1:numOutputs
                
                fileSearchPath = fullfile(theseMosaics(j).folder, theseMosaics(j).name, outputFolderNames{k}, '*.png');
                files = dir(fileSearchPath);
                numFiles = length(files);
                outPutFiles = cell(numFiles,1);
                for ind = 1:numFiles
                   outPutFiles{ind} = fullfile(files(ind).folder, files(ind).name);
                end

                allFilePaths{i}{j}{k} = outPutFiles;
            end
        end
    end
end

function subFolders = clearReturnDirs(subFolders)
    for i = 2:-1:1
        if strcmp(subFolders(i).name, '.') || strcmp(subFolders(i).name, '..')
            subFolders(i) = [];
        end
    end
end

function folder = getSubFolders(folder)
    dirFlags = [folder.isdir];
    folder = folder(dirFlags);
    folder = clearReturnDirs(folder);
end

function mosaicTiffPaths = getMosaicTiffsPaths(imagePath)
    temp = split(imagePath, '\');
    temp = temp(1:end-3);
    files = dir(fullfile(temp{:}, '*tif'));
    numFiles = length(files);
    mosaicTiffPaths = cell(numFiles,1);
    for i = 1:length(files)
        mosaicTiffPaths{i} = fullfile(files(i).folder, files(i).name);
    end
end

function diffs = getDiffsWithMosaic(imMosaicPath, imLayerPath, mosaicMaskPath)
    diffs = [];
    % Read in images
    [imLayer, ~, alpha] = imread(imLayerPath);
    imMosaic = imread(imMosaicPath);
    
    % Get the alpha channel and use to create a mask of all pixels with
    % values
    alpha = logical(alpha);
    [layerRowInds, layerColInds] = find(alpha);
    alpha = alpha(:);
    
    % Read in masks and convert to logical index vector
    mosaicMask = imread(mosaicMaskPath); 
    mosaicMask = mosaicMask(:);

    
    layer_r = imLayer(:, : ,1); layer_r = layer_r(:); layer_r(alpha) = [];
    layer_g = imLayer(:, : ,2); layer_g = layer_g(:); layer_g(alpha) = [];
    layer_b = imLayer(:, : ,3); layer_b = layer_b(:); layer_b(alpha) = [];
    
    mosaic_r = imMosaic(:, : ,1); mosaic_r = mosaic_r(:); mosaic_r(mosaicMask) = [];
    mosaic_g = imMosaic(:, : ,2); mosaic_g = mosaic_g(:); mosaic_g(mosaicMask) = [];
    mosaic_b = imMosaic(:, : ,3); mosaic_b = mosaic_b(:); mosaic_b(mosaicMask) = [];
    
    diffs.vectors = [layer_r - mosaic_r, layer_g - mosaic_g, layer_b - mosaic_b];
    diffs.array = NaN(size(imLayer)); 
    diffs.array(layerRowInds,layerColInds,1) = diffs.vectors(:,1);
    diffs.array(layerRowInds,layerColInds,2) = diffs.vectors(:,2);
    diffs.array(layerRowInds,layerColInds,3) = diffs.vectors(:,3);
end

function outStats = rmsFromImage(X, Y, Z, imName, outputDirectory, normFlag)

    outStats = computeImageStats(X, Y, Z);
    
    outfile = fullfile(outputDirectory, [imName '.txt']);
    fid = fopen(outfile, 'w+');
    
    if normFlag
       % Output from normals
       fprintf(fid, '%6s | %6d | %6d | %6d | %6d | %6d | %6d | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %6d | %8d', ...
                imName, outStats.minX, outStats.minY, outStats.minZ, ...
                outStats.maxX, outStats.maxY, outStats.maxZ, outStats.stdX, ...
                outStats.stdY, outStats.stdZ, outStats.RMSE_X, outStats.RMSE_Y, ...
                outStats.RMSE_Z, outStats.maxMag, outStats.pixels);
    else
        % Output from normals
       fprintf(fid, '%6s | %6d | %6d | %6d | %6d | %6d | %6d | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %8d', ...
                imName, outStats.minX, outStats.minY, outStats.minZ, ...
                outStats.maxX, outStats.maxY, outStats.maxZ, outStats.stdX, ...
                outStats.stdY, outStats.stdZ, outStats.RMSE_X, outStats.RMSE_Y, ...
                outStats.RMSE_Z, outStats.pixels);
    end
    
    fclose(fid);
    
end

function imStats = computeImageStats(X, Y, Z)
    imStats = [];
    
    imStats.maxX = max(X);
    imStats.maxY = max(Y);
    imStats.maxZ = max(Z);

    imStats.minX = min(X);
    imStats.minY = min(Y);
    imStats.minZ = min(Z);

    imStats.RMSE_X = sqrt(mean((X.^2)));
    imStats.RMSE_Y = sqrt(mean((Y.^2)));
    imStats.RMSE_Z = sqrt(mean((Z.^2)));

    imStats.stdX = std(X);
    imStats.stdY = std(Y);
    imStats.stdZ = std(Z);

    imStats.magnitudes = sqrt((X + Y + Z).^2);
    imStats.pixels = length(X);

    % Compute max magnitude
    imStats.maxMag = max(imStats.magnitudes);
end

function writeHeader(fid, normFlag)
    if normFlag
        fprintf(fid, '%6s | %6s | %6s | %6s | %6s | %6s | %6s | %6s | %6s | %6s | %6s | %6s | %6s | %7s| %6s\n', ...
                'Name', 'Min X', 'Min Y', 'Min Z', 'Max X', 'Max Y', ...
                'Max Z', 'Std X', 'Std Y', 'Std Z', 'RMSE X', 'RMSE Y', ...
                'RMSE Z', 'Max Mag', 'Pixels');
        fprintf(fid, ['-------|', repmat('--------|', 1, 13), '---------\n']);
    else
        fprintf(fid, '%6s | %6s | %6s | %6s | %6s | %6s | %6s | %6s | %6s | %6s | %6s | %6s | %6s | %6s\n', ...
                'Name', 'Min X', 'Min Y', 'Min Z', 'Max X', 'Max Y', ...
                'Max Z', 'Std X', 'Std Y', 'Std Z', 'RMSE X', 'RMSE Y', ...
                'RMSE Z', 'Pixels');
        fprintf(fid, ['-------|', repmat('--------|', 1, 12), '---------\n']);
    end

end