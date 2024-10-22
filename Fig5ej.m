data = Fig5e; 
group_info = data(:, 1);
y = data(:, 3);%2:4 xyz
coords = data(:, 2:4);
category = data(:, 5); % 5=content, 6=type

valid_indices = ~isnan(y);
group_info = group_info(valid_indices);
y = y(valid_indices);
coords = coords(valid_indices, :);
category = category(valid_indices);

[sorted_y, sorted_indices] = sort(y, 'descend');
sorted_group_info = group_info(sorted_indices);
sorted_coords = coords(sorted_indices, :);
sorted_category = category(sorted_indices);
num_per_group = 10;
num_groups = ceil(length(y) / num_per_group);

grouped_data = cell(1, num_groups);
grouped_group_info = cell(1, num_groups);
grouped_coords = cell(1, num_groups);
grouped_category = cell(1, num_groups);

for i = 1:num_groups
    start_idx = (i - 1) * num_per_group + 1;
    end_idx = min(i * num_per_group, length(y));
    grouped_data{i} = sorted_y(start_idx:end_idx);
    grouped_group_info{i} = sorted_group_info(start_idx:end_idx);
    grouped_coords{i} = sorted_coords(start_idx:end_idx, :);
    grouped_category{i} = sorted_category(start_idx:end_idx);
end

expression_value = zeros(1, num_groups);
group_within_distances = cell(1, num_groups);
group_between_distances = cell(1, num_groups);
A = sum(group_info == 0);
B = sum(group_info == 1);
for i = 1:num_groups
    current_group = grouped_group_info{i};
    current_coords = grouped_coords{i};
    current_category = grouped_category{i};
    valid_indices = current_category ~= 0;
    current_coords = current_coords(valid_indices, :);
    current_category = current_category(valid_indices);

    num_1 = sum(current_group == 0);
    num_2 = sum(current_group == 1);
    
    a = num_2;
    b = num_1;
    expression_value(i) = (a/A - b/B) / (a/A + b/B);
    
    within_distances = [];
    between_distances = [];
    
    for j = 1:length(current_category)
        for k = j+1:length(current_category)
            dist = norm(current_coords(j, :) - current_coords(k, :));
            if current_category(j) == current_category(k)
                within_distances = [within_distances; dist];
            else
                between_distances = [between_distances; dist];
            end
        end
    end
    
    group_within_distances{i} = within_distances;
    group_between_distances{i} = between_distances;
end

within_color = [243, 129, 121] / 255;
between_color = [30, 106, 179] / 255;
marker_alpha = 0.6;
base_marker_size = 100;

figure;
hold on;
for i = 1:num_groups
    x_pos = expression_value(i);
    within_distances = group_within_distances{i};
    between_distances = group_between_distances{i};
    scatter(between_distances, repmat(x_pos, length(between_distances), 1), ...
        base_marker_size * ones(size(between_distances)), ...
        'filled', 'MarkerFaceColor', between_color, 'MarkerFaceAlpha', marker_alpha);
    plot(median(between_distances), x_pos, 'b|', 'MarkerSize', 25, 'LineWidth', 3, ...
        'Color', between_color);
    scatter(within_distances, repmat(x_pos, length(within_distances), 1), ...
        base_marker_size * ones(size(within_distances)), ...
        'filled', 'MarkerFaceColor', within_color, 'MarkerFaceAlpha', marker_alpha);
    plot(median(within_distances), x_pos, 'r|', 'MarkerSize', 25, 'LineWidth', 3, ...
        'Color', within_color);
end

xlabel('Euclidean Distance', 'FontSize', 25, 'FontWeight', 'bold');
ylabel('Selectivity Index', 'FontSize', 25, 'FontWeight', 'bold');
set(gca, 'FontSize', 25, 'FontWeight', 'bold');
hold off;