clc; clear all; format long;

n_iter = 100;
error_limit = 0.0000001;

%zaèetna vrednost(theta1, theta2)
theta_0_x = 10;
theta_0_y = 10;

d1 = ping_stolp_1;
d2 = ping_stolp_2;
d3 = ping_stolp_3;
d = [d1 d2 d3]';

x_p = [1, 10, 2]';
y_p = [1, 5, 4]';

hold on
scatter(theta_0_x, theta_0_y,'g','filled');
for j= 1:length(x_p)
    circle(x_p(j), y_p(j), d(j))
    scatter(x_p(j), y_p(j),'m')
end

cntr = 0;

for i =1:1:n_iter
    %d-dejanski izhod, func(th1, th2, x_s, y_s)-aproksimiran izhod
    %func-vrne radij kroznice z srediscem(x_s, y_s) na mestu(th1, th2)
    %oziroma razdaljo med (x_s, y_s) ter (th1, th2)
    dr = d - func(theta_0_x, theta_0_y, x_p, y_p);
    J = jacobian_func(theta_0_x, theta_0_y, x_p, y_p);
    %sprememba parametrov
    delta_theta = inv(J'*J)*J'*dr;
    %popravek starih parametrov
    theta_new_x = theta_0_x + delta_theta(1);
    theta_new_y = theta_0_y + delta_theta(2);
    scatter(theta_new_x, theta_new_y,'r','filled')
    
    abs_error_x = abs(theta_new_x - theta_0_x);
    abs_error_y = abs(theta_new_y - theta_0_y);
    
    theta_0_x = theta_new_x;
    theta_0_y = theta_new_y;
    
    if ((abs_error_x & abs_error_y) < error_limit)
        break
    end
    cntr = cntr + 1;    
end
fprintf('Izracun se je koncal v %d ciklih z napako %2.10f.\n', cntr, error_limit)
scatter(theta_0_x, theta_0_y,'b','filled')
% xlim([4, 6])
% ylim([1, 3])
hold off
grid on
xlabel('X [km]')
ylabel('Y [km]')



