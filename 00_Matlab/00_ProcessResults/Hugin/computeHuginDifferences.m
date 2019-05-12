function [XYZ, outHull] = computeHuginDifferences(mosaicIm, layerPath)
    % Read in the current layer
    layer = imread(layerPath);

    % Get index values for all the pixels that are to be
    % compared of the two matrices
    [ind_i, ind_j] = find(layer(:,:,4));

    % Get the convex hull coordinates for showing where the
    % layers are w.r.t the mosaic
    outHull = convhull(ind_i, ind_j);
    convX = ind_i(outHull);
    convY = ind_j(outHull);
    outHull = [convX, convY];

    % Get range indices for quicker sampling and processing of
    % the differences
    minVals = min([ind_i, ind_j]);
    maxVals = max([ind_i, ind_j]);

    % Crop the mosaic and layer to a rectangular array containing all the
    % layer pixels
    partMosaic = mosaicIm(minVals(1):maxVals(1), minVals(2):maxVals(2), :);
    layer = layer(minVals(1):maxVals(1), minVals(2):maxVals(2), :);

    % Get indices for the specific pixel locations in vector format
    [inds] = find(layer(:,:,4));

    % Convert the colour components into 16 bit colours so that the
    % differences can be computed.
    layer = int16(layer(:,:,1:3));
    partMosaic = int16(partMosaic(:,:,1:3));
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
end