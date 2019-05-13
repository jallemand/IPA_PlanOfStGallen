function writeStatsToFile(outStats, outHull, imName, outputDirectory, flags)

    % Create the output file paths
    outStatsFile = fullfile(outputDirectory, ['stats_', imName, '.mat']);
    outHistogramFile = fullfile(outputDirectory, ['histogram_', imName, '.mat']);
    outConvexHullFile = fullfile(outputDirectory, ['convHull_', imName, '.mat']);
    
    % Convert statistics to matrix to output
    if flags.threeChannels
        outStatsMatrix = [outStats.minX, outStats.minY, outStats.minZ, ...
                    outStats.maxX, outStats.maxY, outStats.maxZ, outStats.stdX, ...
                    outStats.stdY, outStats.stdZ, outStats.RMSE_X, outStats.RMSE_Y, ...
                    outStats.RMSE_Z, outStats.pixels];

        % Convert histograms into matrix to output
        outHistogramMatrix = [outStats.histX; outStats.histY; outStats.histZ];
    else
        outStatsMatrix = [outStats.minX, outStats.maxX, outStats.stdX, ...
                    outStats.RMSE_X, outStats.pixels];

        % Convert histograms into matrix to output
        outHistogramMatrix = outStats.histX;
    end

    % Output the stats
    save(outStatsFile, 'outStatsMatrix');

    % Output the histograms
    save(outHistogramFile, 'outHistogramMatrix');

    % Output the convex hull coordinates
    save(outConvexHullFile, 'outHull');

    
end