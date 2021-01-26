clc;clear all;format long;

theta_0_x = 10;
theta_0_y = 10;
n_iter = 100;
ponovitev = 1000;

%po zelji dodaj meritve
st_meritev = [2, 20, 200];

len_st_mer = length(st_meritev);
cikli = zeros([ponovitev, len_st_mer]);
X = zeros([ponovitev, len_st_mer]);
Y = zeros([ponovitev, len_st_mer]);

for i = 1:ponovitev
    for j = 1:len_st_mer
        %zadnji argument: 0 - varianca se ne upošteva, 1 - varianca se
        %upošteva
        [cikli(i, j), X(i, j), Y(i, j)] = NLS_func(theta_0_x, theta_0_y, st_meritev(j), n_iter, 0);
    end
end

%raztors in povprecje rezultatov
cikli_mean = zeros(1, len_st_mer);
var_X = zeros(1, len_st_mer);
var_Y = zeros(1, len_st_mer);
for i = 1:len_st_mer
    cikli_mean(i) = mean(cikli(:, i));
    var_X(i) = var(X(:, i));
    var_Y(i) = var(Y(:, i));
end

%hitrost konvergence ter izris koncnih koordinat
x_p = [1, 10, 2]';
y_p = [1, 5, 4]';

%izris
for i = 1:len_st_mer
    fprintf("Povprecno stevilo ciklov pri %d meritev je: %2.4f.\n", st_meritev(i), cikli_mean(i))
    
    set(gcf,'position',[500,300,1000,1000])
    subplot(len_st_mer,1,i)
    title([ "Stevilo meritev:" + num2str(st_meritev(i))])
    hold on
    scatter(x_p, y_p,'b','filled')
    scatter(X(:, i), Y(:, i),'+','b')
    %xlim([4, 6])
    xlim([4.8, 5.5])
    %ylim([1,3])
    ylim([1.0, 3])
    xlabel("X [km]")
    ylabel("Y [km]")
    grid on
    hold off
end



