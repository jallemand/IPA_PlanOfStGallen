function processAllHuginProjects(resultsFolder)
%% This function reads in all the different hugin projects stored in the results folder.

    % Get the current list of folders
    inFolders = dir(resultsFolder);
    
    % Iterate through the result of dir to remove items that aren't folders
    % or the return folders . and ..
    for i = length(inFolders):-1:1
        thisFile = fullfile(inFolders(i).folder, inFolders(i).name);
        if ~isfolder(thisFile)
            inFolders(i) = []; 
        elseif length(inFolders(i).name) <= 2
            inFolders(i) = [];
        end    
    end

    % Iterate through the folders
    for i = 1:length(inFolders)
        % Create the full folder path
        thisFolder = fullfile(inFolders(i).folder, inFolders(i).name);
        fprintf('Processing: %s\n...\n', thisFolder);
        
        % Start generating the results for this folder (wavelength and
        % output type)
        compareHuginProjectResults(thisFolder);
        fprintf('Complete!\n\n');
    end
end