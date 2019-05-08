function [pCloud, filename, Z] = createPtCloudColour(normalPath, ambientPath, outputFolder, ...
                            pixelSpacing, normFlag)
% Read in image
    imAmb = imread(ambientPath);
    [~,name,~] = fileparts(normalPath);
    filename = [outputFolder, '\', name, '.ply'];
    
    [xyz, Z] = normal2xyz(normalPath, pixelSpacing)
    
    r = imAmb(:,:,1);
    g = imAmb(:,:,2);
    b = imAmb(:,:,3);
    rgb = [r(:), g(:), b(:)];
    
    if normFlag
        norm_x = imNorm(:,:,1);
        norm_y = imNorm(:,:,2);
        norm_z = imNorm(:,:,3);
        norm = [norm_x(:), norm_y(:), norm_z(:)];
        pCloud = pointCloud(pts, 'Color', rgb, 'Normal', norm);
    else
        pCloud = pointCloud(pts, 'Color', rgb);
    end
    
    
    Z = reshape(pts(:,3), height, width);
end