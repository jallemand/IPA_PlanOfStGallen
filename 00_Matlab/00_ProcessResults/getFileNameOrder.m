function fileNames = getFileNameOrder(whiteFlag)
%% Creates a cell array containing the names of the patches
    % Names of the rows
    letters = {'a', 'b', 'c', 'd', 'e', 'f'};
    
    % For the white light acquisition
    if whiteFlag
        fileNames = cell(61,1);
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
                fileNames{count} = sprintf('%1c%02d', letters{i}, j);
                count = count + 1;
            end
        end
    % For the multispectral acquisition, all rows are numbered 0-9
    else
        fileNames = cell(60,1);
        for i = 1:6
            for j = 1:10
                fileNames{(i-1)*10 + j} = [letters{i}, char(string(j-1))];
            end
        end
    end
end