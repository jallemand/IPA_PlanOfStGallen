% Add Colour to mesh
[X,Y] = meshgrid(1:1644, 1:1096);
faces = delaunay(X,Y);
colVec = zeros(size(faces));
for i = 1:size(faces,1)
    colVec(i,:) = mean([colVec(faces(i,1),:);
                       colVec(faces(i,2),:); 
                       colVec(faces(i,3),:)]);
end