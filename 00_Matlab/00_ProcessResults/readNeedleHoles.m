run('splitter_needles.m')


imagesname = fullfile('E:\Scratch\01_Data\00_RawImages\15_Normal_White', 'a0_nor.tif ');
im = imread(imagesname);
pos=[x_coords(:,1) y_coords(:,1)];
RGB = insertMarker(im,pos,'marker','circle','size',20);
h=figure;
imshow(RGB);
% close(h);

