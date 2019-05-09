function processAllHuginProjects(resultsFolder)
    inFolders = dir(resultsFolder);
    for i = length(inFolders):-1:1
        thisFile = fullfile(inFolders(i).folder, inFolders(i).name);
        if ~isfolder(thisFile)
            inFolders(i) = []; 
        elseif length(inFolders(i).name) <= 2
            inFolders(i) = [];
        end    
    end
    
    numResults = length(inFolders);
    resultFolders = cell(numResults,1);
    
    
    for i = 1:length(inFolders)
        resultFolders{i} = fullfile(inFolders(i).folder, inFolders(i).name);
        fprintf('Processing: %s\n...\n', resultFolders{i});
        
        compareHuginProjectResults(resultFolders{i});
        fprintf('Complete!\n\n');
    end
end