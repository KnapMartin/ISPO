function [LSE_a, LSE_b, LSE_c, THETA_a, THETA_b, THETA_c] = LSEm(stand_a, stand_b, stand_c)

%podatki za transforamcijo(stand_c -> nestd. podatki)
end_idx = length(stand_c(1,:));
interval_t = max(stand_c(:,end_idx)) - min(stand_c(:,end_idx));
min_t = min(stand_c(:,end_idx));
mean_t = mean(stand_c(:,end_idx));
std_t = std(stand_c(:,end_idx));

range_c = max(stand_c) - min(stand_c);
std_c = std(stand_c);

%X_nstd = stand_c(:,1:end_idx-1);
%Y_nstd = stand_c(:,end_idx);

%LSE - a
X_a = stand_a;
Y_a = stand_a(:,end_idx);
X_a(:,end_idx) = 1;

THETA_a = inv(X_a'*X_a)*X_a'*Y_a;
LSE_a_nt = X_a*THETA_a;
%transformacija 
LSE_a = LSE_a_nt*interval_t + min_t;
%transf - THETA
transf_a = THETA_a.*range_c(end_idx);
transf_a(1:end_idx-1) = transf_a(1:end_idx-1)./range_c(1:end_idx-1)';
THETA_a = transf_a;
THETA_a(end_idx) = -(min(stand_c(:,1:end_idx-1))*transf_a(1:end_idx-1) - THETA_a(end_idx) - min(stand_c(:,end_idx)));

%LSE - b
X_b = stand_b;
Y_b = stand_b(:,end_idx);
X_b(:,end_idx) = 1;

THETA_b = inv(X_b'*X_b)*X_b'*Y_b;
LSE_b_nt = X_b*THETA_b;
%transformacija 
LSE_b = LSE_b_nt*std_t + mean_t;
%transf - THETA
transf_b = THETA_b.*std_c(end_idx);
transf_b(1:end_idx-1) = transf_b(1:end_idx-1)./std_c(1:end_idx-1)';
THETA_b = transf_b;
THETA_b(end_idx) = -(mean(stand_c(:,1:end_idx-1)) * transf_b(1:end_idx-1) - transf_b(end_idx) - mean(stand_c(:,end_idx)));

%LSE - c
X_c = stand_c;
Y_c = stand_c(:,end_idx);
X_c(:,end_idx) = 1;

THETA_c = inv(X_c'*X_c)*X_c'*Y_c;
LSE_c = X_c*THETA_c;

end