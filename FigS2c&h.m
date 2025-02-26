data = xxxx;%,1 group;,2:4 mni
groups = unique(data(:,1));
numGroups = length(groups);
distMatrix = zeros(numGroups, numGroups);
withinDistances = []; 
betweenDistances = []; 

for i = 1:numGroups
    group1 = data(data(:,1) == groups(i), 2:4);
    for j = i:numGroups
        group2 = data(data(:,1) == groups(j), 2:4);
        if i == j
            distances = pdist(group1, 'euclidean');
            withinDistances = [withinDistances; distances(:)];
        else
            distances = pdist2(group1, group2, 'euclidean');
            betweenDistances = [betweenDistances; distances(:)];
        end
        medianDistance = median(distances(:));
        distMatrix(i, j) = medianDistance;
        distMatrix(j, i) = medianDistance; 
    end
end

cmap = [linspace(1, 32/255, 256)', linspace(1, 163/255, 256)', linspace(1, 158/255, 256)'];

figure;
imagesc(distMatrix);
colormap(cmap); 
colorbar;
caxis([0 90]);
xticks(1:numGroups);
yticks(1:numGroups);
xticklabels({'Scene', 'People', 'Object', 'Scene&People'});
yticklabels({'Scene', 'People', 'Object', 'Scene&People'});
set(gca, 'FontSize', 18, 'FontWeight', 'bold');

for i = 1:numGroups
    for j = 1:numGroups
        text(j, i, sprintf('%.2f', distMatrix(i, j)), 'HorizontalAlignment', 'center', 'FontSize', 18, 'FontWeight', 'bold');
    end
end
