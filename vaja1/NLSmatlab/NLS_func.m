
function [cntr, theta_0_x, theta_0_y]=NLS(theta_0_x, theta_0_y, st_meritev, n_iter, varianca)
error_limit = 0.0000001;

x_p = [1, 10, 2]';
y_p = [1, 5, 4]';

%generacija vektorja vecih meritev in vecih kooridnat
d = [];
X_p = [];
Y_p = [];
p1 = [];
p2 = [];
p3 = [];

for i = 0:st_meritev - 1
    %vektor meritev
    d1 = ping_stolp_1;
    d2 = ping_stolp_2;
    d3 = ping_stolp_3;
    D = [d1, d2, d3];
    
    %vektroji meritev za upoštevanje variance
    p1(i+1) = d1;
    p2(i+1) = d2;
    p3(i+1) = d3;
    
    for j = 1:3
        %vektor vecih meritev
        d(i*3 + j,:) = D(j);
        %vektorja vecih koordinat
        X_p(i*3 + j,:) = x_p(j);
        Y_p(i*3 + j,:) = y_p(j);
    end
end

v1 = var(p1);
v2 = var(p2);
v3 = var(p3);

%generacija kovarianène matrike
if (varianca == 1 & st_meritev > 1)
V = zeros(1, st_meritev);
for i = 0:st_meritev - 1
    V(i*3 + 1) =  v1;
    V(i*3 + 2) =  v2;
    V(i*3 + 3) =  v3;
end
O = diag(V);
end

cntr = 0;

%varianca se ne upošteva
if (varianca == 0)
    for i =1:1:n_iter
    %d-dejanski izhod, func(th1, th2, x_s, y_s)-aproksimiran izhod
    %func-vrne radij kroznice z srediscem(x_s, y_s) na mestu(th1, th2)
    %oziroma razdaljo med (x_s, y_s) ter (th1, th2)
    dr = d - func(theta_0_x, theta_0_y, X_p, Y_p);
    J = jacobian_func(theta_0_x, theta_0_y, X_p, Y_p);
    %sprememba parametrov
    delta_theta = inv(J'*J)*J'*dr;
    %popravek starih parametrov
    theta_new_x = theta_0_x + delta_theta(1);
    theta_new_y = theta_0_y + delta_theta(2);
    
    abs_error_x = abs(theta_new_x - theta_0_x);
    abs_error_y = abs(theta_new_y - theta_0_y);
    
    theta_0_x = theta_new_x;
    theta_0_y = theta_new_y;
    
    if ((abs_error_x & abs_error_y) < error_limit)
        break
    end
    cntr = cntr + 1;    
    end
end

%varianca se upošteva
if (varianca == 1 & st_meritev > 1)
    for i =1:1:n_iter
    %d-dejanski izhod, func(th1, th2, x_s, y_s)-aproksimiran izhod
    %func-vrne radij kroznice z srediscem(x_s, y_s) na mestu(th1, th2)
    %oziroma razdaljo med (x_s, y_s) ter (th1, th2)
    dr = d - func(theta_0_x, theta_0_y, X_p, Y_p);
    J = jacobian_func(theta_0_x, theta_0_y, X_p, Y_p);
    %sprememba parametrov
    delta_theta = inv(J'*inv(O)*J)*J'*inv(O)*dr;
    %popravek starih parametrov
    theta_new_x = theta_0_x + delta_theta(1);
    theta_new_y = theta_0_y + delta_theta(2);
    
    abs_error_x = abs(theta_new_x - theta_0_x);
    abs_error_y = abs(theta_new_y - theta_0_y);
    
    theta_0_x = theta_new_x;
    theta_0_y = theta_new_y;
    
    if ((abs_error_x & abs_error_y) < error_limit)
        break
    end
    cntr = cntr + 1;    
    end
end


end




