function [dXYZ, outHull] = computeHuginDifferences(mosaicIm, layerPath)
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
    
    [inds] = find(layer(:,:,4));
    
    partMosaic = int16(partMosaic(:,:,1:3));
    layer = int16(layer(:,:,1:3));

    
    partMosaic_x = partMosaic(:,:,1); partMosaic_x = partMosaic_x(:);
    partMosaic_y = partMosaic(:,:,2); partMosaic_y = partMosaic_y(:);
    partMosaic_z = partMosaic(:,:,3); partMosaic_z = partMosaic_z(:);
    partMosaic = [partMosaic_x(inds), partMosaic_y(inds), partMosaic_z(inds)];
    clear partMosaic_x partMosaic_y partMosaic_z
    
    layer_x = layer(:,:,1); layer_x = layer_x(:);
    layer_y = layer(:,:,2); layer_y = layer_y(:);
    layer_z = layer(:,:,3); layer_z = layer_z(:);
    layer = [layer_x(inds), layer_y(inds), layer_z(inds)];
    clear layer_x layer_y layer_z
    
    dXYZ = single(layer) - single(partMosaic);

end