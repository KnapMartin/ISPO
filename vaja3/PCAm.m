function [PCA_a, PCA_b, PCA_c, THETA_a, THETA_b, THETA_c] = PCAm(stand_a, stand_b, stand_c)

%podatki za transforamcijo(stand_c -> nestd. podatki)
end_idx = length(stand_c(1,:));
interval_t = max(stand_c(:,4)) - min(stand_c(:,4));
min_t = min(stand_c(:,4));
mean_t = mean(stand_c(:,4));
std_t = std(stand_c(:,4));

range_c = max(stand_c) - min(stand_c);
std_c = std(stand_c);
mean_c = mean(stand_c);


%PCA - a
V_a = mean(stand_a);
F_a = (stand_a'*stand_a)/(length(stand_a(:,1)) - 1);
[P_a, D_a, Pt_a] = svd(F_a);
%izberemo lastni vektor, ki mu pripada min lastna vrednost (smer min. variance)
THETA_a = P_a(:, 4);
THETA_a(1:3) = THETA_a(1:3)./THETA_a(4);
THETA_a(4) = V_a(1:3)*THETA_a(1:3) + V_a(4);
THETA_a(1:3) = - THETA_a(1:3);
stand_a(:,4) = 1;
PCA_a_nt = stand_a*THETA_a;
%transformacija 
PCA_a = PCA_a_nt*interval_t + min_t;
%transf - THETA
THETA_a = THETA_a.*range_c(end_idx);
THETA_a(1:end_idx-1) = THETA_a(1:end_idx-1)./range_c(1:end_idx-1)';
THETA_a(end_idx) = min(stand_c(:,end_idx)) + THETA_a(end_idx) - min(stand_c(:,1:end_idx-1))*THETA_a(1:end_idx-1);


%PCA - b
V_b = mean(stand_b);
F_b = (stand_b'*stand_b)/(length(stand_b(:,1)) - 1);
[P_b, D_b, Pt_b] = svd(F_b);
%izberemo lastni vektor, ki mu pripada min lastna vrednost (smer min. variance)
THETA_b = P_b(:, 4);
THETA_b(1:3) = THETA_b(1:3)./THETA_b(4);
THETA_b(4) = V_b(1:3)*THETA_b(1:3) + V_b(4);
THETA_b(1:3) = - THETA_b(1:3);
stand_b(:,4) = 1;
PCA_b_nt = stand_b*THETA_b;
%transformacija
PCA_b = PCA_b_nt*std_t + mean_t;
%transf - THETA
THETA_b = THETA_b.*std_c(end_idx);
THETA_b(1:end_idx-1) = THETA_b(1:end_idx-1)./std_c(1:end_idx-1)';
THETA_b(end_idx) = mean_c(end_idx) + THETA_b(end_idx) - mean_c(1:end_idx-1)*THETA_b(1:end_idx-1);

%PCA - c
V_c = mean(stand_c);
F_c = (stand_c'*stand_c)/(length(stand_c(:,1)) - 1);
[P_c, D_c, Pt_c] = svd(F_c);
%izberemo lastni vektor, ki mu pripada min lastna vrednost (smer min. variance)
THETA_c = P_c(:, 4);
THETA_c(1:3) = THETA_c(1:3)./THETA_c(4);
THETA_c(4) = V_c(1:3)*THETA_c(1:3) + V_c(4);
THETA_c(1:3) = - THETA_c(1:3);
stand_c(:,4) = 1;
PCA_c = stand_c*THETA_c;

end


