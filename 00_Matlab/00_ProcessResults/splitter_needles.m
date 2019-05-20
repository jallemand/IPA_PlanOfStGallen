% read data
[~,data,~] = xlsread('E:\Scratch\temp\FeatureCoords\front_needles.xlsx') ;

% pre allocate coordinate matrices
[nb_rows,nb_columns] = size(data);
pic_names = data(1,:);
x_coords = zeros(nb_rows-1,nb_columns);
y_coords = x_coords;

% iterate through every cell
for i = 2:nb_rows
    for j = 1:nb_columns
        if ~isempty(data{i,j})
            values = split(data(i,j),',');
            x_coords(i-1,j) = str2double(values{1});
            y_coords(i-1,j) = str2double(values{2});
        end
    end
end
        

