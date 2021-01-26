%% 1. del naloge - generacija uène množice za NM
%vzbujanje sistema z stopnièastim signalom, ki ima na zaèetku impulz
%du = u_max/no_steps, trajanje stopnice -> dt = 500 vzorcev (5 sekund)
clc; clear all; format long;

%__________tvorba identifikacijskega signala__________
u_max = 1.25;
no_steps = 15;
dt = 500;
du = u_max/no_steps;

pulz = [zeros(1, dt), u_max*ones(1, dt), zeros(1, dt)];

steps = [];
for i = 1:no_steps
    steps = [steps, i*du*ones(1, dt)];
end

%signal = [pulz, steps];
%signal = steps;
signal = [steps, fliplr(steps)];

%__________vzbujanje sistema__________
x = [0, 0]; %zaè pogoji [hitrost, kot]

for i = 1:length(signal)
    [fi_, fip_] = helicrane(signal(i), x);
    x = [fip_, fi_];    
    angle(i) = fi_;
end

time = [1:1:length(signal)]*0.01;
figure(1)
plot(time, angle)
xlabel('t [s]')
ylabel('angle [deg]')
title('Odziv nihala na identifikacijski signal')
grid on

figure(2)
plot(time, signal)
xlabel('t [s]')
ylabel('u [/]')
title('Identifikacijski signal')
grid on

%__________uèenje nevronske mreže__________
%vhodi
u_k = signal(3:end)';
u_k1 = signal(2:end - 1)';
%izhodi
y_k = angle(3:end)';
y_k1 = angle(2:end - 1)';
y_k2 = angle(1:end - 2)';

no_hidden_layers = 4;
training_pop = [u_k1, y_k1, y_k2]';
training_pop_target = y_k';

%inicializacija ff nevronske mreže
net = newff(training_pop, training_pop_target, no_hidden_layers, {'tansig', 'purelin'});
net = init(net);
net = configure(net, training_pop, training_pop_target);
%view(net);
net = train(net, training_pop, training_pop_target);

%__________primerjava model-nevronska mreža__________

%generacija testnega signala
% no_test_steps = 10;
% test_signal = [];
% 
% for i = 1:no_test_steps
%     test_signal = [test_signal, u_max*rand(1)*ones(1, round(dt*rand(1)))];
% end

%save('test_signal.mat', 'test_signal')
load('test_signal.mat');
%load('C:\Users\Martin\Desktop\ISPO\vaje\VAJA5\matlab\test_signal.mat');

%dejanski model
x_test = [0, 0]; %zaè pogoji [hitrost, kot]

for i = 1:length(test_signal)
    [testfi_, testfip_] = helicrane(test_signal(i), x_test);
    x_test = [testfip_, testfi_];    
    angle_test(i) = testfi_;
end
time_test = [1:1:length(test_signal)]*0.01;

figure(3)
plot(time_test, test_signal);
xlabel('t [s]');
ylabel('u [/]');
title('Validacijski signal');
grid on

figure(4)
plot(time_test, angle_test);
xlabel('t [s]');
ylabel('angle [deg]');
title('Odziv nihala na validacijski signal');
grid on

%nevronska mreža
%zèetne vrednosti vhodov in izhodov
u_k1_test = 0;
y_k_test = 0; y_k1_test = 0; y_k2_test = 0;

for i = 1:length(test_signal)
    test_pop = [u_k1_test, y_k1_test, y_k2_test]';
    y_k_test(i) = net(test_pop);
    
    y_k2_test = y_k1_test;
    y_k1_test = y_k_test(i);
    u_k1_test = test_signal(i);
end

figure(5)
plot(time_test, y_k_test);
xlabel('t [s]');
ylabel('angle [deg]');
title('Odziv dejanskega modela');
grid on

figure(6)
hold on
plot(time_test, angle_test);
plot(time_test, y_k_test);
xlabel('t [s]');
ylabel('angle [deg]');
legend('Dejanski odziv', 'Odziv NN modela')
title('Primerjava odzivov NN modela in dejanskega modela');
grid on
hold off

%% 2. del naloge - mehki model

data = [signal', angle']; %vhod, izhod
no_centers = 10; %inicializacija št. rojev
weight_eta = 2; %izbira uteži
max_no_iterations = 50; %izbira max. št. iteracij
[centers, deviations] = GK(data, no_centers, max_no_iterations, weight_eta);

%__________tvorba veljavnostnih funkcij__________
for i = 1:no_centers
    membership_func(i, :) = exp(-(1/2)*((signal - centers(i)).^2/(deviations(i))));
end

%normiranje
for i = 1:size(membership_func, 2)
    norm_membership_func(:, i) = membership_func(:, i)./sum(membership_func(:, i));
end

%__________WLS - doloèanje parametrov podmodelov__________
%vhodi
u_k = signal(3:end)';
u_k1 = signal(2:end - 1)';
%izhodi
y_k = angle(3:end)';
y_k1 = angle(2:end - 1)';
y_k2 = angle(1:end - 2)';
residu = ones(length(y_k), 1);

X = [residu, u_k1, y_k1, y_k2];

for i = 1:no_centers
    d_mem_func = norm_membership_func(i,3:end)'; 
    Q = eye(length(d_mem_func));
    for j=1:length(d_mem_func)
        Q(j,j) = d_mem_func(j);
    end
    theta(:,i) = inv(X'*Q*X)*X'*Q*y_k; %WLS
end

%disp(theta);

%__________validacija mehkega modela__________
u_k1_test_f = 0;
y_k_test_f(1) = 0; y_k1_test_f = 0; y_k2_test_f = 0;

for i = 1:size(test_signal,2)
    for j=1:no_centers
       mem_func(j) = exp(-(1/2)*((u_k1_test_f - centers(j)).^2/deviations(j))); 
    end
    norm_mem_func = mem_func/sum(mem_func);
    X_data = [1, u_k1_test_f, y_k1_test_f, y_k2_test_f];
    y_k_test_f(i) = ((X_data*theta)*norm_mem_func');
    y_k2_test_f = y_k1_test_f;
    y_k1_test_f = y_k_test_f(i);
    u_k1_test_f = test_signal(i);   
end

figure(8)
hold on
plot(time_test, angle_test);
plot(time_test, y_k_test_f);
plot(time_test, y_k_test);
legend('Odziv dejanskega modela', 'Mehki model', 'NN Model')
xlabel('t [s]');
ylabel('angle [deg]');
title('Primerjava vseh odzivov');
grid on
hold off

figure(9)
hold on
plot(time_test, angle_test);
plot(time_test, y_k_test_f);
legend('Dejanski odziv', 'Mehki model')
xlabel('t [s]');
ylabel('angle [deg]');
title('Primerjava odzivov mehkega modela in dejanskega modela');
grid on
hold off

%__________ocena kvalitete__________
%mse
NN_mse = sum((y_k_test - angle_test).^2)/length(angle_test);
fuzzy_mse = sum((y_k_test_f - angle_test).^2)/length(angle_test);

disp('Mse NN modela:');
disp(NN_mse);
disp('Mse mehkega modela:');
disp(fuzzy_mse);

%histogram
figure(10)
hist(y_k_test - angle_test)
title('Histogram napake med NN modelom in dejanskim modelom')
grid on
figure(11)
hist(y_k_test_f - angle_test)
title('Histogram napake med mehkim modelom in dejanskim modelom')
grid on
