function imStats = computeImageStats(XYZ)
    imStats = [];

    imStats.maxX = max(XYZ(:,1));
    imStats.maxY = max(XYZ(:,2));
    imStats.maxZ = max(XYZ(:,3));

    imStats.minX = min(XYZ(:,1));
    imStats.minY = min(XYZ(:,2));
    imStats.minZ = min(XYZ(:,3));

    imStats.RMSE_X = sqrt(mean((XYZ(:,1).^2)));
    imStats.RMSE_Y = sqrt(mean((XYZ(:,2).^2)));
    imStats.RMSE_Z = sqrt(mean((XYZ(:,3).^2)));

    imStats.stdX = std(XYZ(:,1));
    imStats.stdY = std(XYZ(:,2));
    imStats.stdZ = std(XYZ(:,3));
    
    [imStats.histX, ~] = histcounts(XYZ(:,1), -255.5:1:255.5);
    [imStats.histY, ~] = histcounts(XYZ(:,2), -255.5:1:255.5);
    [imStats.histZ, ~] = histcounts(XYZ(:,3), -255.5:1:255.5);

    imStats.magnitudes = sqrt((sum(XYZ,2)).^2);
    imStats.pixels = length(XYZ(:,1));

    % Compute max magnitude
    imStats.maxMag = max(imStats.magnitudes);
end