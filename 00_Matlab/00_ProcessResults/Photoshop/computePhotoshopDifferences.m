function [XYZ, outHull] = computePhotoshopDifferences(mosaicIm, layerPath, maskPath)
    %% Read in the current layer and mask
    [layer, ~, layerAlpha] = imread(layerPath);
    mask = ~imread(maskPath);
    [mask_X, mask_Y] = find(mask);
    [alpha_X, alpha_Y] = find(layerAlpha);
    
    minVals = [min(mask_X), min(mask_Y); min(alpha_X), min(alpha_Y)];
    maxVals = [max(mask_X), max(mask_Y); max(alpha_X), max(alpha_Y)];
    [rows, cols] = size(mask);
    
    % Ensure the min and max values match
    [minVals, maxVals] = ensureAreasMatch(minVals, maxVals, rows, cols);
    
    % Get index values for all the pixels that are to be
    % compared of the two matrices
    [ind_i, ind_j] = find(layerAlpha);

    % Get the convex hull coordinates for showing where the
    % layers are w.r.t the mosaic
    outHull = convhull(ind_i, ind_j);
    convX = ind_i(outHull);
    convY = ind_j(outHull);
    outHull = [convX, convY];

    % Get range indices for quicker sampling and processing of

    % Crop the mosaic and layer to a rectangular array containing all the
    % layer pixels
%     fprintf('minX: %d      minY: %d\n', minVals(1,1), minVals(1,2));
%     fprintf('maxX: %d      maxY: %d\n', maxVals(1,1), maxVals(1,2));
    partMosaic = mosaicIm(minVals(1,1):maxVals(1,1), minVals(1,2):maxVals(1,2), :);
    
    % Get indices for the specific pixel locations in vector format
    [inds] = find(layerAlpha);

    % Convert the colour components into 16 bit colours so that the
    % differences can be computed.
    layer = int16(layer);
    partMosaic = int16(partMosaic);
    diffs = single(layer) - single(partMosaic);
    
    % Initialise the output array
    XYZ = zeros(length(inds), 3);
    
    % Get the differences of the images
    X = diffs(:, :, 1); X = X(:);
    Y = diffs(:, :, 2); Y = Y(:);
    Z = diffs(:, :, 3); Z = Z(:);

    % Convert to vector format and put in output array
    XYZ(:,1) = X(inds);
    XYZ(:,2) = Y(inds);
    XYZ(:,3) = Z(inds);
    
    maxInds = (abs(XYZ(:,1)) == 255) & (abs(XYZ(:,2)) == 255) & (abs(XYZ(:,3)) == 255);
    XYZ(maxInds,:) = [];
end


function [minVals, maxVals] = ensureAreasMatch(minVals, maxVals, rows, cols)
    ranges = maxVals - minVals;
    diffRanges = ranges(2,:) - ranges(1,:);
    for i = 1:2
        if diffRanges(i) ~= 0
            if mod(diffRanges(i), 2) == 0
                minVals(1,i) = minVals(1,i) - diffRanges(i)/2;
                maxVals(1,i) = maxVals(1,i) + diffRanges(i)/2;
                

            else
                minVals(1,i) = minVals(1,i) - ceil(diffRanges(i)/2);
                maxVals(1,i) = maxVals(1,i) + floor(diffRanges(i)/2);

                if (minVals(1,i) < 1)
                    minVals(1,i) = minVals(1,i) - floor(diffRanges(i)/2) + ceil(diffRanges(i)/2);
                    maxVals(1,i) = maxVals(1,i) + ceil(diffRanges(i)/2) - floor(diffRanges(i)/2);
                end
            end
            if i == 1
                while maxVals(1,i) > rows
                    maxVals(1,i) = maxVals(1,i)-1;
                    minVals(1,i) = minVals(1,i)-1;
                end    
                
                while minVals(1,i) < 1
                    maxVals(1,i) = maxVals(1,i)+1;
                    minVals(1,i) = minVals(1,i)+1;
                end    
                
            elseif i == 2
                while maxVals(1,i) > cols
                    maxVals(1,i) = maxVals(1,i)-1;
                    minVals(1,i) = minVals(1,i)-1;
                end   
                
                while minVals(1,i) < 1
                    maxVals(1,i) = maxVals(1,i)+1;
                    minVals(1,i) = minVals(1,i)+1;
                end   
            end
        end
    end
    ranges = maxVals - minVals;
    diffRanges = ranges(2,:) - ranges(1,:);
%     if all(~diffRanges)
%         fprintf('Arrays successfully converted to the same size\n');
%     else
%         error('Different size image arrays\n')
%     end
end


