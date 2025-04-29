%Data in the corresponding FigS2c&h.xlsx，data = 1 group; 2 type_group; 3:5 xyz.

group_labels = unique(data(:,1));

content_groups = unique(data(:,2)); 
numGroups = length(content_groups);

cmap_left  = [linspace(1, 253/255, 256)', linspace(1, 180/255, 256)', linspace(1, 98/255, 256)'];   
cmap_right = [linspace(1, 32/255, 256)',  linspace(1, 163/255, 256)', linspace(1, 158/255, 256)'];  

figure('Position', [100, 100, 1200, 500]);

t = tiledlayout(1, 2, 'TileSpacing', 'compact', 'Padding', 'compact');  

for k = 1:2
    group_id = group_labels(k);
    subgroup = data(data(:,1) == group_id, :);
    distMatrix = zeros(numGroups, numGroups);
    for i = 1:numGroups
        group1 = subgroup(subgroup(:,2) == content_groups(i), 3:5);
        for j = i:numGroups
            group2 = subgroup(subgroup(:,2) == content_groups(j), 3:5);
            if i == j
                distances = pdist(group1, 'euclidean');
            else
                distances = pdist2(group1, group2, 'euclidean');
            end
            medianDistance = median(distances(:));
            distMatrix(i, j) = medianDistance;
            distMatrix(j, i) = medianDistance;
        end
    end

    ax = nexttile;
    imagesc(distMatrix, 'Parent', ax);

    caxis(ax, [0 70]);

if k == 1
    colormap(ax, cmap_left);
    cb = colorbar(ax, 'Location', 'eastoutside');
    cb.Ticks = [0 70];
    cb.TickLabels = {'0', '70'};
    ax.YAxisLocation = 'left';
else
    colormap(ax, cmap_right);
    cb = colorbar(ax, 'Location', 'westoutside');
    cb.Ticks = [0 70];
    cb.TickLabels = {'0', '70'};
    ax.YAxisLocation = 'right';
end

    xticks(1:numGroups);
    yticks(1:numGroups);
    xticklabels({'Scene', 'People', 'Object', 'Scene&People'});%content
    yticklabels({'Scene', 'People', 'Object', 'Scene&People'});%content
   %xticklabels({'Semantics', 'Personal semantics', 'Familiarity'});%quality
   %yticklabels({'Semantics', 'Personal semantics', 'Familiarity'});%quality
    set(ax, 'FontSize', 18, 'FontWeight', 'bold');

    for i = 1:numGroups
        for j = 1:numGroups
            text(j, i, sprintf('%.2f', distMatrix(i, j)), ...
                'HorizontalAlignment', 'center', 'FontSize', 18, 'FontWeight', 'bold');
        end
    end 
end


