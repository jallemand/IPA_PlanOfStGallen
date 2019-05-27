% Read in mosaic

mosaicPath = 'C:\scratch\00_AllemandIPA\01_RawData\01_Ambient_White_final.tif';
convHullFolder = 'C:\scratch\00_AllemandIPA\01_RawData\02_ConvexHulls\00_Hugin\01_Ambient_White';
im = imread(mosaicPath);

conv_hull_files = cell(61,1);
temp = dir(fullfile(conv_hull_folder, '*.mat'));

for i = 1:61
conv_hull_files{i} = fullfile(temp(i).folder, temp(i).name);
end

for i = 1:61
temp = load(conv_hull_files{i});
if i < 11
thisColour = tempColour(1,:);
elseif i < 21
thisColour = tempColour(34,:);
elseif i < 32
thisColour = tempColour(12,:);
elseif i < 42
thisColour = tempColour(45,:);
elseif i < 52
thisColour = tempColour(23,:);
else
thisColour = tempColour(56,:);
end
plot(temp.outHull(:,2), temp.outHull(:,1), 'LineWidth', 2, 'Color', thisColour);
end