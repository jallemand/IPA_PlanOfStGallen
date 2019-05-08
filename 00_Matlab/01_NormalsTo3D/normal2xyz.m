function [xyz, Z] = normal2xyz(imNorm, pixelSpacing)
    
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


    [I, J] = ind2sub([height,width], 1:(height*width));
    xyz = [(I'.* pixelSpacing), (J'.* pixelSpacing), (Z(:))];
    
    B = [ones(width*height,1), xyz(:,1:2)] \ xyz(:,3);
    temp_z = xyz(:,3) - B(1) - (B(2).* xyz(:,1)) - (B(3) .* xyz(:,2));
    
    xyz(:,3) = temp_z .* pixelSpacing;
    Z = reshape(xyz(:,3), height, width);
    
    Z = (Z - min(Z(:))) * 200;
    Z = uint16(Z);
end