function computeDiffsFromPhotometricOutput(inputFolder, formatType)
    inFolders = dir(inputFolder);
    
    wavelengths = {'NIR', 'Red', 'Green', 'Blue', 'NUV'};
    baseOutFolder = fullfile(inputFolder, '00_ImageDiffs');
    
    for i = length(inFolders):-1:1
        thisFile = fullfile(inFolders(i).folder, inFolders(i).name);
        if ~isfolder(thisFile)
            inFolders(i) = []; 
        elseif length(inFolders(i).name) <= 2
            inFolders(i) = [];
        elseif strcmp(thisFile, baseOutFolder)
            inFolders(i) = [];
            fprintf('Outfolder exists. Deleted.\n');
        end    
    end

    if ~exist(baseOutFolder, 'dir')
       mkdir(baseOutFolder)
    end
    
    numFolders = length(inFolders);
    
    for i = 1:numFolders-1
        inFiles1 = dir(fullfile(inFolders(i).folder, inFolders(i).name));
        inFiles1 = convertToCellArrayOfStrings(inFiles1);
        
        for j = i+1:numFolders
            outFolder = fullfile(baseOutFolder, ...
                                    [wavelengths{i}, '_', wavelengths{j}]);
            if ~exist(outFolder, 'dir')
               mkdir(outFolder)
            end
            
            inFiles2 = dir(fullfile(inFolders(j).folder, inFolders(j).name));
            inFiles2 = convertToCellArrayOfStrings(inFiles2);
            
            numImages = length(inFiles2);
            
            parfor k = 1:numImages
                createDiffImage(inFiles1{k}, inFiles2{k}, outFolder, i, j, formatType) 
            end
        end
    end
end