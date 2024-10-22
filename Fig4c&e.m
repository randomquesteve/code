data = fig4c;
group_info = data(:, 1);
y = data(:, 2);

valid_indices = ~isnan(y);
group_info = group_info(valid_indices);
y = y(valid_indices);

[sorted_y, sorted_indices] = sort(y, 'descend');
sorted_group_info = group_info(sorted_indices);

num_per_group = 5;
num_groups = ceil(length(y) / num_per_group);
grouped_data = cell(1, num_groups);
grouped_group_info = cell(1, num_groups);
A = sum(group_info == 2);
B = sum(group_info == 1);
for i = 1:num_groups
    start_idx = (i - 1) * num_per_group + 1;
    end_idx = min(i * num_per_group, length(y));
    grouped_data{i} = sorted_y(start_idx:end_idx);
    grouped_group_info{i} = sorted_group_info(start_idx:end_idx);
end
expression_value = zeros(1, num_groups); 

for i = 1:num_groups
    current_group = grouped_group_info{i};
    num_1 = sum(current_group == 1);
    num_2 = sum(current_group == 2);
    a = num_2;
    b = num_1;
    expression_value(i) = (a/A - b/B) / (a/A + b/B);
end
y= expression_value
x = 1:length(y);
% 画折线图
figure;
plot(x, y, '-o', 'Color','b' ,'MarkerFaceColor','b','LineWidth', 4, 'MarkerSize', 6);
ylabel('Selectivity Index',  'FontWeight', 'bold');
hold on;
line([0.5, 6.5], [0, 0], 'Color', [0.5, 0.5, 0.5], 'LineStyle', '--', 'LineWidth', 1.5);
hold off;
box off
set(gca,'XLim',[0.5 6.5],'FontSize',25,'FontWeight', 'bold');
xticks([2, 5]); % 设置 x 轴刻度位置
xticklabels({'Anterior','Posterior'});