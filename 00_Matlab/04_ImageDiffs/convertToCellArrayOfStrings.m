function outFiles = convertToCellArrayOfStrings(files)
    numFiles = length(files);
    if numFiles ~= 62
        fprintf('%d', numFiles);
        error('Error. \nIncorrect number of images found in directory');
    else 
        outFiles = cell(60,1);
        count = 60;
        for i = numFiles:-1:1
            if length(files(i).name) <= 2
                files(i) = [];
            else
               outFiles{count} = fullfile(files(i).folder, files(i).name);
               count = count - 1;
            end
        end
    end
end