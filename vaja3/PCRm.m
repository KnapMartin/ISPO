function [PCR_a, PCR_b, PCR_c, THETA_a, THETA_b, THETA_c] = PCRm(stand_a, stand_b, stand_c)

%podatki za transforamcijo(stand_c -> nestd. podatki)
end_idx = length(stand_c(1,:));
interval_t = max(stand_c(:,end_idx)) - min(stand_c(:,end_idx));
min_t = min(stand_c(:,end_idx));
mean_t = mean(stand_c(:,end_idx));
std_t = std(stand_c(:,end_idx));

range_c = max(stand_c) - min(stand_c);
std_c = std(stand_c);
mean_c = mean(stand_c);

%X_nstd = stand_c(:,1:end_idx-1);
%Y_nstd = stand_c(:,end_idx);

%PCR - a
X_a = stand_a(:,1:end_idx-1);
Y_a = stand_a(:,end_idx);

F_a = (X_a'*X_a)/(length(X_a(:,1)) - 1);
[P_a, D_a, Pt_a] = svd(F_a);
%odstranitev glavne komponente z zanemarljivim vplivom
PS_a = P_a(:,1:3);
T_a = X_a*PS_a;
%LSE
THETA_a = inv(T_a'*T_a)*T_a'*Y_a;
THETA_a = PS_a*THETA_a;

PCR_a_nt = X_a*THETA_a;
%transformacija 
PCR_a = PCR_a_nt*interval_t + min_t;
%transf - THETA
THETA_a = THETA_a.*range_c(4);
THETA_a(1:3) = THETA_a(1:3)./range_c(1:3)';
THETA_a(4) = min(stand_c(:,4)) + THETA_a(4) - min(stand_c(:,1:3))*THETA_a(1:3);

%PCR - b
X_b = stand_b(:,1:end_idx-1);
Y_b = stand_b(:,end_idx);

F_b = (X_b'*X_b)/(length(X_b(:,1)) - 1);
[P_b, D_b, Pt_b] = svd(F_b);
%odstranitev glavne komponente z zanemarljivim vplivom
PS_b = P_b(:,1:3);
T_b = X_b*PS_b;
%LSE
THETA_b = inv(T_b'*T_b)*T_b'*Y_b;
THETA_b = PS_b*THETA_b;

PCR_b_nt = X_b*THETA_b;
%transformacija 
PCR_b = PCR_b_nt*std_t + mean_t;
%transf - THETA
THETA_b = THETA_b.*std_c(4);
THETA_b(1:3) = THETA_b(1:3)./std_c(1:3)';
THETA_b(4) = mean_c(4) + THETA_b(4) - mean_c(1:3)*THETA_b(1:3);

%PCR - c
X_c = stand_c(:,1:end_idx-1);
Y_c = stand_c(:,end_idx);

F_c = (X_c'*X_c)/(length(X_c(:,1)) - 1);
[P_c, D_c, Pt_c] = svd(F_c);
%odstranitev glavne komponente z zanemarljivim vplivom
PS_c = P_c(:,1:3);
T_c = X_c*PS_c;
%LSE
THETA_c = inv(T_c'*T_c)*T_c'*Y_c;
THETA_c = PS_c*THETA_c;

PCR_c = X_c*THETA_c;

end