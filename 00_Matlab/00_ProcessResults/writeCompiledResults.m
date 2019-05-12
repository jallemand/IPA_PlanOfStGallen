function writeCompiledResults(outputFile, outStats, meanStats, patchNames)
    % Create the file
    [fid, ~] = fopen(outputFile, 'w');
    if fid == -1
        error('Cannot open file for writing: %s', msg);
    end

    % Print the file header
    fprintf(fid, '%6s | %6s | %6s | %6s | %6s | %6s | %6s | %6s | %6s | %6s | %6s | %6s | %6s | %6s\n', ...
            'Name', 'Min X', 'Min Y', 'Min Z', 'Max X', 'Max Y', ...
            'Max Z', 'Std X', 'Std Y', 'Std Z', 'RMSE X', 'RMSE Y', ...
            'RMSE Z', 'Pixels');
    fprintf(fid, ['-------|', repmat('--------|', 1, 12), '---------\n']);
    
    % Output results for each file
    for i = 1:length(patchNames)
        fprintf(fid, '%6s | %6d | %6d | %6d | %6d | %6d | %6d | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %8d\n', ...
            patchNames{i}, outStats(i,:));
    end

    % Output the average for each field for all the patches
    fprintf(fid, ['-------|', repmat('--------|', 1, 12), '---------\n']);
    fprintf(fid, 'Average| %6d | %6d | %6d | %6d | %6d | %6d | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %8d', ...
            meanStats);
        
    % Close the file
    fclose(fid);
end