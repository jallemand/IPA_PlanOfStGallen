function produceMesh(path, outputFolder, ...
                            pixelSpacing, colourImagesFlag, colourVector)
    % Read in image
    [~,name,~] = fileparts(path);
    filename = [outputFolder, '\', name, '.stl'];
    im = imread(path);
    
    % Get dimensions for image 
    [height, width, ~] = size(im);
    
    
    x = reshape(im, [width*height, 3]);
    minIm = min(x, [], 1);
    for i = 1:3
       im(:,:,i) = im(:,:,i) - minIm(i); 
    end
    
    % Get vector defining the space the image covers (assuming equal pixel
    % spacing.
    x = linspace(0,width-1, width)  .* pixelSpacing;
    y = linspace(0,height-1, height) .* pixelSpacing;
    
    % Generate the heightmap from integration of the normals
    [X, Y] = meshgrid(x, y);
    Z = g2s(double(im(:,:,1))/255, double(im(:,:,2))/255, x', y' );
    
    
    
    % This part needs work
    if colourImagesFlag
        % Create grids based on these spacings

        % Generate the mesh faces
        faces = delaunay(X,Y);
        
        % Pre-allocate array for 3 vectors representing each face's colour
        colourFaces = zeros(size(faces));

        % Get the average colour from the vertex colours
        for i = 1:size(faces,1)
            colourFaces(i,:) = mean([colourVector(faces(i,1),:);
                                      colourVector(faces(i,2),:);
                                      colourVector(faces(i,3),:);]);
        end
    else
        stlwrite(filename, X, Y, Z)
    end
end