function imStats = computeImageStats(dXYZ, flags)
    imStats = [];
    
    if flags.threeChannels
        imStats.maxX = max(dXYZ(:,1));
        imStats.maxY = max(dXYZ(:,2));
        imStats.maxZ = max(dXYZ(:,3));

        imStats.minX = min(dXYZ(:,1));
        imStats.minY = min(dXYZ(:,2));
        imStats.minZ = min(dXYZ(:,3));

        imStats.RMSE_X = sqrt(mean((dXYZ(:,1).^2)));
        imStats.RMSE_Y = sqrt(mean((dXYZ(:,2).^2)));
        imStats.RMSE_Z = sqrt(mean((dXYZ(:,3).^2)));

        imStats.stdX = std(dXYZ(:,1));
        imStats.stdY = std(dXYZ(:,2));
        imStats.stdZ = std(dXYZ(:,3));

        [imStats.histX, ~] = histcounts(dXYZ(:,1), -255.5:1:255.5);
        [imStats.histY, ~] = histcounts(dXYZ(:,2), -255.5:1:255.5);
        [imStats.histZ, ~] = histcounts(dXYZ(:,3), -255.5:1:255.5);

        imStats.magnitudes = sqrt((sum(dXYZ,2)).^2);
        imStats.pixels = length(dXYZ(:,1));

        % Compute max magnitude
        imStats.maxMag = max(imStats.magnitudes);
    else
        imStats.maxX = max(dXYZ(:,1));
        imStats.maxY = max(dXYZ(:,2));
        imStats.maxZ = max(dXYZ(:,3));

        imStats.minX = min(dXYZ(:,1));
        imStats.minY = min(dXYZ(:,2));
        imStats.minZ = min(dXYZ(:,3));

        imStats.RMSE_X = sqrt(mean((dXYZ(:,1).^2)));
        imStats.RMSE_Y = sqrt(mean((dXYZ(:,2).^2)));
        imStats.RMSE_Z = sqrt(mean((dXYZ(:,3).^2)));

        imStats.stdX = std(dXYZ(:,1));
        imStats.stdY = std(dXYZ(:,2));
        imStats.stdZ = std(dXYZ(:,3));

        [imStats.histX, ~] = histcounts(dXYZ(:,1), -255.5:1:255.5);
        [imStats.histY, ~] = histcounts(dXYZ(:,2), -255.5:1:255.5);
        [imStats.histZ, ~] = histcounts(dXYZ(:,3), -255.5:1:255.5);

        imStats.magnitudes = sqrt((sum(dXYZ,2)).^2);
        imStats.pixels = length(dXYZ(:,1));

        % Compute max magnitude
        imStats.maxMag = max(imStats.magnitudes);
    end
end