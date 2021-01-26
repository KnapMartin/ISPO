clc; clear all; format long;

%uvoz podatkov iz vaje 5
% load('C:\Users\Martin\Desktop\ISPO\vaje\VAJA6\matlab\theta.mat')
% load('C:\Users\Martin\Desktop\ISPO\vaje\VAJA6\matlab\centers.mat')
% load('C:\Users\Martin\Desktop\ISPO\vaje\VAJA6\matlab\deviations.mat')

load('C:\Users\Martin\Desktop\ISPO-vaja6\VAJA6\matlab\theta.mat')
load('C:\Users\Martin\Desktop\ISPO-vaja6\VAJA6\matlab\centers.mat')
load('C:\Users\Martin\Desktop\ISPO-vaja6\VAJA6\matlab\deviations.mat')

% load('theta.mat')
% load('centers.mat')
% load('deviations.mat')


%tvorba modelov
mod1 = theta(:, 1);
mod2 = theta(:, 2);
mod3 = theta(:, 3);
mod4 = theta(:, 4);
mod5 = theta(:, 5);

%vaja 5: X = [residu, u_k1, y_k1, y_k2];
%modeli v prostoru stanj
A1 = [0, 1; mod1(4), mod1(3)]; %dinamska matrika
C1 = [0; 1]; %vektor izhodov
B1 = [0; mod1(2)]; %vektor vhodov
R1 = [0; mod1(1)]; %vektor ostankov

A2 = [0, 1; mod2(4), mod2(3)];
C2 = [0; 1];
B2 = [0; mod2(2)];
R2 = [0; mod2(1)];

A3 = [0, 1; mod3(4), mod3(3)];
C3 = [0; 1];
B3 = [0; mod3(2)];
R3 = [0; mod3(1)];

A4 = [0, 1; mod4(4), mod4(3)];
C4 = [0; 1];
B4 = [0; mod4(2)];
R4 = [0; mod4(1)];

A5 = [0, 1; mod5(4), mod5(3)];
C5 = [0; 1];
B5 = [0;  mod5(2)];
R5 = [0; mod5(1)];

%signal
angle_max = 90;
u_max = 1.7;
no_steps = 10;
dt = 500;
du = angle_max/no_steps;

%------stopnicast signal--------
steps = [];
for i = 1:no_steps
    steps = [steps, i*du*ones(1, dt)];
end

% %-------stopnica----------
% angle_max = 90; %tukaj spremenis koncno vrednost stopnice
% pts = 2000;
% steps = zeros(pts);
% steps(round(pts/2):end) = angle_max;

%parametri referencnega modela 1. reda
Ar = 0.9;

%horizont
H = 3;

uk = 0; %zacetni regulirni signal

x0 = [0, 0]; %zacetni pogoji
ym = 0; %zacetni izhod modela
yp = 0; %zacetni izhod procesa
xm = [0; 0]; %zacetni vektor stanja modela

for i=1:size(steps, 2)
    % Izracunamo veljavnostne vrednosti posameznega podmodela
    for j = 1:size(theta, 2)
        mem_func(j) = exp(-(1/2)*((uk - centers(j)).^2/deviations(j))); 
    end
    %normalizacija
    mem_func = mem_func / sum(mem_func);
    
    %dolocitev globalnih modelov
    Aglobal = mem_func(1)*A1 + mem_func(2)*A2 + mem_func(3)*A3 + mem_func(4)*A4 + mem_func(5)*A5;
    Bglobal = mem_func(1)*B1 + mem_func(2)*B2 + mem_func(3)*B3 + mem_func(4)*B4 + mem_func(5)*B5;
    Cglobal = mem_func(1)*C1 + mem_func(2)*C2 + mem_func(3)*C3 + mem_func(4)*C4 + mem_func(5)*C5;
    Rglobal = mem_func(1)*R1 + mem_func(2)*R2 + mem_func(3)*R3 + mem_func(4)*R4 + mem_func(5)*R5;
    
    G0global = Cglobal'*(Aglobal^H - eye(size(Aglobal, 1)))*inv((Aglobal - eye(size(Aglobal, 1))))*Bglobal;
    Gglobal = inv(G0global)*(1 - Ar^H);
    
    %regulirni zakon
    uk = Gglobal*(steps(i) - yp) + (G0global^(-1))*ym - (G0global^(-1))*Cglobal'*(Aglobal^H)*xm - (Bglobal(2)^(-1))*Rglobal(2);
    
    %omejitev regulirnega signala
    if uk < 0
        uk = 0;
    end
    if uk > u_max
        uk = u_max;
    end
    
    process_input(i) = uk;
    
    %izhod procesa
    [fi_ fip_] = helicrane(uk, x0);
    x0 = [fip_, fi_];
    process_output(i) = fi_;
    yp = fi_;
    
    %izhod modela
    xm = Aglobal*xm + Bglobal * uk + Rglobal;
    ym = Cglobal' * xm;
    model_output(i) = ym;
end

ts = 0.01; %cas vzorcenja
time = [0:0.01:ts*(size(steps,2)-1)];

figure()
plot(time, steps) %referencni signal
xlabel('t [s]')
ylabel('kot [deg]')
grid on

figure()
hold on
plot(time, steps) %referencni signal
plot(time, process_output,'-r') %izhod procesa
xlabel('t [s]')
ylabel('kot [deg]')
grid on
hold off

figure()
plot(time, process_input) %regulirni signal
xlabel('t [s]')
ylabel('u [/]')
grid on

figure()
plot(time, model_output) %izhod modela
xlabel('t [s]')
ylabel('kot [deg]')
grid on

%%
%karakteristike odziva na skocno vzbujanje

%cas dviga (cas od 10% amplitude do 90% amplitude)
t10 = find(process_output > 0.1*angle_max);
t90 = find(process_output > 0.9*angle_max);

t_rise = time(t90(1)) - time(t10(1));
disp('cas dviga [s]:');
disp(t_rise);

%maksimalni prenihaj
Mp = ((max(process_output) - process_output(end))/process_output(end))*100;
disp('maksimalni prenihaj [%]:');
disp(Mp)

%cas ustalitve (ko je odziv znotraj +- 5% stac. vrednosti)
tol = 0.05;
err = abs(process_output - process_output(end));
t_idx = find(err < 0.05);
t_start_idx = find(steps > 0);
T_start = time(t_start_idx(1));
T_end = time(t_idx(1));
disp('cas ustalitve [s]:')
disp(T_end - T_start);

%napaka stacionarnega stanja
stat_err = (abs(process_output(end) - steps(end)))*100;
disp('napaka stacionarnega stanja [%]:');
disp(stat_err);

