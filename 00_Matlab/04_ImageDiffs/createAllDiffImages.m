%% Script to generate diff images
baseFolder = 'C:\scratch\00_Allemand_IPA\Data\diffs\00_Data';
formatType = {'_nor_', '_alb_','_amb_'};
inFolders = dir(baseFolder);
numFolders = length(inFolders);
inPaths = cell(3,1);

for i = numFolders:-1:1
    if ~isfolder(fullfile(inFolders(i).folder, inFolders(i).name))
        inFolders(i) = []; 
    elseif length(inFolders(i).name) <= 2
        inFolders(i) = [];
    end    
end

for i=3:-1:1
    inPaths{i} = fullfile(inFolders(i).folder, inFolders(i).name);
end

for i=1:3
    computeDiffsFromPhotometricOutput(inPaths{i}, formatType{i})
end



