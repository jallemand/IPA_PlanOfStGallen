function writeCompiledResults(outputFile, outStats, meanStats, patchNames, flags)
    % Create the file
    [fid, ~] = fopen(outputFile, 'w');
    if fid == -1
        error('Cannot open file for writing: %s', msg);
    end

    if flags.threeChannels
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
    else
        fprintf(fid, '%6s | %6s | %6s | %6s | %6s | %6s\n', ...
                'Name', 'Min I', 'Max I', 'Std I', 'RMSE I', 'Pixels');
        fprintf(fid, ['-------|', repmat('--------|', 1, 4), '---------\n']);

        % Output results for each file
        for i = 1:length(patchNames)
            fprintf(fid, '%6s | %6d | %6d | %6.2f | %6.2f | %8d\n', ...
                patchNames{i}, outStats(i,:));
        end

        % Output the average for each field for all the patches
        fprintf(fid, ['-------|', repmat('--------|', 1, 4), '---------\n']);
        fprintf(fid, 'Average| %6d | %6d | %6.2f | %6.2f | %8d', ...
                meanStats);
    end
        
    % Close the file
    fclose(fid);
end