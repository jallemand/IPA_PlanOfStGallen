function compareHuginProjectResults(baseFolder)
    baseMosaics = dir(fullfile(baseFolder, '*.tif'));
    outputFolder = fullfile(baseFolder, 'Output_Statistics');

    exposureLayersFolder = fullfile(baseFolder, 'Exposure_Layers');
    remappedLayersFolder = fullfile(baseFolder, 'Remapped_Layers');

    exposureLayers = dir(fullfile(exposureLayersFolder, '*.tif'));
    remappedLayers = dir(fullfile(remappedLayersFolder, '*.tif'));

    numMosaics = length(baseMosaics);
    numLayers = length(exposureLayers);
    
    % Pre-allocation
    mosaicPaths = cell(numMosaics,1);
    outputFolders = cell(numMosaics,1);
    
    for i = 1:numMosaics
        mosaicPaths{i} = fullfile(baseMosaics(i).folder, baseMosaics(i).name);
        temp = split(baseMosaics(i).name, '.');
        temp = split(temp{1}, '_');
        outputFolders{i} = cell(2,1);
        outputFolders{i}{1} = fullfile(outputFolder, [sprintf('%s_',temp{4:end-1}),temp{end}], 'Remapped');
        outputFolders{i}{2} = fullfile(outputFolder, [sprintf('%s_',temp{4:end-1}),temp{end}], 'Exposure');
        
        if ~exist(outputFolders{i}, 'dir')
           mkdir(outputFolders{i})
        end
        
        
    end
    
end