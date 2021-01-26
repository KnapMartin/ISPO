clc; clear all; format short;

%1. del vaje
load('VAJA3.mat');
measurments1 = [A_FLOW, T_H2O, C_ACID, I_EFF];

%standarizacija:
% a) (x - min(x))/(max(x) - min(x))
% b) (x - mean(x))/(std(x))
% c) nestandarizirani
stand_a1 = [];
stand_b1 = [];
stand_c1 = measurments1;
for i = 1:length(measurments1(1,:))
    stand_a1(:,i) = (measurments1(:,i) - min(measurments1(:,i)))/(max(measurments1(:,i))-min(measurments1(:,i)));
    stand_b1(:,i) = (measurments1(:,i) - mean(measurments1(:,i)))/std(measurments1(:,i));
end

disp('-----------LSE1------------')
%LSE
[LSE_a1, LSE_b1, LSE_c1, LSE_THETA_a1, LSE_THETA_b1, LSE_THETA_c1] = LSEm1(stand_a1, stand_b1, stand_c1);

%izraèun napake
E_LSE_a1 = stand_c1(:,4) - LSE_a1;
E_LSE_b1 = stand_c1(:,4) - LSE_b1;
E_LSE_c1 = stand_c1(:,4) - LSE_c1;
%mean napaka
E_mean_LSE_a1 = mean(E_LSE_a1);
E_mean_LSE_b1 = mean(E_LSE_b1);
E_mean_LSE_c1 = mean(E_LSE_c1);
%std napaka
E_std_LSE_a1 = std(E_LSE_a1);
E_std_LSE_b1 = std(E_LSE_b1);
E_std_LSE_c1 = std(E_LSE_c1);
%NRMSE
NRMSE_a1 = sqrt((sum((LSE_a1 - stand_c1(:,4)).^2)/length(LSE_a1)))/std(stand_c1(:,4));
NRMSE_b1 = sqrt((sum((LSE_b1 - stand_c1(:,4)).^2)/length(LSE_b1)))/std(stand_c1(:,4));
NRMSE_c1 = sqrt((sum((LSE_c1 - stand_c1(:,4)).^2)/length(LSE_c1)))/std(stand_c1(:,4));

%LSE-varinca
LSE_var_a1 = ((LSE_a1-stand_c1(:,4))'*(LSE_a1-stand_c1(:,4)))/(length(LSE_a1(:,1)) - 3);
LSE_var_b1 = ((LSE_b1-stand_c1(:,4))'*(LSE_b1-stand_c1(:,4)))/(length(LSE_a1(:,1)) - 3);
LSE_var_c1 = ((LSE_c1-stand_c1(:,4))'*(LSE_c1-stand_c1(:,4)))/(length(LSE_a1(:,1)) - 3);


disp('LSE varianca a1:')
disp(LSE_var_a1)
disp('LSE varianca b1:')
disp(LSE_var_b1)
disp('LSE varianca c1:')
disp(LSE_var_c1)



figure(1)
set(gcf,'position',[500,200,1000,500])
hold on
title('LSE')
xlabel('meritve')
ylabel('I_{EFF}')
plot(stand_c1(:,4),'-+m')
plot(LSE_a1,'-or')
plot(LSE_b1,'-*g')
plot(LSE_c1,'-sb')
grid on
legend('Izhod sistema','model - standarizacija_a','model - standarizacija_b','model - standarizacija_c')
hold off

disp('Parametri LSE1: ');
disp('Standarizacija a: ')
disp(LSE_THETA_a1);
disp('Standarizacija b: ')
disp(LSE_THETA_b1);
disp('Standarizacija c: ')
disp(LSE_THETA_c1);
disp('Napaka LSE1:')
disp('Povpreèna vrednost napake pri standarizaciji a:')
disp(E_mean_LSE_a1)
disp('Povpreèna vrednost napake pri standarizaciji b:')
disp(E_mean_LSE_b1)
disp('Povpreèna vrednost napake pri standarizaciji c:')
disp(E_mean_LSE_c1)
disp('Stand. deviacija  napake pri standarizaciji a:')
disp(E_std_LSE_a1)
disp('Stand. deviacija  napake pri standarizaciji b:')
disp(E_std_LSE_b1)
disp('Stand. deviacija napake pri standarizaciji c:')
disp(E_std_LSE_c1)
disp('NRMSE standarizacija a:')
disp(NRMSE_a1)
disp('NRMSE standarizacija b:')
disp(NRMSE_b1)
disp('NRMSE standarizacija c:')
disp(NRMSE_c1)

disp('-----------PCA------------')

%PCA
[PCA_a, PCA_b, PCA_c, PCA_THETA_a, PCA_THETA_b, PCA_THETA_c] = PCAm(stand_a1, stand_b1, stand_c1);

%izraèun napake
E_PCA_a = stand_c1(:,4) - PCA_a;
E_PCA_b = stand_c1(:,4) - PCA_b;
E_PCA_c = stand_c1(:,4) - PCA_c;
%mean napaka
E_mean_PCA_a = mean(E_PCA_a);
E_mean_PCA_b = mean(E_PCA_b);
E_mean_PCA_c = mean(E_PCA_c);
%std napaka
E_std_PCA_a = std(E_PCA_a);
E_std_PCA_b = std(E_PCA_b);
E_std_PCA_c = std(E_PCA_c);
%NRMSE
NRMSE_PCA_a = sqrt((sum((PCA_a - stand_c1(:,4)).^2)/length(PCA_a)))/std(stand_c1(:,4));
NRMSE_PCA_b = sqrt((sum((PCA_b - stand_c1(:,4)).^2)/length(PCA_b)))/std(stand_c1(:,4));
NRMSE_PCA_c = sqrt((sum((PCA_c - stand_c1(:,4)).^2)/length(PCA_c)))/std(stand_c1(:,4));

figure(2)
set(gcf,'position',[500,200,1000,500])
hold on
title('PCA')
xlabel('meritve')
ylabel('I_{EFF}')
plot(stand_c1(:,4),'-+m')
plot(PCA_a,'-or')
plot(PCA_b,'-*g')
plot(PCA_c,'-sb')
grid on
legend('Izhod sistema','model - standarizacija_a','model - standarizacija_b','model - standarizacija_c')
hold off

disp('Parametri PCA: ');
disp('Standarizacija a: ')
disp(PCA_THETA_a);
disp('Standarizacija b: ')
disp(PCA_THETA_b);
disp('Standarizacija c: ')
disp(PCA_THETA_c);
disp('Napaka PCA:')
disp('Povpreèna vrednost napake pri standarizaciji a:')
disp(E_mean_PCA_a)
disp('Povpreèna vrednost napake pri standarizaciji b:')
disp(E_mean_PCA_b)
disp('Povpreèna vrednost napake pri standarizaciji c:')
disp(E_mean_PCA_c)
disp('Stand. deviacija  napake pri standarizaciji a:')
disp(E_std_PCA_a)
disp('Stand. deviacija  napake pri standarizaciji b:')
disp(E_std_PCA_b)
disp('Stand. deviacija napake pri standarizaciji c:')
disp(E_std_PCA_c)
disp('NRMSE standarizacija a:')
disp(NRMSE_PCA_a)
disp('NRMSE standarizacija b:')
disp(NRMSE_PCA_b)
disp('NRMSE standarizacija c:')
disp(NRMSE_PCA_c)


%2. del vaje
load('VAJA3.mat');
X_dep = 2*T_H2O+6+0.1*randn(length(T_H2O),1);
measurments2 = [A_FLOW, T_H2O, C_ACID, X_dep, I_EFF];

%standarizacija:
% a) (x - min(x))/(max(x) - min(x))
% b) (x - mean(x))/(std(x))
% c) nestandarizirani
stand_a2 = [];
stand_b2 = [];
stand_c2 = measurments2;
for i = 1:length(measurments2(1,:))
    stand_a2(:,i) = (measurments2(:,i) - min(measurments2(:,i)))/(max(measurments2(:,i))-min(measurments2(:,i)));
    stand_b2(:,i) = (measurments2(:,i) - mean(measurments2(:,i)))/std(measurments2(:,i));
end

disp('-----------LSE2------------')

%LSE
[LSE_a2, LSE_b2, LSE_c2, LSE_THETA_a2, LSE_THETA_b2, LSE_THETA_c2] = LSEm1(stand_a2, stand_b2, stand_c2);

%izraèun napake
E_LSE_a2 = stand_c2(:,5) - LSE_a2;
E_LSE_b2 = stand_c2(:,5) - LSE_b2;
E_LSE_c2 = stand_c2(:,5) - LSE_c2;
%mean napaka
E_mean_LSE_a2 = mean(E_LSE_a2);
E_mean_LSE_b2 = mean(E_LSE_b2);
E_mean_LSE_c2 = mean(E_LSE_c2);
%std napaka
E_std_LSE_a2 = std(E_LSE_a2);
E_std_LSE_b2 = std(E_LSE_b2);
E_std_LSE_c2 = std(E_LSE_c2);
%NRMSE
NRMSE_a2 = sqrt((sum((LSE_a2 - stand_c2(:,5)).^2)/length(LSE_a2)))/std(stand_c2(:,5));
NRMSE_b2 = sqrt((sum((LSE_b2 - stand_c2(:,5)).^2)/length(LSE_b2)))/std(stand_c2(:,5));
NRMSE_c2 = sqrt((sum((LSE_c2 - stand_c2(:,5)).^2)/length(LSE_c2)))/std(stand_c2(:,5));

figure(3)
set(gcf,'position',[500,200,1000,500])
hold on
title('LSE-dodana meritev')
xlabel('meritve')
ylabel('I_{EFF}')
plot(stand_c1(:,4),'-+m')
plot(LSE_a2,'-or')
plot(LSE_b2,'-*g')
plot(LSE_c2,'-sb')
grid on
legend('Izhod sistema','model - standarizacija_a','model - standarizacija_b','model - standarizacija_c')
hold off

disp('Parametri LSE2: ');
disp('Standarizacija a: ')
disp(LSE_THETA_a2);
disp('Standarizacija b: ')
disp(LSE_THETA_b2);
disp('Standarizacija c: ')
disp(LSE_THETA_c2);
disp('Napaka LSE2:')
disp('Povpreèna vrednost napake pri standarizaciji a:')
disp(E_mean_LSE_a2)
disp('Povpreèna vrednost napake pri standarizaciji b:')
disp(E_mean_LSE_b2)
disp('Povpreèna vrednost napake pri standarizaciji c:')
disp(E_mean_LSE_c2)
disp('Stand. deviacija  napake pri standarizaciji a:')
disp(E_std_LSE_a2)
disp('Stand. deviacija  napake pri standarizaciji b:')
disp(E_std_LSE_b2)
disp('Stand. deviacija napake pri standarizaciji c:')
disp(E_std_LSE_c2)
disp('NRMSE standarizacija a:')
disp(NRMSE_a2)
disp('NRMSE standarizacija b:')
disp(NRMSE_b2)
disp('NRMSE standarizacija c:')
disp(NRMSE_c2)

disp('-----------PCR------------')

%PCR
[PCR_a, PCR_b, PCR_c, PCR_THETA_a, PCR_THETA_b, PCR_THETA_c] = PCRm(stand_a2, stand_b2, stand_c2);

%izraèun napake
E_PCR_a = stand_c2(:,5) - PCR_a;
E_PCR_b = stand_c2(:,5) - PCR_b;
E_PCR_c = stand_c2(:,5) - PCR_c;
%mean napaka
E_mean_PCR_a = mean(E_PCR_a);
E_mean_PCR_b = mean(E_PCR_b);
E_mean_PCR_c = mean(E_PCR_c);
%std napaka
E_std_PCR_a = std(E_PCR_a);
E_std_PCR_b = std(E_PCR_b);
E_std_PCR_c = std(E_PCR_c);
%NRMSE
NRMSE_PCR_a = sqrt((sum((PCR_a - stand_c2(:,5)).^2)/length(PCR_a)))/std(stand_c2(:,5));
NRMSE_PCR_b = sqrt((sum((PCR_b - stand_c2(:,5)).^2)/length(PCR_b)))/std(stand_c2(:,5));
NRMSE_PCR_c = sqrt((sum((PCR_c - stand_c2(:,5)).^2)/length(PCR_c)))/std(stand_c2(:,5));


figure(4)
set(gcf,'position',[500,200,1000,500])
hold on
title('PCR')
xlabel('meritve')
ylabel('I_{EFF}')
plot(stand_c1(:,4),'-+m')
plot(PCR_a,'-or')
plot(PCR_b,'-*g')
plot(PCR_c,'-sb')
grid on
legend('Izhod sistema','model - standarizacija_a','model - standarizacija_b','model - standarizacija_c')
hold off

disp('Parametri PCR: ');
disp('Standarizacija a: ')
disp(PCR_THETA_a);
disp('Standarizacija b: ')
disp(PCR_THETA_b);
disp('Standarizacija c: ')
disp(PCR_THETA_c);
disp('Napaka PCR:')
disp('Povpreèna vrednost napake pri standarizaciji a:')
disp(E_mean_PCR_a)
disp('Povpreèna vrednost napake pri standarizaciji b:')
disp(E_mean_PCR_b)
disp('Povpreèna vrednost napake pri standarizaciji c:')
disp(E_mean_PCR_c)
disp('Stand. deviacija  napake pri standarizaciji a:')
disp(E_std_PCR_a)
disp('Stand. deviacija  napake pri standarizaciji b:')
disp(E_std_PCR_b)
disp('Stand. deviacija napake pri standarizaciji c:')
disp(E_std_PCR_c)
disp('NRMSE standarizacija a:')
disp(NRMSE_PCR_a)
disp('NRMSE standarizacija b:')
disp(NRMSE_PCR_b)
disp('NRMSE standarizacija c:')
disp(NRMSE_PCR_c)


%% VEÈKRATNO MODELIRANJE

reps = 100;

LSEm_a = [];
LSEm_b = [];
LSEm_c = [];
LSEm_THETA_a = [];
LSEm_THETA_b = [];
LSEm_THETA_c = [];

PCRm_a = [];
PCRm_b = [];
PCRm_c = [];
PCRm_THETA_a = [];
PCRm_THETA_b = [];
PCRm_THETA_c = [];

for i = 1:reps
    load('VAJA3.mat');
    X_dep = 2*T_H2O+6+0.1*randn(length(T_H2O),1);
    measurments2 = [A_FLOW, T_H2O, C_ACID, X_dep, I_EFF];

    %standarizacija:
    stand_a2 = [];
    stand_b2 = [];
    stand_c2 = measurments2;
    for i = 1:length(measurments2(1,:))
        stand_a2(:,i) = (measurments2(:,i) - min(measurments2(:,i)))/(max(measurments2(:,i))-min(measurments2(:,i)));
        stand_b2(:,i) = (measurments2(:,i) - mean(measurments2(:,i)))/std(measurments2(:,i));
    end
    
    %LSE
    [LSE_a2, LSE_b2, LSE_c2, LSE_THETA_a2, LSE_THETA_b2, LSE_THETA_c2] = LSEm1(stand_a2, stand_b2, stand_c2);
    [PCR_a, PCR_b, PCR_c, PCR_THETA_a, PCR_THETA_b, PCR_THETA_c] = PCRm(stand_a2, stand_b2, stand_c2);
    
    LSEm_a = [LSEm_a, LSE_a2];
    LSEm_b = [LSEm_a, LSE_b2];
    LSEm_c = [LSEm_a, LSE_c2];
    LSEm_THETA_a = [LSEm_THETA_a , LSE_THETA_a2];
    LSEm_THETA_b = [LSEm_THETA_b , LSE_THETA_b2];
    LSEm_THETA_c = [LSEm_THETA_c , LSE_THETA_c2];
    
    PCRm_a = [PCRm_a, PCR_a];
    PCRm_b = [PCRm_b, PCR_b];
    PCRm_c = [PCRm_c, PCR_c];
    PCRm_THETA_a = [PCRm_THETA_a , PCR_THETA_a];
    PCRm_THETA_b = [PCRm_THETA_b , PCR_THETA_b];
    PCRm_THETA_c = [PCRm_THETA_c , PCR_THETA_c];
     
end

%povprecenje
LSE_a2 = mean(LSEm_a,2);
LSE_b2 = mean(LSEm_b,2);
LSE_c2 = mean(LSEm_c,2);
LSE_THETA_a2 = mean(LSEm_THETA_a,2);
LSE_THETA_b2 = mean(LSEm_THETA_b,2);
LSE_THETA_c2 = mean(LSEm_THETA_c,2);

%LSE-varinca
LSE_var_a2 = ((LSE_a2-stand_c1(:,4))'*(LSE_a2-stand_c1(:,4)))/(length(LSE_a2(:,1)) - 4);
LSE_var_b2 = ((LSE_b2-stand_c1(:,4))'*(LSE_b2-stand_c1(:,4)))/(length(LSE_a2(:,1)) - 4);
LSE_var_c2 = ((LSE_c2-stand_c1(:,4))'*(LSE_c2-stand_c1(:,4)))/(length(LSE_a2(:,1)) - 4);


disp('LSE varianca a2:')
disp(LSE_var_a2)
disp('LSE varianca b2:')
disp(LSE_var_b2)
disp('LSE varianca c2:')
disp(LSE_var_c2)

%var_LSE_THETA_a = 

PCR_a = mean(PCRm_a,2);
PCR_b  = mean(PCRm_b,2);
PCR_c  = mean(PCRm_c,2);
PCR_THETA_a = mean(PCRm_THETA_a,2);
PCR_THETA_b = mean(PCRm_THETA_b,2);
PCR_THETA_c = mean(PCRm_THETA_c,2);

%izraèun napake-LSE
E_LSE_a2 = stand_c1(:,4) - LSE_a2;
E_LSE_b2 = stand_c1(:,4)  - LSE_b2;
E_LSE_c2 = stand_c1(:,4) - LSE_c2;
%mean napaka
E_mean_LSE_a2 = mean(E_LSE_a2);
E_mean_LSE_b2 = mean(E_LSE_b2);
E_mean_LSE_c2 = mean(E_LSE_c2);
%std napaka
E_std_LSE_a2 = std(E_LSE_a2);
E_std_LSE_b2 = std(E_LSE_b2);
E_std_LSE_c2 = std(E_LSE_c2);
%NRMSE
NRMSE_a2 = sqrt((sum((LSE_a2 - stand_c1(:,4)).^2)/length(LSE_a2)))/std(stand_c1(:,4));
NRMSE_b2 = sqrt((sum((LSE_b2 - stand_c1(:,4)).^2)/length(LSE_b2)))/std(stand_c1(:,4));
NRMSE_c2 = sqrt((sum((LSE_c2 - stand_c1(:,4)).^2)/length(LSE_c2)))/std(stand_c1(:,4));


figure(5)
set(gcf,'position',[500,200,1000,500])
hold on
title('LSE-veè ponovitev')
xlabel('meritve')
ylabel('I_{EFF}')
plot(stand_c1(:,4),'-+m')
plot(LSE_a2,'-or')
plot(LSE_b2,'-*g')
plot(LSE_c2,'-sb')
grid on
legend('Izhod sistema','model - standarizacija_a','model - standarizacija_b','model - standarizacija_c')
hold off

disp('-----------LSE-veè ponovitev------------')

disp('Parametri LSE2: ');
disp('Standarizacija a: ')
disp(LSE_THETA_a2);
disp('Standarizacija b: ')
disp(LSE_THETA_b2);
disp('Standarizacija c: ')
disp(LSE_THETA_c2);
disp('Napaka LSE2:')
disp('Povpreèna vrednost napake pri standarizaciji a:')
disp(E_mean_LSE_a2)
disp('Povpreèna vrednost napake pri standarizaciji b:')
disp(E_mean_LSE_b2)
disp('Povpreèna vrednost napake pri standarizaciji c:')
disp(E_mean_LSE_c2)
disp('Stand. deviacija  napake pri standarizaciji a:')
disp(E_std_LSE_a2)
disp('Stand. deviacija  napake pri standarizaciji b:')
disp(E_std_LSE_b2)
disp('Stand. deviacija napake pri standarizaciji c:')
disp(E_std_LSE_c2)
disp('NRMSE standarizacija a:')
disp(NRMSE_a2)
disp('NRMSE standarizacija b:')
disp(NRMSE_b2)
disp('NRMSE standarizacija c:')
disp(NRMSE_c2)


figure(6)
set(gcf,'position',[500,200,1000,500])
hold on
title('PCR-veè ponovitev')
xlabel('meritve')
ylabel('I_{EFF}')
plot(stand_c1(:,4),'-+m')
plot(PCR_a,'-or')
plot(PCR_b,'-*g')
plot(PCR_c,'-sb')
grid on
legend('Izhod sistema','model - standarizacija_a','model - standarizacija_b','model - standarizacija_c')
hold off

disp('-----------PCR-veè ponovitev------------')

disp('Parametri PCR: ');
disp('Standarizacija a: ')
disp(PCR_THETA_a);
disp('Standarizacija b: ')
disp(PCR_THETA_b);
disp('Standarizacija c: ')
disp(PCR_THETA_c);
disp('Napaka PCR:')
disp('Povpreèna vrednost napake pri standarizaciji a:')
disp(E_mean_PCR_a)
disp('Povpreèna vrednost napake pri standarizaciji b:')
disp(E_mean_PCR_b)
disp('Povpreèna vrednost napake pri standarizaciji c:')
disp(E_mean_PCR_c)
disp('Stand. deviacija  napake pri standarizaciji a:')
disp(E_std_PCR_a)
disp('Stand. deviacija  napake pri standarizaciji b:')
disp(E_std_PCR_b)
disp('Stand. deviacija napake pri standarizaciji c:')
disp(E_std_PCR_c)
disp('NRMSE standarizacija a:')
disp(NRMSE_PCR_a)
disp('NRMSE standarizacija b:')
disp(NRMSE_PCR_b)
disp('NRMSE standarizacija c:')
disp(NRMSE_PCR_c)






