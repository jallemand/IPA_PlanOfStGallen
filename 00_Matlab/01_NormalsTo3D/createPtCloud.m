function [pCloud, filename, Z] = createPtCloud(normalPath, outputFolder, ...
                            pixelSpacing, normFlag)

% Read in image
    [~,name,~] = fileparts(normalPath);
    filename = [outputFolder, '\', name, '.ply'];
    imNorm = imread(normalPath);
    
    % Get dimensions for image 
    [height, width, ~] = size(imNorm);
    
    x = reshape(imNorm, [width*height, 3]);
    minIm = min(x, [], 1);
    for i = 1:2
       imNorm(:,:,i) = imNorm(:,:,i) - minIm(i); 
    end
    
    % Get vector defining the space the image covers (assuming equal pixel
    % spacing.
    x = linspace(0,width-1, width)  .* pixelSpacing;
    y = linspace(0,height-1, height) .* pixelSpacing;
    
    % Generate the heightmap from integration of the normals
    Z = g2s(double(imNorm(:,:,1))/255, double(imNorm(:,:,2))/255, x', y' );

    % Convert from location in matrix to tuple cartesian coordinates
    [I, J] = ind2sub([height,width], 1:(height*width));
    pts = [(I'.* pixelSpacing), (J'.* pixelSpacing), (Z(:))];
    
    % As the heights came out on some kind of angle from the algorithm
    % used, this has to be fit, thus a plane function is fitted to the data
    % and the resulting height output corresponds to the difference to the
    % plane.
    B = [ones(width*height,1), pts(:,1:2)] \ pts(:,3);
    temp_z = pts(:,3) - B(1) - (B(2).* pts(:,1)) - (B(3) .* pts(:,2));
    pts(:,3) = temp_z .* pixelSpacing;
    
    if normFlag
        norm_x = imNorm(:,:,1);
        norm_y = imNorm(:,:,2);
        norm_z = imNorm(:,:,3);
        norm = [norm_x(:), norm_y(:), norm_z(:)];
        pCloud = pointCloud(pts, 'Normal', norm);
    else
        pCloud = pointCloud(pts);
    end
    
    Z = reshape(pts(:,3), height, width);
end