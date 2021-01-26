clc; clear all; format long;

load ('data.mat');

%normalizacija podatkov (2->n:0 maligen, 4->n:1 benigen)
data_norm = [];
for i = 1:size(data, 2)
    data_norm(:, i) = (data(:, i) - min(data(:, i)))/(max(data(:, i)) - min(data(:, i)));
end

%loèevanje maligni/benigni (212/357)
malignant = [];
benign = [];
for i = 1:size(data, 1)
    if (data_norm(i, 1) == 0)
        malignant = [malignant; data_norm(i, :)];
    else
        benign = [benign; data_norm(i, :)];
    end
end

%locevanje ucna/testna množica
training_pop_share = 0.66;
%size(malignant,1)
%size(benign,1)
malig_training_size = round(size(malignant,1)*training_pop_share);
benig_training_size = round(size(benign,1)*training_pop_share);

%populaciji
training_pop = [malignant(1:malig_training_size, 2:end); benign(1:benig_training_size, 2:end)]';
test_pop = [malignant(malig_training_size + 1:end, 2:end); benign(benig_training_size + 1:end, 2:end)]';

%tarèe
training_pop_target = [malignant(1:malig_training_size, 1); benign(1:benig_training_size, 1)]';
test_pop_target = [malignant(malig_training_size + 1:end, 1); benign(benig_training_size + 1:end, 1)]';

%________________train________________
%init mreže
activation_func = 'tansig';
%activation_func = 'purelin';

net1 = newff(training_pop, training_pop_target, 3, {activation_func, activation_func});
net1 = init(net1);
net1 = configure(net1, training_pop, training_pop_target);
view(net1);
[net1, tr] = train(net1, training_pop, training_pop_target);
gbest1 = getwb(net1);

%_____ANALIZA - UNÈNA MNOŽICA_____
training_yest1 = net1(training_pop);
training_mse1 = sum((training_yest1 - training_pop_target).^2)/length(training_yest1);
%confusion matrix
Y_train1 = [training_pop_target; ~training_pop_target];
YEST_train1 = [round(training_yest1); ~round(training_yest1)];
figure(1);
plotconfusion(Y_train1, YEST_train1);
title('Uèna množica - train');
%fprintf('MSE uène množice - train: %1.5f\n', training_mse1);
% Y_train_malig1 = [training_pop_target(1:malig_training_size), ~training_pop_target(1:malig_training_size)];
% YEST_train_malig1 = [round(training_yest1(1:malig_training_size)), ~round(training_yest1(1:malig_training_size))];
% figure(5);
% plotconfusion(Y_train_malig1, YEST_train_malig1);



%_____ANALIZA - TESTNA MNOŽICA_____
test_yest1 = net1(test_pop);
test_mse1 = sum((test_yest1 - test_pop_target).^2)/length(test_yest1);
%confusion matrix
Y_test1 = [test_pop_target; ~test_pop_target];
YEST_test1 = [round(test_yest1); ~round(test_yest1)];
figure(2);
plotconfusion(Y_test1, YEST_test1);
title('Testna množica - train');
%fprintf('MSE testne množice - train: %1.5f\n', test_mse1);

%________________PSO________________
%init mreže
activation_func = 'tansig';
%activation_func = 'purelin';

net2 = newff(training_pop, training_pop_target, 3, {activation_func, activation_func});
net2 = init(net2);
net2 = configure(net2, training_pop, training_pop_target);
%view(net2);
[gbest2, fg_best] = PSOconstriction(net2, training_pop, training_pop_target, 100, 3, 3, 1);
% disp(fg_best);

%nastavitev uteži
net2 = setwb(net2, gbest2);

%_____ANALIZA - UNÈNA MNOŽICA_____
training_yest2 = net2(training_pop);
training_mse2 = sum((training_yest2 - training_pop_target).^2)/length(training_yest2);
%confusion matrix
Y_train2 = [training_pop_target; ~training_pop_target];
YEST_train2 = [round(training_yest2); ~round(training_yest2)];
figure(3);
plotconfusion(Y_train2, YEST_train2);
title('Uèna množica - PSO');
%fprintf('MSE uène množice - PSO: %1.5f\n', training_mse2);

%_____ANALIZA - TESTNA MNOŽICA_____
test_yest2 = net2(test_pop);
test_mse2 = sum((test_yest2 - test_pop_target).^2)/length(test_yest2);
%confusion matrix
Y_test2 = [test_pop_target; ~test_pop_target];
YEST_test2 = [round(test_yest2); ~round(test_yest2)];
figure(4);
plotconfusion(Y_test2, YEST_test2);
title('Testna množica - PSO');
%fprintf('MSE testne množice - PSO: %1.5f\n', test_mse2);

%_____izpis napak_____
fprintf('MSE uène množice - train: %1.5f\n', training_mse1);
fprintf('MSE testne množice - train: %1.5f\n', test_mse1);
fprintf('MSE uène množice - PSO: %1.5f\n', training_mse2);
fprintf('MSE testne množice - PSO: %1.5f\n', test_mse2);
