data = csvread('data.csv');
pos_labels = data(:, 2); %1=medial-lateral；2=anterior-posterior
mem_labels = data(:, 4); 

model = fitglm(pos_labels, mem_labels, 'Distribution', 'binomial');

mem_pred_probs = predict(model, pos_labels);

[fpr, tpr, ~, original_auc] = perfcurve(mem_labels, mem_pred_probs, 1);
disp(['Original AUC: ', num2str(original_auc)]);

if fpr(1) > 0
    fpr = [0; fpr];
    tpr = [0; tpr];
end
if fpr(end) < 1
    fpr = [fpr; 1];
    tpr = [tpr; 1];
end

n_iterations = 1000;
roc_curves = zeros(n_iterations, length(fpr));
shuffled_aucs = zeros(n_iterations, 1);

for i = 1:n_iterations
    shuffled_pos_labels = pos_labels(randperm(length(pos_labels)));
    modeli = fitglm(shuffled_pos_labels, mem_labels, 'Distribution', 'binomial');
    shuffled_pred_probs = predict(modeli, shuffled_pos_labels);
    
    [shuffled_fpr, shuffled_tpr, ~] = perfcurve(mem_labels, shuffled_pred_probs, 1);

    if shuffled_fpr(1) > 0
        shuffled_fpr = [0; shuffled_fpr];
        shuffled_tpr = [0; shuffled_tpr];
    end
    if shuffled_fpr(end) < 1
        shuffled_fpr = [shuffled_fpr; 1];
        shuffled_tpr = [shuffled_tpr; 1];
    end
    [shuffled_fpr, idx] = unique(shuffled_fpr);
    shuffled_tpr = shuffled_tpr(idx);

    roc_curves(i, :) = interp1(shuffled_fpr, shuffled_tpr, fpr, 'linear', 'extrap');
    shuffled_aucs(i) = trapz(shuffled_fpr, shuffled_tpr);
end

figure;
plot(fpr, tpr, 'b-', 'LineWidth', 4);
hold on;
h_original_roc = plot(fpr, tpr, 'b-', 'LineWidth', 2.5);

p_value = sum(shuffled_aucs >= original_auc) / n_iterations;
fprintf('p-value: %.4f\n', p_value);

mean_roc = mean(roc_curves);
lower_bound = prctile(roc_curves, 2.5);  
upper_bound = prctile(roc_curves, 97.5); 

mean_roc(end) = 1;
lower_bound(end) = 1;
upper_bound(end) = 1;

[fpr, unique_idx] = unique(fpr);
mean_roc = mean_roc(unique_idx);
lower_bound = lower_bound(unique_idx);
upper_bound = upper_bound(unique_idx);

num_points = 1000; 
fpr_interp = linspace(0, 1, num_points);

mean_roc_smooth = interp1(fpr, mean_roc, fpr_interp, 'pchip');
lower_bound_smooth = interp1(fpr, lower_bound, fpr_interp, 'pchip');
upper_bound_smooth = interp1(fpr, upper_bound, fpr_interp, 'pchip');

plot(fpr_interp, mean_roc_smooth, 'k-', 'LineWidth', 2);

fill([fpr_interp, fliplr(fpr_interp)], [upper_bound_smooth, fliplr(lower_bound_smooth)], [0.5 0.5 0.5], 'FaceAlpha', 0.2, 'EdgeColor', 'none');
uistack(h_original_roc, 'top');

text(0.72, 0.12, ['AUC= ', num2str(original_auc)], 'FontSize', 22,'FontWeight','bold', 'Color', 'black');
text(0.4, 0.98, ['p < ', num2str(p_value)], 'FontSize', 22,'FontWeight','bold', 'Color', 'black');


xlabel('False Positive Rate');
ylabel('True Positive Rate');
set(gca, 'FontWeight','bold', 'FontSize', 25,'LineWidth', 2, 'Box', 'off');
set(groot, 'DefaultAxesLabelFontSizeMultiplier', 1);
hold off;
