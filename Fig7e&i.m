data_matrix = csvread('Fig7e.csv');
p_values = zeros(1, 7);

figure;
hold on;
box_width = 0.2; 
scatter_spread = 0.25; 
custom_box_width = 0.25; 
fixed_text_height = 0.77; 
alpha = 0.05; 
alpha_bonf = alpha / 7; 

for col = 2:8
    group1_data = data_matrix(data_matrix(:, 1) == 2, col);
    group2_data = data_matrix(data_matrix(:, 1) == 1, col);
    positions = col-1 + [-box_width, box_width];  
    h1 = boxplot(group1_data, 'positions', positions(1), 'colors', [253,180,98]/255, 'Whisker', 1.5, 'Symbol', '', 'Widths', custom_box_width); 
    h2 = boxplot(group2_data, 'positions', positions(2), 'colors', [32 163 158]/255, 'Whisker', 1.5, 'Symbol', '', 'Widths', custom_box_width);
    set(findobj(h1, 'Type', 'Line'), 'LineWidth', 1.5);
    set(findobj(h2, 'Type', 'Line'), 'LineWidth', 1.5);
    scatter(repmat(positions(1), length(group1_data), 1) + (rand(size(group1_data)) - 0.5) * scatter_spread, group1_data, 35, [253,180,98]/255, 'filled', 'MarkerFaceAlpha', 0.5); 
    scatter(repmat(positions(2), length(group2_data), 1) + (rand(size(group2_data)) - 0.5) * scatter_spread, group2_data, 35, [32 163 158]/255, 'filled', 'MarkerFaceAlpha', 0.5); 
    [p, ~] = ranksum(group1_data, group2_data);
    p_values(col-1) = p; 
    median1 = nanmedian(group1_data);
    median2 = nanmedian(group2_data);
    line([positions(1)-0.137, positions(1)+0.137], [median1, median1], 'Color', [255,160,75]/255, 'LineWidth', 2.5);
    line([positions(2)-0.137, positions(2)+0.137], [median2, median2], 'Color', [32 163 158]/255, 'LineWidth', 2.5);
    
end
xlabel(['Fusiform gyrus'])
ylabel('Connection probability');
xticks([1, 7]); 
xticklabels({ 'Anterior','Posterior'});
set(gca, 'YLim', [-0.05 0.8], 'YTick', 0:0.2:0.8, 'YTickLabel', 0:0.2:0.8);
set(gca, 'LineWidth', 2, 'FontWeight', 'bold', 'FontSize', 25);
box off
legend('Internally oriented reminiscences', 'Externally oriented hallucinations', 'FontWeight', 'bold', 'edgecolor', 'none');
hold off;
