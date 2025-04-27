data = csvread('xy.csv');
x = data(:, 1);
y = data(:, 2);
bandwidth = 4; 
[X, Y] = meshgrid(min(x):0.1:max(x), min(y):0.1:max(y));
Z = zeros(size(X));
for j = 1:length(x)
    Z = Z + exp(-((X - x(j)).^2 + (Y - y(j)).^2) / (2 * bandwidth^2));
end

num_points = length(x); 
Z = Z / num_points; 

figure;
contourf(X, Y, Z, 'LineStyle', 'none');
hold on; 
scatter(x, y, 30, 'w', 'o', 'LineWidth', 2, 'MarkerEdgeColor', [0.3 0.3 0.3]);
colormap(jet); 
colorbar; 
set(gca,'FontSize',25, 'FontWeight', 'bold'); 
