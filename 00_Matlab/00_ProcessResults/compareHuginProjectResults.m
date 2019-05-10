function compareHuginProjectResults(baseFolder)
    lowerPath = lower(baseFolder);
    normFlag = contains(lowerPath, 'normal');
    whiteFlag = contains(lowerPath, 'white');
    
    fileNames = getFileNameOrder(whiteFlag);

    layerTypes = {'Remapped', 'Exposure'};
    baseMosaics = dir(fullfile(baseFolder, '*.tif'));
    outputFolder = fullfile(baseFolder, 'Output_Statistics');

    exposureLayersFolder = fullfile(baseFolder, 'Exposure_Layers');
    remappedLayersFolder = fullfile(baseFolder, 'Remapped_Layers');

    exposureLayers = dir(fullfile(exposureLayersFolder, '*.tif'));
    remappedLayers = dir(fullfile(remappedLayersFolder, '*.tif'));

    numMosaics = length(baseMosaics);
    numLayers = length(exposureLayers);
    
    outputFileName = 'compiledResults.txt';
    
    for i = 1:numLayers
        exposureLayers(i).fullPath = fullfile(exposureLayers(i).folder, exposureLayers(i).name);
        remappedLayers(i).fullPath = fullfile(exposureLayers(i).folder, exposureLayers(i).name);
    end
    
    % Pre-allocation
    mosaicPaths = cell(numMosaics,1);
    outputFolders = cell(numMosaics,1);
    
    for i = 1:numMosaics
        mosaicPaths{i} = fullfile(baseMosaics(i).folder, baseMosaics(i).name);
        temp = split(baseMosaics(i).name, '.');
        temp = split(temp{1}, '_');
        outputFolders{i} = cell(2,1);
        
        % Read in the mosiac
        fprintf('Reading mosaic:  %s\n', mosaicPaths{i});
        mosaic = imread(mosaicPaths{i});
        mosaic = mosaic(:,:,1:3);

        for j = 1:2
            fprintf(' - Processing %s layers\n', layerTypes{j});
            fprintf(' - Current temp: \n');
            temp
            outputFolders{i}{j} = fullfile(outputFolder, [sprintf('%s_',temp{4:end-1}),temp{end}], layerTypes{j});
            if ~exist(outputFolders{i}{j}, 'dir')
               mkdir(outputFolders{i}{j});
            else
                delete(fullfile(outputFolders{i}{j}, outputFileName));
            end
                
            % pass through the correct set of layers being processed
            if j == 1
                curLayers = exposureLayers;
            elseif j == 2
                curLayers = remappedLayers;
            end

            % Iterate through each layer
            parfor k = 1:numLayers
                layer = imread(curLayers(k).fullPath);
                
                % Get index values for all the pixels that are to be
                % compared of the two matrices
                [ind_i, ind_j] = find(layer(:,:,4));
                
                % Get the convex hull coordinates for showing where the
                % layers are w.r.t the mosaic
%                 K = convhull(ind_i, ind_j);
                
                % Get range indices for quicker sampling and processing of
                % the differences
                
                minVals = min([ind_i, ind_j]);
                maxVals = max([ind_i, ind_j]);
                
                partMosaic = mosaic(minVals(1):maxVals(1), minVals(2):maxVals(2), :);
                layer = layer(minVals(1):maxVals(1), minVals(2):maxVals(2), :);
                
                [inds] = find(layer(:,:,4));
                
                layer = int16(layer(:,:,1:3));
                partMosaic = int16(partMosaic(:,:,1:3));
                diffs = single(layer - partMosaic);
                
                X = diffs(:, :, 1); X = X(inds);
                Y = diffs(:, :, 2); Y = Y(inds);
                Z = diffs(:, :, 3); Z = Z(inds);

                rmsFromImage(X, Y, Z, fileNames{k}, outputFolders{i}{j}, normFlag);
            end
            
            % Get indices for min and max values in the layer (4th channel)
            outfile = fullfile(outputFolders{i}{j}, outputFileName);
            [fid, ~] = fopen(outfile, 'w');
            if fid == -1
                error('Cannot open file for writing: %s', msg);
            end
            writeHeader(fid, normFlag);
            
            T = dir(fullfile(outputFolders{i}{j}, '*.txt'));
            for thisInd = numel(T):-1:1
                tempFile = fullfile(T(thisInd).folder, T(thisInd).name);
                if ~strcmp(tempFile, outfile)
                    files{thisInd} = tempFile;
                end
            end
            
            numberOfFiles = length(files);
            for k = 1:numberOfFiles
                fprintf(fid, '%s\n', fileread(files{k}));
                delete(files{k});
            end
            
            fclose(fid);

        end
    end
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
    
    [imStats.histX, ~] = imhist(X);
    [imStats.histY, ~] = imhist(Y);
    [imStats.histZ, ~] = imhist(Z);

    imStats.magnitudes = sqrt((X + Y + Z).^2);
    imStats.pixels = length(X);

    % Compute max magnitude
    imStats.maxMag = max(imStats.magnitudes);
end

function outStats = rmsFromImage(X, Y, Z, imName, outputDirectory, normFlag)

    outStats = computeImageStats(X, Y, Z);
    
    outfile = fullfile(outputDirectory, [char(imName) '.txt']);
    fid = fopen(outfile, 'w');
    
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

function fileNames = getFileNameOrder(whiteFlag)
    letters = {'a', 'b', 'c', 'd', 'e', 'f'};
    if whiteFlag
        fileNames = cell(61,1);
        count = 1;
        for i = 1:6
            if i < 3
                for j = 1:10
                    fileNames{count} = sprintf('%1c%02d', letters{i}, j-1);
                    count = count + 1;
                end
            elseif i == 3
                for j = 0:10
                    fileNames{count} = sprintf('%1c%02d', letters{i}, j);
                    count = count + 1;
                end
            elseif i > 3
                for j = 1:10
                    fileNames{count} = sprintf('%1c%02d', letters{i}, j);
                    count = count + 1;
                end
            end
        end
    else
        fileNames = cell(60,1);
        for i = 1:6
            for j = 1:10
                fileNames{(i-1)*10 + j} = [letters{i}, char(string(j-1))];
            end
        end
    end
end
        