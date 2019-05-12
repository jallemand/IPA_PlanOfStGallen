function writeStatsToFile(outStats, outHull, imName, outputDirectory)

    % Create the output file paths
    outStatsFile = fullfile(outputDirectory, ['stats_', imName, '.csv']);
    outHistogramFile = fullfile(outputDirectory, ['histogram_', imName, '.csv']);
    outConvexHullFile = fullfile(outputDirectory, ['convHull_', imName, '.csv']);
    
    % Convert statistics to matrix to output
    outStatsMatrix = [outStats.minX, outStats.minY, outStats.minZ, ...
                outStats.maxX, outStats.maxY, outStats.maxZ, outStats.stdX, ...
                outStats.stdY, outStats.stdZ, outStats.RMSE_X, outStats.RMSE_Y, ...
                outStats.RMSE_Z, outStats.pixels];
            
    % Convert histograms into matrix to output
    outHistogramMatrix = [outStats.histX; outStats.histY; outStats.histZ];
    
    if contains(version, 'R2019a')
        % Output the stats
        writematrix(outStatsMatrix, outStatsFile);

        % Output the histograms
        writematrix(outHistogramMatrix, outHistogramFile);

        % Output the convex hull coordinates
        writematrix(outHull, outConvexHullFile);
    else
        % Output the stats
        csvwrite(outStatsFile, outStatsMatrix);

        % Output the histograms
        csvwrite(outHistogramFile, outHistogramMatrix);

        % Output the convex hull coordinates
        csvwrite(outConvexHullFile, outHull);
    end
    
end